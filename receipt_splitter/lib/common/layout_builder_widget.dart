import 'package:flutter/material.dart';

class LayoutBuilderWidget extends StatelessWidget {
  final Widget child;
  const LayoutBuilderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 20.0), child: child);
  }
}
