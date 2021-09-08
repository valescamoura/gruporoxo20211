import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

// -----------------------------------------------------------------------------------
// Esse arquivo dart nomeado 'AppService' tem como objetivo prover o contexto necessário
// para que todas as telas do aplicativo consigam receber os dados referentes tanto a
// autenticação, como aos dados referentes a jogo em si para que o gameplay funcione
// como esperado.
class AppService {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _games =
      FirebaseFirestore.instance.collection('games');
  Map? _userData;
  Map? _gameState;
  Map? _futureGameState;
  bool gameHost = false;

  AppService(this._firebaseAuth);

  Future<void> setOneSignalId(String oneSignalId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('oneSignalId', oneSignalId);
  }

  // *******************************
  // SERVIÇO DE AUTENTICAÇÃO
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      QuerySnapshot query = await _users.where('email', isEqualTo: email).get();
      QueryDocumentSnapshot doc = query.docs[0];

      await setUserData(doc['nick'], email, doc['wins'], doc['losses']);

      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  Future<String> signUp(String nickname, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oneSignalId = prefs.getString('oneSignalId');

    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.currentUser!.updateDisplayName(nickname);
      await _users.add({
        'nick': nickname,
        'email': email,
        'wins': 0,
        'losses': 0,
        'oneSignal': oneSignalId
      });

      await setUserData(nickname, email, 0, 0);

      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> fetchUserData() async {
    String? email = _firebaseAuth.currentUser!.email;

    QuerySnapshot query = await _users.where('email', isEqualTo: email).get();
    QueryDocumentSnapshot doc = query.docs[0];

    await setUserData(doc['nick'], email!, doc['wins'], doc['losses']);
  }

  Future<void> setUserData(
      String nickname, String email, int wins, int losses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? oneSignalId = prefs.getString('oneSignalId');

    this._userData = {
      'nick': nickname,
      'email': email,
      'wins': 0,
      'losses': 0,
      'signalId': oneSignalId
    };
  }

  //Envia o e-mail com o link para resetar a senha do usuário
  Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Sent';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  // Retorna o nickname do usuário atual
  String? getNickname() {
    return _firebaseAuth.currentUser!.displayName;
  }

  // Retorna o e-mail do usuário atual
  String? getEmail() {
    return _firebaseAuth.currentUser!.email;
  }

  // Incrementa wins ou losses dependendo da String que é passada como argumento [wins|losses]
  Future<void> incrementWinsLosses(String result) async {
    
    this._userData![result] += 1;
    QuerySnapshot query = await _users
        .where('email', isEqualTo: _firebaseAuth.currentUser!.email)
        .get();

    _users.doc(query.docs[0].id).update({result: this._userData![result]});
  }

  // Retorna o número de vitórias do usuário atual
  int getWins() {
    return this._userData!['wins'];
  }

  // Retorna o número de derrotas do usuário atual
  int getLosses() {
    return this._userData!['losses'];
  }

  // *******************************
  // SERVIÇO DE JOGO
  Future<void> fetchGameState() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: this._gameState!['gameId'])
        .get();

