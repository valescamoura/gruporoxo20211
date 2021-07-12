import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/pages/gameRulesPage.dart';
import 'Dart:io';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF062B06),
      child: Column(children: <Widget>[
        //Imagem
        Container(
          margin: EdgeInsets.only(top: 30.0, bottom: 0.0),
          child: Image.asset(
            'assets/images/imageFromHomePage.png',
            width: 330,
            height: 150,
          ),
        ),
        //Título
        Column(children: <Widget>[
          Text(
            'BlackJack',
            style: GoogleFonts.bungee(
                textStyle: TextStyle(
                    color: Color(0xFFddb512),
                    fontSize: 60.0,
                    decoration: TextDecoration.none)),
          ),
          Text(
            '21',
            style: GoogleFonts.bungee(
                textStyle: TextStyle(
                    color: Color(0xFFddb512),
                    fontSize: 60.0,
                    decoration: TextDecoration.none)),
          ),
        ]),
        //Botões
        Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(130.0, 15.0, 130.0, 15.0)),
              ),
              child: Text(
                'Jogar',
                style: GoogleFonts.robotoCondensed(
                textStyle: TextStyle(fontSize: 30.0, color: Colors.white),
              )),
              onPressed: () {
                //Ação ao pressionar ao botão
              },
            )),
        Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(122.0, 15.0, 122.0, 15.0)),
              ),
              child: Text(
                'Regras',
                style: GoogleFonts.robotoCondensed(
                textStyle: TextStyle(fontSize: 30.0, color: Colors.white),
              )),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>GameRulesPage())
                );
              },
            )),
        Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(140.0, 15.0, 140.0, 15.0)),
              ),
              child: Text(
                'Sair',
                style: GoogleFonts.robotoCondensed(
                textStyle: TextStyle(fontSize: 30.0, color: Colors.white),
              )),
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  exit(0);
                });
              },
            )),
      ]),
    );
  }
}
