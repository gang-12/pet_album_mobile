import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.f01,
      appBar: AppBar(
        title: Text(
          '알림',
          style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: SvgPicture.asset(
              'assets/system/icons/icon_chevron_right.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/system/icons/icon_notification.svg',
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
              ),
              const SizedBox(height: 12),
              Text(
                '도착한 알림이 없습니다.',
                style: AppTextStyle.body16M120.copyWith(color: AppColors.f04),
              ),
            ],
          ),
        ),
      ),
    );
  }
}