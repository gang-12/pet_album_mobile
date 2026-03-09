import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_bar_main_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/album_icon_button_list_box.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/background_template_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/drawing_tool_sheet.dart';


class AlbumEditFormPage extends StatefulWidget {
  const AlbumEditFormPage({super.key});

  @override
  State<AlbumEditFormPage> createState() => _AlbumEditFormPageState();
}

class _AlbumEditFormPageState extends State<AlbumEditFormPage> {
  bool _isInitialState = true;
  bool _showBackgroundPanel = false;
  bool _showDrawingPanel = false;
  bool _showModalSheet = false;
  bool _isDrawingMode = false;
  int? _selectedTextIndex;
  final List<_CanvasText> _canvasTexts = [];

  EditorState _current = EditorState();
  List<EditorState> _history = [];
  List<EditorState> _redoStack = [];

  List<DrawingPoint?> drawingPoints = [];
  String currentLineStyle = '실선';
  double currentLineWidth = 4;
  Color currentColor = const Color(0xFFBDBDBD);

  void _applyState(EditorState newState) {
    setState(() {
      _history.add(_current);
      _redoStack.clear();
      _current = newState;
      _isInitialState = false;
    });
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() {
      _redoStack.add(_current);
      _current = _history.last;
      _history.removeLast();
      _isInitialState = _current.drawingPoints.isEmpty
          && _current.background.color == null
          && _current.background.image == null;
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _history.add(_current);
      _current = _redoStack.last;
      _redoStack.removeLast();
      _isInitialState = _current.drawingPoints.isEmpty
          && _current.background.color == null
          && _current.background.image == null;
    });
  }

  void _saveToHistory() {
    _history.add(_current);
    _redoStack.clear();
  }

  final TextEditingController _textInputController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  bool _isTextMode = false;

  void _onTextConfirmed() {
    if (_textInputController.text.isNotEmpty) {
      setState(() {
        _canvasTexts.add(_CanvasText(text: _textInputController.text));
        _selectedTextIndex = _canvasTexts.length - 1;
      });
    }
    _textInputController.clear();
    _textFocusNode.unfocus();
    setState(() => _isTextMode = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonMainAppBar(
        // 1. undo/redo: 맨 왼쪽에서 20px, 아이콘 간격 8px
        leadingPadding: const EdgeInsets.only(left: 20),
        leadingContent: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _undo,
              child: SvgPicture.asset(
                'assets/system/icons/icon_undo.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.f05,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _redo,
              child: SvgPicture.asset(
                'assets/system/icons/icon_redo.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.f05,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        // 2. 앨범 이름 정중앙, subtitle20M120, f05
        title: '새로운 앨범',
        actions: [
          // 3. 취소/완료 오른쪽에서 20px
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap:  () => Navigator.pop(context),
                child: Text(
                  '취소',
                  style: AppTextStyle.body16R120.copyWith(
                    color: AppColors.f03,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {},
                child: Text(
                  '완료',
                  style: AppTextStyle.body16R120.copyWith(
                    color: AppColors.f05,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_current.background.color != null || _current.background.image != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: _current.background.color,
                  image: _current.background.image != null
                      ? DecorationImage(
                    image: _current.background.image!,
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
              ),
            ),

          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTextIndex = null),
              behavior: HitTestBehavior.translucent,
              child: SafeArea(child: _first()),
            ),
          ),

          if (_isDrawingMode || _current.drawingPoints.isNotEmpty)
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  _applyState(_current.copyWith(
                    drawingPoints: [
                      ..._current.drawingPoints,
                      DrawingPoint(
                        offset: details.localPosition,
                        paint: Paint()
                          ..color = currentColor
                          ..strokeWidth = currentLineWidth
                          ..strokeCap = StrokeCap.round
                          ..strokeJoin = StrokeJoin.round,
                      ),
                    ],
                  ));
                },
                onPanUpdate: (details) {
                  setState(() {
                    _current = _current.copyWith(
                      drawingPoints: [
                        ..._current.drawingPoints,
                        DrawingPoint(
                          offset: details.localPosition,
                          paint: Paint()
                            ..color = currentColor
                            ..strokeWidth = currentLineWidth
                            ..strokeCap = StrokeCap.round
                            ..strokeJoin = StrokeJoin.round,
                        ),
                      ],
                    );
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _current = _current.copyWith(
                      drawingPoints: [..._current.drawingPoints, null],
                    );
                  });
                },
                child: CustomPaint(
                  painter: DrawingPainter(
                    drawingPoints: _current.drawingPoints,
                    lineStyle: currentLineStyle,
                  ),
                ),
              ),
            ),

          // 4. 배경 패널
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: 0, right: 0,
            bottom: _showBackgroundPanel ? 0 : -400,
            child: BackgroundTabletPanel(
              onClose: () => setState(() => _showBackgroundPanel = false),
              onSave: () {
                setState(() => _showBackgroundPanel = false);
              },
              onColorChanged: (color) {
                _applyState(_current.copyWith(
                  background: BackgroundState(color: color),
                ));
              },
            ),
          ),

          ..._canvasTexts.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _selectedTextIndex == index;
            const handleSize = 24.0;
            const padding = handleSize / 2;

            return Positioned(
              left: item.x - padding,
              top: item.y - padding,
              child: GestureDetector(
                onTap: () => setState(() {
                  if (_selectedTextIndex == index) {
                    _selectedTextIndex = null;
                  } else {
                    _selectedTextIndex = index;
                  }
                }),
                onPanUpdate: (details) {
                  setState(() {
                    item.x += details.delta.dx;
                    item.y += details.delta.dy;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: isSelected
                            ? BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        )
                            : BoxDecoration(
                          border: Border.all(color: Colors.transparent, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.text,
                          style: TextStyle(fontSize: item.fontSize, color: Colors.black),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          right: -padding,
                          bottom: -padding,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                item.fontSize = (item.fontSize + details.delta.dx * 0.3).clamp(8, 80);
                              });
                            },
                            child: Container(
                              width: handleSize,
                              height: handleSize,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      if (isSelected)
                        Positioned(
                          right: -padding,
                          top: -padding,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _canvasTexts.removeAt(index);
                                _selectedTextIndex = null;
                              });
                            },
                            child: Container(
                              width: handleSize,
                              height: handleSize,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          // 5. 드로잉 툴 패널
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: 0, right: 0,
            bottom: _showDrawingPanel ? 0 : -500,
            child: DrawingToolPanel(
              onSettingsChanged: (style, width, color) {
                setState(() {
                  currentLineStyle = style;
                  currentLineWidth = width;
                  currentColor = color;
                });
              },
              onClose: () => setState(() {
                _showDrawingPanel = false;
                _isDrawingMode = false;
              }),
            ),
          ),

          if (_isTextMode)
            Positioned(
              left: 40, right: 40, top: 200,
              child: TextField(
                controller: _textInputController,
                focusNode: _textFocusNode,
                autofocus: true,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: '텍스트 입력',
                  border: InputBorder.none,
                ),
              ),
            ),

          // 6. 하단 아이콘바
          if (!_showBackgroundPanel && !_showDrawingPanel && !_showModalSheet)
            Positioned(
              left: 0, right: 0, bottom: 24 + MediaQuery.of(context).padding.bottom,
              child: Center(
                child: EditorIconBar(
                  isTextMode: _isTextMode,
                  onBackgroundPressed: () {
                    setState(() {
                      _showBackgroundPanel = !_showBackgroundPanel;
                      if (_showBackgroundPanel) _showDrawingPanel = false;
                    });
                  },
                  onDrawPressed: () {
                    setState(() {
                      _showDrawingPanel = !_showDrawingPanel;
                      if (_showDrawingPanel) {
                        _showBackgroundPanel = false;
                        _isDrawingMode = true;
                      }
                    });
                  },
                  onSheetOpened: () => setState(() => _showModalSheet = true),
                  onSheetClosed: () => setState(() => _showModalSheet = false),
                  onTextPressed: () {
                    setState(() => _isTextMode = true);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _textFocusNode.requestFocus();
                    });
                  },
                  onTextClosed: () {
                    if (_textInputController.text.isNotEmpty) {
                      setState(() {
                        _canvasTexts.add(_CanvasText(text: _textInputController.text));
                        _selectedTextIndex = _canvasTexts.length - 1;
                      });
                    }
                    _textInputController.clear();
                    _textFocusNode.unfocus();
                    setState(() {
                      _isTextMode = false;
                    });
                  },
                ),
              ),
            ),


        ],
      ),
    );
  }

  Widget _first() {
    return SingleChildScrollView(
      child: Padding(
        // 4. 양쪽 20px
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = width * (457 / 350);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        dashPattern: const [6, 4],
                        strokeWidth: 1,
                        radius: const Radius.circular(16),
                        color: AppColors.gray03,
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: width,
                        height: height,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '표지 영역입니다.\n앨범의 표지를 꾸며주세요!',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.body16M140.copyWith(
                            color: AppColors.f02,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        '아래로 스크롤해서 앨범을 꾸며주세요.',
                        style: AppTextStyle.body16M120.copyWith(
                          color: AppColors.f02,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



class BackgroundState {
  final Color? color;
  final ImageProvider? image;

  BackgroundState({this.color, this.image});
}

class EditorState {
  final List<DrawingPoint?> drawingPoints;
  final BackgroundState background;
  // final List<StickerItem> stickers;
  // final List<TextItem> texts;

  EditorState({
    this.drawingPoints = const [],
    BackgroundState? background,
  }) : background = background ?? BackgroundState();

  EditorState copyWith({
    List<DrawingPoint?>? drawingPoints,
    BackgroundState? background,
  }) {
    return EditorState(
      drawingPoints: drawingPoints ?? this.drawingPoints,
      background: background ?? this.background,
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  final String lineStyle;

  DrawingPainter({
    required this.drawingPoints,
    this.lineStyle = '실선',
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        final point1 = drawingPoints[i]!;
        final point2 = drawingPoints[i + 1]!;

        if (lineStyle == '점선') {
          _drawDashedLine(canvas, point1.offset, point2.offset, point1.paint);
        } else {
          canvas.drawLine(point1.offset, point2.offset, point1.paint);
        }
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final distance = (p2 - p1).distance;
    if (distance == 0) return;

    final normalizedDirection = Offset(
      (p2.dx - p1.dx) / distance,
      (p2.dy - p1.dy) / distance,
    );

    double currentDistance = 0.0;
    while (currentDistance < distance) {
      final start = Offset(
        p1.dx + normalizedDirection.dx * currentDistance,
        p1.dy + normalizedDirection.dy * currentDistance,
      );
      currentDistance += dashWidth;

      final end = Offset(
        p1.dx + normalizedDirection.dx * currentDistance.clamp(0, distance),
        p1.dy + normalizedDirection.dy * currentDistance.clamp(0, distance),
      );

      canvas.drawLine(start, end, paint);
      currentDistance += dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CanvasText {
  final String text;
  double x;
  double y;
  double fontSize;
  _CanvasText({required this.text, this.x = 80, this.y = 200, this.fontSize = 16});
}