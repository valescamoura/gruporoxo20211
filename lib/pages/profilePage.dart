import 'package:flutter/material.dart';
import 'package:gruporoxo20211/AuthenticationService.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? _name = context.read<AuthenticationService>().getNickname();
    String? _email = context.read<AuthenticationService>().getEmail();
    int _wins = context.read<AuthenticationService>().getWins();
    int _losses = context.read<AuthenticationService>().getLosses();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Perfil',
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
        body: Card(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
            color: Color(0xFB126012),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFFAD200C),
                        ),
                        padding: EdgeInsets.only(top: 10.0),
                        width: 120,
                        height: 100,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Text("Nickname:",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                Text(_name.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ))
                              ],
                            ),
                            Column(
                              children: [
                                Text("Email:",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                Text(_email.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ))
                              ],
                            ),
                            Column(
                              children: [
                                Text("Vitorias:",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                Text(_wins.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ))
                              ],
                            ),
                            Column(
                              children: [
                                Text("Derrotas:",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold)),
                                Text(_losses.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ))
                              ],
                            ),
                          ],
                        ))),
              ],
            )));
  }
}
