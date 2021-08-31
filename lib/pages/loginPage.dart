import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/pages/forgotPasswordPage.dart';
import 'package:flutter/gestures.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/pages/signUpPage.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF062B06),
      child: Column(children: <Widget>[
        /* Imagem representativa do jogo */
        Container(
          margin: EdgeInsets.only(top: 30.0, bottom: 0.0),
          child: Image.asset(
            'assets/images/imageFromHomePage.png',
            width: 300,
            height: 100,
          ),
        ),
        /* Título do jogo */
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
        Card(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
          color: Color(0xFB126012),
          /* Formulário com os campos e-mail e senha */
          child: Form(
            key: _loginKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextFormField(
                    controller: _textEmail,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Email',
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
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFAD200C)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0)),
                      ),
                      /* Button para efetuar o login e entrar no jogo */
                      child: Text('Entrar',
                          style: GoogleFonts.robotoCondensed(
                            textStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          )),
                      onPressed: () {
                        if (_loginKey.currentState!.validate()) {
                          context
                              .read<AppService>()
                              .signIn(_textEmail.text, _textPassword.text);
                        }
                      }),
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
                            /* Redireciona para a page de cadastro, caso o usuário não possua uma conta e queira efetuar o cadastro */
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
                            /* Redireciona para a page de recuperar a senha, caso do usuário tenha esquecido a senha */
                            TextSpan(
                              text: "       Recuperar senha",
                              style: TextStyle(color: Colors.blue),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()));
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
        )
      ]),
    );
  }
}
