import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle suit({
    required double size,
    required FontWeight weight,
    required double height,
  }) {
    return TextStyle(
      fontFamily: 'SUIT',
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * -0.015,
    );
  }

// ================= BODY 16 =================
  static final body16R120 =
  suit(size: 16, weight: FontWeight.w400, height: 1.2);

  static final body16R140 =
  suit(size: 16, weight: FontWeight.w400, height: 1.4);

  static final body16M120 =
  suit(size: 16, weight: FontWeight.w500, height: 1.2);

  static final body16M140 =
  suit(size: 16, weight: FontWeight.w500, height: 1.4);


// ================= DESCRIPTION 14 =================
  static final description14R120 =
  suit(size: 14, weight: FontWeight.w400, height: 1.2);

  static final description14R140 =
  suit(size: 14, weight: FontWeight.w400, height: 1.4);

  static final description14M120 =
  suit(size: 14, weight: FontWeight.w500, height: 1.2);

  static final description14M140 =
  suit(size: 14, weight: FontWeight.w500, height: 1.4);


// ================= CAPTION 12 =================
  static final caption12R120 =
  suit(size: 12, weight: FontWeight.w400, height: 1.2);

  static final caption12R140 =
  suit(size: 12, weight: FontWeight.w400, height: 1.4);


// ================= SUBTITLE 20 =================
  static final subtitle20R120 =
  suit(size: 20, weight: FontWeight.w400, height: 1.2);

  static final subtitle20R140 =
  suit(size: 20, weight: FontWeight.w400, height: 1.4);

  static final subtitle20M120 =
  suit(size: 20, weight: FontWeight.w500, height: 1.2);

  static final subtitle20M140 =
  suit(size: 20, weight: FontWeight.w500, height: 1.4);

  static final subtitle20Sb120 =
  suit(size: 20, weight: FontWeight.w600, height: 1.2);

  static final subtitle20Sb140 =
  suit(size: 20, weight: FontWeight.w600, height: 1.4);


// ================= TITLE PAGE =================
  static final titlePage28Sb130 =
  suit(size: 28, weight: FontWeight.w600, height: 1.3);

  static final titlePage32Sb130 =
  suit(size: 32, weight: FontWeight.w600, height: 1.3);
}