import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/pages/loginPage.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF062B06),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Esqueci a senha',
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
      body: ForgotPasswordForm(),
    );
  }
}

class ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
      height: 300,
      color: Color(0xFB126012),
      child: Form(
        key: _signUpKey,
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
                    return 'Este campo é obrigatório';
                  }
                  return null;
                },
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
                child: Text('Enviar',
                    style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                    )),
                onPressed: () {
                  if (_signUpKey.currentState!.validate()) {
                    //envia query para recuperar senha
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
