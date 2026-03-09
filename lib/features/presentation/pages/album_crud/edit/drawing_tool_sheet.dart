import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/color_select_scale.dart';

/// 그리기 도구 패널 (토글 방식)
class DrawingToolPanel extends StatefulWidget {
  final Function(String lineStyle, double lineWidth, Color color) onSettingsChanged;
  final VoidCallback onClose;

  const DrawingToolPanel({
    Key? key,
    required this.onSettingsChanged,
    required this.onClose,
  }) : super(key: key);

  @override
  State<DrawingToolPanel> createState() => _DrawingToolPanelState();
}

class _DrawingToolPanelState extends State<DrawingToolPanel> {
  String selectedLineStyle = '실선';
  double lineWidth = 4;
  Color? selectedColor;
  bool _isDropdownOpen = false;

  final List<String> lineStyles = ['실선', '점선', '파선'];

  @override
  void initState() {
    super.initState();
    selectedColor = ColorSelectorSection.colors.isNotEmpty
        ? ColorSelectorSection.colors[0]
        : const Color(0xFFEDE3D6);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyChanges();
    });
  }

  void _notifyChanges() {
    widget.onSettingsChanged(selectedLineStyle, lineWidth, selectedColor!);
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
      // 전체 패널을 Stack으로 감싸서 드롭다운을 최상단 레이어에 띄움
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── 실제 콘텐츠 레이어 ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(),
                const SizedBox(height: 20),
                _buildSectionLabel('선 스타일'),
                const SizedBox(height: 20),
                // 헤더 버튼만 여기 배치 (고정 높이)
                _buildDropdownHeader(),
                const SizedBox(height: 20),
                _buildSectionLabel('선 두께'),
                const SizedBox(height: 20),
                _buildLineWidthSlider(),
                const SizedBox(height: 20),
                _buildSectionLabel('색상'),
                const SizedBox(height: 20),
                ColorSelectorSection(
                  selectedColor: selectedColor,
                  onChanged: (color) {
                    setState(() => selectedColor = color);
                    _notifyChanges();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // ── 드롭다운 오버레이 레이어 (최상단) ──
          if (_isDropdownOpen)
            Positioned(
              // 핸들(28) + SizedBox(20) + 라벨(약17) + SizedBox(20) + 헤더(40) + top padding(0) + gap(4)
              top: 28 + 20 + 17 + 20 + 40 + 4,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray02, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: lineStyles.map((style) {
                      final isSelected = selectedLineStyle == style;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLineStyle = style;
                            _isDropdownOpen = false;
                          });
                          _notifyChanges();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color:
                            isSelected ? AppColors.gray01 : Colors.white,
                            borderRadius: BorderRadius.circular(
                              style == lineStyles.first
                                  ? 12
                                  : style == lineStyles.last
                                  ? 12
                                  : 0,
                            ),
                          ),
                          child: _buildLinePreview(style),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 핸들 바
  Widget _buildHandle() {
    return GestureDetector(
      onTap: widget.onClose,
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          widget.onClose();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Center(
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
    );
  }

  // 섹션 라벨
  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: AppTextStyle.description14M120.copyWith(
        color: AppColors.f05,
      ),
    );
  }

  // 드롭다운 헤더 버튼만 (고정 높이 40px — 레이아웃에 영향 없음)
  Widget _buildDropdownHeader() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDropdownOpen = !_isDropdownOpen;
        });
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray02, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildLinePreview(selectedLineStyle),
            ),
            SvgPicture.asset(
              'assets/system/icons/icon_expand_more.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                AppColors.gray05,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 선 스타일 미리보기 위젯
  Widget _buildLinePreview(String style) {
    return SizedBox(
      height: 20,
      child: CustomPaint(
        painter: _LineStylePainter(
          style: style,
          color: AppColors.gray05,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  // 선 두께 슬라이더
  Widget _buildLineWidthSlider() {
    return Row(
      children: [
        GestureDetector(
          onTap: _decreaseLineWidth,
          child: SvgPicture.asset(
            'assets/system/icons/icon_minus.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColors.gray05,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${lineWidth.round()}',
                  style: AppTextStyle.body16R120.copyWith(
                    color: AppColors.f05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.gray03,
                    inactiveTrackColor: AppColors.gray02,
                    thumbColor: AppColors.gray04,
                    overlayColor: AppColors.gray03.withOpacity(0.2),
                    overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 16),
                    thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 12),
                    trackHeight: 4,
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Slider(
                    value: lineWidth,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    onChanged: (value) {
                      setState(() => lineWidth = value);
                      _notifyChanges();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _increaseLineWidth,
          child: SvgPicture.asset(
            'assets/system/icons/icon_add.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColors.gray05,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  void _decreaseLineWidth() {
    if (lineWidth > 1) {
      setState(() => lineWidth--);
      _notifyChanges();
    }
  }

  void _increaseLineWidth() {
    if (lineWidth < 20) {
      setState(() => lineWidth++);
      _notifyChanges();
    }
  }
}

// 선 스타일 미리보기 CustomPainter
class _LineStylePainter extends CustomPainter {
  final String style;
  final Color color;

  _LineStylePainter({required this.style, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double y = size.height / 2;
    final double startX = 0;
    final double endX = size.width;

    switch (style) {
      case '실선':
        canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
        break;

      case '점선':
        paint.strokeWidth = 2;
        const double dotSize = 3;
        const double gap = 6;
        double x = startX;
        while (x < endX) {
          canvas.drawCircle(
              Offset(x, y), dotSize / 2, paint..style = PaintingStyle.fill);
          x += dotSize + gap;
        }
        paint.style = PaintingStyle.stroke;
        break;

      case '파선':
        const double dashWidth = 12;
        const double dashGap = 6;
        double x = startX;
        while (x < endX) {
          canvas.drawLine(
            Offset(x, y),
            Offset((x + dashWidth).clamp(startX, endX), y),
            paint,
          );
          x += dashWidth + dashGap;
        }
        break;

      case '물결선':
        final path = Path();
        path.moveTo(startX, y);
        double x = startX;
        bool up = true;
        while (x < endX) {
          path.quadraticBezierTo(
            x + 5, up ? y - 5 : y + 5,
            x + 10, y,
          );
          x += 10;
          up = !up;
        }
        canvas.drawPath(path, paint);
        break;

      case '지그재그':
        final path = Path();
        path.moveTo(startX, y);
        double x = startX;
        bool upZ = true;
        while (x < endX) {
          path.lineTo(x + 8, upZ ? y - 5 : y + 5);
          x += 8;
          upZ = !upZ;
        }
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _LineStylePainter oldDelegate) =>
      oldDelegate.style != style || oldDelegate.color != color;
}