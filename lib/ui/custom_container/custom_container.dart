import 'package:flutter/material.dart';

import '../../constants.dart';

class CustomContainer extends StatelessWidget {
  final void Function()? onTap;
  final double padding;
  final double radius;
  final Widget child;

  const CustomContainer({
    super.key,
    this.onTap,
    required this.padding,
    required this.radius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: const Color(colorMain),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: child,
      ),
    );
  }
}
