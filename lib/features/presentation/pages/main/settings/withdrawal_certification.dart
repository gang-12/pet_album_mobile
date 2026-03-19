import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/oauth2_login_form.dart';

class WithdrawalCertificationPage extends StatefulWidget {
  const WithdrawalCertificationPage({super.key});

  @override
  State<WithdrawalCertificationPage> createState() => _WithdrawalCertificationPageState();
}

class _WithdrawalCertificationPageState extends State<WithdrawalCertificationPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.045; // 화면 너비의 4.5%
    final double verticalPadding = screenHeight * 0.02;   // 화면 높이의 2%

    return Scaffold(
      appBar: CommonBackAppBar(title: '회원탈퇴'),
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 탈퇴할 계정
                  _sectionCard(
                    title: '탈퇴할 계정',
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                      child: Text(
                        'aaa@gmail.com',
                        style: AppTextStyle.body16R120.copyWith(
                          color: AppColors.f05,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // 이메일 인증
                  _sectionCard(
                    title: '이메일 인증',
                    child: Column(
                      children: [
                        _bulletItem('안전한 탈퇴를 위해 이메일인증을 진행합니다.'),
                        _bulletItem('이메일로 발송된 6자리 코드를 입력해 주세요.'),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // 인증번호 입력
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: screenHeight * 0.067, // 55 기준
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '인증번호',
                                hintStyle: AppTextStyle.body16R120.copyWith(
                                  color: AppColors.f03,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: AppTextStyle.body16R120.copyWith(
                                color: AppColors.f05,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      SizedBox(
                        height: screenHeight * 0.067,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: 인증하기 로직
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            '인증하기',
                            style: AppTextStyle.body16R120.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              screenHeight * 0.015,
              horizontalPadding,
              screenHeight * 0.04,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppCustomButton(
                    text: '이전',
                    onTap: () => Navigator.of(context).pop(),
                    backgroundColor: AppColors.white,
                    textColor: AppColors.f05,
                    borderColor: AppColors.gray02,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: AppCustomButton(
                    text: '탈퇴하기',
                    onTap: () {
                      // TODO: 탈퇴하기 로직
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
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.body16M120.copyWith(
              color: AppColors.f05,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          child,
        ],
      ),
    );
  }

  Widget _bulletItem(String text) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: AppTextStyle.description14R140.copyWith(color: AppColors.f04)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.description14R140.copyWith(color: AppColors.f04),
            ),
          ),
        ],
      ),
    );
  }
}