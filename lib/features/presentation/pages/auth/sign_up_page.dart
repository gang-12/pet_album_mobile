import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_button_theme.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/theme/app_text_semantic.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/guardian_info_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;

  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool get _isFormFilled =>
      _idController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _idController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isFormFilled;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('회원가입', style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05)),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final hPad = width * 0.06;
            final btnSmallWidth = width * 0.27;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // 아이디
                        Text('아이디', style: AppText.body12m),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _idController,
                                hintText: '아이디를 입력하세요.',
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: btnSmallWidth,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: AppButtonTheme.elevated.style,
                                child: const Text('중복확인'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '사용가능한 아이디입니다.',
                            style: AppTextStyle.caption12R120.copyWith(color: AppColors.f05),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // 비밀번호
                        Text('비밀번호', style: AppText.body12m),
                        const SizedBox(height: 8),
                        AppTextField(
                          controller: _passwordController,
                          hintText: '비밀번호를 입력해 주세요.',
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: SvgPicture.asset(
                              _obscurePassword
                                  ? 'assets/system/icons/icon_visibility_off.svg'
                                  : 'assets/system/icons/icon_visibility.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(AppColors.f03, BlendMode.srcIn),
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 이름
                        Text('이름', style: AppText.body12m),
                        const SizedBox(height: 8),
                        AppTextField(controller: _nameController, hintText: '이름을 작성해 주세요.'),
                        const SizedBox(height: 20),

                        // 이메일
                        Text('이메일', style: AppText.body12m),
                        const SizedBox(height: 8),
                        AppTextField(controller: _emailController, hintText: '이메일을 입력해주세요.'),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // 하단 버튼
                Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: isActive ? AppButtonTheme.elevated.style : AppButtonTheme.inactive_btn.style,
                      onPressed: isActive
                          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuardianInfoPage()))
                          : null,
                      child: const Text('회원가입'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}