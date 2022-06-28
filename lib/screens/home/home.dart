// ignore_for_file: prefer_const_constructors

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase/screens/reports/report_range.dart';
import 'package:firebase/services/database.dart';
import 'package:flutter/services.dart';
import 'package:firebase/models/user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../reports/report_daily.dart';
import 'components/dial_menu.dart';
import 'components/transaction_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;
  final menuIsOpen = ValueNotifier<bool>(false);
  late Stream quizStream;
  Stream? dayStream;
  DatabaseService db = DatabaseService();
  double vault = 0;
  double vaultdaily = 0;
  final newTransaction = UserTransaction(null, null, null, null, null);
  late int currentIndex;
  DateTime? date;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    Future.wait([db.getVaultValue()]).then((value) {
      setState(() {
        vault = value[0];
      });
    });
    db.getTransactionsData().then((value) {
      setState(() {
        quizStream = value;
      });
    });

    super.initState();

    animation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    currentIndex = 0;
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  toggleMenu() {
    menuIsOpen.value ? animation.reverse() : animation.forward();
    menuIsOpen.value = !menuIsOpen.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    'assets/images/logo1.png',
                    alignment: Alignment.centerLeft,
                  ),
                  title: RichText(
                    text: TextSpan(
                        text: 'Cofrinho: ',
                        style: TextStyle(fontSize: 25),
                        children: [
                          TextSpan(
                              text: 'R\$ $vault',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: vaultColor()))
                        ]),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                (currentIndex == 0)
                    ? transactionList(context, quizStream)
                    : (currentIndex == 1)
                        ? listFilteredDaily()
                        : ReportRange(),
              ]))
            ],
          ),
        ),
        bottomNavigationBar: bubbleMenu(context),
        floatingActionButton: speedDialMenu(context, newTransaction),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked);
  }

  Widget bubbleMenu(BuildContext context) {
    return BubbleBottomBar(
      opacity: .2,
      currentIndex: currentIndex,
      onTap: changePage,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      elevation: 8,
      fabLocation: BubbleBottomBarFabLocation.end, //new
      hasNotch: true, //new
      hasInk: true, //new, gives a cute ink effect
      inkColor: Colors.black12, //optional, uses theme color if not specified
      items: const <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            title: Text("Início")),
        BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple,
            icon: Icon(
              Icons.category_rounded,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.category_rounded,
              color: Colors.deepPurple,
            ),
            title: Text("Relatório Diário")),
        BubbleBottomBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(
              Icons.folder_open,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.folder_open,
              color: Colors.indigo,
            ),
            title: Text("Relátorio Mensal")),
      ],
    );
  }

  vaultColor() {
    if (vault < 0) {
      return Colors.red;
    } else if (vault > 0) {
      return Colors.green;
    } else {
      Colors.white;
    }
  }

  String getDateAsText() {
    if (date == null) {
      return 'Selecione uma Data';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
    }
  }
}
