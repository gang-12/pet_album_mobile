import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/photo_gallery_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/sticker_search_bottom_sheet.dart';

class TextEditorIconBar extends StatefulWidget {
  final VoidCallback? onDrawPressed;
  final VoidCallback? onBackgroundPressed;
  final VoidCallback? onTextPressed;

  const TextEditorIconBar({
    super.key,
    this.onDrawPressed,
    this.onBackgroundPressed,
    this.onTextPressed,
  });

  @override
  State<TextEditorIconBar> createState() => _TextEditorIconBarState();
}

class _TextEditorIconBarState extends State<TextEditorIconBar> {
  // 정렬 아이콘 순환 목록
  final List<String> _alignIcons = [
    'assets/system/icons/icon_align_center.svg',
    'assets/system/icons/icon_align_justify.svg',
    'assets/system/icons/icon_align_left.svg',
    'assets/system/icons/icon_align_right.svg',
  ];
  int _alignIndex = 0;

  void _cycleAlign() {
    setState(() {
      _alignIndex = (_alignIndex + 1) % _alignIcons.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // IMPACT 텍스트 (18px)
          GestureDetector(
            onTap: () => widget.onBackgroundPressed?.call(),
            child: const Text(
              'IMPACT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 정렬 아이콘 (탭마다 순환)
          GestureDetector(
            onTap: _cycleAlign,
            child: SvgPicture.asset(
              _alignIcons[_alignIndex],
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColors.f05,
                BlendMode.srcIn,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Bold
          _buildSvgIconButton(
            'assets/system/icons/icon_bold.svg',
                () {},
          ),

          const SizedBox(width: 12),

          // Italic
          _buildSvgIconButton(
            'assets/system/icons/icon_italic.svg',
                () => widget.onDrawPressed?.call(),
          ),

          const SizedBox(width: 12),

          // Underline
          _buildSvgIconButton(
            'assets/system/icons/icon_text_underline.svg',
                () {},
          ),

          const SizedBox(width: 12),

          // 컬러 원: 24x24, main 색상, stroke 2.5px rgba(0,0,0,0.1)
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.main,
                border: Border.all(
                  color: Colors.black.withOpacity(0.10),
                  width: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSvgIconButton(String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          AppColors.f05,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}