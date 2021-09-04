import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/pages/aboutPage.dart';
import 'package:gruporoxo20211/pages/gameRulesPage.dart';
import 'package:gruporoxo20211/pages/profilePage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? nickname = context.read<AppService>().getNickname();

    return Container(
        color: Color(0xFF062B06),
        child: Column(children: <Widget>[
          /* Mensagem de boas-vindas */
          Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text("Bem-vindo, $nickname",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                      fontSize: 20.0,
                      color: Colors.white,
                      decoration: TextDecoration.none))),
          /* Imagem representativa do jogo */
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Image.asset(
              'assets/images/imageFromHomePage.png',
              width: 250,
              height: 80,
            ),
          ),
          /* Nome do jogo */
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
                      fontSize: 45.0,
                      decoration: TextDecoration.none)),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0)),
            Column(children: [
              /* Button que redireciona o usuário para jogar uma partida */
              Center(
                  child: ElevatedButton(
                child: Image.asset(
                  "assets/images/imagePlay.png",
                  width: 40,
                  height: 30,
                ),
                onPressed: () {
                  context.read<AppService>().searchForGame();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFAD200C)),
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                        top: 20, bottom: 20, left: 115.0, right: 115.0)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 30))),
              )),
              Row(children: [
                /* Button que redireciona para a page 'Perfil' */
                Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 70.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageProfile.png",
                        width: 40,
                        height: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfilePage()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 20, bottom: 20, left: 45.0, right: 45.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    )),
                /* Button que redireciona para a page 'Notificações' */
                Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 10.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageNotifications.png",
                        width: 40,
                        height: 30,
                      ),
                      onPressed: () {
                        context.read<AppService>().createGame();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 20, bottom: 20, left: 45.0, right: 45.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    )),
              ]),
              Row(children: [
                /* Button que redireciona para a page 'Regras' */
                Padding(
                    padding: EdgeInsets.only(top: 11.0, left: 70.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageRules.png",
                        width: 40,
                        height: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GameRulesPage()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 20, bottom: 20, left: 45.0, right: 45.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    )),
                /* Button que redireciona para a page 'Sobre' */
                Padding(
                    padding: EdgeInsets.only(top: 11.0, left: 10.0),
                    child: ElevatedButton(
                      child: Image.asset(
                        "assets/images/imageAbout.png",
                        width: 40,
                        height: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutPage()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: 20, bottom: 20, left: 45.0, right: 45.0)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                    ))
              ]),
              /* Button que desloga o usuário do jogo */
              Padding(
                  padding: EdgeInsets.only(top: 50.0),
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
                              top: 10, bottom: 10, left: 40.0, right: 40.0)),
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
