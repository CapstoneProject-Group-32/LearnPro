import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final Color borderColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.borderColor = const Color.fromARGB(0, 0, 0, 0),
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 20, // newly added
        shadowColor: Colors.grey[800]?.withOpacity(0.15), //newly added
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
