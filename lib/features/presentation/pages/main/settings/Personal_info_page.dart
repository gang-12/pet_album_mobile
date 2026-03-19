import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/email_change_page.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/phone_change_page.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/password_change_page.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _nameController = TextEditingController(text: '조혜원');
  final _idController = TextEditingController(text: 'aaa');

  // 아이디 상태: null=기본, true=사용가능, false=사용중
  bool? _idCheckResult;
  bool _idChanged = false;

  @override
  void initState() {
    super.initState();
    _idController.addListener(() {
      setState(() {
        _idChanged = _idController.text.isNotEmpty;
        _idCheckResult = null;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _checkDuplicate() {
    if (_idController.text.isEmpty) {
      setState(() => _idCheckResult = null);
      return;
    }
    // 임시: 'aaa'는 사용중, 나머지는 사용가능
    setState(() => _idCheckResult = _idController.text != 'aaa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '개인정보 변경'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 이름
                  _Label('이름'),
                  const SizedBox(height: 8),
                  _EditableField(controller: _nameController, hint: '이름'),

                  const SizedBox(height: 20),

                  /// 아이디
                  _Label('아이디'),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _EditableField(
                          controller: _idController,
                          hint: '아이디',
                        ),
                      ),
                      if (_idChanged) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 101,
                          height: 55,
                          child: AppCustomButton(
                            text: '중복확인',
                            onTap: _checkDuplicate,
                            backgroundColor: AppColors.black,
                            textColor: AppColors.f01,
                            borderColor: AppColors.black,
                            borderRadius: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_idCheckResult != null) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _idCheckResult! ? '사용가능한 아이디입니다.' : '*이미 사용중인 아이디 입니다.',
                        style: AppTextStyle.description14R120.copyWith(
                          color: _idCheckResult! ? AppColors.f05 : Colors.red,
                        ),
                      ),
                    ),
                  ] else if (_idChanged && _idController.text.isEmpty) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '*아이디를 입력해 주세요.',
                        style: AppTextStyle.description14R120.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  /// 이메일
                  _Label('이메일'),
                  const SizedBox(height: 8),
                  _TappableField(
                    value: 'aaa@gmail.com',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Email_change_page()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 전화번호
                  _Label('전화번호'),
                  const SizedBox(height: 8),
                  _TappableField(
                    value: '010-0000-0000',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Phone_change_page()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 비밀번호
                  _Label('비밀번호'),
                  const SizedBox(height: 8),
                  _TappableField(
                    value: '••••••••••',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Password_change_page()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// 하단 저장 버튼
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
              onTap: () => Navigator.of(context).pop(),
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
/// 🔹 라벨
////////////////////////////////////////////////////////////

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.body16M120.copyWith(color: AppColors.f03),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 수정 가능한 입력 필드
////////////////////////////////////////////////////////////

class _EditableField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _EditableField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
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
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 탭하면 이동하는 필드 (이메일, 전화번호, 비밀번호)
////////////////////////////////////////////////////////////

class _TappableField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _TappableField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: AppTextStyle.body16M120.copyWith(color: AppColors.f05),
            ),
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
}