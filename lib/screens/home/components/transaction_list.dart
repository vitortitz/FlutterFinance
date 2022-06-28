import 'package:firebase/screens/home/components/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'dart:core';

Widget transactionList(BuildContext context, Stream stream) {
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
                  return TransactionTile(
                    date: snapshot.data.docs[index].data()["date"].toDate(),
                    description:
                        snapshot.data.docs[index].data()["description"],
                    type: snapshot.data.docs[index].data()["type"],
                    value: snapshot.data.docs[index].data()["value"],
                    category: snapshot.data.docs[index].data()["category"],
                  );
                }));
      },
    ),
  );
}
