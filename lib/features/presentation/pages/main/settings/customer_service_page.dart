import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/faq_detail_page.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/email_inquiry_page.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': '회원가입은 어떻게 하나요?',
      'a': '앱 실행 후 회원가입 버튼을 눌러\n이메일과 비밀번호를 입력하면 가입할 수 있어요.',
    },
    {
      'q': '로그인이 되지 않아요.',
      'a': '이메일 또는 비밀번호가 올바르게 입력되었는지 \n확인해 주세요. 문제가 계속되면 \n비밀번호 재설정을 이용해 주세요.',
    },
    {
      'q': '비밀번호를 잊어버렸어요.',
      'a': '로그인 화면의 비밀번호 찾기를 눌러 이메일 인증 후 \n새 비밀번호를 설정할 수 있어요.',
    },
    {
      'q': '이메일을 변경할 수 있나요?',
      'a': '이메일 변경이 필요한 경우 문의하기를 통해 \n고객센터로 연락해 주세요.',
    },
    {
      'q': '아이디/비밀번호 변경',
      'a': '설정 또는 마이페이지에서 회원 탈퇴 메뉴를 통해 \n탈퇴할 수 있어요.',
    },
    {
      'q': '앱 이용 중 오류가 발생했어요.',
      'a': '앱을 최신 버전으로 업데이트하거나 \n앱을 다시 실행해 주세요. \n문제가 계속되면 문의하기를 통해 알려주세요.',
    },
    {
      'q': '알림이 오지 않아요.',
      'a': '기기의 설정에서 앱 알림이 허용되어 있는지 확인해 주세요.',
    },
    {
      'q': '계정을 여러 기기에서 사용할 수 있나요?',
      'a': '같은 계정으로 여러 기기에서 로그인하여 사용할 수 있어요.',
    },
    {
      'q': '개인정보는 안전하게 보호되나요?',
      'a': '서비스는 개인정보 보호정책에 따라 사용자의 정보를 \n안전하게 관리하고 보호하고 있어요.',
    },
    {
      'q': '문의는 어떻게 할 수 있나요?',
      'a': '이메일 문의하기 메뉴를 통해 이메일로 문의를 보내주시면 \n확인 후 답변드려요.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '문의하기'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '무엇을 도와드릴까요?',
              style: AppTextStyle.titlePage28Sb130.copyWith(color: AppColors.f05),
            ),
            const SizedBox(height: 20),

            /// 자주 묻는 질문
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
                  Text(
                    '자주 묻는 질문',
                    style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _faqs.length; i++) ...[
                        _FaqItem(
                          text: _faqs[i]['q']!,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FaqDetailPage(
                                  question: _faqs[i]['q']!,
                                  answer: _faqs[i]['a']!,
                                ),
                              ),
                            );
                          },
                        ),
                        if (i < _faqs.length - 1) const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// 이메일 문의
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmailInquiryPage()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  '이메일 문의하기',
                  style: AppTextStyle.body16R120.copyWith(color: AppColors.f04),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FaqItem({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Q', style: AppTextStyle.body16R120.copyWith(color: AppColors.f03)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.body16R120.copyWith(color: AppColors.f04),
            ),
          ),
        ],
      ),
    );
  }
}