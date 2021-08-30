import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/pages/LoginPage.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
    final _textEmail = TextEditingController();
    return Scaffold(
        backgroundColor: Color(0xFF062B06),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Recuperar senha',
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
        body: Column(children: [
          Form(
            key: _signUpKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
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
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFAD200C)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0)),
                    ),
                    child: Text('Enviar',
                        style: GoogleFonts.robotoCondensed(
                          textStyle:
                              TextStyle(fontSize: 18.0, color: Colors.white),
                        )),
                    onPressed: () {
                      if (_signUpKey.currentState!.validate()) {
                        context
                            .read<AppService>()
                            .resetPassword(_textEmail.text);
                        showRessetPasswordSentAlert(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}

showRessetPasswordSentAlert(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("E-mail enviado!"),
    content: Text(
      "Verifique seu e-mail e click no link recebido para então resetar sua senha do jogo.",
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

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
