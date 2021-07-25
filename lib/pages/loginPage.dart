import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/pages/forgotPasswordPage.dart';
import 'package:gruporoxo20211/pages/signUpPage.dart';

import 'homePage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF062B06),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login',
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
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
      height: 300,
      color: Color(0xFB126012),
      child: Form(
        key: _loginKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'example@gmail.com'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite algo';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite algo';
                  }
                  return null;
                },
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  backgroundColor: MaterialStateProperty.all(Color(0xFFAD200C)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0)),
                ),
                child: Text('Entrar',
                    style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    )),
                onPressed: () {
                  if (_loginKey.currentState!.validate()) {
                    //envia query para login
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: "Não possui uma conta?",
                        ),
                        TextSpan(
                          text: "        Cadastre-se\n",
                          style: TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                            },
                        )
                      ],
                    ),
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Esqueceu a senha?",
                        ),
                        TextSpan(
                          text: "       Recuperar senha",
                          style: TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()));
                            },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
