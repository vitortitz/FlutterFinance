import 'package:firebase/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/color_utils.dart';
import '../home/components/transaction_list.dart';

double vaultdaily = 0;
DateTime? date;
Stream? dayStream;

class ListFilteredDaily extends StatefulWidget {
  const ListFilteredDaily({Key? key}) : super(key: key);

  @override
  State<ListFilteredDaily> createState() => _ListFilteredDailyState();
}

class _ListFilteredDailyState extends State<ListFilteredDaily> {
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
            text: TextSpan(
                text: 'Saldo do dia: ',
                style: const TextStyle(fontSize: 25, color: Colors.black),
                children: [
              TextSpan(
                  text: 'R\$ $vaultdaily',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: vaultColor(vaultdaily)))
            ])),
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
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
