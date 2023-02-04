// ignore_for_file: prefer_const_constructors

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase/screens/login/signin.dart';
import 'package:firebase/screens/reports/report_range.dart';
import 'package:firebase/services/database.dart';
import 'package:flutter/services.dart';
import 'package:firebase/models/user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/auth.dart';
import '../../utils/color_utils.dart';
import '../../widgets_reuse/widgetsReuse.dart';
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
  bool _isLoading = true;
  final Auth _fireAuth = Auth();
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));

    Future.wait([db.getVaultValue()]).then((value) {
      setState(() {
        vault = value[0];
      });
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      db.getTransactionsData().then((value) {
        setState(() {
          quizStream = value;
          _isLoading = false;
        });
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
                backgroundColor: hexStringToColor("#139ebd"),
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
                                  color: vaultColor())),
                        ]),
                  ),
                ),
                actions: [
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: RichText(
                        text: TextSpan(
                            text: "Sair", style: TextStyle(fontSize: 15))),
                    onPressed: () async {
                      _fireAuth.logout().then((value) => Navigator.of(context)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => SignIn()),
                              (Route<dynamic> route) => false));
                    },
                  )
                ],
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                (currentIndex == 0)
                    ? _isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            enabled: _isLoading,
                            child: teste(context),
                          )
                        : transactionList(context, quizStream)
                    : (currentIndex == 1)
                        ? ListFilteredDaily()
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
            title: Text("Diário")),
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
            title: Text("Período")),
      ],
    );
  }

  vaultColor() {
    if (vault < 0) {
      return Colors.red;
    } else if (vault > 0) {
      return Colors.greenAccent;
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
