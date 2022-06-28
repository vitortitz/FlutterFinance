// ignore_for_file: prefer_const_constructors

import 'package:firebase/models/user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../new_transaction/new_transaction.dart';

Widget speedDialMenu(BuildContext context, UserTransaction newTransaction) {
  return SpeedDial(
    animatedIcon: AnimatedIcons.menu_close,
    children: [
      SpeedDialChild(
          onTap: () {
            newTransaction.type = 'Gasto';
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewTransaction(
                          newTransaction: newTransaction,
                        )));
          },
          child: Icon(Icons.arrow_downward_rounded),
          backgroundColor: Color.fromARGB(255, 238, 140, 140),
          labelBackgroundColor: Color.fromARGB(255, 238, 140, 140),
          label: 'Retirar do Cofrinho'),
      SpeedDialChild(
          onTap: () {
            newTransaction.type = 'Ganho';
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewTransaction(
                          newTransaction: newTransaction,
                        )));
          },
          child: Icon(Icons.arrow_upward_rounded),
          backgroundColor: Color.fromARGB(255, 190, 245, 209),
          labelBackgroundColor: Color.fromARGB(255, 190, 245, 209),
          label: 'Guardar no Cofrinho'),
    ],
  );
}
