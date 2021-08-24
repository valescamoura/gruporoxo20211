import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/pages/aboutPage.dart';
import 'package:gruporoxo20211/pages/gameRulesPage.dart';
import 'package:gruporoxo20211/blackjack/Example.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? nickname = context.read<AppService>().getNickname();

    return Container(
        color: Color(0xFF062B06),
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text("Bem-vindo, $nickname",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontSize: 20.0,
                      color: Colors.white,
                      decoration: TextDecoration.none))),
          //Imagem
          Container(
            margin: EdgeInsets.only(top: 30.0, bottom: 0.0),
            child: Image.asset(
              'assets/images/imageFromHomePage.png',
              width: 250,
              height: 80,
            ),
          ),
          //Título
          Column(children: <Widget>[
            Text(
              'BlackJack',
              style: GoogleFonts.bungee(
                  textStyle: TextStyle(
                      color: Color(0xFFddb512),
                      fontSize: 50.0,
                      decoration: TextDecoration.none)),
            ),
            Text(
              '21',
              style: GoogleFonts.bungee(
                  textStyle: TextStyle(
                      color: Color(0xFFddb512),
                      fontSize: 50.0,
                      decoration: TextDecoration.none)),
            ),
            //Botões
            Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    child: Image.asset(
                      "assets/images/imagePlay.png",
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () async {
                      String nome = await context.read<AppService>().searchForGame();

                      if (nome.isEmpty) {
                        // TODO: Mostrar talvez um widget com a seguinte mensagem:
                        // "Esperando por um jogador..."
                        await context.read<AppService>().createGame();
                      }

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GetGameWidget()));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFAD200C)),
                        padding: MaterialStateProperty.all(EdgeInsets.only(
                            top: 30, bottom: 30, left: 125.0, right: 125.0)),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 30))),
                  )),
              Row(children: [
                Padding(
                    padding: EdgeInsets.only(top: 11.0, left: 70.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageProfile.png",
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {

                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 30, bottom: 30, left: 50.0, right: 50.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 11.0, left: 10.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageNotifications.png",
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        context.read<AppService>().createGame();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 30, bottom: 30, left: 50.0, right: 50.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    )),
              ]),
              Row(children: [
                Padding(
                    padding: EdgeInsets.only(top: 11.0, left: 70.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageRules.png",
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GameRulesPage()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 30, bottom: 30, left: 50.0, right: 50.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 11.0, left: 10.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageAbout.png",
                        width: 40,
                        height: 40,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutPage()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 30, bottom: 30, left: 50.0, right: 50.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    ))
              ]),
              Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: TextButton(
                      onPressed: () {
                        context.read<AppService>().signOut();
                      },
                      child: Text("Sair",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto')),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 15, bottom: 15, left: 50.0, right: 50.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.white))))))
            ]),
          ])
        ]));
  }
}