    setFutureGameState(query.docs[0]);
  }

  // Faz o set do estado do jogo
  void setGameState(QueryDocumentSnapshot doc) {
    this._gameState = {
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

  // Faz o set do _futureGameState
  void setFutureGameState(QueryDocumentSnapshot doc) {
    this._futureGameState = {
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

  // Passa o estado do futureGameState para o gameState
  void passGameState() {
    for (String key in this._futureGameState!.keys) {
      this._gameState![key] = this._futureGameState![key];
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
      await _games
          .doc(query.docs[0].id)
          .update({'player2': getNickname(), 'gameState': 1});

      setGameState(query.docs[0]);

      return query.docs[0]['player1'];
    }

    return "";
  }

  // Cria o jogo no FireStore
  Future<void> createGame() async {
    List<String> deck = generateDeck();
    List<String> p1Hand = [];
    List<String> p2Hand = [];

    this._gameState = {
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
    this.gameHost = true;

    await _games.add({
      'gameId': this._gameState!['gameId'],
      'player1': this._gameState!['player1'],
      'player2': this._gameState!['player2'],
      'deck': this._gameState!['deck'],
      'p1Hand': this._gameState!['p1Hand'],
      'p2Hand': this._gameState!['p2Hand'],
      'gameState': this._gameState!['gameState'],
      'handsDown': this._gameState!['handsDown'],
      'timeCreated': FieldValue.serverTimestamp()
    });

    //return await waitForPlayer();
  }

  // Deleta o jogo com o gameId que está atualmente no _gameState
  Future<void> deleteGame() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: this._gameState!['gameId'])
        .get();

    await _games.doc(query.docs[0].id).delete();
  }

  // Desiste do jogo
  Future<void> giveUp() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: this._gameState!['gameId'])
        .get();

    if (this.gameHost) {
      await _games.doc(query.docs[0].id).update({
        'p1Hand': ['WO'],
        'gameState': 2
      });
    } else {
      await _games.doc(query.docs[0].id).update({
        'p2Hand': ['WO'],
        'gameState': 2
      });
    }

    await incrementWinsLosses('losses');
  }

  // Finalizar jogo devido ao fim do tempo de jogo para evitar que um jogador
  // fique preso na partida caso outro saia inesperadamente
  Future<void> endGame() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: this._gameState!['gameId'])
        .get();

    await _games.doc(query.docs[0].id).update({
        'gameState': 2
    });
  }

  // Pega uma carta aleatória do deck localmente e retorna a String dela
  String getCard(List<String> deck) {
    Random rnd = new Random();
    int rndCardNum = rnd.nextInt(deck.length);

    return deck.removeAt(rndCardNum);
  }

  // Retorna o nickname do oponente
  String getOpponentNick() {
    if (this.gameHost) {
      return this._gameState?['player2'];
    }

    return this._gameState?['player1'];
  }

  // Obter cartas da mão do jogador
  List<String> getCards(){
    if (this.gameHost) {
      return this._gameState?['p1Hand'].cast<String>();
    }

    return this._gameState?['p2Hand'].cast<String>();
  }

  // Obter cartas da mão do oponente
  List<String> getOpponentCards(){
    if (this.gameHost) {
      return this._gameState?['p2Hand'].cast<String>();
    }

    return this._gameState?['p1Hand'].cast<String>();
  }

  // Espera por um jogador e busca no Firestore para ver se
  // o gameState do registro foi atualizado com 1 (significando que o jogo começou)
  Future<bool> waitForPlayer() async {
    
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: this._gameState!['gameId'])
        .get();
    int gameState = query.docs[0]['gameState'];

    if (gameState == 1) {
      setGameState(query.docs[0]);
      return true;
    }

    return false;
   
  }

  void getListOfStrings(List<String> localDeck, List<dynamic> fireBaseDeck) {
    fireBaseDeck.forEach((element) {
      localDeck.add(element);
    });
  }

  // Pega uma carta do deck no Firestore e atualiza o registro
  Future<String> askForCard() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: this._gameState!['gameId'])
        .get();

    List<String> deck = [];
    getListOfStrings(deck, query.docs[0]['deck']);

    String docId = query.docs[0].id;
    String card = getCard(deck);

    if (this.gameHost) {
      await updateDeckHand(card, 'p1Hand', docId);
    } else {
      await updateDeckHand(card, 'p2Hand', docId);
    }

    await _games.doc(docId).update({'deck': deck});
    return card;
  }

  // Atualiza a mão de um jogador no Firestore
  Future<void> updateDeckHand(String card, String player, String docId) async {
    this._gameState![player].add(card);

    await _games.doc(docId).update({player: this._gameState![player]});
  }

  // Retorna verdadeira caso o oponente tenha pedido uma carta e atualiza o
  // estado local da mão do oponente
  List<String> checkOpponentCard() {
    if (this.gameHost) {
      return isHandBigger(_futureGameState!['p2Hand'].cast<String>(), 'p2Hand');
    } else {
      return isHandBigger(_futureGameState!['p1Hand'].cast<String>(), 'p1Hand');
    }
  }

  // Checa se a mão do oponente está maior do que a do estado atual, caso sim,
  // atualizar o estado e retornar verdadeiro
  List<String> isHandBigger(List<String> playerHand, String player) {
    List<String> newCards = [];
  
    if (playerHand.length > this._gameState![player].length) {
      playerHand.forEach((element) {
        if (!this._gameState![player].contains(element)) {
          newCards.add(element);
        }
      });
      this._gameState![player] = playerHand;
    }

    return newCards;
  }

  // Desce a mão de cartas
  Future<void> putHandDown() async {
    QuerySnapshot query = await _games
        .where('gameId', isEqualTo: this._gameState!['gameId'])
        .get();

    this._gameState!['handsDown'] += 1;
    await _games
        .doc(query.docs[0].id)
        .update({'handsDown': this._gameState!['handsDown']});
  }

  // Checa para ver se handsDown é igual a 2, o que significa que o jogo acabou
  bool isGameOver() {
    if (_futureGameState!['handsDown'] >= 2 ||
        _futureGameState!['gameState'] == 2) {
      return true;
    }

    return false;
  }

  // Retorna uma String dizendo qual jogador venceu ou se foi empate [player1|player2|empate]
  String whoWon() {
    int p1Points = getPlayerPoints('p1Hand');
    int p2Points = getPlayerPoints('p2Hand');

    List p1Hand = this._futureGameState!['p1Hand'];
    List p2Hand = this._futureGameState!['p2Hand'];

    // Verificação de mãos vazias
    if (p1Hand.isEmpty && p2Hand.isEmpty) {
      return 'empate';
    } else if ((this.gameHost && p2Hand.isEmpty) || (!this.gameHost && p2Hand.isEmpty)) {
      return 'player1';
    }
    else if ((this.gameHost && p1Hand.isEmpty) || (!this.gameHost && p1Hand.isEmpty)) {
      return 'player2';
    }
    
    // Checagem de WO
    if (this.gameHost && p2Hand[0] == 'WO') {
      return 'player1';
    } else if (!this.gameHost && p1Hand[0] == 'WO') {
      return 'player2';
    }

    // Checagem por pontos
    if ((p1Points > 21 && p2Points > 21) || (p1Points == p2Points)) {
      return 'empate';
    } else if (p1Points > p2Points) {
      return 'player1';
    } else {
      return 'player2';
    }
  }

  // Retorna o valor de pontos correspondente à mão de um jogador
  int getPlayerPoints(String playerHand) {
    int points = 0;

    // Faz o loop dentro do array de cartas da mão de um jogador
    for (int i = 0; i < this._futureGameState![playerHand].length; i++) {
      // Checa se a carta começa com J, Q ou K
      if (this._futureGameState![playerHand][i].startsWith(RegExp(r'^[JQK]'))) {
        points += 10;

        // Checa se a carta começa com A
      } else if (this._futureGameState![playerHand][i].startsWith('A')) {
        points += 11;

        // O restante das cartas tem o
      } else {
        points += int.parse(this._futureGameState![playerHand][i]![0]);
      }
    }

    return points;
  }

  // Limpa os dados do jogo que acabou
  void cleanGameState() {
    this._gameState!.clear();
    _futureGameState!.clear();
    this.gameHost = false;
  }
}

List<String> generateDeck() {
  return [
    'AE',
    '2E',
    '3E',
    '4E',
    '5E',
    '6E',
    '7E',
    '8E',
    '9E',
    'DE',
    'JE',
    'QE',
    'KE',
    'AC',
    '2C',
    '3C',
    '4C',
    '5C',
    '6C',
    '7C',
    '8C',
    '9C',
    'DC',
    'JC',
    'QC',
    'KC',
    'AO',
    '2O',
    '3O',
    '4O',
    '5O',
    '6O',
    '7O',
    '8O',
    '9O',
    'DO',
    'JO',
    'QO',
    'KO',
    'AP',
    '2P',
    '3P',
    '4P',
    '5P',
    '6P',
    '7P',
    '8P',
    '9P',
    'DP',
    'JP',
    'QP',
    'KP'
  ];
}
