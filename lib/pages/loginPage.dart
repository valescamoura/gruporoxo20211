import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/components/loginForm.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            width: 300,
            height: 100,
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
        //LOGIN
        LoginForm(),
      ]),
    );
  }
}
