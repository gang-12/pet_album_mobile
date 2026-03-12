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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(),
                // 헤더 버튼만 여기 배치 (고정 높이)
                const SizedBox(height: 20),
                _buildLineWidthSlider(),
                const SizedBox(height: 20),
                _buildLineStyleTabs(),
                const SizedBox(height: 20),                const SizedBox(height: 20),
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

        ],
      ),
    );
  }

  // 핸들 바
  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        children: [
          // ✕ 엑스: 변경 취소 + 시트 닫기
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
                '그리기',
                style: AppTextStyle.description14R120,
              ),
            ),
          ),

          // ✓ 체크: 저장 + 시트 닫기
          GestureDetector(
            onTap: widget.onClose,
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

  // 선 두께 슬라이더
  Widget _buildLineWidthSlider() {
    return Row(
      children: [
        Text(
          '선 두께',
          style:
          AppTextStyle.description14M120.copyWith(color: AppColors.f05),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.gray03,
              inactiveTrackColor: AppColors.gray02,
              thumbColor: AppColors.gray04,
              overlayColor: const Color(0x33BDBDBD),
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
    );
  }
  Widget _buildLineStyleTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: lineStyles.map((style) {
          final isSelected = selectedLineStyle == style;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLineStyle = style;
              });
              _notifyChanges();
            },
            child: Container(
              width: 64,
              height: 40,
              margin: const EdgeInsets.only(right: 8),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),

                border: Border.all(
                  color: isSelected
                      ? AppColors.main
                      : AppColors.gray02,
                  width: isSelected ? 2 : 1,
                ),
              ),

              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 20,

                  child: CustomPaint(
                    painter: _LineStylePainter(
                      style: style,
                      color: AppColors.gray05,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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

    // ================= 실선 =================
      case '실선':
        paint
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(startX, y),
          Offset(endX, y),
          paint,
        );
        break;


    // ================= 점선 =================
      case '점선':
        paint
          ..strokeWidth = 2
          ..style = PaintingStyle.fill;

        const double dotSize = 4;
        const double gap = 10;

        double x = startX;

        while (x < endX) {
          canvas.drawCircle(
            Offset(x, y),
            dotSize / 2,
            paint,
          );

          x += dotSize + gap;
        }

        paint.style = PaintingStyle.stroke;
        break;


    // ================= 파선 =================
      case '파선':
        paint
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        const double dashWidth = 18;
        const double dashGap = 8;

        double x = startX;

        while (x < endX) {
          canvas.drawLine(
            Offset(x, y),
            Offset(
              (x + dashWidth).clamp(startX, endX),
              y,
            ),
            paint,
          );

          x += dashWidth + dashGap;
        }
        break;


    // ================= 물결선 =================
      case '물결선':
        paint
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        final path = Path();

        path.moveTo(startX, y);

        double x = startX;
        bool up = true;

        const double waveWidth = 16;
        const double waveHeight = 6;

        while (x < endX) {
          path.quadraticBezierTo(
            x + waveWidth / 2,
            up ? y - waveHeight : y + waveHeight,
            x + waveWidth,
            y,
          );

          x += waveWidth;
          up = !up;
        }

        canvas.drawPath(path, paint);
        break;


    // ================= 지그재그 =================
      case '지그재그':
        paint
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        final path = Path();

        path.moveTo(startX, y);

        double x = startX;
        bool upZ = true;

        const double zigWidth = 12;
        const double zigHeight = 6;

        while (x < endX) {
          path.lineTo(
            x + zigWidth,
            upZ ? y - zigHeight : y + zigHeight,
          );

          x += zigWidth;
          upZ = !upZ;
        }

        canvas.drawPath(path, paint);
        break;
    }  }

  @override
  bool shouldRepaint(covariant _LineStylePainter oldDelegate) =>
      oldDelegate.style != style || oldDelegate.color != color;
}