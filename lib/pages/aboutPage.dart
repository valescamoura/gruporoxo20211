import 'package:flutter/material.dart';
//----------------------------------------
//Página sobre, para fins de créditos
//---------------------------------------

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF062B06),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Sobre',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFAD200C),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 30.0, bottom: 30.0),
              child: Text(
                "O jogo BlackJack 21 foi desenvolvido pelos alunos Gabriel Stofel De Souza, Karina Pereira de Lemos, Matheus Lima Romaneli, Thiago Lopes Nascimento e Valesca Moura De Sousa, para a disciplina de Laboratório de Dispositivos Móveis, ministrada pelo professor Lauro Eduardo Kozovits no semestre de 2021.1 do curso de Ciência da Computação da Universidade Federal Fluminense.",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
              )),
          Text("Versão 1.0.0",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold))
        ]))));
  }
}
