import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';

/// 색상 선택 바텀시트
class ColorPickerBottomSheet extends StatefulWidget {
  final Function(Color) onColorAdded;

  const ColorPickerBottomSheet({
    Key? key,
    required this.onColorAdded,
  }) : super(key: key);

  @override
  State<ColorPickerBottomSheet> createState() => _ColorPickerBottomSheetState();

  static Future<Color?> show(
      BuildContext context, {
        required Function(Color) onColorAdded,
      }) {
    return showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => ColorPickerBottomSheet(onColorAdded: onColorAdded),
    );
  }
}

class _ColorPickerBottomSheetState extends State<ColorPickerBottomSheet> {
  Color? selectedColor;
  bool _isDropperMode = false;

  // 색상 팔레트 생성
  List<List<Color>> _generateColorPalette() {
    final List<List<Color>> palette = [];
    const int rows = 10;
    const int cols = 16;

    for (int row = 0; row < rows; row++) {
      final List<Color> rowColors = [];
      for (int col = 0; col < cols; col++) {
        final double hue = (col / cols) * 360;
        if (col == 0) {
          final double gray = row / (rows - 1);
          rowColors.add(Color.fromRGBO(
            (gray * 255).round(),
            (gray * 255).round(),
            (gray * 255).round(),
            1.0,
          ));
        } else {
          double lightness;
          if (row == 0) {
            lightness = 0.15;
          } else if (row == 1) {
            lightness = 0.30;
          } else {
            lightness = 0.30 + ((row - 1) / (rows - 2)) * 0.65;
          }
          rowColors.add(_hslToColor(hue, 1.0, lightness));
        }
      }
      palette.add(rowColors);
    }
    return palette;
  }

  Color _hslToColor(double h, double s, double l) {
    h = h / 360;
    double r, g, b;
    if (s == 0) {
      r = g = b = l;
    } else {
      double hue2rgb(double p, double q, double t) {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1 / 6) return p + (q - p) * 6 * t;
        if (t < 1 / 2) return q;
        if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
        return p;
      }
      final double q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      final double p = 2 * l - q;
      r = hue2rgb(p, q, h + 1 / 3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1 / 3);
    }
    return Color.fromRGBO(
      (r * 255).round(),
      (g * 255).round(),
      (b * 255).round(),
      1.0,
    );
  }

  String _colorToHex(Color color) {
    return '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Color>> colorPalette = _generateColorPalette();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
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
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ 핸들바 삭제 → 헤더(엑스 / 색상추가 / 체크)로 대체
            _buildHeader(context),

            const SizedBox(height: 20),

            // 색상 팔레트 + 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  // 색상 그리드
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gray02),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: colorPalette.map((List<Color> row) {
                          return Row(
                            children: row.map((Color color) {
                              final bool isSelected = selectedColor == color;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColor = color;
                                      _isDropperMode = false;
                                    });
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        border: isSelected
                                            ? Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        )
                                            : null,
                                      ),
                                      child: isSelected
                                          ? Center(
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x4D000000),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ 하단: + 버튼 + 스포이드 SVG (HEX 삭제)
                  Row(
                    children: [
                      // + 버튼
                      GestureDetector(
                        onTap: () {
                          if (selectedColor != null) {
                            widget.onColorAdded(selectedColor!);
                            Navigator.of(context).pop(selectedColor);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: selectedColor ?? AppColors.gray03,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/system/icons/icon_add.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // ✅ HEX 삭제 → 스포이드 SVG로 대체
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDropperMode = !_isDropperMode;
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _isDropperMode
                                ? AppColors.gray02
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SvgPicture.asset(
                            'assets/system/icons/icon_dropper.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              _isDropperMode ? AppColors.f05 : AppColors.f03,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 새 헤더: 엑스 / "색상추가" / 체크
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          // ✕ 엑스: 취소 후 닫기
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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

          // 중앙 "색상추가" 텍스트
          Expanded(
            child: Center(
              child: Text(
                '색상추가',
                style: AppTextStyle.body16M120.copyWith(color: AppColors.f05),
              ),
            ),
          ),

          // ✓ 체크: 선택한 색상 저장 후 닫기
          GestureDetector(
            onTap: () {
              if (selectedColor != null) {
                widget.onColorAdded(selectedColor!);
                Navigator.of(context).pop(selectedColor);
              } else {
                Navigator.of(context).pop();
              }
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
}