// ignore_for_file: prefer_const_constructors

import 'package:firebase/controllers/money_controller.dart';
import 'package:flutter/material.dart';

import '../../../models/Money.dart';
import '../../../models/user_transaction.dart';
import '../../../utils/constants.dart';
import '../../details/details_screen.dart';
import 'cashier_details_view.dart';
import 'cashier_short_view.dart';

import 'cashier_card.dart';

// Today i will show you how to implement the animation
// So starting project comes with the UI
// Run the app

class MoneyScreen extends StatelessWidget {
  final controller = MoneyController();

  MoneyScreen({Key? key, required this.newTransaction}) : super(key: key);
  final UserTransaction newTransaction;

  void _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta! < -0.7) {
      controller.changeMoneyState(MoneyState.cashier);
    } else if (details.primaryDelta! > 3) {
      controller.changeMoneyState(MoneyState.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Color(0xFFEAEAEA),
            child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return LayoutBuilder(
                    builder: (context, BoxConstraints constraints) {
                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: panelTransition,
                            top: controller.moneyState == MoneyState.normal
                                ? 0
                                : -(constraints.maxHeight -
                                    cartBarHeight * 2 -
                                    0),
                            left: 0,
                            right: 0,
                            height: constraints.maxHeight - 0 - cartBarHeight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(defaultPadding * 1.5),
                                  bottomRight:
                                      Radius.circular(defaultPadding * 1.5),
                                ),
                              ),
                              child: GridView.builder(
                                itemCount: demo_moneys.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  mainAxisSpacing: defaultPadding,
                                  crossAxisSpacing: defaultPadding,
                                ),
                                itemBuilder: (context, index) => MoneyCashier(
                                  money: demo_moneys[index],
                                  press: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 500),
                                        reverseTransitionDuration:
                                            const Duration(milliseconds: 500),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            FadeTransition(
                                          opacity: animation,
                                          child: DetailsScreen(
                                            money: demo_moneys[index],
                                            onMoneyAdd: () {
                                              controller.addMoneyToCashier(
                                                  demo_moneys[index]);
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Card Panel
                          AnimatedPositioned(
                            duration: panelTransition,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: controller.moneyState == MoneyState.normal
                                ? cartBarHeight
                                : (constraints.maxHeight - cartBarHeight),
                            child: GestureDetector(
                              onVerticalDragUpdate: _onVerticalGesture,
                              child: Container(
                                padding: const EdgeInsets.all(defaultPadding),
                                color: Color(0xFFEAEAEA),
                                alignment: Alignment.topLeft,
                                child: AnimatedSwitcher(
                                  duration: panelTransition,
                                  child: controller.moneyState ==
                                          MoneyState.normal
                                      ? CashierShortView(controller: controller)
                                      : CashierDetailsView(
                                          controller: controller,
                                          newTransaction: newTransaction,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          // Header
                        ],
                      );
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }
}
