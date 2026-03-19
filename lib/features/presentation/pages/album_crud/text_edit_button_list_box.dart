import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_select_scale.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/photo_gallery_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/sticker_search_bottom_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/text_edit/text_style_sheet.dart';

// 정렬 순서: 왼쪽 → 중앙 → 오른쪽 → 반복
enum _AlignCycle { left, center, right }

class EditorIconBar extends StatefulWidget {
  final bool isTextMode;
  final VoidCallback? onDrawPressed;
  final VoidCallback? onBackgroundPressed;
  final VoidCallback? onSheetOpened;
  final VoidCallback? onSheetClosed;
  final VoidCallback? onTextPressed;
  final VoidCallback? onTextClosed;
  final VoidCallback? onTextStylePressed;

  // 텍스트 스타일 변경 콜백 (부모에서 실제 텍스트에 적용)
  final ValueChanged<String>? onFontFamilyChanged;
  final ValueChanged<Color>? onTextColorChanged;
  final ValueChanged<TextAlign>? onTextAlignChanged;
  final ValueChanged<bool>? onUnderlineChanged;

  const EditorIconBar({
    super.key,
    this.isTextMode = false,
    this.onDrawPressed,
    this.onBackgroundPressed,
    this.onSheetOpened,
    this.onSheetClosed,
    this.onTextPressed,
    this.onTextClosed,
    this.onTextStylePressed,
    this.onFontFamilyChanged,
    this.onTextColorChanged,
    this.onTextAlignChanged,
    this.onUnderlineChanged,
  });

  @override
  State<EditorIconBar> createState() => _EditorIconBarState();
}

class _EditorIconBarState extends State<EditorIconBar> {
  Color? selectedColor;
  String _selectedFontFamily = 'Pretendard';
  String _selectedFontLabel = '가'; // 폰트 버튼에 표시할 텍스트
  _AlignCycle _alignCycle = _AlignCycle.left;
  bool _isUnderline = false;

  // 현재 정렬 아이콘 경로
  String get _alignIconPath {
    switch (_alignCycle) {
      case _AlignCycle.left:
        return 'assets/system/icons/text_edit_left.svg';
      case _AlignCycle.center:
        return 'assets/system/icons/text_edit_middle.svg';
      case _AlignCycle.right:
        return 'assets/system/icons/text_edit_right.svg';
    }
  }

