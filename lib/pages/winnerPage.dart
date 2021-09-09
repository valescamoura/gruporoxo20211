import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/pages/SalaDeEspera.dart';
import 'package:gruporoxo20211/pages/GamePage.dart';
import 'package:provider/provider.dart';
import 'package:gruporoxo20211/AppService.dart';

//Pagina pós jogo que indica a Vitória na partida

class WinnerPage extends StatelessWidget {
  const WinnerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF062B06),
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text("Fim do Jogo!",
                  style: GoogleFonts.bungee(
                      textStyle: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          decoration: TextDecoration.none)))),
          Stack(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 100.0, left: 80.0),
                child: Image.asset("assets/images/win.png",
                    width: 250, height: 200)),
            Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Image.asset("assets/images/win_image1.png",
                    width: 500, height: 200)),
            Padding(
                padding: EdgeInsets.only(top: 200.0),
                child: Image.asset("assets/images/win_image2.png",
                    width: 550, height: 200))
          ]),
          Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(30, 15.0, 30.0, 15.0)),
                ),
                child: Text('Jogar Novamente',
                    style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                    )),
                onPressed: () async {
                  String nome =
                      await context.read<AppService>().searchForGame();

                  if (nome.isEmpty) {
                    // Criar jogo
                    await context.read<AppService>().createGame();

                    // enviar notificações aqui
                    await context.read<AppService>().postNotification();

                    // Redirecionar para sala de espera
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SalaDeEspera()));
                  } else {
                    // Redirecionar para tela de jogo
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => GamePage()));
                  }
                },
              )),
          Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(40, 15.0, 40.0, 15.0)),
                ),
                child: Text('Voltar ao menu',
                    style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(fontSize: 25.0, color: Colors.white),
                    )),
                onPressed: () {
                  // Voltar à homepage
                  Navigator.of(context).pop();
                },
              )),
        ]));
  }
}
