import 'package:flutter/material.dart';

import '../models/Money.dart';
import '../models/MoneyItem.dart';

enum MoneyState { normal, cashier }

class MoneyController extends ChangeNotifier {
  MoneyState moneyState = MoneyState.normal;

  List<MoneyItem> cashier = [];
  double initialValue = 0;
  static int quantity = 1;

  void add() {
    quantity++;
  }

  void remove() {
    if (quantity > 1) {
      quantity--;
    }
  }

  void changeMoneyState(MoneyState state) {
    moneyState = state;
    notifyListeners();
  }

  void addMoneyToCashier(Money money) {
    for (MoneyItem item in cashier) {
      if (item.money!.title == money.title) {
        item.quantity += quantity;
        initialValue += double.parse("${item.money!.title}") * quantity;
        notifyListeners();
        return;
      }
    }

    cashier.add(MoneyItem(money: money, quantity: quantity));
    initialValue += double.parse("${money.title}") * quantity;
    notifyListeners();
  }

  void removeMoneyToCashier(Money money) {
    for (MoneyItem item in cashier) {
      if (item.money!.title == money.title) {
        initialValue -= double.parse("${item.money!.title}");
        item.substract();
        notifyListeners();
        return;
      }
    }
    cashier.remove(MoneyItem(money: money));
    initialValue -= double.parse("${money.title}");
    notifyListeners();
  }

  int totalCashierItems() => cashier.fold(
      0, (previousValue, element) => previousValue + element.quantity);
}
