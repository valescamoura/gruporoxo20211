import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/AppService.dart';
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
  late Timer _timer;
  late BuildContext? _context;
  late BlackJack _myGame;

  set context(BuildContext? context) {
    _context = context;
  }

  void startTimer(int s) {
    _counter = s;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      (_counter > 0) ? _counter-- : _timer.cancel();
      
      //Atualizar contador da classe BlackJack
      _myGame.timer = _counter;

      // Chamar funções que atualizam estado do jogo através de comunicação com Firestore
      _context!.read<AppService>().fetchGameState();
      _context!.read<AppService>().passGameState();
      
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
                        var s = _counter;
                        _counter = 0;
                        _timer.cancel();
                        showAlertDialog1(context);
                        startTimer(s);
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

showAlertDialog1(BuildContext context) {
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
                onPressed: () {
                  //TODO 
                 
                  
                  //Aumentar em 1 o número de derrotas;
                  //Dar vitória para o adversário
                  //Redireciona o perdedor para a página de derrota
                  //Redireciona o vencedor para a página de vitória
                  //Parar contador
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
