import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_bar_main_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/text_edit_button_list_box.dart';import 'package:dotted_border/dotted_border.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/background_template_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/drawing_tool_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/text_edit/text_style_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/sticker_search_bottom_sheet.dart';


class AlbumEditFormPage extends StatefulWidget {
  final Map<String, String>? album;

  const AlbumEditFormPage({super.key, this.album});

  @override
  State<AlbumEditFormPage> createState() => _AlbumEditFormPageState();
}

class _AlbumEditFormPageState extends State<AlbumEditFormPage> {
  bool _isInitialState = true;
  bool _showBackgroundPanel = false;
  bool _showDrawingPanel = false;
  bool _showModalSheet = false;
  bool _isDrawingMode = false;
  String currentTextFamily = 'Pretendard';
  Color currentTextColor = Colors.black;
  TextAlign currentTextAlign = TextAlign.left;
  bool currentTextUnderline = false;
  int? _selectedTextIndex;
  final List<_CanvasText> _canvasTexts = [];
  int? _selectedStickerIndex;
  final List<_CanvasSticker> _canvasStickers = [];

  EditorState _current = EditorState();
  List<EditorState> _history = [];
  List<EditorState> _redoStack = [];

  List<DrawingPoint?> drawingPoints = [];
  String currentLineStyle = '실선';
  double currentLineWidth = 4;
  Color currentColor = const Color(0xFFBDBDBD);
  Offset? _lastDotPoint;

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
        _canvasTexts.add(_CanvasText(
          text: _textInputController.text,
          fontFamily: currentTextFamily,
          color: currentTextColor,
          textAlign: currentTextAlign,
          isUnderline: currentTextUnderline,
        ));
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: SizedBox(
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 가운데: 앨범 이름
              Center(
                child: Text(
                  widget.album?['title'] ?? '새로운 앨범',
                  style: AppTextStyle.subtitle20M120.copyWith(
                    color: AppColors.f05,
                  ),
                ),
              ),

              // 왼쪽: undo / redo 아이콘
              Positioned(
                left: 20,
                child: Row(
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
              ),

              // 오른쪽: 취소 / 완료 (같은 너비로 묶기)
              Positioned(
                right: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SizedBox(
                        width: 40,
                        child: Text(
                          '취소',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.body16R120.copyWith(
                            color: AppColors.f03,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, {
                          'title': widget.album?['title'] ?? '새로운 앨범',
                          'edited': 'true',
                        });
                      },
                      child: SizedBox(
                        width: 40,
                        child: Text(
                          '완료',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.body16R120.copyWith(
                            color: AppColors.f05,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              onTap: () => setState(() {
                _selectedTextIndex = null;
                _selectedStickerIndex = null;
              }),
              behavior: HitTestBehavior.translucent,
              child: SafeArea(child: _first()),
            ),
          ),

          // 그린 획 표시 (항상)
          if (_current.drawingPoints.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: DrawingPainter(
                    drawingPoints: _current.drawingPoints,
                  ),
                ),
              ),
            ),

          // 그리기 터치 입력 (드로잉 모드일 때만)
          if (_isDrawingMode)
            Positioned.fill(
              child: GestureDetector(
                onPanStart: (details) {
                  _saveToHistory();
                  _lastDotPoint = details.localPosition;
                  setState(() {
                    _isInitialState = false;
                    _current = _current.copyWith(
                      drawingPoints: [
                        ..._current.drawingPoints,
                        DrawingPoint(
                          offset: details.localPosition,
                          lineStyle: currentLineStyle,
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
                onPanUpdate: (details) {
                  setState(() {
                    final pos = details.localPosition;
                    if (currentLineStyle == '실선') {
                      _current = _current.copyWith(
                        drawingPoints: [
                          ..._current.drawingPoints,
                          DrawingPoint(
                            offset: pos,
                            lineStyle: currentLineStyle,
                            paint: Paint()
                              ..color = currentColor
                              ..strokeWidth = currentLineWidth
                              ..strokeCap = StrokeCap.round
                              ..strokeJoin = StrokeJoin.round,
                          ),
                        ],
                      );
                    } else {
                      final gap = currentLineWidth * 4;
                      final dist = (pos - _lastDotPoint!).distance;
                      if (dist >= gap) {
                        _current = _current.copyWith(
                          drawingPoints: [
                            ..._current.drawingPoints,
                            DrawingPoint(
                              offset: pos,
                              lineStyle: currentLineStyle,
                              paint: Paint()
                                ..color = currentColor
                                ..strokeWidth = currentLineWidth
                                ..strokeCap = StrokeCap.round
                                ..strokeJoin = StrokeJoin.round,
                            ),
                          ],
                        );
                        _lastDotPoint = pos;
                      }
                    }
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    _current = _current.copyWith(
                      drawingPoints: [..._current.drawingPoints, null],
                    );
                    _lastDotPoint = null;
                  });
                },
                child: CustomPaint(
                  painter: DrawingPainter(
                    drawingPoints: _current.drawingPoints,
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
            const handleSize = 20.0;
            const padding = handleSize / 2;

            // 핸들 공통 그림자
            const handleShadow = [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
            ];

            return Positioned(
              left: item.x - padding,
              top: item.y - padding,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 텍스트 컨테이너 + 드래그/선택 GestureDetector
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
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
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: isSelected
                            ? BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        )
                            : BoxDecoration(
                          border: Border.all(color: Colors.transparent, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.text,
                          textAlign: item.textAlign,
                          style: TextStyle(
                            fontSize: item.fontSize,
                            color: item.color,
                            fontFamily: item.fontFamily,
                            decoration: item.isUnderline
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            decorationColor: item.color,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 좌측 상단: X (삭제) — 부모 GestureDetector와 완전 분리
                  if (isSelected)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _canvasTexts.removeAt(index);
                            _selectedTextIndex = null;
                          });
                        },
                        child: Container(
                          width: handleSize,
                          height: handleSize,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: handleShadow,
                          ),
                          child: SvgPicture.asset(
                            'assets/system/icons/icon_close.svg',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              AppColors.f05,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 우측 하단: 크기 조절 — 부모 GestureDetector와 완전 분리
                  if (isSelected)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: (details) {
                          setState(() {
                            item.fontSize = (item.fontSize + details.delta.dx * 0.3).clamp(8, 80);
                          });
                        },
                        child: Container(
                          width: handleSize,
                          height: handleSize,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: handleShadow,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/system/icons/icon_zoom_inout.svg',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                AppColors.f05,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),

          // 스티커 렌더링
          ..._canvasStickers.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _selectedStickerIndex == index;
            const handleSize = 20.0;
            const padding = handleSize / 2;
            const handleShadow = [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 0),
              ),
            ];

            return Positioned(
              left: item.x - padding,
              top: item.y - padding,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() {
                        _selectedStickerIndex = isSelected ? null : index;
                        _selectedTextIndex = null;
                      }),
                      onPanUpdate: (details) {
                        setState(() {
                          item.x += details.delta.dx;
                          item.y += details.delta.dy;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: isSelected
                            ? BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        )
                            : BoxDecoration(
                          border: Border.all(color: Colors.transparent, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: item.svgPath != null
                            ? SvgPicture.asset(
                          item.svgPath!,
                          width: item.size,
                          height: item.size,
                        )
                            : Text(
                          item.emoji,
                          style: TextStyle(fontSize: item.size * 0.7),
                        ),
                      ),
                    ),
                  ),

                  // 좌측 상단: X 삭제
                  if (isSelected)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _canvasStickers.removeAt(index);
                            _selectedStickerIndex = null;
                          });
                        },
                        child: Container(
                          width: handleSize,
                          height: handleSize,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: handleShadow,
                          ),
                          child: SvgPicture.asset(
                            'assets/system/icons/icon_close.svg',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              AppColors.f05,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 우측 하단: 리사이즈 핸들
                  if (isSelected)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: (details) {
                          setState(() {
                            item.size = (item.size + details.delta.dx).clamp(24.0, 200.0);
                          });
                        },
                        child: Container(
                          width: handleSize,
                          height: handleSize,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: handleShadow,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/system/icons/icon_zoom_inout.svg',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                              colorFilter: ColorFilter.mode(
                                AppColors.f05,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
                style: TextStyle(
                  fontFamily: currentTextFamily,
                  fontSize: 20,
                  color: currentTextColor,
                  decoration: currentTextUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
                textAlign: currentTextAlign,
                decoration: const InputDecoration(
                  hintText: '텍스트 입력',
                  border: InputBorder.none,
                ),
              ),
            ),

          // 6. 하단 아이콘바
          if (!_showBackgroundPanel && !_showDrawingPanel && !_showModalSheet)
            Positioned(
              left: 0, right: 0,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
              child: Center(
                child: EditorIconBar(
                  isTextMode: _isTextMode,
                  selectedFontFamily: _selectedTextIndex != null && _selectedTextIndex! < _canvasTexts.length
                      ? _canvasTexts[_selectedTextIndex!].fontFamily
                      : currentTextFamily,
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
                  onSheetOpened: () async {
                    setState(() => _showModalSheet = true);
                    final sticker = await StickerBottomSheet.show(context);
                    if (!mounted) return null;
                    setState(() => _showModalSheet = false);
                    if (sticker != null) {
                      setState(() {
                        _canvasStickers.add(_CanvasSticker(
                          svgPath: sticker.svgPath,
                          emoji: sticker.emoji,
                        ));
                        _selectedStickerIndex = _canvasStickers.length - 1;
                      });
                    }
                    return sticker;
                  },
                  onSheetClosed: () => setState(() => _showModalSheet = false),
                  onTextPressed: () {
                    setState(() => _isTextMode = true);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _textFocusNode.requestFocus();
                    });
                  },
                  onTextStylePressed: () {
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
                          selectedFontFamily: currentTextFamily,
                          selectedTextAlign: currentTextAlign,
                          onTextFamilyChanged: (family) {
                            setState(() {
                              currentTextFamily = family;
                              if (_selectedTextIndex != null &&
                                  _selectedTextIndex! < _canvasTexts.length) {
                                _canvasTexts[_selectedTextIndex!].fontFamily = family;
                              }
                            });
                          },
                          onTextAlignChanged: (align) {
                            setState(() {
                              currentTextAlign = align;
                              if (_selectedTextIndex != null &&
                                  _selectedTextIndex! < _canvasTexts.length) {
                                _canvasTexts[_selectedTextIndex!].textAlign = align;
                              }
                            });
                          },
                          onClose: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  onTextClosed: () {
                    if (_textInputController.text.isNotEmpty) {
                      setState(() {
                        _canvasTexts.add(_CanvasText(
                          text: _textInputController.text,
                          fontFamily: currentTextFamily,
                          color: currentTextColor,
                          textAlign: currentTextAlign,
                          isUnderline: currentTextUnderline,
                        ));
                        _selectedTextIndex = _canvasTexts.length - 1;
                      });
                    }
                    _textInputController.clear();
                    _textFocusNode.unfocus();
                    setState(() {
                      _isTextMode = false;
                    });
                  },
                  onFontFamilyChanged: (family) {
                    setState(() {
                      currentTextFamily = family;
                      if (_selectedTextIndex != null &&
                          _selectedTextIndex! < _canvasTexts.length) {
                        _canvasTexts[_selectedTextIndex!].fontFamily = family;
                      }
                    });
                  },
                  onTextColorChanged: (color) {
                    setState(() {
                      currentTextColor = color;
                      if (_selectedTextIndex != null &&
                          _selectedTextIndex! < _canvasTexts.length) {
                        _canvasTexts[_selectedTextIndex!].color = color;
                      }
                    });
                  },
                  onTextAlignChanged: (align) {
                    setState(() {
                      currentTextAlign = align;
                      if (_selectedTextIndex != null &&
                          _selectedTextIndex! < _canvasTexts.length) {
                        _canvasTexts[_selectedTextIndex!].textAlign = align;
                      }
                    });
                  },
                  onUnderlineChanged: (val) {
                    setState(() {
                      currentTextUnderline = val;
                      if (_selectedTextIndex != null &&
                          _selectedTextIndex! < _canvasTexts.length) {
                        _canvasTexts[_selectedTextIndex!].isUnderline = val;
                      }
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
  final String lineStyle;

  DrawingPoint({
    required this.offset,
    required this.paint,
    this.lineStyle = '실선',
  });
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        final point1 = drawingPoints[i]!;
        final point2 = drawingPoints[i + 1]!;
        final style = point1.lineStyle; // 각 획의 스타일 사용

        if (style == '점선') {
          _drawDottedLine(canvas, point1.offset, point2.offset, point1.paint);
        } else if (style == '파선') {
          _drawDashedLine(canvas, point1.offset, point2.offset, point1.paint);
        } else {
          canvas.drawLine(point1.offset, point2.offset, point1.paint);
        }
      }
    }
  }

  // 파선 (두께 반영)
  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final strokeW = paint.strokeWidth;
    final dashWidth = strokeW * 4;
    final dashSpace = strokeW * 2;

    final distance = (p2 - p1).distance;
    if (distance == 0) return;

    final dir = Offset((p2.dx - p1.dx) / distance, (p2.dy - p1.dy) / distance);
    double d = 0.0;
    while (d < distance) {
      final start = Offset(p1.dx + dir.dx * d, p1.dy + dir.dy * d);
      d += dashWidth;
      final end = Offset(
        p1.dx + dir.dx * d.clamp(0, distance),
        p1.dy + dir.dy * d.clamp(0, distance),
      );
      canvas.drawLine(start, end, paint);
      d += dashSpace;
    }
  }

  // 점선 (두께 반영: dotRadius = strokeWidth / 2)
  void _drawDottedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final dotRadius = paint.strokeWidth / 2;
    final dotGap = paint.strokeWidth * 2;

    final distance = (p2 - p1).distance;
    if (distance == 0) return;

    final dir = Offset((p2.dx - p1.dx) / distance, (p2.dy - p1.dy) / distance);
    final dotPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;

    double d = 0.0;
    while (d < distance) {
      final point = Offset(p1.dx + dir.dx * d, p1.dy + dir.dy * d);
      canvas.drawCircle(point, dotRadius, dotPaint);
      d += dotRadius * 2 + dotGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CanvasSticker {
  final String? svgPath;
  final String emoji;
  double x;
  double y;
  double size;

  _CanvasSticker({
    this.svgPath,
    this.emoji = '',
    this.x = 100,
    this.y = 200,
    this.size = 80,
  });
}

class _CanvasText {
  final String text;
  double x;
  double y;
  double fontSize;
  String fontFamily;
  Color color;
  TextAlign textAlign;
  bool isUnderline;

  _CanvasText({
    required this.text,
    this.x = 80,
    this.y = 200,
    this.fontSize = 20,
    this.fontFamily = 'Pretendard',
    this.color = Colors.black,
    this.textAlign = TextAlign.left,
    this.isUnderline = false,
  });
}