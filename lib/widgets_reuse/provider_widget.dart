import 'package:flutter/material.dart';

import '../services/auth.dart';

class Provider extends InheritedWidget {
  final Auth auth;

  const Provider({Key? key, required Widget child, required this.auth})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider);
}
