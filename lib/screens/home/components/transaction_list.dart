import 'package:firebase/screens/home/components/transaction_tile.dart';
import 'package:firebase/screens/home/home.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter_slidable/flutter_slidable.dart';

enum Actions { edit, delete }

User user = FirebaseAuth.instance.currentUser!;
Widget transactionList(BuildContext context, Stream stream) {
  DatabaseService db = DatabaseService();
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    child: StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.data == null
            ? Container()
            : ListView.builder(
                padding: const EdgeInsets.only(top: 0),
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data?.size,
                itemBuilder: ((context, index) {
                  return Slidable(
                    endActionPane:
                        ActionPane(motion: const StretchMotion(), children: [
                      SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Deletar',
                          onPressed: ((context) async {
                            await db.deletTransaction(
                                snapshot.data.docs[index].id, context);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (Route<dynamic> route) => false,
                            );
                          }))
                    ]),
                    child: TransactionTile(
                      date: snapshot.data.docs[index].data()["date"].toDate(),
                      description:
                          snapshot.data.docs[index].data()["description"],
                      type: snapshot.data.docs[index].data()["type"],
                      value: snapshot.data.docs[index].data()["value"],
                      category: snapshot.data.docs[index].data()["category"],
                    ),
                  );
                }));
      },
    ),
  );
}
