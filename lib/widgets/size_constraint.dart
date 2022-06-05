import 'package:flutter/material.dart';

class SizeConstraintWidget extends StatelessWidget {
  final Widget child;

  const SizeConstraintWidget({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200), child: child),
    );
  }
}
