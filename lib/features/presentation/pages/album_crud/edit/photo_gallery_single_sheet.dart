import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';

class PhotoGallerySingleBottomSheet extends StatefulWidget {
  const PhotoGallerySingleBottomSheet({super.key});

  static Future<int?> show(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PhotoGallerySingleBottomSheet(),
    );
  }

  @override
  State<PhotoGallerySingleBottomSheet> createState() =>
      _PhotoGallerySingleBottomSheetState();
}

class _PhotoGallerySingleBottomSheetState
    extends State<PhotoGallerySingleBottomSheet> {
  int? selectedIndex;

  String selectedFilter = '최근항목';
  bool _isDropdownOpen = false;

  final List<int> items = List.generate(20, (i) => i);


  void select(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void confirm() {
    Navigator.pop(context, selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [

          /// header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    'assets/system/icons/icon_close_big.svg',
                    width: 24,
                    height: 24,
                  ),
                ),

                const Expanded(
                  child: Center(
                    child: Text('사진'),
                  ),
                ),

                GestureDetector(
                  onTap: confirm,
                  child: SvgPicture.asset(
                    'assets/system/icons/icon_check.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  offset: const Offset(0, 40),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onOpened: () => setState(() => _isDropdownOpen = true),
                  onCanceled: () => setState(() => _isDropdownOpen = false),
                  onSelected: (value) => setState(() {
                    selectedFilter = value;
                    _isDropdownOpen = false;
                  }),
                  itemBuilder: (_) => [
                    _buildPopupMenuItem('최근항목'),
                    _buildPopupMenuItem('다운로드'),
                    _buildPopupMenuItem('즐겨찾기'),
                    _buildPopupMenuItem('폴더이름'),
                  ],
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedFilter,
                        style: AppTextStyle.body16M120.copyWith(
                          color: AppColors.f05,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedRotation(
                        turns: _isDropdownOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: SvgPicture.asset(
                          'assets/system/icons/icon_expand_more.svg',
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
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: items.length,
                itemBuilder: (_, i) {
                  final isSelected = selectedIndex == i;

                  return GestureDetector(
                    onTap: () => select(i),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [

                        /// 이미지 영역
                        Container(
                          color: AppColors.gray01,
                        ),

                        /// 선택 오버레이
                        if (isSelected)
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0x4D000000),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),

                        /// 체크 아이콘 (기존 시트와 동일)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFFFBBC05)
                                  : const Color(0xCCFFFFFF),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFBBC05)
                                    : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                              child: SvgPicture.asset(
                                'assets/system/icons/icon_check.svg',
                                width: 16,
                                height: 16,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
            ),
          ),
        ],
      ),
    );
  }
  PopupMenuItem<String> _buildPopupMenuItem(String title) {
    final isSelected = selectedFilter == title;

    return PopupMenuItem<String>(
      value: title,
      child: Text(
        title,
        style: AppTextStyle.body16M120.copyWith(
          color: isSelected ? AppColors.f05 : AppColors.f03,
        ),
      ),
    );
  }
}