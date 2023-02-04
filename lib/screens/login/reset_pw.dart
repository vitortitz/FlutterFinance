// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/widgets_reuse/widgetsReuse.dart';
import 'package:firebase/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- SEE HERE
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Redefinir Senha",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("#139ebd"),
            hexStringToColor("#520085"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Digite o email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Redefinir senha", () {
                  FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _emailTextController.text)
                      .then((value) {
                    Navigator.of(context).pop();
                  }).onError((error, stackTrace) =>
                          _displayErrorMotionToast(context, "Erro"));
                })
              ],
            ),
          ))),
    );
  }
}

_displayErrorMotionToast(BuildContext context, String error) {
  MotionToast.error(
          title: Text("Erro ao realizar redefinção!"),
          description: Text(error),
          animationCurve: Curves.bounceIn,
          width: 300,
          animationType: AnimationType.fromTop,
          position: MotionToastPosition.top,
          animationDuration: Duration(milliseconds: 100))
      .show(context);
}

_displaySucessMotionToast(BuildContext context) {
  MotionToast.success(
          title: Text("Redefinição com sucesso!"),
          description:
              Text("Informações para redefinição enviada ao seu email"),
          animationCurve: Curves.bounceIn,
          width: 300,
          animationType: AnimationType.fromTop,
          position: MotionToastPosition.top,
          animationDuration: Duration(milliseconds: 100))
      .show(context);
}
