import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_common_button_styles.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/theme/app_text_semantic.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_bar_main_scaffold.dart';
import 'package:petAblumMobile/core/widgets/pet_card.dart';
import 'package:petAblumMobile/features/presentation/pages/main/settings/settings_page.dart';
import 'package:petAblumMobile/features/presentation/pages/auth/guardian_info_page.dart';
import 'package:petAblumMobile/features/presentation/pages/pet_crud/pet_list.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final TextEditingController _foodController = TextEditingController();
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pets = [
    {
      'imageUrl': 'assets/system/logo/logo.png',
      'name': '    또또',
      'species': '말티즈',
      'personality': ['코지', '예민함', '물어요', '손조심'],
      'favoriteToy': '2세',
      'sex': '여아',
      'birth': '2025.01.02',
      'petFamily': '또또네 가족',
      'cardSvg': 'assets/system/pet_card/dog_pet_card.svg',
      'traits': ['큰소리 주의', '이물질 섭취 주위 필요', '입질경험있음', '분리불안'],
      'health': ['관절문제있음', '슬개골문제 있음', '피부문제있음'],
      'medicine': ['없음'],
    },
    {
      'imageUrl': 'assets/system/logo/logo.png',
      'name': '    망고',
      'species': '치즈',
      'personality': ['활동가', '애교쟁이', '산책광'],
      'favoriteToy': '2세',
      'sex': '남아',
      'birth': '2024.03.15',
      'petFamily': '또또네 가족',
      'cardSvg': 'assets/system/pet_card/cat_pet_card.svg',
      'traits': ['낯선사람 주의', '소심한', '뛰는거좋아', '창문 좋아'],
      'health': ['눈병', '다리문제 있음', '설사', '간식주의'],
      'medicine': ['안약'],
    },
    {
      'imageUrl': 'assets/system/logo/logo.png',
      'name': '    모모',
      'species': '비숑',
      'personality': ['순둥이', '먹보', '잠꾸러기'],
      'favoriteToy': '3세',
      'sex': '남아',
      'birth': '2023.06.10',
      'petFamily': '또또네 가족',
      'cardSvg': 'assets/system/pet_card/dog_pet_card.svg',
      'traits': ['겁쟁이', '낯가림'],
      'health': ['눈물자국 있음', '관절문제 있음','간식 주의', '정해진식단'],
      'medicine': ['안약', '비타민'],
    },
  ];

  @override
  void dispose() {
    _foodController.dispose();
    _pageController.dispose();
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
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // 반려동물 프로필 사진
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
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
                              return const Icon(Icons.pets, size: 60, color: AppColors.f01);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('조혜원', style: AppTextStyle.subtitle20Sb120),
                    const SizedBox(height: 8),
                    Text('또또네 가족', style: AppTextStyle.description14R120.copyWith(color: AppColors.f04)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 99,
                      height: 41,
                      child: ElevatedButton(
                        style: AppButtonStyles.base(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.gray01,
                        ).copyWith(
                          elevation: WidgetStateProperty.all(2),
                          shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.08)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          side: WidgetStateProperty.all(BorderSide.none),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const GuardianInfoPage()),
                          );
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '내 정보 수정',
                            style: AppTextStyle.description14R120.copyWith(color: AppColors.f05),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 스와이프 카드 영역 (패딩 없음)
              SizedBox(
                height: 560,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pets.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final pet = _pets[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            PetCard(
                              imageUrl: pet['imageUrl'],
                              name: pet['name'],
                              species: pet['species'],
                              personality: List<String>.from(pet['personality']),
                              favoriteToy: pet['favoriteToy'],
                              sex: pet['sex'],
                              birth: pet['birth'],
                              petFamily: pet['petFamily'],
                              cardSvg: pet['cardSvg'] ?? 'assets/system/pet_card/dog_pet_card.svg',
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const PetListPage()));
                              },
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('반려동물 정보', style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05)),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 29,
                                        child: Center(child: Text('성향', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f03))),
                                      ),
                                      const SizedBox(width: 16),
                                      SizedBox(
                                        width: 256,
                                        height: 64,
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: List<String>.from(pet['traits']).map((t) => _buildChip(t)).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 29,
                                        child: Center(child: Text('건강', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f03))),
                                      ),
                                      const SizedBox(width: 16),
                                      SizedBox(
                                        width: 256,
                                        height: 64,
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: List<String>.from(pet['health']).map((h) => _buildChip(h)).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 29,
                                        child: Center(child: Text('복용약', style: AppTextStyle.caption12R120.copyWith(color: AppColors.f03))),
                                      ),
                                      const SizedBox(width: 16),
                                      SizedBox(
                                        width: 256,
                                        height: 64,
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: List<String>.from(pet['medicine']).map((m) => _buildChip(m)).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 페이지 인디케이터
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pets.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? AppColors.main : AppColors.gray02,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('반려동물', style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('내 앨범', style: AppTextStyle.body16M120.copyWith(color: AppColors.f04)),
                    ),
                    const SizedBox(height: 20),
                    Text('라이프케어', style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('라이프케어란?', style: AppTextStyle.body16M120.copyWith(color: AppColors.f04)),
                    ),
                    const SizedBox(height: 24),
                  ],
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
      decoration: BoxDecoration(color: AppColors.gray01, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: AppTextStyle.description14R120.copyWith(color: AppColors.f05)),
    );
  }
}