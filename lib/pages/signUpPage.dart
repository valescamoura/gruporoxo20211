import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF062B06),
      appBar: AppBar(
        centerTitle: true,
        /* Título da Page */
        title: const Text(
          'Cadastro',
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
      body: SignUpForm(),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  final _textNickname = TextEditingController();
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
      height: 372,
      /* Formulário com os campos Nickname, e-mail e senha para efetuar o cadastro */
      child: Form(
        key: _signUpKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: TextFormField(
                controller: _textNickname,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Nickname',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: TextFormField(
                controller: _textEmail,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                    hintText: 'example@gmail.com'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: TextFormField(
                controller: _textPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
                obscureText: true,
              ),
            ),
            /* Button que confirma o cadastro do usuário */
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0)),
                ),
                child: Text('Confirmar',
                    style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    )),
                onPressed: () {
                  if (_signUpKey.currentState!.validate()) {
                    context.read<AppService>().signUp(_textNickname.text,
                        _textEmail.text, _textPassword.text);
                    showRegistrationAlert(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* Função com um alert que informará ao usuário se o cadastro foi efetuado com sucesso */
showRegistrationAlert(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("Cadastro realizado com sucesso!"),
    content: Text(
      "Volte para a página de Login e efetue o login para entrar no jogo!",
      style: TextStyle(fontSize: 17.0),
    ),
    actions: [
      Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(
            "OK",
            style: TextStyle(fontSize: 18.0),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      )
    ],
  );

  /* Função que retorna o alert 'showRegistrationAlert' na screen */
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
