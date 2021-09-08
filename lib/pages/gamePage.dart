import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/blackjack/Carta.dart';
import 'package:gruporoxo20211/pages/empatePage.dart';
import 'package:gruporoxo20211/pages/loserPage.dart';
import 'package:gruporoxo20211/pages/winnerPage.dart';
import 'package:provider/provider.dart';
import 'package:gruporoxo20211/blackjack/BlackJack.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _counter = 180;
  int _counter_auxiliar = 15;
  late Timer _timer;
  late Timer _timer_auxiliar;
  late BuildContext? _context;
  late BlackJack _myGame;

  set context(BuildContext? context) {
    _context = context;
  }

  void startTimer(int s) {
    _counter = s;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      (_counter > 0) ? _counter-- : _timer.cancel();
      
      // Atualizar contador da classe BlackJack
      _myGame.timer = _counter;

      // Chamar funções que atualizam estado do jogo através de comunicação com Firestore
      await _context!.read<AppService>().fetchGameState();

      // Verificar se oponente comprou cartas e animar compra na tela do jogo
      var lista = _context!.read<AppService>().checkOpponentCard();
      if (lista.length > 0){
        for (var i = 0; i < lista.length; i++){
          // transformar string em objeto carta
          var carta = Carta.toCard(lista[i]);
          BlackJack.adversario.mao.add(carta);
          BlackJack.adversario.pontos += carta.valor;
        }
        
        // Animar compra da carta realizada pelo usuário
        BlackJack.cardAdv = true;
      }

      // Se o counter é igual a 0, o jogo termina devido ao fim do tempo
      if (_counter == 1) {
        // Mudar estado do jogo no firebase
        await _context!.read<AppService>().endGame();
      } 

      // Passar estado do jogo
      _context!.read<AppService>().passGameState();

      // Verificar se jogo terminou 
      var isGameOver = _context!.read<AppService>().isGameOver();
      if (isGameOver) {
        BlackJack.turnAdv = true;
        BlackJack.gameEnd = true;

        // 15 segundos para que os usuários vejam as cartas um do outro
        // Iniciar segundo contador
        startTimerAuxiliar();
      }   
    });
  }

  void startTimerAuxiliar() {
    _counter_auxiliar = 16;
    _timer_auxiliar = Timer.periodic(Duration(seconds: 1), (timer) async {
      (_counter_auxiliar > 0) ? _counter_auxiliar-- : _timer_auxiliar.cancel();
      
      // Atualizar contador da classe BlackJack
      _myGame.timer = _counter_auxiliar;

      if (_counter_auxiliar == 1){
        //Parar contador
        _timer_auxiliar.cancel();

        var winner = _context!.read<AppService>().whoWon();
        if (winner == 'player1' && _context!.read<AppService>().gameHost) {
          // Ganhou
          // Atualizar número de vitórias
          await _context!.read<AppService>().incrementWinsLosses('wins');
          // Limpar estado do jogo
          _context!.read<AppService>().cleanGameState();
          //Redireciona o jogador para a página de vitória
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WinnerPage()));
        }
        else if (winner == 'player2' && _context!.read<AppService>().gameHost) {
          // Perdeu
          // Atualizar número de derrotas
          await _context!.read<AppService>().incrementWinsLosses('losses');
          // Limpar estado do jogo
          _context!.read<AppService>().cleanGameState();
          //Redireciona o jogador para a página de derrota
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoserPage()));
        }
        else {
          // Empate
          // Limpar estado do jogo
          _context!.read<AppService>().cleanGameState();
          // Redirecionar o jogador para a página de empate
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EmpatePage()));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer(180);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    var myGame = BlackJack(context);
    _myGame = myGame;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            child: GameWidget(game: myGame),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 345.0),
                    child: TextButton(

                      onPressed: () {
                        showAlertDialog1(context, _timer);
                      },
                      child: Image.asset("assets/images/exitButton.png",
                          height: 30.0, width: 23),
                    ))
              ],
            )),
      ],
    );
  }
}

showAlertDialog1(BuildContext context, Timer timer) {
  //configura o  AlertDialog se o jogador apertar o botão de sair
  AlertDialog alerta = AlertDialog(
    title: Text("Deseja mesmo desistir?"),
    content: Text(
      "Você irá automaticamente perder a partida.",
      style: TextStyle(fontSize: 17.0),
    ),
    actions: [
      Center(
          child: Row(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 100.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Text(
                  "Não",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () => Navigator.pop(context, true),
              )),
          Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: ElevatedButton(
                child: Text(
                  "Sim",
                  style: TextStyle(fontSize: 18.0),
                ),
                onPressed: () async {
                  // Desistir da partida e aumentar em 1 o número de derrotas
                  await context.read<AppService>().giveUp();

                  // Limpar estado do jogo
                  context.read<AppService>().cleanGameState();
                
                  //Parar contador
                  timer.cancel();

                  //Redireciona o jogador para a página de derrota
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoserPage()));
                },
              )),
        ],
      ))
    ],
  );
  // exibe o dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alerta;
    },
  );
}
