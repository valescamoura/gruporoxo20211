import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/pages/loginPage.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _resetPasswordKey = GlobalKey<FormState>();
  final _textEmail = TextEditingController();
  String message = "";
  String alertMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFF062B06),
        appBar: AppBar(
          centerTitle: true,
          /* Título da Page */
          title: const Text(
            'Recuperar senha',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFAD200C),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ),
        body: Column(children: [
          /* Formulário com o campo 'e-mail' para o usuário preencher */
          Form(
            key: _resetPasswordKey,
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
                /* Button responsável por enviar para o firebase o e-mail do usuário que deseja redefinir a senha */
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                      child: Text('Enviar',
                          style: GoogleFonts.robotoCondensed(
                            textStyle:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                          )),
                      onPressed: () {
                        if (_resetPasswordKey.currentState!.validate()) {
                          context
                              .read<AppService>()
                              .resetPassword(_textEmail.text)
                              .then((value) {
                            alertMessage = value;
                            print(alertMessage);
                            if (alertMessage == "Sent") {
                              setState(() {
                                message = "E-mail enviado!";
                              });
                            } else {
                              setState(() {
                                message = "Erro ao enviar e-mail";
                              });
                            }
                            return "";
                          });
                        }
                      }),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          /* Um alerta será mostrado na tela caso a solicitação de redefinição de senha tenha sido feita corretamente e o e-mail com o link de redefinição de senha enviado com sucesso para o usuário */
          if (message == "E-mail enviado!")
            Container(
              color: Colors.blue,
              child: ListTile(
                  title: Text(message,
                      style: TextStyle(color: Colors.black, fontSize: 18.0)),
                  subtitle: Text(
                      "Click no link enviado e faça a alteração da senha",
                      style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  leading: Icon(Icons.error),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          message = "";
                        });
                      })),
            ),
          /* Um alerta será mostrado na tela caso a solicitação de redefinição de senha tenha dado algum erro */
          if (message == "Erro ao enviar e-mail")
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
            )
        ]));
  }
}
