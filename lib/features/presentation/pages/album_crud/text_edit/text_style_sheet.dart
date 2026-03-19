import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

/// 폰트 정보 모델
class FontItem {
  final String label;       // 박스 안에 표시할 텍스트
  final String fontFamily;  // Flutter fontFamily 이름

  const FontItem({required this.label, required this.fontFamily});
}

/// 폰트 스타일 선택 패널 (토글 방식 — drawing_tool_sheet와 동일 구조)
class TextStylePanel extends StatefulWidget {
  final String selectedFontFamily;
  final TextAlign selectedTextAlign;
  final ValueChanged<String> onTextFamilyChanged;
  final ValueChanged<TextAlign>? onTextAlignChanged;
  final VoidCallback onClose;

  const TextStylePanel({
    Key? key,
    required this.selectedFontFamily,
    this.selectedTextAlign = TextAlign.left,
    required this.onTextFamilyChanged,
    this.onTextAlignChanged,
    required this.onClose,
  }) : super(key: key);

  // 외부에서 TextStylePanel.fonts 로 접근 가능
  static const List<FontItem> fonts = [
    FontItem(label: '프리텐다드',             fontFamily: 'Pretendard'),
    FontItem(label: 'Memoment\nKkukkukk',   fontFamily: 'MemomentKkukkukk'),
    FontItem(label: 'LTIM',                  fontFamily: 'LTIM'),
    FontItem(label: 'Hubbell',               fontFamily: 'Soap'),
    FontItem(label: 'IMPACT',                fontFamily: 'Impact'),
  ];

  @override
  State<TextStylePanel> createState() => _FontStylePanelState();
}

class _FontStylePanelState extends State<TextStylePanel> {
  late String _selectedFamily;
  late TextAlign _selectedAlign;

  @override
  void initState() {
    super.initState();
    _selectedFamily = widget.selectedFontFamily;
    _selectedAlign = widget.selectedTextAlign;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(),
            const SizedBox(height: 20),
            _buildFontGrid(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── 핸들 바 (x / 폰트 스타일 / v) ──
  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        children: [
          // ✕ 닫기
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
                '폰트 스타일',
                style: AppTextStyle.description14R120,
              ),
            ),
          ),

          // ✓ 확인
          GestureDetector(
            onTap: () {
              widget.onTextFamilyChanged(_selectedFamily);
              widget.onClose();
            },
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


  // ── 폰트 그리드 (wrap) ──
  Widget _buildFontGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: TextStylePanel.fonts.map((font) {
        final isSelected = _selectedFamily == font.fontFamily;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedFamily = font.fontFamily);
            widget.onTextFamilyChanged(font.fontFamily);
          },
          child: Container(
            width: 75,
            height: 42,
            padding: isSelected
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isSelected ? AppColors.main : AppColors.gray01,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                font.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: font.fontFamily,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  letterSpacing: -0.2,
                  color: const Color(0xFF505050),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}