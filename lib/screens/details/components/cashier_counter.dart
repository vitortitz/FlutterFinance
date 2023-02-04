// ignore_for_file: prefer_const_constructors

import 'package:firebase/controllers/money_controller.dart';

import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'rounded_icon_btn.dart';

class CartCounter extends StatefulWidget {
  const CartCounter({
    Key? key,
  }) : super(key: key);

  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  MoneyController moneyController = MoneyController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        children: [
          RoundIconBtn(
            iconData: Icons.remove,
            color: Colors.black38,
            press: () {
              setState(() {
                moneyController.remove();
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 4),
            child: Text(
              "${MoneyController.quantity}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
          RoundIconBtn(
            iconData: Icons.add,
            color: Colors.black38,
            press: () {
              setState(() {
                moneyController.add();
              });
            },
          ),
        ],
      ),
    );
  }
}
