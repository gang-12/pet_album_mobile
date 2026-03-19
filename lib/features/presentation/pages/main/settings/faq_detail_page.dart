import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';

class FaqDetailPage extends StatelessWidget {
  final String question;
  final String answer;

  const FaqDetailPage({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '자주 묻는 질문'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: AppTextStyle.subtitle20Sb140.copyWith(color: AppColors.f05),
            ),
            const SizedBox(height: 20),
            Text(
              answer,
              style: AppTextStyle.body16R140.copyWith(color: AppColors.f05),
            ),
          ],
        ),
      ),
    );
  }
}