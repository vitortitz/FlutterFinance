import 'package:firebase/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home/components/transaction_list.dart';

Stream? rangeStream;
double vaultrange = 0;
DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().toLocal(),
    end: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 5));
DateTimeRange? newDateRange;

class ReportRange extends StatefulWidget {
  ReportRange({Key? key}) : super(key: key);

  @override
  State<ReportRange> createState() => _ReportRangeState();
}

class _ReportRangeState extends State<ReportRange> {
  DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text('Saldo do dia R\$ $vaultrange'),
        ElevatedButton(
            style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(size.width - 20, 50))),
            onPressed: () => datePickerDaily(context),
            child: Text(getDateAsText())),
        if (newDateRange != null) transactionList(context, rangeStream!)
      ],
    );
  }

  String getDateAsText() {
    if (newDateRange == null) {
      return 'Selecione uma Data';
    } else {
      var start = DateFormat('dd/MM/yyyy').format(dateRange.start);
      var end = DateFormat('dd/MM/yyyy').format(dateRange.end);
      return "$start - $end";
    }
  }

  datePickerDaily(BuildContext context) async {
    final today = DateTime.now().toLocal();

    newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
    );

    if (newDateRange == null) {
      return;
    } else {
      setState(() {
        dateRange = newDateRange!;
        db
            .getTransactionsDataRange(
                DateTime.parse(
                    DateFormat('yyyy-MM-dd').format(dateRange.start.toLocal())),
                DateTime.parse(
                    DateFormat('yyyy-MM-dd').format(dateRange.end.toLocal())))
            .then((value) {
          setState(() {
            rangeStream = value;
          });
        });
        Future.wait([
          db.getVaultValueRange(
              DateTime.parse(
                  DateFormat('yyyy-MM-dd').format(dateRange.start.toLocal())),
              DateTime.parse(
                  DateFormat('yyyy-MM-dd').format(dateRange.end.toLocal())))
        ]).then((value) {
          setState(() {
            vaultrange = value[0];
          });
        });
      });
    }
  }
}
