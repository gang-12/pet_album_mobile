import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_common_button_styles.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/theme/app_text_semantic.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/login_form.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/sign_up_page.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/customer_service_page.dart';

class Oauth2LoginPage extends ConsumerWidget {
  const Oauth2LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth - 48; // 좌우 24씩
    final isSmall = screenHeight < 700;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isSmall ? 40 : screenHeight * 0.1),

                  // 로고
                  Image.asset(
                    'assets/system/logo/logo.png',
                    width: screenWidth * 0.28,
                    height: screenWidth * 0.28,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: isSmall ? 40 : screenHeight * 0.12),

                  // 카카오 로그인
                  SizedBox(
                    width: buttonWidth,
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
                          const Spacer(),
                          const Text('카카오 로그인 하기'),
                          const Spacer(),
                          const SizedBox(width: 32),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 구글 로그인
                  SizedBox(
                    width: buttonWidth,
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
                          const Spacer(),
                          const Text('구글 로그인 하기'),
                          const Spacer(),
                          const SizedBox(width: 32),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 구분선
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: screenWidth * 0.15, child: const Divider(thickness: 1.5)),
                      const SizedBox(width: 8),
                      Text('또는', style: AppText.captionSecondary),
                      const SizedBox(width: 8),
                      SizedBox(width: screenWidth * 0.15, child: const Divider(thickness: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 애플 / 네이버
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.black),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "assets/system/icons/apple_logo.svg",
                            width: 28,
                            height: 28,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF03CF5D)),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "assets/system/icons/naver_logo.svg",
                            width: 28,
                            height: 28,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 회원가입 / 아이디 로그인 / 문의하기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage())),
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: Colors.transparent,
                        ),
                        child: Text('회원가입', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04)),
                      ),
                      const Text('|'),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IdLoginPage())),
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: Colors.transparent,
                        ),
                        child: Text('아이디 로그인', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04)),
                      ),
                      const Text('|'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerServicePage()));
                        },
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: Colors.transparent,
                        ),
                        child: Text('문의하기', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04)),
                      ),
                    ],
                  ),

                  SizedBox(height: isSmall ? 24 : screenHeight * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}