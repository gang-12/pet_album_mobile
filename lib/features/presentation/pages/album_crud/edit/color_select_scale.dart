import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_pickup_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_pickup_sheet.dart';

class ColorSelectorSection extends StatefulWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onChanged;

  const ColorSelectorSection({
    super.key,
    required this.selectedColor,
    required this.onChanged,
  });

  // 기본 색상 목록 (외부에서도 참조 가능하도록 static 유지)
  static List<Color> colors = [
    const Color(0xFFEDE3D6),
    const Color(0xFFFFFFFF),
    const Color(0xFF383838),
  ];

  @override
  State<ColorSelectorSection> createState() => _ColorSelectorSectionState();
}

class _ColorSelectorSectionState extends State<ColorSelectorSection> {
  // 로컬 색상 목록 (동적 추가 지원)
  late List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _colors = List.from(ColorSelectorSection.colors);
  }

  void _addColor(Color color) {
    // 중복 색상은 추가하지 않음
    if (!_colors.contains(color)) {
      setState(() {
        _colors.add(color);
        ColorSelectorSection.colors = List.from(_colors); // static도 동기화
      });
    }
    widget.onChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 색상 추가 버튼 (맨 앞)
        _buildAddButton(context),
        const SizedBox(width: 12),
        // 색상 목록
        ...List.generate(_colors.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildColorButton(_colors[index]),
          );
        }),
      ],
    );
  }

  // 색상 추가 버튼: 32x32, padding 2px 0, border-radius 62px, background gray03
  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedColor = await ColorPickerBottomSheet.show(
          context,
          onColorAdded: (color) {
            _addColor(color);
          },
        );
        if (pickedColor != null) {
          _addColor(pickedColor);
        }
      },
      child: Container(
        width: 32,
        height: 32,
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.gray03,
          borderRadius: BorderRadius.circular(62),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/system/icons/icon_add.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  // 일반 색상 버튼
  Widget _buildColorButton(Color color) {
    final isSelected = widget.selectedColor == color;

    return GestureDetector(
      onTap: () => widget.onChanged(color),
      child: SizedBox(
        width: 38,
        height: 38,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 선택 시 외곽 링
            if (isSelected)
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.main,
                    width: 2,
                  ),
                ),
              ),
            // 색상 원
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withOpacity(0.1),
                  width: 2.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}