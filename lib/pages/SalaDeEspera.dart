import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/pages/gamePage.dart';
import 'package:gruporoxo20211/pages/homepage.dart';
import 'package:provider/provider.dart';

class SalaDeEspera extends StatefulWidget {
  const SalaDeEspera({ Key? key }) : super(key: key);

  @override
  _SalaDeEsperaState createState() => _SalaDeEsperaState();
}

class _SalaDeEsperaState extends State<SalaDeEspera> {
  int _counter = 31;
  late Timer _timer;
  late BuildContext? _context;

  set context(BuildContext? context) {
    _context = context;
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Future<bool> hasOpponent() async {
    bool hasOpponent = await this.context.read<AppService>().waitForPlayer();
    return hasOpponent;
  }

  void startTimer() {
    _counter = 31;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        (_counter > 0) ? _counter-- : _timer.cancel();
      });
      print('Contador = $_counter');
      if (await hasOpponent()) {
        // Zerar contador
        _counter = 0;
        _timer.cancel();

        // Redirecionar para tela de jogo
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GamePage()));
      }
    });
  }

  void desistir(){
    // Parar temporizador
    _counter = 0;
    _timer.cancel();
    // Deletar sala antes de sair
    context.read<AppService>().deleteGame();
    // Voltar à homepage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Sala de espera',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        backgroundColor: Color(0xFFAD200C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => desistir(),
        ),
      ),
      backgroundColor: Color(0xFF062B06),
      body: Center (
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Aguardando outro jogador...',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 20.0)
          ),
          Text(
            '$_counter',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0)
          ),
          (_counter > 0) 
          ? Text("")
          : Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => startTimer(),
                child: Text('Esperar'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0)
              ),
              ElevatedButton(
                onPressed: () => desistir(),
                child: Text('Desistir'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20))
                ),
              ),
            ]
          ),
        ],
      ),
      )
    );
  }
}
