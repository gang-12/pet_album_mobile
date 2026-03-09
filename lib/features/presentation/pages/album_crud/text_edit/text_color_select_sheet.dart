import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:flutter/cupertino.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_select_scale.dart';

class TextColorSelect extends StatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<Color?>? onColorChanged;

  const TextColorSelect({
    super.key,
    required this.onClose,
    this.onColorChanged,
  });

  @override
  State<TextColorSelect> createState() => _TextColorSelectState();
}

class _TextColorSelectState extends State<TextColorSelect> {
  int selectedTabIndex = 1;
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // SafeArea 제거, height 제거
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          const SizedBox(height: 16),
          _buildColorSection(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 16),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2),
        ),
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
}