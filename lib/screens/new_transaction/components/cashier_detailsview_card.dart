import 'package:firebase/controllers/money_controller.dart';
import 'package:flutter/material.dart';

import '../../../models/MoneyItem.dart';
import '../../../utils/constants.dart';

class MoneyDetailsViewCashier extends StatefulWidget {
  MoneyDetailsViewCashier({Key? key, required this.moneyItem})
      : super(key: key);

  final MoneyItem moneyItem;
  final MoneyController moneyController = MoneyController();

  @override
  State<MoneyDetailsViewCashier> createState() =>
      _MoneyDetailsViewCashierState();
}

class _MoneyDetailsViewCashierState extends State<MoneyDetailsViewCashier> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(widget.moneyItem.money!.image!),
      ),
      title: Text(
        '${widget.moneyItem.money!.title!} ${widget.moneyItem.money!.type}',
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: FittedBox(
        child: Row(
          children: [
            Text(
              "  x ${widget.moneyItem.quantity}",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
