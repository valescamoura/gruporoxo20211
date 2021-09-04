import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gruporoxo20211/AppService.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SalaDeEspera extends StatefulWidget {
  SalaDeEspera({Key? key, context}) : super(key: key);

  BuildContext? context;
  
  @override
  SalaDeEsperaState createState() {
    var salaDeEsperaState = SalaDeEsperaState();
    salaDeEsperaState.startTimer();
    return salaDeEsperaState;
  }

  bool hasOpponent() {
    String hasOpponent = this.context!.read<AppService>().getOpponentNick();
    return hasOpponent.isNotEmpty;
  }
}

class SalaDeEsperaState extends State<SalaDeEspera> {
  int _counter = 31;
  late Timer _timer;

  void startTimer() {
    _counter = 31;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        (_counter > 0) ? _counter-- : _timer.cancel();
      });

      if (SalaDeEspera().hasOpponent()) {
        print('iniciar jogo');
        // TODO: redirecionar para tela do jogo
      }
      else {
        print('Sem oponentes');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                onPressed: () => startTimer(),
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