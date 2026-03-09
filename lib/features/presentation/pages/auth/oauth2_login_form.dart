import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_common_button_styles.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/theme/app_text_semantic.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/login_form.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/sign_up_page.dart';

class Oauth2LoginPage extends ConsumerWidget {
  const Oauth2LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/system/logo/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 137),

                    // 카카오 로그인
                    SizedBox(
                      width: 350,
                      height: 55,
                      child: ElevatedButton(
                        style: AppButtonStyles.base(
                          backgroundColor: const Color(0xFFFFE812),
                          foregroundColor: AppColors.f05,
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            SvgPicture.asset("assets/system/icons/kakao_logo.svg", width: 32, height: 32),
                            const SizedBox(width: 58),
                            const Text('카카오 로그인 하기'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 구글 로그인
                    SizedBox(
                      width: 350,
                      height: 55,
                      child: ElevatedButton(
                        style: AppButtonStyles.base(
                          backgroundColor: AppColors.gray01,
                          foregroundColor: AppColors.f05,
                        ),
                        onPressed: () {},
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            SvgPicture.asset("assets/system/icons/google_logo.svg", width: 32, height: 32),
                            const SizedBox(width: 58),
                            const Text('구글 로그인 하기'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 60, child: Divider(thickness: 1.5)),
                        const SizedBox(width: 8),
                        Text('또는', style: AppText.captionSecondary),
                        const SizedBox(width: 8),
                        const SizedBox(width: 60, child: Divider(thickness: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Container(
                            width: 60, height: 60,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.black),
                            alignment: Alignment.center,
                            child: SvgPicture.asset("assets/system/icons/apple_logo.svg", width: 28, height: 28,
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: Container(
                            width: 60, height: 60,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF03CF5D)),
                            alignment: Alignment.center,
                            child: SvgPicture.asset("assets/system/icons/Naver_logo.svg", width: 28, height: 28,
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignUpPage()),
                            );
                          },
                          child: Text('회원가입', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04)),
                        ),
                        const Text('|'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const IdLoginPage()),
                            );
                          },
                          child: Text('아이디 로그인', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04)),
                        ),
                        const Text('|'),
                        TextButton(
                          onPressed: () {},
                          child: Text('문의하기', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}