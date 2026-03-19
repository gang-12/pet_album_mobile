import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final String cancelText;
  final String confirmText;

  const DeleteConfirmDialog({
    Key? key,
    this.title = '삭제하시겠습니까?',
    required this.content,
    required this.onConfirm,
    this.cancelText = '취소',
    this.confirmText = '삭제',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyle.subtitle20M120.copyWith(
                color: AppColors.f05,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: AppTextStyle.description14R120.copyWith(
                color: AppColors.f04,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppCustomButton(
                    text: cancelText,
                    onTap: () => Navigator.pop(context),
                    backgroundColor: AppColors.gray02,
                    textColor: AppColors.f05,
                    borderColor: AppColors.gray02,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCustomButton(
                    text: confirmText,
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    backgroundColor: AppColors.black,
                    textColor: AppColors.f01,
                    borderColor: AppColors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    String? title,
    required String content,
    required VoidCallback onConfirm,
    String? cancelText,
    String? confirmText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        title: title ?? '삭제하시겠습니까?',
        content: content,
        onConfirm: onConfirm,
        cancelText: cancelText ?? '취소',
        confirmText: confirmText ?? '삭제',
      ),
    );
  }
}