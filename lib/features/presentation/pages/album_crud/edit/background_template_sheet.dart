import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_select_scale.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/photo_gallery_sheet.dart';

class BackgroundTabletPanel extends StatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<Color?>? onColorChanged;
  final Color? selectedColor;
  final VoidCallback onSave;   // ✓ 체크: 저장 후 닫기

  const BackgroundTabletPanel({
    super.key,
    required this.onClose,
    required this.onSave,
    this.onColorChanged,
    this.selectedColor,
  });

  @override
  State<BackgroundTabletPanel> createState() =>
      _BackgroundTabletPanelState();
}

class _BackgroundTabletPanelState extends State<BackgroundTabletPanel> {
  int selectedTabIndex = 1;
  Color? selectedColor;

  // 무지(index 1)일 때만 색상 섹션 표시
  bool get _showColorSection => selectedTabIndex == 1;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.selectedColor;
  }

  Future<void> _openPhotoGallery() async {
    final selectedPhotos = await PhotoGalleryBottomSheet.show(context);
    if (selectedPhotos != null && selectedPhotos.isNotEmpty) {
      // TODO: 선택된 사진 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      // 핸들바(28px) 제거 → 헤더(56px)로 대체, 높이 재조정
      height: _showColorSection ? 320 : 253,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          top: BorderSide(color: AppColors.gray01, width: 1.5),
          left: BorderSide(color: AppColors.gray01, width: 1.5),
          right: BorderSide(color: AppColors.gray01, width: 1.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, -4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 20),
            _buildTabs(),

            // 무지 선택 시에만 색상 섹션 표시
            if (_showColorSection) ...[
              const SizedBox(height: 20),
              _buildColorSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // ✕ 엑스: 변경 취소 + 시트 닫기
          GestureDetector(
            onTap: widget.onClose,
            child: SvgPicture.asset(
              'assets/system/icons/icon_close_big.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.f05,
                BlendMode.srcIn,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                '배경',
                style: AppTextStyle.description14R120,
              ),
            ),
          ),

          // ✓ 체크: 저장 + 시트 닫기
          GestureDetector(
            onTap: widget.onSave,
            child: SvgPicture.asset(
              'assets/system/icons/icon_check.svg',
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
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: AppTextStyle.description14M120.copyWith(
          color: AppColors.f05,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhotoAddTab(),
          const SizedBox(width: 12),
          _buildTab(1, '무지'),
          const SizedBox(width: 12),
          _buildTab(2, '모눈종이'),
          const SizedBox(width: 12),
          _buildTab(3, '글종이'),
        ],
      ),
    );
  }

  Widget _buildPhotoAddTab() {
    final isSelected = selectedTabIndex == 0;
    return GestureDetector(
      onTap: () {
        setState(() => selectedTabIndex = 0);
        _openPhotoGallery();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              dashPattern: const [4, 4],
              strokeWidth: 1.5,
              radius: const Radius.circular(12),
              color: isSelected ? AppColors.main : AppColors.gray03,
              padding: EdgeInsets.zero,
            ),
            child: SizedBox(
              width: 92,
              height: 106,
              child: Center(
                child: SvgPicture.asset(
                  'assets/system/icons/icon_add.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.main : AppColors.f02,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '사진추가',
            style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ColorSelectorSection(
        selectedColor: selectedColor,
        onChanged: (color) {
          setState(() => selectedColor = color);
          widget.onColorChanged?.call(color);
        },
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 106,
            decoration: BoxDecoration(
              color: AppColors.f01,
              border: Border.all(
                color: isSelected ? AppColors.main : AppColors.gray01,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyle.caption12R120.copyWith(
              color: AppColors.f04,
            ),
          ),
        ],
      ),
    );
  }
}