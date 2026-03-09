import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_common_button_styles.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/theme/app_text_semantic.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_bar_main_scaffold.dart';
import 'package:petAblumMobile/core/widgets/pet_card.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/settings_page.dart';
import 'package:petAblumMobile/features/presentation/pages/pet_crud/pet_list.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final TextEditingController _foodController = TextEditingController();

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonMainAppBar(
        title: "마이페이지",
        actions: [
          IconButton(
          onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) => const SettingsPage(),
    ),
    );
    },
      icon: SvgPicture.asset(
        'assets/system/icons/icon_settings.svg',
        width: 24,
        height: 24,
      ),
    ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // 반려동물 프로필 사진
              Column(
                children: [
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/system/logo/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.pets,
                              size: 60,
                              color: AppColors.f01,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '조혜원',
                    style: AppTextStyle.subtitle20Sb120,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '또또네 가족',
                    style: AppTextStyle.description14R120.copyWith(
                      color: AppColors.f04,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 99,
                    height: 41,
                    child: ElevatedButton(
                      style: AppButtonStyles.base(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.gray01,
                      ).copyWith(
                        elevation: MaterialStateProperty.all(2),
                        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.08)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        side: MaterialStateProperty.all(BorderSide.none),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // ← 추가
                      ),
                      onPressed: () {},
                      child: FittedBox( // ← 추가
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '내 정보 수정',
                          style: AppTextStyle.description14R120.copyWith(
                            color: AppColors.f05,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              // 반려동물 정보 카드
              _buildPetCard(0),
              // ListView(
              //   padding: const EdgeInsets.all(20),
              //   children: [
              //     _buildPetCard(0),
              //     const SizedBox(height: 16),
              //     _buildPetCard(1),
              //     const SizedBox(height: 24),
              //   ],
              // ),
              SizedBox(height: 20),

              Center(
                child:
                  Column(
                    children: [

                      // 박스
                      Container(

                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              '반려동물 정보',
                              style: AppTextStyle.subtitle20M120.copyWith(
                                color: AppColors.f05,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 성향
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Container(
                                    width: 40,
                                    height: 29,
                                    padding: const EdgeInsets.fromLTRB(4, 7.5, 5, 7.5),
                                    child: Text(
                                      '성향',
                                      style: AppTextStyle.caption12R120.copyWith(
                                        color: AppColors.f03,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      _buildChip('큰소리 주의'),
                                      _buildChip('이물질 섭취 주위 필요'),
                                      _buildChip('입질경험있음'),
                                      _buildChip('분리불안'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // 건강
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Container(
                                    width: 40,
                                    height: 29,
                                    padding: const EdgeInsets.fromLTRB(4, 7.5, 5, 7.5),
                                    child: Text(
                                      '건강',
                                      style: AppTextStyle.caption12R120.copyWith(
                                        color: AppColors.f03,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildChip('관절문제있음'),
                                      _buildChip('슬개골문제 있음'),
                                      _buildChip('피부문제있음'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // 복용약
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Container(
                                    width: 40,
                                    height: 29,
                                    padding: const EdgeInsets.fromLTRB(4, 7.5, 5, 7.5),
                                    child: Text(
                                      '복용약',
                                      style: AppTextStyle.caption12R120.copyWith(
                                        color: AppColors.f03,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildChip('없음'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      //페이지 인디케이터
                      _buildPageIndicator(),

                    ],
                  ),
                ),



              const SizedBox(height: 40),

              // 반려동물
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '반려동물',
                      style: AppTextStyle.subtitle20M120.copyWith(
                        color: AppColors.f05,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Text(
                        '내 앨범',
                        style: AppTextStyle.body16M120.copyWith(
                          color: AppColors.f04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              const SizedBox(height: 20),
//패밀리
              Text(
                '패밀리',
                style: AppTextStyle.subtitle20M120.copyWith(
                  color: AppColors.f05,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '패밀리 계정',
                  style: AppTextStyle.body16M120.copyWith(
                    color: AppColors.f04,
                  ),
                ),
              ),

              const SizedBox(height: 0),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '패밀리 관리하기',
                  style: AppTextStyle.body16M120.copyWith(
                    color: AppColors.f04,
                  ),
                ),
              ),

              const SizedBox(height: 20),



              // 펫시터
              Text(
                '펫시터',
                style: AppTextStyle.subtitle20M120.copyWith(
                  color: AppColors.f05,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '펫시터 이용 내역',
                  style: AppTextStyle.body16M120.copyWith(
                    color: AppColors.f04,
                  ),
                ),
              ),

              const SizedBox(height: 0),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '내 후기 관리',
                  style: AppTextStyle.body16M120.copyWith(
                    color: AppColors.f04,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 결제
              Text(
                '결제',
                style: AppTextStyle.subtitle20M120.copyWith(
                  color: AppColors.f05,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '결제수단 등록',
                  style: AppTextStyle.body16M120.copyWith(
                    color: AppColors.f04,
                  ),
                ),
              ),

              const SizedBox(height: 0),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '결제수단 변경',
                  style: AppTextStyle.body16M120.copyWith(
                    color: AppColors.f04,
                  ),
                ),
              ),


              const SizedBox(height: 20),

              // 라이프케어
              Text(
                '라이프케어',
                style: AppTextStyle.subtitle20M120.copyWith(
                  color: AppColors.f05,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '라이프케어란?',
                  style: AppTextStyle.body16M120.copyWith(
                    color: AppColors.f04,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray01,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyle.description14R120.copyWith(
          color: AppColors.f05,

        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.main,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.gray02,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildPetCard(int index) {
    return PetCard(
      imageUrl: 'assets/system/logo/logo.png',
      name: '또또 (2세)',
      species: '말티즈',
      personality: ['코지', '예민함', '물어요', '손조심'],
      favoriteToy: '목욕',
      sex: '수컷',
      birth: '2025.01.02',
      petFamily: '또또네 가족',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PetListPage()),
        );
      },
    );
  }

}