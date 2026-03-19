import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';

class EmailInquiryPage extends StatefulWidget {
  const EmailInquiryPage({super.key});

  @override
  State<EmailInquiryPage> createState() => _EmailInquiryPageState();
}

class _EmailInquiryPageState extends State<EmailInquiryPage> {
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _contentController = TextEditingController();

  // 임시 첨부파일 목록 (파일명, 용량MB)
  final List<Map<String, String>> _attachments = [];

  bool get _canSubmit =>
      _idController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _contentController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _idController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _addAttachment() {
    // 임시: 파일 선택 시뮬레이션
    setState(() {
      _attachments.add({
        'name': '스크린샷 2025-11-${1000 + _attachments.length}.png',
        'size': '0.22MB',
      });
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '이메일 문의하기'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 아이디
                  _Label('아이디'),
                  const SizedBox(height: 8),
                  AppTextField(controller: _idController, hintText: '아이디 입력해주세요.'),
                  const SizedBox(height: 20),

                  /// 답장받을 이메일 주소
                  _Label('답장받을 이메일 주소'),
                  const SizedBox(height: 8),
                  AppTextField(controller: _emailController, hintText: '이메일을 입력해주세요.'),
                  const SizedBox(height: 20),

                  /// 이메일 제목
                  _Label('제목'),
                  const SizedBox(height: 8),
                  AppTextField(controller: _emailController, hintText: '제목을 입력해주세요.'),
                  const SizedBox(height: 20),

                  /// 문의내용
                  _Label('문의내용'),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.gray01,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: _contentController,
                      maxLines: 6,
                      style: AppTextStyle.body16R120.copyWith(color: AppColors.f05),
                      decoration: InputDecoration(
                        hintText: '내용을 입력해 주세요.',
                        hintStyle: AppTextStyle.body16R120.copyWith(color: AppColors.f03),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 첨부파일 추가
                  _Label('첨부파일 추가'),
                  const SizedBox(height: 8),

                  // 첨부된 파일 목록
                  ..._attachments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final file = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                file['name']!,
                                style: AppTextStyle.description14R120.copyWith(color: AppColors.f04),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _removeAttachment(index),
                              child: SvgPicture.asset(
                                'assets/system/icons/icon_close.svg',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // + 추가 버튼
                  GestureDetector(
                    onTap: _addAttachment,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/system/icons/icon_add.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),

                  // 용량 표시
                  if (_attachments.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${(_attachments.length * 0.22).toStringAsFixed(2)}MB',
                        style: AppTextStyle.caption12R140.copyWith(color: AppColors.f03),
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),
                  Text(
                    '첨부한 파일의 전체 크기는 10Mbyte 미만이여야 합니다.\n용량이 초과될 경우, 문의 접수가 원활하게 진행되지 않을 수 있습니다.',
                    style: AppTextStyle.caption12R140.copyWith(color: AppColors.f03),
                  ),
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
              text: '문의접수',
              onTap: _canSubmit ? () => Navigator.of(context).pop() : null,
              backgroundColor: _canSubmit ? AppColors.black : AppColors.gray02,
              textColor: _canSubmit ? AppColors.f01 : AppColors.f03,
              borderColor: _canSubmit ? AppColors.black : AppColors.gray02,
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
    return Text(
      text,
      style: AppTextStyle.body16M120.copyWith(color: AppColors.f03),
    );
  }
}