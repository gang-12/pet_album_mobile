import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';

class Login_device_page extends StatefulWidget {
  const Login_device_page({super.key});

  @override
  State<Login_device_page> createState() => _Login_device_pageState();
}

class _Login_device_pageState extends State<Login_device_page> {
  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'iPhone X',
      'icon': 'assets/system/icons/icon_mobile.svg',
      'country': '대한민국',
      'lastActive': '2026.05.12',
    },
    {
      'name': 'PC',
      'icon': 'assets/system/icons/icon_pc.svg',
      'country': '대한민국',
      'lastActive': '2026.05.12',
    },
  ];

  void _showLogoutDialog(int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 350,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '로그아웃',
                    style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '선택한 기기에서 로그아웃 하시겠습니까?\n해당 기기에서는 다시 로그인해야 합니다.',
                    style: AppTextStyle.description14R120.copyWith(color: AppColors.f04),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppCustomButton(
                          text: '취소',
                          onTap: () => Navigator.of(context).pop(),
                          backgroundColor: AppColors.gray02,
                          textColor: AppColors.f05,
                          borderColor: AppColors.gray02,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppCustomButton(
                          text: '확인',
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() => _devices.removeAt(index));
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '로그인 기기 관리'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_devices.length, (index) {
            final device = _devices[index];
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  device['icon'],
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  device['name'],
                                  style: AppTextStyle.body16M120.copyWith(color: AppColors.f05),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        device['country'],
                                        style: AppTextStyle.description14R120.copyWith(color: AppColors.f03),
                                      ),
                                      Text(
                                        '최근활동 : ${device['lastActive']}',
                                        style: AppTextStyle.description14R120.copyWith(color: AppColors.f03),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showLogoutDialog(index),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: AppColors.gray02),
                                    ),
                                    child: Text(
                                      '로그아웃',
                                      style: AppTextStyle.description14R120.copyWith(color: AppColors.f04),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}