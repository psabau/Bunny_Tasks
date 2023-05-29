import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color myPink = Color.fromRGBO(255, 120, 170, 1.0);
const Color myMint = Color.fromRGBO(120, 255, 205, 1.0);
const Color myRed = Color.fromRGBO(222, 0, 72, 1.0);
const Color white = Colors.white;
const primaryColor = myPink;
const Color darkGrey = Color(0xFF121212);
Color? headerColor = Colors.grey[800];

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryColor,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    backgroundColor: darkGrey,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
  );
}

TextStyle get headerText {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get detailText {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey),
  );
}

TextStyle get titleText {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get smallTitle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700]),
  );
}

