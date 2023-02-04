import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/user_transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  getTransactionsData() async {
    User user = FirebaseAuth.instance.currentUser!;

    return FirebaseFirestore.instance
        .collection("UsersData")
        .doc(user.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  getTransactionsDataDaily(DateTime date) async {
    User user = FirebaseAuth.instance.currentUser!;

    return FirebaseFirestore.instance
        .collection("UsersData")
        .doc(user.uid)
        .collection('transactions')
        .where('date', isEqualTo: date)
        .snapshots();
  }

  getTransactionsDataRange(DateTime dateStart, DateTime dateEnd) async {
    User user = FirebaseAuth.instance.currentUser!;

    return FirebaseFirestore.instance
        .collection("UsersData")
        .doc(user.uid)
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: dateStart)
        .where('date', isLessThanOrEqualTo: dateEnd)
        .snapshots();
  }

  Future<double> getVaultValue() async {
    User user = FirebaseAuth.instance.currentUser!;
    num sum = 0.0;
    await FirebaseFirestore.instance
        .collection("UsersData")
        .doc(user.uid)
        .collection('transactions')
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        num value = element.data()["value"];
        sum = sum + value;
      }
    });
    return double.parse(sum.toString());
  }

  Future<double> getVaultValueDaily(DateTime date) async {
    User user = FirebaseAuth.instance.currentUser!;
    num sum = 0.0;
    await FirebaseFirestore.instance
        .collection("UsersData")
        .doc(user.uid)
        .collection('transactions')
        .where('date', isEqualTo: date)
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        num value = element.data()["value"];
        sum = sum + value;
      }
    });
    return double.parse(sum.toString());
  }

  Future<double> getVaultValueRange(
      DateTime dateStart, DateTime dateEnd) async {
    User user = FirebaseAuth.instance.currentUser!;
    num sum = 0.0;
    await FirebaseFirestore.instance
        .collection("UsersData")
        .doc(user.uid)
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: dateStart)
        .where('date', isLessThanOrEqualTo: dateEnd)
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        num value = element.data()["value"];
        sum = sum + value;
      }
    });
    return double.parse(sum.toString());
  }

  Future addTransaction(
      UserTransaction newTransaction, BuildContext context) async {
    User user = FirebaseAuth.instance.currentUser!;
    if (newTransaction.type == 'Gasto') {
      newTransaction.value = newTransaction.value! * -1;
      newTransaction.date =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(newTransaction.date!))
              .toLocal();
      FirebaseFirestore.instance
          .collection('UsersData')
          .doc(user.uid)
          .collection('transactions')
          .doc()
          .set(newTransaction.toJson());
    } else {
      FirebaseFirestore.instance
          .collection('UsersData')
          .doc(user.uid)
          .collection('transactions')
          .doc()
          .set(newTransaction.toJson());
    }
  }

  deletTransaction(id, BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('UsersData')
        .doc(user.uid)
        .collection('transactions')
        .doc(id)
        .delete();
  }
}
