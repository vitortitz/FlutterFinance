import 'package:firebase/widgets_reuse/widgetsReuse.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import '../../services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final Auth _fireAuth = Auth();

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Cadastro",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("#9ebd13"),
            hexStringToColor("#008552"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Digite o seu nome", Icons.person_outline,
                    false, _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Digite o email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Digite a senha", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Criar nova conta", () async {
                  await _fireAuth
                      .register(
                          _emailTextController.text,
                          _passwordTextController.text,
                          _userNameTextController.text)
                      .then((value) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false);
                  }).onError((error, stackTrace) {
                    _displayWarningMotionToast(context, _fireAuth.warning);
                  });
                })
              ],
            ),
          ))),
    );
  }

  _displayWarningMotionToast(BuildContext context, String warning) {
    MotionToast.warning(
            title: "Erro ao realizar cadastro!!",
            titleStyle: const TextStyle(fontWeight: FontWeight.bold),
            description: warning,
            animationCurve: Curves.bounceIn,
            width: 300,
            animationType: ANIMATION.FROM_TOP,
            position: MOTION_TOAST_POSITION.TOP,
            animationDuration: const Duration(milliseconds: 100))
        .show(context);
  }
}
