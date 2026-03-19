import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

class AppOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const AppOutlineButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 171,
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gray02,
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              offset: Offset(0, 4),
              color:AppColors.blue,
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTextStyle.body16M120.copyWith(
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}

class AppFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const AppFilledButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 171,
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.gray02,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: AppTextStyle.body16M120.copyWith(
            color: AppColors.f05,
          ),
        ),
      ),
    );
  }
}
