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
      color: Color(0xFB126012),
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
                    context.read<AppService>()
                        .signUp(_textNickname.text, _textEmail.text, _textPassword.text)
                        .then((_) => Navigator.of(context).pop());
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
