import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  Map? _userData;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return '${e.message}';
    }
  }

  Future<String> signUp(String nickname, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.currentUser!.updateDisplayName(nickname);
      await _users.add({
        'nick': nickname,
        'email': email,
        'wins': 0,
        'losses': 0,
      });

      setUserData(nickname, email, 0, 0);

      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return '${e.message}';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void setUserData(String nickname, String email, int wins, int losses) {
    _userData = {'nick': nickname, 'email': email, 'wins': 0, 'losses': 0};
  }

  String? getNickname() {
    return _firebaseAuth.currentUser!.displayName;
  }

  String? getEmail() {
    return _firebaseAuth.currentUser!.email;
  }

  int getWins() {
    return _userData!['wins'];
  }

  int getLosses() {
    return _userData!['losses'];
  }
}
