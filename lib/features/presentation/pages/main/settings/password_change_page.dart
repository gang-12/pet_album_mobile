import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';

class Password_change_page extends StatefulWidget {
  const Password_change_page({super.key});

  @override
  State<Password_change_page> createState() => _Password_change_pageState();
}

class _Password_change_pageState extends State<Password_change_page> {
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  bool _currentObscure = true;
  bool _newObscure = true;
  bool _confirmObscure = true;

  void _submit() {
    final current = _currentPwController.text;
    final newPw = _newPwController.text;
    final confirm = _confirmPwController.text;

    // 현재 비밀번호 오류 (임시: 'password123'이 정답)
    if (current != 'password123') {
      _showErrorDialog(
        title: '현재 비밀번호 오류',
        message: '현재 비밀번호가 일치하지 않습니다.\n비밀번호를 다시 입력해 주세요.',
      );
      return;
    }

    // 새 비밀번호 확인 오류
    if (newPw != confirm) {
      _showErrorDialog(
        title: '새 비밀번호 확인 오류',
        message: '새 비밀번호가 일치하지 않습니다.\n비밀번호를 다시 확인해 주세요.',
      );
      return;
    }

    Navigator.of(context).pop();
  }

  void _showErrorDialog({required String title, required String message}) {
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
                    title,
                    style: AppTextStyle.subtitle20M120.copyWith(
                      color: AppColors.f05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: AppTextStyle.description14R120.copyWith(
                      color: AppColors.f04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          onTap: () => Navigator.of(context).pop(),
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
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '비밀번호'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 안내 문구
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '주기적인 비밀번호 변경은 개인정보를 안전하게\n보호하고 개인정보 도용 피해를 예방할 수 있어요.\n비밀번호를 변경하면 다른 기기들은 로그아웃돼요.',
                        style: AppTextStyle.body16R140.copyWith(
                          color: AppColors.f04,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 현재 비밀번호
                  _PwField(
                    controller: _currentPwController,
                    hint: '현재 비밀번호',
                    obscure: _currentObscure,
                    onToggle: () => setState(() => _currentObscure = !_currentObscure),
                  ),
                  const SizedBox(height: 12),

                  /// 새 비밀번호
                  _PwField(
                    controller: _newPwController,
                    hint: '새 비밀번호',
                    obscure: _newObscure,
                    onToggle: () => setState(() => _newObscure = !_newObscure),
                  ),
                  const SizedBox(height: 12),

                  /// 새 비밀번호 확인
                  _PwField(
                    controller: _confirmPwController,
                    hint: '새 비밀번호 확인',
                    obscure: _confirmObscure,
                    onToggle: () => setState(() => _confirmObscure = !_confirmObscure),
                  ),
                ],
              ),
            ),
          ),

          /// 하단 버튼
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  offset: Offset(0, -4),
                  blurRadius: 12,
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: AppCustomButton(
              text: '내 정보 수정',
              onTap: _submit,
              backgroundColor: AppColors.black,
              textColor: AppColors.f01,
              borderColor: AppColors.black,
              borderRadius: 16,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 비밀번호 입력 필드
////////////////////////////////////////////////////////////

class _PwField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;

  const _PwField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        maxLines: 1,
        style: AppTextStyle.body16M120.copyWith(color: AppColors.f05),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyle.body16M120.copyWith(color: AppColors.f03),
          filled: true,
          fillColor: AppColors.gray01,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.f03,
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}