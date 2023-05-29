import 'package:flutter/material.dart';
import 'size_config.dart';
import 'theme.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? label;

  CustomButton({
    this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: 45,
        width: 150,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label!,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

