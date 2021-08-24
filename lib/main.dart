import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gruporoxo20211/AppService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gruporoxo20211/pages/homepage.dart';
import 'package:gruporoxo20211/pages/loginPage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AppService>(
            create: (_) => AppService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AppService>().authStateChanges,
            initialData: null,
          )
        ],
        child: MaterialApp(
          title: 'AuthenticationWrapper',
          home: AuthenticationWrapper()
        )
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomePage();
    }

    return LoginPage();
  }
}
