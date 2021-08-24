import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'dart:math';

class AppService {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');
  final CollectionReference _games = FirebaseFirestore.instance.collection('games');
  Map? _userData;
  Map? _gameState;
  Map? _futureGameState;
  bool _gameHost = false;

  AppService(this._firebaseAuth);

  // *******************************
  // SERVIÇO DE AUTENTICAÇÃO
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      QuerySnapshot query = await _users
          .where('email', isEqualTo: email)
          .get();
      QueryDocumentSnapshot doc = query.docs[0];

      setUserData(doc['nick'], email, doc['wins'], doc['losses']);

      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  Future<String> signUp(String nickname, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser!.updateDisplayName(nickname);
      await _users.add({
        'nick': nickname,
        'email': email,
        'wins': 0,
        'losses': 0,
      });

      setUserData(nickname, email, 0, 0);

      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void setUserData(String nickname, String email, int wins, int losses) {
    _userData = {
      'nick': nickname,
      'email': email,
      'wins': 0,
      'losses': 0
    };
  }

  String? getNickname() {
    return _firebaseAuth.currentUser!.displayName;
  }

  int getWins() {
    return _userData!['wins'];
  }

  int getLosses() {
    return _userData!['losses'];
  }

  // *******************************
  // SERVIÇO DE JOGO
  Future<void> fetchGameState() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: _gameState!['gameId'])
        .get();

    setGameState(query.docs[0], _futureGameState);
  }

  // Faz o set do estado do jogo
  void setGameState(QueryDocumentSnapshot doc, Map? gameState) {
    gameState = {
      'gameId': doc['gameId'],
      'player1': doc['player1'],
      'player2': doc['player2'],
      'deck': doc['deck'],
      'p1Hand': doc['p1Hand'],
      'p2Hand': doc['p2Hand'],
      'gameState': doc['gameState'],
      'handsDown': doc['handsDown'],
      'timeCreated': doc['timeCreated']
    };
  }

  void passGameState() {
    for (String key in _futureGameState!.keys) {
      _gameState![key] = _futureGameState![key];
    }
  }

  // Procura por um jogo, retornando o nome do Jogador caso encontre, caso não,
  // retorna uma String vazia
  Future<String> searchForGame() async {
    QuerySnapshot query = await _games
        .where('gameState', isEqualTo: 0)
        .orderBy('timeCreated')
        .get();

    if (query.docs.isNotEmpty) {
      await _games.doc(query.docs[0].id)
          .update({'player2': getNickname(), 'gameState': 1});

      setGameState(query.docs[0], _gameState);

      return query.docs[0]['player1'];
    }

    return "";
  }

  // Cria o jogo no FireStore
  Future<void> createGame() async {
    List<String> deck = generateDeck();
    List<String> p1Hand = [getCard(deck), getCard(deck)];
    List<String> p2Hand = [getCard(deck), getCard(deck)];

    _gameState = {
      'gameId': randomString(6, from: 48, to: 90),
      'player1': _firebaseAuth.currentUser!.displayName,
      'player2': '',
      'deck': deck,
      'p1Hand': p1Hand,
      'p2Hand': p2Hand,
      'gameState': 0,
      'handsDown': 0,
      'timeCreated': FieldValue.serverTimestamp()
    };
    _gameHost = true;
    
    await _games.add({
      'gameId': _gameState!['gameId'],
      'player1': _gameState!['player1'],
      'player2': _gameState!['player2'],
      'deck': _gameState!['deck'],
      'p1Hand': _gameState!['p1Hand'],
      'p2Hand': _gameState!['p2Hand'],
      'gameState': _gameState!['gameState'],
      'handsDown': _gameState!['handsDown'],
      'timeCreated': FieldValue.serverTimestamp()
    });

    return await waitForPlayer();
  }

  // Pega uma carta aleatória do deck localmente e retorna a String dela
  String getCard(List<String> deck) {
    Random rnd = new Random();
    int rndCardNum = rnd.nextInt(deck.length);

    return deck.removeAt(rndCardNum);
  }

  // Espera por um jogador e a cada 2 segundos busca no Firestore para ver se
  // o gameState do registro foi atualizado com 1 (significando que o jogo começou)
  Future<void> waitForPlayer() async {
    while (true) {
      QuerySnapshot query = await _games
          .where('gameId', isEqualTo: _gameState!['gameId'])
          .get();
      int gameState = query.docs[0]['gameState'];

      if (gameState == 1) {
        setGameState(query.docs[0], _gameState);
        return;

      } else {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  // Pega uma carta do deck no Firestore e atualiza o registro
  Future<void> askForCard() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: _gameState!['gameId'])
        .get();
    List<String> deck = query.docs[0]['deck'];
    String docId = query.docs[0].id;

    String card = getCard(deck);

    if (_gameHost) {
      await updateDeckHand(card, 'p1Hand', docId);
      return;
    }

    await updateDeckHand(card, 'p2Hand', docId);
  }

  // Atualiza a mão de um jogador no Firestore
  Future<void> updateDeckHand(String card, String player, String docId) async {
    _gameState![player].add(card);

    await _games.doc(docId).update({player: _gameState![player]});
  }

  // Retorna verdadeira caso o oponente tenha pedido uma carta e atualiza o
  // estado local da mão do oponente
  Future<List<String>> checkOpponentCard() async {
    if (_gameHost) {
      return isHandBigger(_futureGameState!['p2Hand'], 'p2Hand');

    } else {
      return isHandBigger(_futureGameState!['p1Hand'], 'p1Hand');
    }
  }

  // Checa se a mão do oponente está maior do que a do estado atual, caso sim,
  // atualizar o estado e retornar verdadeiro
  List<String> isHandBigger(List<String> playerHand, String player) {
    List<String> newCards = [];

    if (playerHand.length > _gameState![player].length) {
      playerHand.forEach((element) {
        if (!_gameState![player].contains(element)) {
          newCards.add(element);
        }
      });
      _gameState![player] = playerHand;
    }

    return newCards;
  }

  // Checa para ver se handsDown é igual a 2, o que significa que o jogo acabou
  bool isGameOver() {
    if (_gameState!['handsDown'] == 2) {
      // Jogo terminado! Computar vencedor
      return true;
    }

    return false;
  }

  // Limpa os dados do jogo que acabou
  void cleanGameState() {
    _gameState!.clear();
    _futureGameState!.clear();
    _gameHost = false;
  }
}

List<String> generateDeck() {
  return [
    'AE', '2E', '3E', '4E', '5E', '6E', '7E', '8E', '9E', 'DE', 'JE', 'QE', 'KE',
    'AC', '2C', '3C', '4C', '5C', '6C', '7C', '8C', '9C', 'DC', 'JC', 'QC', 'KC',
    'AO', '2O', '3O', '4O', '5O', '6O', '7O', '8O', '9O', 'DO', 'JO', 'QO', 'KO',
    'AP', '2P', '3P', '4P', '5P', '6P', '7P', '8P', '9P', 'DP', 'JP', 'QP', 'KP'
  ];
}