// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/services/prefs_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/models/user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var erro;
  var warning;

  UserLogged? __userLoggedFireBase(User user) {
    return user != null ? UserLogged(uid: user.uid) : null;
  }

  Future siginInEmailAndPass(String email, String password) async {
    UserCredential result;
    User? userLogged;
    try {
      result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userLogged = result.user;

      userLogged?.updateDisplayName('Vitor');

      PrefsService.save(userLogged?.uid);
    } on FirebaseAuthException catch (e, s) {
      erro = _handleFirebaseLoginWithCredentialsException(e, s);
    }
    return __userLoggedFireBase(userLogged!);
  }

  Future register(String email, String password, String name) async {
    UserCredential result;
    User? userLogged;
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      userLogged = result.user;
      _auth.currentUser?.updateDisplayName(name);
      FirebaseFirestore.instance
          .collection('UsersData')
          .doc(userLogged?.uid)
          .set({'vault': 0.0});
      PrefsService.save(userLogged?.uid);
    } on FirebaseAuthException catch (e, s) {
      warning = _handleFirebaseLoginWithCredentialsException(e, s);
    }
    return __userLoggedFireBase(userLogged!);
  }

  Future logout() async {
    try {
      PrefsService.logout();
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  String _handleFirebaseLoginWithCredentialsException(
      FirebaseAuthException e, StackTrace s) {
    if (e.code == 'user-disabled') {
      return 'O usuário informado está desabilitado.';
    } else if (e.code == 'user-not-found') {
      return 'O usuário informado não está cadastrado.';
    } else if (e.code == 'invalid-email') {
      return 'O domínio do e-mail informado é inválido.';
    } else if (e.code == 'wrong-password') {
      return 'A senha informada está incorreta.';
    } else if (e.code == 'email-already-in-use') {
      return 'e-mail já está em uso';
    } else if (e.code == 'weak-password') {
      return 'Senha deve conter no minímo 6 caracteres';
    } else {
      return 'Erro Desconhecido';
    }
  }
}
