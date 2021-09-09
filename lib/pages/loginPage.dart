import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:gruporoxo20211/pages/forgotPasswordPage.dart';
import 'package:gruporoxo20211/pages/signUpPage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

//Pagina utilizada para fazer o login através do email e senha
//Também possui redirecionamento para: forgotPassword e signUp
//caso não tenha ninguem logado, ela será a primeira a aparecer

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final String oneSignalAppId = "77921c19-8d0d-48da-ae17-caf67a5bd4a7";
  String message = "";
  String alertMessage = "";
  String userId = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF062B06),
        key: _scaffoldKey,
        body: SingleChildScrollView(
            child: Container(
          child: Column(children: <Widget>[
            /* Imagem representativa do jogo */
            Container(
              margin: EdgeInsets.only(top: 30.0, bottom: 0.0),
              child: Image.asset(
                'assets/images/imageFromHomePage.png',
                width: 250,
                height: 80,
              ),
            ),
            /* Nome do jogo */
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
                        fontSize: 48.0,
                        decoration: TextDecoration.none)),
              ),
            ]),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 55),
              color: Color(0xFB126012),
              /* Formulário com os campos e-mail e senha para o usuário preencher */
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
                            labelText: 'E-mail',
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
                            return 'Digite algo';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      /*Button que efetuará o login do usuário no jogo */
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
                        child: Text('Entrar',
                            style: GoogleFonts.robotoCondensed(
                              textStyle: TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            )),
                        onPressed: () {
                          context.read<AppService>().setOneSignalId(userId);
                          if (_loginKey.currentState!.validate()) {
                            context
                                .read<AppService>()
                                .signIn(_textEmail.text, _textPassword.text)
                                .then((value) {
                              alertMessage = value;
                              print(alertMessage);
                              if (alertMessage ==
                                  "The password is invalid or the user does not have a password.") {
                                setState(() {
                                  message = "Senha ou e-mail inválidos!";
                                });
                                print(message);
                              }
                              if (alertMessage != "Signed In" &&
                                  alertMessage != "" &&
                                  alertMessage !=
                                      "The password is invalid or the user does not have a password.") {
                                setState(() {
                                  message = "Erro ao efetuar login!";
                                });
                              }
                              return "";
                            });
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpPage()));
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
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
            ),
            SizedBox(height: 20.0),
            /* Um alerta será mostrado na tela caso o usuário tenha preenchido o e-mail ou senha incorretamente, não podendo consequentemente efetuar o login corretamente */
            if (message == "Senha ou e-mail inválidos!" ||
                message == "Erro ao efetuar login!")
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
          ]),
        )));
  }

  Future<void> initPlatformState() async {
    //Faz a conexão do aplicativo com o oneSignal
    await OneSignal.shared.setAppId(oneSignalAppId);

    // Obtém o userId Onesignal
    // Para que possa ser usado para enviar notificações aos usuários posteriormente.̥
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    userId = osUserID.toString();
  }
}
