import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/BlackJack.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            child: GameWidget(game: BlackJack(context)),
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
                        print("alert");
                        showAlertDialog1(context);
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
                  //No firebase
                  //Aumentar em 1 o número de derrotas;
                  //Dar vitória para o adversário
                  //Redireciona o perdedor para a página de derrota
                  //Redireciona o vencedor para a página de vitória
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
