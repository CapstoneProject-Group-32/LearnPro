import 'package:flutter/material.dart';

class CustomLoadingAnimation extends StatelessWidget {
  const CustomLoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/artificial-intelligence.gif',
      width: 100,
      height: 100,
    );
  }
}
