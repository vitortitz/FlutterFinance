import 'package:firebase/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home/components/transaction_list.dart';

double vaultdaily = 0;
DateTime? date;
Stream? dayStream;

class listFilteredDaily extends StatefulWidget {
  listFilteredDaily({Key? key}) : super(key: key);

  @override
  State<listFilteredDaily> createState() => _listFilteredDailyState();
}

class _listFilteredDailyState extends State<listFilteredDaily> {
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Saldo do dia R\$ $vaultdaily'),
        ElevatedButton(
            onPressed: () => datePickerDaily(context),
            child: Text(getDateAsText())),
        if (date != null) transactionList(context, dayStream!)
      ],
    );
  }

  String getDateAsText() {
    if (date == null) {
      return 'Selecione uma Data';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
    }
  }

  datePickerDaily(BuildContext context) async {
    final today = DateTime.now().toLocal();

    final _transactionDate = await showDatePicker(
      context: context,
      initialDate: date ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
    );

    if (_transactionDate == null) {
      return;
    } else {
      setState(() {
        date = _transactionDate;
        db
            .getTransactionsDataDaily(DateTime.parse(
                DateFormat('yyyy-MM-dd').format(date!.toLocal())))
            .then((value) {
          setState(() {
            dayStream = value;
          });
        });
        Future.wait([
          db.getVaultValueDaily(
              DateTime.parse(DateFormat('yyyy-MM-dd').format(date!.toLocal())))
        ]).then((value) {
          setState(() {
            vaultdaily = value[0];
          });
        });
      });
    }
  }
}
