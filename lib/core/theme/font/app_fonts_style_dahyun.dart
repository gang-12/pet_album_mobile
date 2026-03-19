import 'package:flutter/material.dart';

class AppTextStyleDahyun {
  static TextStyle dahyun({
    required double size,
    required FontWeight weight,
    required double height,
  }) {
    return TextStyle(
      fontFamily: 'Dahyun',
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * -0.015,
    );
  }

}