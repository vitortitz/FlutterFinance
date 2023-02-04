import 'package:flutter/material.dart';

class VerticalDelegate extends FlowDelegate {
  final AnimationController animation;
  VerticalDelegate({required this.animation}) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    final lastFabIndex = context.childCount - 1;
    const buttonSize = 56;
    const buttonMargin = 10;
    const buttonRadius = buttonSize / 2;

    final positionX = context.size.width - buttonSize;
    final positionY = context.size.height - buttonSize;

    for (int i = lastFabIndex; i >= 0; i--) {
      final y = positionY - ((buttonSize + buttonMargin) * i * animation.value);
      final size = (i != 0) ? animation.value : 1.0;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(positionX, y, 0)
          ..translate(buttonRadius, buttonRadius)
          ..scale(size)
          ..translate(-buttonRadius, -buttonRadius),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    throw UnimplementedError();
  }
}