  TextAlign get _currentTextAlign {
    switch (_alignCycle) {
      case _AlignCycle.left:   return TextAlign.left;
      case _AlignCycle.center: return TextAlign.center;
      case _AlignCycle.right:  return TextAlign.right;
    }
  }

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
            color: Color(0x0A000000),
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
        _buildIconButton('assets/system/icons/icon_background.svg',
                () => widget.onBackgroundPressed?.call()),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/icon_add_photo.svg',
                () => _onImageAddPressed(context)),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/icon_text.svg', _onTextPushPressed),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/icon_brush.svg',
                () => widget.onDrawPressed?.call()),
        const SizedBox(width: 20),
        _buildIconButton('assets/system/icons/icon_sticker.svg',
                () => _onStickerPressed(context)),
      ],
    );
  }

  Widget _buildTextModeBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✕ 닫기
        GestureDetector(
          onTap: () => widget.onTextClosed?.call(),
          child: SvgPicture.asset(
            'assets/system/icons/icon_close_big.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 20),

        // 폰트 버튼: 선택된 폰트로 텍스트 표시
        _buildFontLabelButton(),
        const SizedBox(width: 20),

        // 색상 아이콘
        _buildIconButton('assets/system/icons/text_edit_impact.svg', _onColorPressed),
        const SizedBox(width: 20),

        // 정렬 버튼: 클릭마다 왼쪽→중앙→오른쪽 순환
        _buildIconButton(_alignIconPath, _onAlignPressed),
        const SizedBox(width: 20),

        // 밑줄 버튼: 활성화 시 main 색상으로 강조
        _buildUnderlineButton(),
        const SizedBox(width: 20),

        // 색상 원 버튼
        _buildColorButton(selectedColor ?? const Color(0xFFBDBDBD)),
        const SizedBox(width: 20),

        // ✓ 확인 (제일 오른쪽)
        GestureDetector(
          onTap: () => widget.onTextClosed?.call(),
          child: SvgPicture.asset(
            'assets/system/icons/icon_check.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  // 폰트 라벨 버튼: 선택된 폰트로 텍스트 표시
  Widget _buildFontLabelButton() {
    return GestureDetector(
      onTap: _onFontPressed,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        child: Text(
          _selectedFontLabel,
          style: TextStyle(
            fontFamily: _selectedFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.f05,
          ),
        ),
      ),
    );
  }

  // 밑줄 버튼: 활성화 시 main 색상으로 강조
  Widget _buildUnderlineButton() {
    return GestureDetector(
      onTap: _onUnderlinePressed,
      child: SvgPicture.asset(
        'assets/system/icons/text_edit_underline.svg',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          _isUnderline ? AppColors.main : AppColors.f05,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildIconButton(String iconPath, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
      ),
    );
  }

  // ── 메인 바 액션 ──

  Future<void> _onImageAddPressed(BuildContext context) async {
    widget.onSheetOpened?.call();
    final selectedPhotos = await PhotoGalleryBottomSheet.show(context);
    widget.onSheetClosed?.call();
    if (selectedPhotos != null && selectedPhotos.isNotEmpty) {
      print('Selected photos: $selectedPhotos');
    }
  }

  void _onTextPushPressed() => widget.onTextPressed?.call();

  Future<void> _onStickerPressed(BuildContext context) async {
    widget.onSheetOpened?.call();
    final selectedSticker = await StickerBottomSheet.show(context);
    widget.onSheetClosed?.call();
    if (selectedSticker != null) {
      print('선택된 스티커: ${selectedSticker.emoji} - ${selectedSticker.name}');
    }
  }

  // ── 텍스트 모드 액션 ──

  // 폰트 선택 시트 열기
  void _onFontPressed() {
    widget.onTextStylePressed?.call();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.6,
        builder: (context, scrollController) => TextStylePanel(
          selectedFontFamily: _selectedFontFamily,
          onTextFamilyChanged: (fontFamily) {
            // 선택된 폰트의 label을 찾아서 버튼에 표시
            final matched = TextStylePanel.fonts.firstWhere(
                  (f) => f.fontFamily == fontFamily,
              orElse: () => const FontItem(label: '가', fontFamily: 'Pretendard'),
            );
            setState(() {
              _selectedFontFamily = fontFamily;
              _selectedFontLabel = matched.label.split('\n').first;
            });
            widget.onFontFamilyChanged?.call(fontFamily);
          },
          onClose: () => Navigator.pop(context),
        ),
      ),
    );
  }

  // 정렬: 왼쪽 → 중앙 → 오른쪽 순환
  void _onAlignPressed() {
    setState(() {
      switch (_alignCycle) {
        case _AlignCycle.left:
          _alignCycle = _AlignCycle.center;
          break;
        case _AlignCycle.center:
          _alignCycle = _AlignCycle.right;
          break;
        case _AlignCycle.right:
          _alignCycle = _AlignCycle.left;
          break;
      }
    });
    widget.onTextAlignChanged?.call(_currentTextAlign);
  }

  // 밑줄 토글
  void _onUnderlinePressed() {
    setState(() {
      _isUnderline = !_isUnderline;
    });
    widget.onUnderlineChanged?.call(_isUnderline);
  }

  // 색상 시트 열기 → color_select_scale.dart의 ColorSelectorSection 사용
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 헤더: x / 색상 / v
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        'assets/system/icons/icon_close_big.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                            AppColors.f05, BlendMode.srcIn),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text('색상',
                            style: AppTextStyle.description14R120),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, selectedColor),
                      child: SvgPicture.asset(
                        'assets/system/icons/icon_check.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                            AppColors.f05, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ColorSelectorSection(
                  selectedColor: selectedColor,
                  onChanged: (color) {
                    Navigator.pop(context, color);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (selectedColorResult != null) {
      setState(() {
        selectedColor = selectedColorResult;
      });
      widget.onTextColorChanged?.call(selectedColorResult);
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
                border: Border.all(color: AppColors.main, width: 2),
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