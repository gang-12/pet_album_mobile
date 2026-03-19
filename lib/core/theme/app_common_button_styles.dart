import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

class AppButtonStyles {
  static ButtonStyle base({
    required Color backgroundColor,
    required Color foregroundColor,
    double elevation = 0,
    Color? shadowColor,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      minimumSize: const Size(double.infinity, 55),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: AppTextStyle.body16M120,
      elevation: elevation,
      shadowColor: shadowColor,
    );
  }
}
