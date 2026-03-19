import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_text_semantic.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextStyle? style;

  const AppTextField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(10), // ✅ padding 10
        decoration: BoxDecoration(
          color: AppColors.gray01,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8), // ✅ gap 8
            ],

            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                obscureText: obscureText,
                style: style ?? AppTextStyle.body16R120.copyWith(
                  color: AppColors.f03,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyle.body16R120.copyWith(
                    color: AppColors.f03,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero, // 중요
                ),
                onChanged: onChanged,
              ),
            ),

            if (suffixIcon != null) ...[
              const SizedBox(width: 8), // ✅ gap 8
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}