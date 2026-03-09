import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/oauth2_login_form.dart';
import 'package:petAblumMobile/core/widgets/app_out_button.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/withdrawal_page.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/Personal_info_page.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/notification_settings_page.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/login_device_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  void _showLogoutDialog() {
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
                    '로그아웃 하시겠습니까?',
                    style: AppTextStyle.subtitle20M120.copyWith(
                      color: AppColors.f05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '로그아웃하시면 서비스 이용이 제한될 수 있습니다.',
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
                          text: '로그아웃',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const Oauth2LoginPage(),
                              ),
                                  (route) => false,
                            );
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
      appBar: CommonBackAppBar(title: '설정'),
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _fixedCard(child: _card('계정', [
            _itemWithTap('개인정보 변경', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersonalInfoPage()),
              );
            }),
          ])),
          const SizedBox(height: 16),
          _fixedCard(child: _card('알림', [
            _itemWithTap('알림 설정', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Notification_settings_page()),
              );
            }),
          ])),
          const SizedBox(height: 16),
          _fixedCard(child: _card('보안', [
            _itemWithTap('로그인 기기 관리', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Login_device_page()),
              );
            }),
          ])),
          const SizedBox(height: 16),
          _fixedCard(child: _card('도움', [
            _item('자주 묻는 질문'),
            _item('고객센터'),
          ])),
          const SizedBox(height: 16),
          _fixedCard(child: _card('약관 및 정책', [
            _item('서비스 이용 약관'),
            _item('개인정보 처리 방침'),
          ])),
          const SizedBox(height: 16),
          _fixedCard(
            child: _cardOnlyItems([
              _itemWithTap(
                '로그아웃',
                showArrow: false,
                onTap: _showLogoutDialog,
              ),
              _itemWithTap(
                '회원탈퇴',
                showArrow: false,
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WithdrawalPage()),
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

Widget _itemWithTap(
    String text, {
      bool showArrow = true,
      Color? color,
      VoidCallback? onTap,
    }) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: AppTextStyle.body16R120.copyWith(
              color: color ?? AppColors.f04,
            ),
          ),
          if (showArrow)
            SvgPicture.asset(
              'assets/system/icons/chevron_right.svg',
              width: 24,
              height: 24,
            ),
        ],
      ),
    ),
  );
}

Widget _fixedCard({required Widget child}) {
  return Center(child: SizedBox(width: 350, child: child));
}

Widget _card(String title, List<Widget> items) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05)),
        const SizedBox(height: 8),
        ...items,
      ],
    ),
  );
}

Widget _item(String text, {bool showArrow = true, Color? color}) {
  return SizedBox(
    height: 36,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: AppTextStyle.body16R120.copyWith(color: color ?? AppColors.f04)),
        if (showArrow)
          SvgPicture.asset('assets/system/icons/chevron_right.svg', width: 24, height: 24),
      ],
    ),
  );
}

Widget _cardOnlyItems(List<Widget> items) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        items.length,
            (index) => Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 8),
          child: items[index],
        ),
      ),
    ),
  );
}