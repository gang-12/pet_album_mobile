import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_dahyun.dart';

class PetCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String species;
  final List<String>? personality;
  final String favoriteToy;
  final String sex;
  final String birth;
  final VoidCallback? onTap;
  final Widget? topRightIcon;
  final String petFamily;
  final bool isSelected;
  final bool isDeleteMode;

  const PetCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.species,
    required this.personality,
    required this.favoriteToy,
    required this.sex,
    required this.birth,
    this.onTap,
    this.topRightIcon,
    required this.petFamily,
    this.isSelected = false,
    this.isDeleteMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final double h = w * (210 / 350);
        final double s = w / 350;

        // 스트로크 색상 결정: 삭제 모드일 때만 표시
        // 선택됨 → main 컬러, 미선택 → gray01
        final Color strokeColor = isSelected
            ? AppColors.main  // main 컬러로 교체 (프로젝트 AppColors.main 사용)
            : AppColors.gray01;
        final bool showStroke = isDeleteMode;

        return GestureDetector(
          onTap: onTap,
          child: Center(
            child: SizedBox(
              width: w,
              height: h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // SVG 배경
                  SvgPicture.asset(
                    'assets/system/pet_card/dog_pet_card.svg',
                    width: w,
                    height: h,
                    fit: BoxFit.fill,
                  ),

                  Positioned(
                    left: 207 * s,
                    top: 29 * s,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12 * s),
                      child: Image.asset(
                        imageUrl,
                        width: 118 * s,
                        height: 120 * s,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 118 * s,
                          height: 120 * s,
                          color: Colors.grey[200],
                          child: const Icon(Icons.pets, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  _buildTextOverlays(s),

                  Positioned(
                    right: 17 * s,
                    bottom: 45 * s,
                    child: SizedBox(
                      width: 30 * s,
                      height: 30 * s,
                      child: SvgPicture.asset(
                        'assets/system/pet_card/idcard_part.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // topRightIcon (필요 시 유지)
                  if (topRightIcon != null)
                    Positioned(
                      right: 8 * s,
                      top: 8 * s,
                      child: topRightIcon!,
                    ),

                  // 외곽 스트로크 - SVG 포함 모든 레이어 위에 렌더링
                  if (showStroke)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20 * s),
                            border: Border.all(
                              color: strokeColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextOverlays(double s) {
    return Stack(
      children: [
        Positioned(
          left: 70 * s,
          top: 50 * s,
          width: 160 * s,
          child: Stack(
            children: [
              Text(
                name,
                style: AppTextStyleDahyun.dahyun(
                  size: 20 * s,
                  weight: FontWeight.w400,
                  height: 1.0 * s,
                ).copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1 * s
                    ..color = const Color(0xFF111111),
                  letterSpacing: -0.3 * s,
                ),
              ),
              Text(
                name,
                style: AppTextStyleDahyun.dahyun(
                  size: 20 * s,
                  weight: FontWeight.w400,
                  height: 1.0 * s,
                ).copyWith(
                  color: const Color(0xFFFFEAA2),
                  letterSpacing: -0.3 * s,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 35 * s,
          top: 100 * s,
          child: Text(
            '나이 : $favoriteToy  품종 : $species',
            style: AppTextStyleDahyun.dahyun(
              size: 14 * s,
              weight: FontWeight.normal,
              height: 1.2 * s,
            ),
          ),
        ),
        Positioned(
          left: 35 * s,
          top: 123 * s,
          child: Text(
            '성별 : $sex   생일 : $birth',
            style: AppTextStyleDahyun.dahyun(
              size: 14 * s,
              weight: FontWeight.normal,
              height: 1.2 * s,
            ),
          ),
        ),
        Positioned(
          left: 35 * s,
          top: 148 * s,
          width: 160 * s,
          child: _buildPersonalityText(personality, s),
        ),
        Positioned(
          left: 240 * s,
          top: 162 * s,
          child: Text(
            petFamily,
            style: AppTextStyleDahyun.dahyun(
              size: 14 * s,
              weight: FontWeight.normal,
              height: 1.2 * s,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalityText(List<String>? personality, double s) {
    if (personality == null || personality.isEmpty) {
      return const SizedBox.shrink();
    }

    final textStyle = AppTextStyleDahyun.dahyun(
      size: 14 * s,
      weight: FontWeight.normal,
      height: 1.2,
    );

    if (personality.length <= 2) {
      return Text(
        '성격 : ${personality.map((p) => '#$p').join(' ')}',
        style: textStyle,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '성격 : ${personality.take(2).map((p) => '#$p').join(' ')}',
          style: textStyle,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30 * s),
          child: Text(
            personality.skip(2).map((p) => '#$p').join(' '),
            style: textStyle,
          ),
        ),
      ],
    );
  }
}