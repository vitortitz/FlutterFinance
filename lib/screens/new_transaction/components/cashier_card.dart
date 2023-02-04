// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../models/Money.dart';
import '../../../utils/constants.dart';

class MoneyCashier extends StatelessWidget {
  const MoneyCashier({
    Key? key,
    required this.money,
    required this.press,
  }) : super(key: key);

  final Money money;

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultPadding * 1.25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: money.title!,
              child: Image.asset(money.image!),
            ),
            Center(
              child: Text(
                money.title!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Center(
              child: Text(
                money.type!,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
