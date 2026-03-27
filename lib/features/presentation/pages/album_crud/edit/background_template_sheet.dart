import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_select_scale.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/photo_gallery_sheet.dart';
import 'photo_gallery_single_sheet.dart';

// ─── 탭 데이터 ────────────────────────────────────────────────────────────────
// index 0 : 사진추가 (별도 처리)
// index 1 : 무지 (색상 섹션 표시)
// index 2~ : SVG 배경
class _BgTabData {
  final int index;
  final String label;
  final String? svgPath; // null이면 무지(단색 배경)

  const _BgTabData({
    required this.index,
    required this.label,
    this.svgPath,
  });
}

const _bgTabs = [
  _BgTabData(index: 1,  label: '무지'),
  _BgTabData(index: 2,  label: '모눈화이트', svgPath: 'assets/system/background/모눈화이트.svg'),
  _BgTabData(index: 3,  label: '모눈블랙',   svgPath: 'assets/system/background/모눈블랙.svg'),
  _BgTabData(index: 4,  label: '모눈블루',   svgPath: 'assets/system/background/모눈블루.svg'),
  _BgTabData(index: 5,  label: '공책',       svgPath: 'assets/system/background/공책.svg'),
  _BgTabData(index: 6,  label: '하트체크',   svgPath: 'assets/system/background/하트체크.svg'),
  _BgTabData(index: 7,  label: '별',         svgPath: 'assets/system/background/별.svg'),
  _BgTabData(index: 8,  label: '하트',       svgPath: 'assets/system/background/하트.svg'),
  _BgTabData(index: 9,  label: '강아지',     svgPath: 'assets/system/background/강아지.svg'),
  _BgTabData(index: 10, label: '발자국',     svgPath: 'assets/system/background/발자국.svg'),
  _BgTabData(index: 11, label: '들판',       svgPath: 'assets/system/background/들판.svg'),
  _BgTabData(index: 12, label: '구름',       svgPath: 'assets/system/background/구름.svg'),
  _BgTabData(index: 13, label: '벚꽃',       svgPath: 'assets/system/background/벚꽃.svg'),
];

// ─── Widget ───────────────────────────────────────────────────────────────────
class BackgroundTabletPanel extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;
  final ValueChanged<Color?>? onColorChanged;
  final ValueChanged<String?>? onSvgBackgroundChanged;
  final Color? selectedColor;
  final String? selectedSvgPath;

  const BackgroundTabletPanel({
    super.key,
    required this.onClose,
    required this.onSave,
    this.onColorChanged,
    this.onSvgBackgroundChanged,
    this.selectedColor,
    this.selectedSvgPath,
  });

  @override
  State<BackgroundTabletPanel> createState() => _BackgroundTabletPanelState();
}

class _BackgroundTabletPanelState extends State<BackgroundTabletPanel> {
  int _tabIndex = 1;
  Color? _selectedColor;
  String? _selectedSvgPath;

  bool get _showColorSection => _tabIndex == 1;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
    _selectedSvgPath = widget.selectedSvgPath;

    // 현재 적용된 SVG가 있으면 해당 탭으로 초기화
    if (_selectedSvgPath != null) {
      final match = _bgTabs.where((t) => t.svgPath == _selectedSvgPath);
      if (match.isNotEmpty) _tabIndex = match.first.index;
    }
  }

  Future<void> _openPhotoGallery() async {
    final selectedPhoto = await PhotoGallerySingleBottomSheet.show(context);
    if (selectedPhoto != null) {
      // TODO 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: _showColorSection ? 320 : 253,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          top:   BorderSide(color: AppColors.gray01, width: 1.5),
          left:  BorderSide(color: AppColors.gray01, width: 1.5),
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
            if (_showColorSection) ...[
              const SizedBox(height: 20),
              _buildColorSection(),
            ],
          ],
        ),
      ),
    );
  }

  // ── 헤더 ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onClose,
            child: SvgPicture.asset(
              'assets/system/icons/icon_close_big.svg',
              width: 24, height: 24,
              colorFilter: const ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('배경', style: AppTextStyle.description14R120),
            ),
          ),
          GestureDetector(
            onTap: widget.onSave,
            child: SvgPicture.asset(
              'assets/system/icons/icon_check.svg',
              width: 24, height: 24,
              colorFilter: const ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  // ── 탭 가로 스크롤 ────────────────────────────────────────────────────────
  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사진추가
          _buildPhotoAddTab(),
          // 무지 + SVG 배경들
          ..._bgTabs.expand((tab) => [
            const SizedBox(width: 12),
            _buildTab(tab),
          ]),
        ],
      ),
    );
  }

  // ── 사진추가 탭 ───────────────────────────────────────────────────────────
  Widget _buildPhotoAddTab() {
    final isSelected = _tabIndex == 0;
    return GestureDetector(
      onTap: () {
        setState(() => _tabIndex = 0);
        _openPhotoGallery();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  width: 24, height: 24,
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

  // ── 개별 탭 (무지 / SVG 배경) ─────────────────────────────────────────────
  Widget _buildTab(_BgTabData tab) {
    final isSelected = _tabIndex == tab.index;
    final hasSvg = tab.svgPath != null;

    return GestureDetector(
      onTap: () {
        setState(() => _tabIndex = tab.index);
        if (hasSvg) {
          // SVG 배경 즉시 미리보기 적용
          _selectedSvgPath = tab.svgPath;
          widget.onSvgBackgroundChanged?.call(tab.svgPath);
        } else {
          // 무지: SVG 배경 해제
          _selectedSvgPath = null;
          widget.onSvgBackgroundChanged?.call(null);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 92,
            height: 106,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              // SVG 없는 탭(무지)은 기본 배경색
              color: hasSvg ? null : AppColors.white,
              border: Border.all(
                color: isSelected ? AppColors.main : AppColors.gray01,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: hasSvg
                ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SvgPicture.asset(
                tab.svgPath!,
                width: 92,
                height: 106,
                fit: BoxFit.cover,
              ),
            )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          Text(
            tab.label,
            style: AppTextStyle.caption12R120.copyWith(color: AppColors.f04),
          ),
        ],
      ),
    );
  }

  // ── 색상 섹션 (무지 탭) ───────────────────────────────────────────────────
  Widget _buildColorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ColorSelectorSection(
        selectedColor: _selectedColor,
        onChanged: (color) {
          setState(() => _selectedColor = color);
          widget.onColorChanged?.call(color);
        },
      ),
    );
  }
}