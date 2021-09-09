import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:provider/provider.dart';

//Essa página serve para que o usuário se cadastre no sistema e faça login após

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  final _textNickname = TextEditingController();
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late Future<String> aux;
  String message = "";
  String alertMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF062B06),
      key: _scaffoldKey,
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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              height: 372,
              child:
                  /* Formulário com os campos Nickname, e-mail e senha para efetuar o cadastro */
                  Form(
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFAD200C)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0)),
                        ),
                        child: Text('Confirmar',
                            style: GoogleFonts.robotoCondensed(
                              textStyle: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            )),
                        onPressed: () {
                          if (_signUpKey.currentState!.validate()) {
                            context
                                .read<AppService>()
                                .signUp(_textNickname.text, _textEmail.text,
                                    _textPassword.text)
                                .then((value) {
                              alertMessage = value;
                              if (alertMessage == "Signed Up") {
                                setState(() {
                                  message = "Cadastro realizado com sucesso!";
                                });
                              }
                              if (alertMessage ==
                                  "The email address is badly formatted.") {
                                setState(() {
                                  message = "O endereço de e-mail não é válido";
                                });
                              }
                              if (alertMessage ==
                                  "The email address is already in use by another account.") {
                                setState(() {
                                  message =
                                      "O endereço de e-mail já está sendo usado por outra conta";
                                });
                              }
                              if (alertMessage ==
                                  "Password should be at least 6 characters") {
                                setState(() {
                                  message =
                                      "A senha deve ter pelo menos 6 caracteres";
                                });
                              }
                              if (alertMessage != "Signed Up" &&
                                  alertMessage !=
                                      "The email address is badly formatted." &&
                                  alertMessage !=
                                      "The email address is already in use by another account." &&
                                  alertMessage !=
                                      "Password should be at least 6 characters") {
                                setState(() {
                                  message = "Erro ao efetuar o cadastro";
                                });
                              }
                              return "";
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
          /* Um alerta será mostrado na tela caso algum campo do cadastro tenha sido preenchido incorretamente */
          if (message == "O endereço de e-mail não é válido" ||
              message ==
                  "O endereço de e-mail já está sendo usado por outra conta" ||
              message == "A senha deve ter pelo menos 6 caracteres" ||
              message == "Erro ao efetuar o cadastro")
            Container(
              color: Colors.amber,
              child: ListTile(
                  title: Text(message,
                      style: TextStyle(color: Colors.black, fontSize: 18.0)),
                  leading: Icon(Icons.error),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          message = "";
                        });
                      })),
            ),
          /* Um alerta será mostrado na tela caso o cadastro tenha sido feito com sucesso */
          if (message == "Cadastro realizado com sucesso!")
            Container(
              color: Colors.blue,
              child: ListTile(
                  title: Text(message,
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  subtitle: Text("Retorne para a página de login",
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  leading: Icon(Icons.error),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          message = "";
                        });
                      })),
            )
        ]),
      ),
    );
  }
}
