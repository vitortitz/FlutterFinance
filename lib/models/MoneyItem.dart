// ignore_for_file: file_names

import 'package:firebase/models/Money.dart';

import 'Money.dart';

class MoneyItem {
  int quantity;
  final Money? money;

  MoneyItem({this.quantity = 1, required this.money});

  void increment() {
    quantity++;
  }

  // void add() {
  // }

  void substract() {
    quantity--;
  }
}
