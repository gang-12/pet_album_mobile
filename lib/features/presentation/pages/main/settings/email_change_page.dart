import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';

class Email_change_page extends StatefulWidget {
  const Email_change_page({super.key});

  @override
  State<Email_change_page> createState() => _Email_change_pageState();
}

class _Email_change_pageState extends State<Email_change_page> {
  final _newEmailController = TextEditingController();
  final _codeController = TextEditingController();

  bool? _codeResult;
  bool _codeSent = false;

  void _sendCode() {
    if (_newEmailController.text.isEmpty) return;
    setState(() {
      _codeSent = true;
      _codeResult = null;
    });
  }

  void _verifyCode() {
    if (_codeController.text.isEmpty) return;
    setState(() {
      _codeResult = _codeController.text == '123456';
    });
  }

  bool get _isVerified => _codeResult == true;

  @override
  void initState() {
    super.initState();
    _newEmailController.addListener(() => setState(() {}));
    _codeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '이메일 변경'),
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
                        '이메일을 수정하기 위해 인증절차가 필요합니다.\n이메일로 발송된 6자리 코드를 입력해 주세요.',
                        style: AppTextStyle.body16R140.copyWith(color: AppColors.f04),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 현재 이메일 카드
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('현재 이메일', style: AppTextStyle.body16M120.copyWith(color: AppColors.f05)),
                        const SizedBox(height: 8),
                        _InfoField(value: 'aaa@gmail.com'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// 변경할 이메일
                  _Label('변경할 이메일주소'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _newEmailController,
                          hintText: '이메일을 입력해주세요.',
                        ),
                      ),
                      if (_newEmailController.text.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 101,
                          height: 55,
                          child: AppCustomButton(
                            text: '인증하기',
                            onTap: _sendCode,
                            backgroundColor: AppColors.black,
                            textColor: AppColors.f01,
                            borderColor: AppColors.black,
                            borderRadius: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// 인증번호 + 확인 버튼
                  if (_codeSent) ...[
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _codeController,
                            hintText: '인증번호',
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 101,
                          height: 55,
                          child: AppCustomButton(
                            text: '확인',
                            onTap: _isVerified ? null : _verifyCode,
                            backgroundColor: _isVerified ? AppColors.bg : AppColors.black,
                            textColor: _isVerified ? AppColors.f03 : AppColors.f01,
                            borderColor: _isVerified ? AppColors.gray01 : AppColors.black,
                            borderRadius: 16,
                          ),
                        ),
                      ],
                    ),
                  ],

                  /// 인증 상태 메시지
                  if (_codeSent) ...[
                    const SizedBox(height: 8),
                    if (_isVerified)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('인증되었습니다.',
                            style: AppTextStyle.description14R120.copyWith(color: AppColors.f05)),
                      )
                    else if (_codeResult == false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('인증번호가 일치하지 않습니다. ',
                              style: AppTextStyle.description14R120.copyWith(color: Colors.red)),
                          GestureDetector(
                            onTap: _sendCode,
                            child: Text('재전송',
                                style: AppTextStyle.description14R120.copyWith(
                                    color: AppColors.f03, decoration: TextDecoration.underline)),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('인증번호가 발송되었습니다. ',
                              style: AppTextStyle.description14R120.copyWith(color: AppColors.f05)),
                          GestureDetector(
                            onTap: _sendCode,
                            child: Text('재전송',
                                style: AppTextStyle.description14R120.copyWith(
                                    color: AppColors.f03, decoration: TextDecoration.underline)),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
          ),

          /// 하단 버튼
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color(0x0A000000), offset: Offset(0, -4), blurRadius: 12)],
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: AppCustomButton(
              text: '내 정보 수정',
              onTap: _isVerified ? () => Navigator.of(context).pop() : null,
              backgroundColor: _isVerified ? AppColors.black : AppColors.bg,
              textColor: _isVerified ? AppColors.f01 : AppColors.f03,
              borderColor: _isVerified ? AppColors.black : AppColors.gray01,
              borderRadius: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyle.body16M120.copyWith(color: AppColors.f03));
  }
}

class _InfoField extends StatelessWidget {
  final String value;
  const _InfoField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(value, style: AppTextStyle.body16M120.copyWith(color: AppColors.f05)),
    );
  }
}