// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/color_utils.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile(
      {Key? key,
      required this.date,
      required this.type,
      required this.description,
      required this.value,
      required this.category})
      : super(key: key);

  final String type, description, category;
  final double value;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 20, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Image.asset(
                          getIcon(),
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      width: (size.width - 90) * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            DateFormat('dd/MM/yyyy').format(date),
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: (size.width - 100) * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${value.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: getColors()),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 8),
            child: Divider(
              thickness: 0.8,
            ),
          )
        ],
      ),
    );
  }

  Widget shimmerLoading(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: EdgeInsets.only(top: 20, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (size.width - 40) * 0.7,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Container(
                              color: Colors.white,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          width: (size.width - 90) * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 15,
                                color: Colors.white,
                              ),
                              SizedBox(height: 5),
                              Container(height: 18, color: Colors.white),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (size.width - 100) * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 8),
                child: Divider(
                  thickness: 0.8,
                ),
              )
            ],
          ),
        ));
  }

  Color getColors() {
    if (type == 'Gasto') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  Gradient getBackGroundColors() {
    if (type == 'Gasto') {
      return LinearGradient(colors: [
        hexStringToColor("#fe3d6c"),
        hexStringToColor("#fc9995"),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight);
    } else {
      return LinearGradient(colors: [
        hexStringToColor("#3fff7c"),
        hexStringToColor("#3ffbe0"),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight);
    }
  }

  String getIcon() {
    if (category == 'Presente') {
      return 'assets/images/category/gift.png';
    } else if (category == 'Mesada') {
      return 'assets/images/category/cash.png';
    } else if (category == 'Salário') {
      return 'assets/images/category/cash.png';
    } else if (category == 'Brinquedo') {
      return 'assets/images/category/toy.png';
    } else if (category == 'Jogos') {
      return 'assets/images/category/games.png';
    } else {
      return 'assets/images/category/food.png';
    }
  }
}
