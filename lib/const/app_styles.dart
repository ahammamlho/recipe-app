import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.blueAccent;
  static const Color secondary = Colors.orange;
  static Color inputColor = Colors.grey[100] as Color;
  static Color iconColor = Colors.grey[500] as Color;
  static const Color background = Colors.white;
  static const Color button = Colors.green;
  static const Color text = Colors.black;
  static const Color border = Colors.grey;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle headingWhite = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.background,
  );
  static const TextStyle headingNormal = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );
  static const TextStyle bodyWhite = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle setps = TextStyle(
    fontSize: 18,
    color: AppColors.text,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle textSign = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );
}

class AppSizes {
  static const double iconSize = 25.0;
  static const double buttonHeight = 50.0;
  static const double borderRadiusPrimary = 10.0;
  static const double borderRadiusSecondary = 20.0;

  static const double borderWidth = 1.0;

  static const double spaceBetweenWidget = 20.0;
}
