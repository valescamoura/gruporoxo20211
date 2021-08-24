import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/blackjack/Example.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool controller = true;
  String textButtonSound = 'assets/images/soundButton.png';

  @override
  Widget build(BuildContext context) {
    final myGame = MyGame(context);
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
                    padding: EdgeInsets.only(left: 150.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFC0C0C0)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(5, 7, 5, 7)),
                      ),
                      onPressed: () {
                        if (controller == true) {
                          setState(() {
                            //TODO: Ver outra maneira de atualizar o estado do botão sem utilizar o setState
                            textButtonSound = 'assets/images/muteButton.png';
                          });
                          /*TODO: Colocar função de parar sons do jogo*/
                          controller = false;
                        } else {
                          setState(() {
                            textButtonSound = 'assets/images/soundButton.png';
                          });
                          /*TODO: Colocar função de tocar sons do jogo*/
                          controller = true;
                        }
                      },
                      child:
                          Image.asset(textButtonSound, height: 30.0, width: 28),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFC0C0C0)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(5, 7, 5, 7)),
                      ),
                      onPressed: () {},
                      child: Image.asset("assets/images/zoomOutButton.png",
                          height: 30.0, width: 28),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFC0C0C0)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(5, 7, 5, 7)),
                      ),
                      onPressed: () {},
                      child: Image.asset("assets/images/zoomInButton.png",
                          height: 30.0, width: 28),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFC0C0C0)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(5, 7, 5, 7)),
                      ),
                      onPressed: () {
                        print("apertei!");
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
    title: Text("Deseja mesmo desistir da partida?"),
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
