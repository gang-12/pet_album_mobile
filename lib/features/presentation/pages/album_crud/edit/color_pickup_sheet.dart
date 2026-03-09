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

  /// 바텀시트를 표시하는 헬퍼 메서드
  static Future<Color?> show(
      BuildContext context, {
        required Function(Color) onColorAdded,
      }) {
    return showModalBottomSheet<Color>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => ColorPickerBottomSheet(
        onColorAdded: onColorAdded,
      ),
    );
  }
}

class _ColorPickerBottomSheetState extends State<ColorPickerBottomSheet> {
  Color? selectedColor;
  bool _isDropperMode = false; // 스포이드 모드 여부
  final TextEditingController hexController = TextEditingController();

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
  }

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

  // HSL → Color 변환
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

  // HEX → Color 업데이트
  void _updateColorFromHex(String hexValue) {
    hexValue = hexValue.replaceAll('#', '').trim();
    if (hexValue.length == 6) {
      try {
        final Color color = Color(int.parse('FF$hexValue', radix: 16));
        setState(() {
          selectedColor = color;
        });
      } catch (_) {}
    }
  }

  // Color → HEX 변환
  String _colorToHex(Color color) {
    return '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  // + 버튼 색상: 선택된 색상이 있으면 해당 색상, 없으면 gray03
  Color get _addButtonColor => selectedColor ?? AppColors.gray03;

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
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
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
            // 핸들 바
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                width: 54,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray03,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 헤더: 색상추가 / 취소
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '색상추가',
                    style: AppTextStyle.body16M120.copyWith(
                      color: AppColors.f05,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '취소',
                        style: AppTextStyle.body16M120.copyWith(
                          color: AppColors.f03,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
                                      hexController.text = _colorToHex(color);
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
                                                color: Colors.black
                                                    .withOpacity(0.3),
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

                  // 하단 버튼 영역
                  Row(
                    children: [
                      // + 버튼: 선택한 색상으로 배경 바뀌고 누르면 추가
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
                            color: _addButtonColor,
                            shape: BoxShape.circle,
                          ),
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

                      const SizedBox(width: 12),

                      // 스포이드 버튼: 누르면 HEX 입력 필드로 포커스 + 스포이드 모드 활성화
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDropperMode = !_isDropperMode;
                          });
                          if (_isDropperMode && selectedColor != null) {
                            hexController.text = _colorToHex(selectedColor!);
                          }
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
                            'assets/system/icons/icon_ dropper.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              _isDropperMode ? AppColors.f05 : AppColors.f03,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // HEX 입력 필드
                      Container(
                        height: 33,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isDropperMode
                                ? AppColors.main
                                : AppColors.gray02,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'HEX:',
                              style: AppTextStyle.description14R120.copyWith(
                                color: AppColors.f04,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 70,
                              child: TextField(
                                controller: hexController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '263EDF',
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                                style: AppTextStyle.description14R120.copyWith(
                                  color: AppColors.f04,
                                ),
                                onChanged: (value) {
                                  _updateColorFromHex(value);
                                },
                              ),
                            ),
                          ],
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
}