import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  AuthProvider() {
    _auth.authStateChanges().listen((user) async {
      _user = user;
      if (user != null) {
        _token = await user.getIdToken();
      } else {
        _token = null;
      }
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    _user = result.user;
    if (_user != null) {
      _token = await _user!.getIdToken();
    }
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    _user = result.user;
    if (_user != null) {
      _token = await _user!.getIdToken();
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _token = null;
    notifyListeners();
  }
}
