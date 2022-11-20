import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  late String _errorMessage;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  

  Future register(String email, String password, BuildContext context) async {
    setLoading(false);
    try {
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      User? userconf = FirebaseAuth.instance.currentUser;
      
      if (userconf!.emailVerified == false) {
        await userconf.sendEmailVerification();
      }
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to internet");
    } catch (e) {
      setLoading(false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Usuario no válido")));
    }
    notifyListeners();
  }

  Future login(String email, String password, BuildContext context) async {
    setLoading(false);
    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      User? userconf = FirebaseAuth.instance.currentUser;
      
      if (userconf!.emailVerified == false) {
        await userconf.sendEmailVerification();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Enviado")));
      }
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to internet");
    } catch (e) {
      setLoading(false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Usuario no válido")));
    }
    notifyListeners();
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User?> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
