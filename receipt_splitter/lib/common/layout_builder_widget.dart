import 'package:flutter/material.dart';

class LayoutBuilderWidget extends StatelessWidget {
  final Widget child;
  final double top;
  final double bottom;
  final double left;
  final double right;
  const LayoutBuilderWidget({
    super.key,
    required this.child,
    this.top = 25.0,
    this.bottom = 20.0,
    this.left = 15.0,
    this.right = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: child,
    );
  }
}
