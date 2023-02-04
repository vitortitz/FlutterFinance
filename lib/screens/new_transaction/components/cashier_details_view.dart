// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:firebase/controllers/money_controller.dart';
import 'package:firebase/services/database.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import '../../../models/user_transaction.dart';
import '../../../services/auth.dart';
import '../../../utils/constants.dart';
import '../../home/home.dart';
import 'cashier_detailsview_card.dart';

class CashierDetailsView extends StatefulWidget {
  const CashierDetailsView(
      {Key? key, required this.controller, required this.newTransaction})
      : super(key: key);
  final UserTransaction newTransaction;
  final MoneyController controller;

  @override
  State<CashierDetailsView> createState() => _CashierDetailsViewState();
}

class _CashierDetailsViewState extends State<CashierDetailsView> {
  bool isActive = true;
  final Auth _fireAuth = Auth();
  var confettiController = ConfettiController();

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(duration: Duration(seconds: 1));
  }

  final confetticontroller = ConfettiController();

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  false, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
          Text("Caixa:", style: Theme.of(context).textTheme.headline6),
          ...List.generate(
            widget.controller.cashier.length,
            (index) => MoneyDetailsViewCashier(
                moneyItem: widget.controller.cashier[index]),
          ),
          SizedBox(height: defaultPadding),
          Center(
            child: confetti(context),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                onPressed: () async {
                  if (isActive) {
                    widget.newTransaction.value =
                        widget.controller.initialValue;
                    await db
                        .addTransaction(widget.newTransaction, context)
                        .then((value) {
                      confetticontroller.play();
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      });
                    }).onError((error, stackTrace) =>
                            _displayErrorMotionToast(context, _fireAuth.erro));
                  } else {
                    _displayErrorMotionToastTrans(context);
                  }
                  setState(() {
                    isActive = false;
                  });
                },
                child:
                    Text("Confirmar - R\$ ${widget.controller.initialValue}")),
          ),
          Text(
              'Caso deseja escolher outro valor, volte a página de DATA E DESCRIÇÃO e clique em continuar novamente')
        ],
      ),
    );
  }

  confetti(BuildContext context) {
    return ConfettiWidget(
      confettiController: confetticontroller,
      shouldLoop: false,
      blastDirectionality: BlastDirectionality.explosive,
      maxBlastForce: 20,
      numberOfParticles: 50,
    );
  }

  _displayErrorMotionToast(BuildContext context, String error) {
    MotionToast.error(
            title: Text("Erro ao realizar transação!"),
            description: Text(error),
            animationCurve: Curves.bounceIn,
            width: 300,
            animationType: AnimationType.fromTop,
            position: MotionToastPosition.top,
            animationDuration: Duration(milliseconds: 100))
        .show(context);
  }

  _displayErrorMotionToastTrans(BuildContext context) {
    MotionToast.error(
            title: Text("Erro ao realizar transação!"),
            description: Text("Transação já realiazada aguarde!"),
            animationCurve: Curves.bounceIn,
            width: 300,
            animationType: AnimationType.fromTop,
            position: MotionToastPosition.top,
            animationDuration: Duration(milliseconds: 100))
        .show(context);
  }
}
