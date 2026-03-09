import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/login_form.dart';

class GuardianInfoPage extends StatefulWidget {
  const GuardianInfoPage({super.key});

  @override
  State<GuardianInfoPage> createState() => _GuardianInfoPageState();
}

class _GuardianInfoPageState extends State<GuardianInfoPage> {
  final _nicknameController = TextEditingController();
  final _addressDetailController = TextEditingController();

  String? _selectedGender;
  final String _address = "서울 구로구 디지털로 31길 62\n서울 구로구 구로동 197-11";

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(() => setState(() {}));
    _addressDetailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _addressDetailController.dispose();
    super.dispose();
  }

  bool get _isFormFilled =>
      _nicknameController.text.isNotEmpty && _selectedGender != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonBackAppBar(title: ''),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 타이틀
                      Text(
                        '보호자님의 기본정보를\n알려주세요.',
                        style: AppTextStyle.titlePage28Sb130.copyWith(color: AppColors.f05),
                      ),
                      const SizedBox(height: 40),

                      /// 프로필 사진
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 130,
                          height: 145,
                          decoration: BoxDecoration(
                            color: AppColors.gray03,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/system/icons/icon_camera.svg',
                              width: 44,
                              height: 44,
                              colorFilter: ColorFilter.mode(AppColors.f01, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// 닉네임
                      Text('닉네임', style: AppTextStyle.body16M120.copyWith(color: AppColors.f03)),
                      const SizedBox(height: 8),
                      _InputField(controller: _nicknameController, hint: '닉네임을 입력해주세요'),
                      const SizedBox(height: 20),

                      /// 성별
                      Text('성별', style: AppTextStyle.body16M120.copyWith(color: AppColors.f03)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _GenderButton(
                              label: '여자',
                              isSelected: _selectedGender == 'female',
                              onTap: () => setState(() => _selectedGender = 'female'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GenderButton(
                              label: '남자',
                              isSelected: _selectedGender == 'male',
                              onTap: () => setState(() => _selectedGender = 'male'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// 거주지
                      Text('거주지', style: AppTextStyle.body16M120.copyWith(color: AppColors.f03)),
                      const SizedBox(height: 8),

                      /// 지도에서 위치 확인 박스
                      Container(
                        width: double.infinity,
                        height: 81,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.gray01,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 25,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  '지도에서 위치 확인',
                                  style: AppTextStyle.description14R120.copyWith(color: AppColors.f05),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// 선택된 주소
                      if (_address.isNotEmpty) ...[
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _address,
                                style: AppTextStyle.body16M120.copyWith(color: AppColors.f05),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 18),

                      /// 상세주소
                      _InputField(
                        controller: _addressDetailController,
                        hint: '건물 명, 동/호수 등의 상세주소 입력',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 하단 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: AppCustomButton(
              text: '완료',
              onTap: _isFormFilled
                  ? () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const IdLoginPage()),
                      (route) => route.isFirst,
                );
              }
                  : null,
              backgroundColor: _isFormFilled ? AppColors.black : AppColors.gray02,
              textColor: _isFormFilled ? AppColors.f01 : AppColors.f03,
              borderColor: _isFormFilled ? AppColors.black : AppColors.gray02,
              borderRadius: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
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

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.main : AppColors.gray02,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                label == '여자'
                    ? 'assets/system/icons/icon_female.svg'
                    : 'assets/system/icons/icon_male.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.main : AppColors.f05,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.body16M120.copyWith(
                  color: isSelected ? AppColors.main : AppColors.f05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}