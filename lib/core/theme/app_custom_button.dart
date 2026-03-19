//팝업 버튼 두개 컴포넌트

import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

class AppCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final double borderWidth;
  final double height;
  final double borderRadius;

  const AppCustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.backgroundColor = AppColors.black,
    this.textColor = AppColors.f01,
    this.borderColor = AppColors.black,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.borderWidth = 1.5,
    this.height = 55,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledBackgroundColor ?? AppColors.bg;
            }
            return backgroundColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledTextColor ?? AppColors.f03;
            }
            return textColor;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: disabledBackgroundColor ?? AppColors.bg,
                width: borderWidth,
              );
            }
            return BorderSide(color: borderColor, width: borderWidth);
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          elevation: WidgetStateProperty.all(0),
        ),
        child: Text(
          text,
          style: AppTextStyle.body16R120,
        ),
      ),
    );
  }
}