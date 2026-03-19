import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/withdrawal_certification.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.045;
    final double verticalPadding = screenHeight * 0.02;

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

                  // 계정 복구 및 데이터 파기
                  _sectionCard(
                    title: '계정 복구 및 데이터 파기',
                    child: Column(
                      children: [
                        _bulletItem('탈퇴일로부터 30일 이내에는 개인정보와 데이터가 보존되며 복구할 수 있습니다.'),
                        _bulletItem('탈퇴일로부터 30일 이후에는 개인정보와 탈퇴 시간, 도중 등 관련된 모든 데이터가 삭제됩니다. 삭제된 데이터는 복구되지 않으니 필요한 데이터는 미리 백업해 주세요.'),
                        _bulletItem('전자상거래 등에서의 소비자 보호에 관한 법률 등 관련 법령 및 본청 방침에 따라 필요한 정보는 법령이 정한 일정 기간 보관됩니다.'),
                        _bulletItem('개인정보 처리방침에 따라 분류 및 이용기간이 다른 특별한 경우는 해당 사유에 따릅니다.'),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // 요금제 이용권 등의 환불
                  _sectionCard(
                    title: '요금제 이용권 등의 환불',
                    child: Column(
                      children: [
                        _bulletItem('유료로 구입하거나 무상으로 제공받은 요금제, 사용권, 이용권 등은 환불 또는 환급되지 않습니다.'),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // 탈퇴 후 재가입
                  _sectionCard(
                    title: '탈퇴 후 재가입',
                    child: Column(
                      children: [
                        _bulletItem('탈퇴일로부터 30일 이후 재가입이 가능하며, 해당 계정의 이메일 주소로 재가입할 수 있습니다.'),
                        _bulletItem('단 기존 정보는 파기되어 복구할 수 없습니다.'),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // 체크박스 카드
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenHeight * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _isChecked = !_isChecked),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            _isChecked
                                ? 'assets/system/icons/checkbox_on.svg'
                                : 'assets/system/icons/checkbox_off.svg',
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Text(
                              '탈퇴 주의사항을 모두 확인하였으며 동의합니다.',
                              style: AppTextStyle.description14R140.copyWith(
                                color: AppColors.f04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
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
                    text: '취소',
                    onTap: () => Navigator.of(context).pop(),
                    backgroundColor: AppColors.white,
                    textColor: AppColors.f05,
                    borderColor: AppColors.gray02,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: AppCustomButton(
                    text: '다음',
                    onTap: _isChecked
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WithdrawalCertificationPage(),
                        ),
                      );
                    }
                        : null,
                    backgroundColor: AppColors.black,
                    textColor: AppColors.f01,
                    borderColor: AppColors.black,
                    disabledBackgroundColor: AppColors.bg,
                    disabledTextColor: AppColors.f03,
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