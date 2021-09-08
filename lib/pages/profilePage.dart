import 'package:flutter/material.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String? _name = context.read<AppService>().getNickname();
    String? _email = context.read<AppService>().getEmail();
    int _wins = context.read<AppService>().getWins();
    int _losses = context.read<AppService>().getLosses();
    return Scaffold(
        backgroundColor: Color(0xFF062B06),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            /* Título da Page */
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
        body: Padding(
          padding: EdgeInsets.only(top: 30.0, left: 5.0),
          child: Container(
              width: 400,
              height: 400,
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Color(0xFB126012),
                  /* Dados do jogador (nickname, e-mail, número de vitórias e derrotas) */
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 30.0),
                          child: Text("Nickname:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 10.0),
                          child: Text(_name.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ))),
                      Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 30.0),
                          child: Text("E-mail:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 20.0),
                          child: Text(_email.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ))),
                      Padding(
                          padding: EdgeInsets.only(top: 30.0, left: 15.0),
                          child: Row(children: [
                            Image.asset("assets/images/imageTrophy.png"),
                            Text("Vitórias:",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))
                          ])),
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 20.0),
                          child: Text(_wins.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ))),
                      Padding(
                          padding: EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text("Derrotas:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold))),
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 20.0),
                          child: Text(_losses.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              )))
                    ],
                  ))),
        ));
  }
}
