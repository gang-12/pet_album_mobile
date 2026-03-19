import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/album_view.dart';

/// 앨범 아이템 위젯
class AlbumGridItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool isBookmarked;
  final Map<String, String> album; // 뷰 페이지 전달용
  final VoidCallback? onTap;       // kebab 메뉴 → 바텀시트 호출
  final bool isSelectMode;         // 선택 모드 여부
  final bool isSelected;           // 선택됨 여부
  final VoidCallback? onSelectTap; // 선택 모드에서 이미지 탭

  const AlbumGridItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isBookmarked,
    required this.album,
    this.onTap,
    this.isSelectMode = false,
    this.isSelected = false,
    this.onSelectTap,
  });

  // ── 공통 그라디언트 오버레이 ──────────────────
  static const _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.633, 1.0],
    colors: [
      Color(0x00000000), // rgba(0,0,0,0.00)
      Color(0x33000000), // rgba(0,0,0,0.20)
    ],
  );

  // ── 공통 그림자 ───────────────────────────────
  static const _shadow = BoxShadow(
    color: Color(0x14000000), // rgba(0,0,0,0.08)
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth;
        final double imageHeight = itemWidth * 4 / 3; // 3:4 비율

        // 상태별 border/radius
        final bool showBorder = isSelected;
        final double outerRadius = 12.0;
        final double innerRadius = showBorder ? 9.5 : 12.0; // 2.5px 테두리 보정

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── 이미지 박스 ───────────────────────
            GestureDetector(
              onTap: isSelectMode
                  ? onSelectTap
                  : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AlbumViewPage(album: album),
                ),
              ),
              child: Container(
                width: itemWidth,
                height: imageHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(outerRadius),
                  border: showBorder
                      ? Border.all(color: AppColors.main, width: 2.5)
                      : null,
                  boxShadow: const [_shadow],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(innerRadius),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // 1. 흰색 배경 (항상)
                      const ColoredBox(color: AppColors.white),

                      // 2. 이미지
                      if (imageUrl.isNotEmpty)
                        Image.asset(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const ColoredBox(color: AppColors.gray01);
                          },
                        ),

                      // 3. 그라디언트 오버레이
                      //    기본 모드: 없음 / 선택 모드(선택 전·후 모두): 있음
                      if (isSelectMode)
                        const Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(gradient: _gradient),
                          ),
                        ),

                      // 4. 선택 모드 우하단 라디오 아이콘
                      if (isSelectMode)
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0, // 좌우 모두 0으로 잡아줌
                          child: Center(
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.main
                                    : const Color(0xCCFFFFFF),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.main
                                      : AppColors.gray03,
                                  width: 1.5,
                                ),
                              ),
                              child: isSelected
                                  ? SvgPicture.asset(
                                'assets/system/icons/icon_check.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              )
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── 타이틀 + kebab (선택 모드에서는 kebab 숨김) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.body16M120.copyWith(
                      color: AppColors.f05,
                    ),
                  ),
                ),
                if (!isSelectMode)
                  GestureDetector(
                    onTap: onTap,
                    child: SvgPicture.asset(
                      'assets/system/icons/icon_kebab_menu.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.f05,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}