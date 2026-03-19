import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_button_theme.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/theme/app_text_semantic.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/main/main_shell.dart';

class IdLoginPage extends ConsumerStatefulWidget {
  const IdLoginPage({super.key});

  @override
  ConsumerState<IdLoginPage> createState() => _IdLoginPageState();
}

class _IdLoginPageState extends ConsumerState<IdLoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonBackAppBar(title: '로그인'),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('아이디', style: AppTextStyle.body16M120.copyWith(color: AppColors.f03)),
                const SizedBox(height: 8),
                AppTextField(controller: _idController, hintText: '아이디를 작성해 주세요.'),
                const SizedBox(height: 20),
                Text('비밀번호', style: AppTextStyle.body16M120.copyWith(color: AppColors.f03)),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _passwordController,
                  hintText: '비밀번호를 입력해 주세요.',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainShell()),
                          (route) => false,
                    );
                  },
                  style: AppButtonTheme.elevated.style,
                  child: const Text('로그인'),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 98),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 60, child: Divider(thickness: 1.5)),
                      const SizedBox(width: 8),
                      Text('SNS 로그인', style: AppText.captionSecondary),
                      const SizedBox(width: 8),
                      const SizedBox(width: 60, child: Divider(thickness: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _snsButton(asset: 'assets/system/icons/kakao_logo.svg', onTap: () => debugPrint('카카오 로그인'), bgColor: const Color(0xFFFFE812)),
                      const SizedBox(width: 10),
                      _snsButton(asset: 'assets/system/icons/google_logo.svg', onTap: () => debugPrint('구글 로그인'), bgColor: AppColors.gray01, strokeColor: AppColors.gray02),
                      const SizedBox(width: 10),
                      _snsButton(asset: 'assets/system/icons/apple_logo.svg', onTap: () => debugPrint('애플 로그인'), bgColor: AppColors.black, iconColor: Colors.white),
                      const SizedBox(width: 10),
                      _snsButton(asset: 'assets/system/icons/naver_logo.svg', onTap: () => debugPrint('네이버 로그인'), bgColor: const Color(0xFF03CF5D), iconColor: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _snsButton({
    required String asset,
    required VoidCallback onTap,
    Color? bgColor,
    Color? iconColor,
    Color? strokeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? Colors.transparent,
          border: strokeColor != null
              ? Border.all(color: strokeColor, width: 1.5)
              : null,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          asset,
          width: 24,
          height: 24,
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor, BlendMode.srcIn)
              : null,
        ),
      ),
    );
  }
}