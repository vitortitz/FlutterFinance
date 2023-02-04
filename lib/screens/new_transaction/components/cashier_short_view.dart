// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../controllers/money_controller.dart';
import '../../../utils/constants.dart';

class CashierShortView extends StatelessWidget {
  const CashierShortView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MoneyController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Caixa:",
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                controller.cashier.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: defaultPadding / 2),
                  child: Hero(
                    tag:
                        controller.cashier[index].money!.title! + "_cashierTag",
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          AssetImage(controller.cashier[index].money!.image!),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            controller.totalCashierItems().toString(),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        )
      ],
    );
  }
}
