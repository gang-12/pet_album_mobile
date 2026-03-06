import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_select_scale.dart';

class TextColorSelect extends StatefulWidget {
  final VoidCallback onClose;         // ✕ 엑스: 취소 후 닫기
  final VoidCallback? onSave;         // ✓ 체크: 저장 후 닫기
  final ValueChanged<Color?>? onColorChanged;

  const TextColorSelect({
    super.key,
    required this.onClose,
    this.onSave,
    this.onColorChanged,
  });

  @override
  State<TextColorSelect> createState() => _TextColorSelectState();
}

class _TextColorSelectState extends State<TextColorSelect> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ 높이: 핸들바 제거 → 헤더(24px) + 패딩(top16+bottom24) + gap(20) + 색상줄(38px) = 약 122px
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 핸들바 삭제 → 헤더(엑스 / "색상" / 체크)로 대체
          _buildHeader(),
          const SizedBox(height: 20),
          Text('Hello'),
          _buildColorSection(),
        ],
      ),
    );
  }

  // ✅ 헤더: 엑스 / "색상" / 체크
  Widget _buildHeader() {
    return Row(
      children: [

        // ✕ 엑스
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

        // 중앙 "색상" 텍스트
        Expanded(
          child: Center(
            child: Text(
              '색상',
              style: AppTextStyle.subtitle20M120,
            ),
          ),
        ),

        // ✓ 체크 (onSave 없으면 onClose로 fallback)
        GestureDetector(
          onTap: widget.onSave ?? widget.onClose,
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
    );
  }

  Widget _buildColorSection() {
    return ColorSelectorSection(
      selectedColor: selectedColor,
      onChanged: (color) {
        setState(() => selectedColor = color);
        widget.onColorChanged?.call(color);
      },
    );
  }
}