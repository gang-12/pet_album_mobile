import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_select_scale.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/photo_gallery_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/sticker_search_bottom_sheet.dart';

class EditorIconBar extends StatefulWidget {
  final bool isTextMode;
  final VoidCallback? onDrawPressed;
  final VoidCallback? onBackgroundPressed;
  final VoidCallback? onSheetOpened;   // 모달 시트 열릴 때
  final VoidCallback? onSheetClosed;   // 모달 시트 닫힐 때
  final VoidCallback? onTextPressed;
  final VoidCallback? onTextClosed;

  const EditorIconBar({
    super.key,
    this.isTextMode = false,
    this.onDrawPressed,
    this.onBackgroundPressed,
    this.onSheetOpened,
    this.onSheetClosed,
    this.onTextPressed,
    this.onTextClosed,
  });

  @override
  State<EditorIconBar> createState() => _EditorIconBarState();
}

class _EditorIconBarState extends State<EditorIconBar> {
  bool _isTextMode = false;
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray01, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: widget.isTextMode ? _buildTextModeBar() : _buildMainBar(),
    );
  }

  Widget _buildMainBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconButton(
          'assets/system/icons/icon_background.svg',
              () => widget.onBackgroundPressed?.call(),
        ),
        const SizedBox(width: 20),
        _buildIconButton(
          'assets/system/icons/icon_add_photo.svg',
              () => _onImageAddPressed(context),
        ),
        const SizedBox(width: 20),
        _buildIconButton(
          'assets/system/icons/icon_text.svg',
          _onTextPushPressed,
        ),
        const SizedBox(width: 20),
        _buildIconButton(
          'assets/system/icons/icon_brush.svg',
              () => widget.onDrawPressed?.call(),
        ),
        const SizedBox(width: 20),
        _buildIconButton(
          'assets/system/icons/icon_sticker.svg',
              () => _onStickerPressed(context),
        ),
      ],
    );
  }

  Widget _buildTextModeBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 텍스트 모드 닫기 → 메인 바로 돌아가기
        GestureDetector(
          onTap: () {
            widget.onTextClosed?.call();
          },
          child: SvgPicture.asset(
            'assets/system/icons/icon_close_big.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColors.f05,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/text_edit_select_font.svg', _onFontPressed),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/text_edit_impact.svg', _onColorPressed),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/text_edit_middle.svg', _onAlignPressed),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/text_edit_italic.svg', _onItalicPressed),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/text_edit_underline.svg', _onUnderlinePressed),
        const SizedBox(width: 20),
        _buildColorButton(selectedColor ?? const Color(0xFFBDBDBD)),
      ],
    );
  }

  Widget _buildIconButton(String iconPath, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
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

  // 메인 바 액션들
  Future<void> _onImageAddPressed(BuildContext context) async {
    widget.onSheetOpened?.call();
    final selectedPhotos = await PhotoGalleryBottomSheet.show(context);
    widget.onSheetClosed?.call();
    if (selectedPhotos != null && selectedPhotos.isNotEmpty) {
      print('Selected photos: $selectedPhotos');
    }
  }

  void _onTextPushPressed() {
    widget.onTextPressed?.call();
  }

  Future<void> _onStickerPressed(BuildContext context) async {
    widget.onSheetOpened?.call();
    final selectedSticker = await StickerBottomSheet.show(context);
    widget.onSheetClosed?.call();
    if (selectedSticker != null) {
      print('선택된 스티커: ${selectedSticker.emoji} - ${selectedSticker.name}');
    }
  }

  // 텍스트 모드 액션들
  void _onFontPressed() => print('폰트 변경');
  void _onAlignPressed() => print('정렬 변경');
  void _onItalicPressed() => print('이탤릭 토글');
  void _onUnderlinePressed() => print('밑줄 토글');

  void _onColorPressed() async {
    final selectedColorResult = await showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.3,
        builder: (context, scrollController) => Container(
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
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 핸들바
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 54,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray03,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: ColorSelectorSection(
                  selectedColor: selectedColor,
                  onChanged: (color) {
                    Navigator.pop(context, color);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedColorResult != null) {
      setState(() {
        selectedColor = selectedColorResult;
      });
    }
  }

  Widget _buildColorButton(Color color) {
    final isSelected = selectedColor == color;
    return GestureDetector(
      onTap: _onColorPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}