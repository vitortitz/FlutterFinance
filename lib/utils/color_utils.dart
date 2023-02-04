import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

vaultColor(vault) {
  if (vault < 0) {
    return Colors.red;
  } else if (vault > 0) {
    return Colors.green;
  } else {
    Colors.black;
  }
}
