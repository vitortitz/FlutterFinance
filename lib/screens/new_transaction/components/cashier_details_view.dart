// ignore_for_file: prefer_const_constructors
import 'package:confetti/confetti.dart';
import 'package:firebase/controllers/money_controller.dart';
import 'package:firebase/services/database.dart';
import 'package:flutter/material.dart';
import '../../../models/user_transaction.dart';
import '../../../utils/constants.dart';
import '../../home/home.dart';
import 'cashier_detailsview_card.dart';

class CashierDetailsView extends StatelessWidget {
  CashierDetailsView(
      {Key? key, required this.controller, required this.newTransaction})
      : super(key: key);

  final UserTransaction newTransaction;
  final MoneyController controller;
  final confetticontroller = ConfettiController();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    DatabaseService db = DatabaseService();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Caixa:", style: Theme.of(context).textTheme.headline6),
          ...List.generate(
            controller.cashier.length,
            (index) =>
                MoneyDetailsViewCashier(moneyItem: controller.cashier[index]),
          ),
          SizedBox(height: defaultPadding),
          Center(
            child: confetti(context),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  newTransaction.value = controller.initialValue;
                  db.addTransaction(newTransaction, context);
                  confetticontroller.play();
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false);
                  });
                },
                child: Text("Confirmar - R\$ ${controller.initialValue}")),
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
}
