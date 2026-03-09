import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_button_theme.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_common_button_styles.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_dahyun.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/main/alram.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/system/icons/icon_notification.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AlarmPage()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// SVG 이미지
              SvgPicture.asset(
                'assets/system/dumy/main2.svg',
                width: 270,
                height: 270,
              ),
              const SizedBox(height: 24),
              Text(
                '함께한 추억들을 정리해,\n또또와의 이야기를 만들어보세요',
                textAlign: TextAlign.center,
                style: AppTextStyleDahyun.dahyun(
                  size: 24,
                  weight: FontWeight.w400,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 171,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {},
                  style: AppButtonStyles.base(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.f01,
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.25),
                  ),
                  child: Text(
                    '앨범 생성하기',
                    style: AppTextStyle.body16M120.copyWith(
                      color: AppColors.f01,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}