// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:firebase/services/auth.dart';
import 'package:firebase/services/prefs_service.dart';

import 'package:firebase/widgets_reuse/widgetsReuse.dart';
import 'package:firebase/screens/home/home.dart';

import 'package:firebase/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

import 'reset_pw.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool deviceSupported = false;

  final Auth _fireAuth = Auth();

  @override
  void initState() {
    super.initState();
    _initBiometrics();
    Future.wait([
      PrefsService.isAuth(),
    ]).then((value) => value[0]! ? loginBiometric() : null);
  }

  void loginBiometric() async {
    bool _res = await _auth();
    if (_res) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false);
    }
    return null;
  }

  Future<List<BiometricType>> _initBiometrics() async {
    deviceSupported = await _localAuth.isDeviceSupported();
    List<BiometricType> _availableBiometrics = <BiometricType>[];
    if (deviceSupported) {
      try {
        if (await _localAuth.canCheckBiometrics) {
          _availableBiometrics = await _localAuth.getAvailableBiometrics();
          return _availableBiometrics;
        }
      } catch (e) {
        deviceSupported = false;
      }
    }
    return [];
  }

  Future<bool> _auth() async {
    bool authentication = false;
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      authentication = await _localAuth.authenticate(
          localizedReason: "Desbloqueie seu celular!",
          authMessages: <AuthMessages>[
            AndroidAuthMessages(
                signInTitle: 'Oops! Autenticação biométrica necessária.',
                biometricHint: '')
          ]);
      return authentication;
    } catch (e) {
      return false;
    }
  }

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              Text('Kashie',
                  style: GoogleFonts.bebasNeue(
                      textStyle: TextStyle(
                          color: Colors.white70,
                          letterSpacing: 8,
                          fontSize: 70))),
              logoWidget("assets/images/logo1.png"),
              const SizedBox(
                height: 30,
              ),
              reusableTextField("Digite o usuário", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Digite a senha", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 5,
              ),
              forgetPassword(context),
              firebaseUIButton(context, "Entrar", () async {
                await _fireAuth
                    .siginInEmailAndPass(context, _emailTextController.text,
                        _passwordTextController.text)
                    .then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) => false);
                }).onError((error, stackTrace) {
                  _displayErrorMotionToast(context, _fireAuth.erro);
                });
              }),
              signUpOption()
            ],
          ),
        ),
      ),
    ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Não possui conta?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUp()));
          },
          child: const Text(
            " Cadastre-se Já",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Esqueceu a senha?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }

  _displayErrorMotionToast(BuildContext context, String error) {
    MotionToast.error(
            title: Text("Erro ao realizar login!"),
            description: Text(error),
            animationCurve: Curves.bounceIn,
            width: 300,
            animationType: AnimationType.fromTop,
            position: MotionToastPosition.top,
            animationDuration: Duration(milliseconds: 100))
        .show(context);
  }
}
