// ignore_for_file: prefer_const_constructors

import 'package:firebase/controllers/money_controller.dart';
import 'package:flutter/material.dart';

import '../../models/Money.dart';
import '../../utils/constants.dart';
import 'components/cashier_counter.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key, required this.money, required this.onMoneyAdd})
      : super(key: key);

  final Money money;
  final VoidCallback onMoneyAdd;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _cashierTag = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
              onPressed: () {
                widget.onMoneyAdd();
                setState(() {
                  _cashierTag = '_cashierTag';
                  MoneyController.quantity = 1;
                });
                Navigator.pop(context);
              },
              child: Text("Adicionar"),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.37,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  color: Color(0xFFF8F8F8),
                  child: Hero(
                    tag: widget.money.title! + _cashierTag,
                    child: Image.asset(widget.money.image!),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  child: CartCounter(),
                )
              ],
            ),
          ),
          SizedBox(height: defaultPadding * 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "${widget.money.title!} ${widget.money.type!}",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              "Deseja adicionar essa quantia de notas/moedas de ${widget.money.title!} ${widget.money.type!}?",
              style: TextStyle(
                color: Color(0xFFBDBDBD),
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(
        color: Colors.black,
      ),
      backgroundColor: Color(0xFFF8F8F8),
      elevation: 0,
      centerTitle: true,
    );
  }
}
