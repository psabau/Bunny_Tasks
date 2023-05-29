import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData mediaData;
  static double? screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    mediaData = MediaQuery.of(context);
    screenWidth = mediaData.size.width;
    screenHeight = mediaData.size.height;
    orientation = mediaData.orientation;
  }
}

double getHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 800.0) * screenHeight;
}

double getWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth!;
  return (inputWidth / 400.0) * screenWidth;
}