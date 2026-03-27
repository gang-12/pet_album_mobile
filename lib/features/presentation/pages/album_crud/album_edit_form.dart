import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_bar_main_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/text_edit_button_list_box.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/background_template_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/drawing_tool_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/text_edit/text_style_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/edit/sticker_search_bottom_sheet.dart';

// AppTextField 위젯이 다른 경로에 있다면 여기에 import 해주세요.
// import 'AppTextField_경로';

class AlbumEditFormPage extends StatefulWidget {
  final Map<String, String>? album;

  const AlbumEditFormPage({super.key, this.album});

  @override
  State<AlbumEditFormPage> createState() => _AlbumEditFormPageState();
}

class _AlbumEditFormPageState extends State<AlbumEditFormPage> {
  // 앨범 제목 상태 변수
  late String _albumTitle;

  bool _isInitialState = true;
  bool _showBackgroundPanel = false;
  bool _showDrawingPanel = false;
  bool _showModalSheet = false;
  bool _isDrawingMode = false;

  String currentTextFamily = 'Pretendard';
  Color currentTextColor = Colors.black;
  TextAlign currentTextAlign = TextAlign.left;
  bool currentTextUnderline = false;

  String? _selectedItemId;
  final Map<String, GlobalKey> _itemKeys = {};

  double _textInputX = 40;
  double _textInputY = 200;

  EditorState _current = EditorState();
  List<EditorState> _history = [];
  List<EditorState> _redoStack = [];

  List<DrawingPoint?> drawingPoints = [];
  String currentLineStyle = '실선';
  double currentLineWidth = 4;
  Color currentColor = const Color(0xFFBDBDBD);
  Offset? _lastDotPoint;

  // 회전 및 스케일 제어를 위한 상태 변수
  Offset _actionCenter = Offset.zero;
  double _startAngle = 0.0;
  double _initialItemAngle = 0.0;
  double _initialScale = 0.0;
  double _startDistance = 0.0;

  final TextEditingController _textInputController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  bool _isTextMode = false;

  @override
  void initState() {
    super.initState();
    // 초기 앨범 제목 설정
    _albumTitle = widget.album?['title'] ?? '새로운 앨범';
  }

  // 앨범 제목 수정 바텀시트 호출 함수
  void _showTitleEditBottomSheet() async {
    final newTitle = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, // 키보드 올라올 때 바텀시트 스크롤 허용
      backgroundColor: Colors.transparent,
      builder: (context) => AlbumTitleEditBottomSheet(
        initialTitle: _albumTitle,
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty) {
      setState(() {
        _albumTitle = newTitle.trim();
      });
    }
  }

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
      _isInitialState = _current.drawingPoints.isEmpty &&
          _current.background.color == null &&
          _current.background.image == null &&
          _current.items.isEmpty;
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _history.add(_current);
      _current = _redoStack.last;
      _redoStack.removeLast();
      _isInitialState = _current.drawingPoints.isEmpty &&
          _current.background.color == null &&
          _current.background.image == null &&
          _current.items.isEmpty;
    });
  }

  void _saveToHistory() {
    _history.add(_current);
    _redoStack.clear();
  }

  void _onItemTapped(String id) {
    setState(() {
      if (_selectedItemId == id) {
        _selectedItemId = null;
      } else {
        _selectedItemId = id;
        // 선택된 아이템을 리스트 맨 뒤로 보내어 최상단(가장 위 레이어)에 렌더링되게 함
        final items = List<CanvasItem>.from(_current.items);
        final index = items.indexWhere((item) => item.id == id);
        if (index != -1 && index != items.length - 1) {
          final selectedItem = items.removeAt(index);
          items.add(selectedItem);
          _saveToHistory();
          _current = _current.copyWith(items: items);
        }
      }
    });
  }

  void _updateSelectedText({
    String? fontFamily,
    Color? color,
    TextAlign? textAlign,
    bool? isUnderline,
  }) {
    if (_selectedItemId == null) return;
    final items = List<CanvasItem>.from(_current.items);
    final index = items.indexWhere((i) => i.id == _selectedItemId);
    if (index == -1) return;

    final item = items[index];
    if (item is CanvasTextItem) {
      items[index] = item.copyWith(
        fontFamily: fontFamily,
        color: color,
        textAlign: textAlign,
        isUnderline: isUnderline,
      );
      _applyState(_current.copyWith(items: items));
    }
  }

  void _onTextConfirmed() {
    if (_textInputController.text.isNotEmpty) {
      final newItem = CanvasTextItem(
        id: 'text_${DateTime.now().millisecondsSinceEpoch}',
        text: _textInputController.text,
        x: _textInputX,
        y: _textInputY,
        fontFamily: currentTextFamily,
        color: currentTextColor,
        textAlign: currentTextAlign,
        isUnderline: currentTextUnderline,
      );
      final newItems = [..._current.items, newItem];
      _applyState(_current.copyWith(items: newItems));
      setState(() => _selectedItemId = newItem.id);
    }
    _textInputController.clear();
    _textFocusNode.unfocus();
    setState(() {
      _isTextMode = false;
      _textInputX = 40;
      _textInputY = 200;
    });
  }

  @override
  Widget build(BuildContext context) {
    CanvasTextItem? selectedTextItem;
    if (_selectedItemId != null) {
      final idx = _current.items.indexWhere((i) => i.id == _selectedItemId);
      if (idx != -1 && _current.items[idx] is CanvasTextItem) {
        selectedTextItem = _current.items[idx] as CanvasTextItem;
      }
    }

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
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _showTitleEditBottomSheet, // 타이틀 터치 시 바텀시트 호출
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      _albumTitle, // 상태 변수 사용
                      style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _undo,
                      child: SvgPicture.asset(
                        'assets/system/icons/icon_undo.svg',
                        width: 24, height: 24,
                        colorFilter: const ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _redo,
                      child: SvgPicture.asset(
                        'assets/system/icons/icon_redo.svg',
                        width: 24, height: 24,
                        colorFilter: const ColorFilter.mode(AppColors.f05, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),
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
                          style: AppTextStyle.body16R120.copyWith(color: AppColors.f03),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, {
                          'title': _albumTitle, // 수정된 타이틀 반환
                          'edited': 'true',
                        });
                      },
                      child: SizedBox(
                        width: 40,
                        child: Text(
                          '완료',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.body16R120.copyWith(color: AppColors.f05),
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
          // 1. 캔버스 배경 (가장 아래 레이어)
          if (_current.background.color != null || _current.background.image != null || _current.background.svgPath != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: _current.background.color,
                  image: _current.background.image != null
                      ? DecorationImage(image: _current.background.image!, fit: BoxFit.cover)
                      : null,
                ),
                // 추가된 부분: svgPath가 있으면 SvgPicture로 그려줌
                child: _current.background.svgPath != null
                    ? SvgPicture.asset(
                  _current.background.svgPath!,
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),

          // 2. 스크롤 캔버스
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _selectedItemId = null),
              behavior: HitTestBehavior.translucent,
              child: SafeArea(child: _first()),
            ),
          ),

          // 3. 드로잉 획 표시
          if (_current.drawingPoints.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: DrawingPainter(drawingPoints: _current.drawingPoints),
                ),
              ),
            ),

          // 4. 드로잉 터치 입력
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
                  painter: DrawingPainter(drawingPoints: _current.drawingPoints),
                ),
              ),
            ),

          // 5. 텍스트/스티커 통합 아이템 렌더링
          ..._current.items.map((item) {
            final isSelected = _selectedItemId == item.id;
            final key = _itemKeys.putIfAbsent(item.id, () => GlobalKey());
            const handleSize = 24.0;
            const padding = handleSize / 2;
            const handleShadow = [
              BoxShadow(color: Color(0x1F000000), blurRadius: 3, spreadRadius: 0, offset: Offset(0, 0)),
            ];

            Widget content;
            if (item is CanvasTextItem) {
              content = Container(
                key: key,
                padding: const EdgeInsets.all(4),
                decoration: isSelected
                    ? BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 3)],
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
                    decoration: item.isUnderline ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: item.color,
                  ),
                ),
              );
            } else if (item is CanvasStickerItem) {
              content = Container(
                key: key,
                padding: const EdgeInsets.all(4),
                decoration: isSelected
                    ? BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 3)],
                )
                    : BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 2.0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: item.svgPath != null
                    ? SvgPicture.asset(item.svgPath!, width: item.size, height: item.size)
                    : Text(item.emoji, style: TextStyle(fontSize: item.size * 0.7)),
              );
            } else {
              content = const SizedBox();
            }

            return Positioned(
              left: item.x - padding,
              top: item.y - padding,
              child: Transform.rotate(
                angle: item.angle,
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _onItemTapped(item.id),
                        onPanStart: (_) => _saveToHistory(),
                        onPanUpdate: (details) {
                          final itemsList = List<CanvasItem>.from(_current.items);
                          final idx = itemsList.indexWhere((i) => i.id == item.id);
                          if (idx != -1) {
                            itemsList[idx] = itemsList[idx].copyWith(
                              x: itemsList[idx].x + details.delta.dx,
                              y: itemsList[idx].y + details.delta.dy,
                            );
                            setState(() => _current = _current.copyWith(items: itemsList));
                          }
                        },
                        child: content,
                      ),
                    ),

                    // 좌측 상단: X (삭제)
                    if (isSelected)
                      Positioned(
                        left: 0, top: 0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            final itemsList = List<CanvasItem>.from(_current.items)..removeWhere((i) => i.id == item.id);
                            _applyState(_current.copyWith(items: itemsList));
                            setState(() => _selectedItemId = null);
                          },
                          child: Container(
                            width: handleSize, height: handleSize,
                            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle, boxShadow: handleShadow),
                            child: SvgPicture.asset('assets/system/icons/icon_close.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.f05, BlendMode.srcIn)),
                          ),
                        ),
                      ),

                    // 우측 상단: 회전 (atan2 활용)
                    if (isSelected)
                      Positioned(
                        right: 0, top: 0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (details) {
                            _saveToHistory();
                            final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
                            _actionCenter = box.localToGlobal(box.size.center(Offset.zero));
                            _initialItemAngle = item.angle;
                            _startAngle = math.atan2(
                              details.globalPosition.dy - _actionCenter.dy,
                              details.globalPosition.dx - _actionCenter.dx,
                            );
                          },
                          onPanUpdate: (details) {
                            final double currentAngle = math.atan2(
                              details.globalPosition.dy - _actionCenter.dy,
                              details.globalPosition.dx - _actionCenter.dx,
                            );
                            final itemsList = List<CanvasItem>.from(_current.items);
                            final idx = itemsList.indexWhere((i) => i.id == item.id);
                            if (idx != -1) {
                              itemsList[idx] = itemsList[idx].copyWith(
                                angle: _initialItemAngle + (currentAngle - _startAngle),
                              );
                              setState(() => _current = _current.copyWith(items: itemsList));
                            }
                          },
                          child: Container(
                            width: handleSize, height: handleSize,
                            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle, boxShadow: handleShadow),
                            child: Center(
                              child: SvgPicture.asset('assets/system/icons/icon_autorenew.svg', width: 16, height: 16, colorFilter: const ColorFilter.mode(AppColors.f05, BlendMode.srcIn)),
                            ),
                          ),
                        ),
                      ),

                    // 우측 하단: 크기 조절 (중심점으로부터의 거리 기반 스케일)
                    if (isSelected)
                      Positioned(
                        right: 0, bottom: 0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (details) {
                            _saveToHistory();
                            final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
                            _actionCenter = box.localToGlobal(box.size.center(Offset.zero));
                            if (item is CanvasTextItem) {
                              _initialScale = item.fontSize;
                            } else if (item is CanvasStickerItem) {
                              _initialScale = item.size;
                            }
                            _startDistance = (details.globalPosition - _actionCenter).distance;
                          },
                          onPanUpdate: (details) {
                            final currentDistance = (details.globalPosition - _actionCenter).distance;
                            final scaleFactor = currentDistance / _startDistance;
                            final itemsList = List<CanvasItem>.from(_current.items);
                            final idx = itemsList.indexWhere((i) => i.id == item.id);
                            if (idx != -1) {
                              if (item is CanvasTextItem) {
                                itemsList[idx] = (itemsList[idx] as CanvasTextItem).copyWith(
                                  fontSize: (_initialScale * scaleFactor).clamp(8.0, 200.0),
                                );
                              } else if (item is CanvasStickerItem) {
                                itemsList[idx] = (itemsList[idx] as CanvasStickerItem).copyWith(
                                  size: (_initialScale * scaleFactor).clamp(24.0, 400.0),
                                );
                              }
                              setState(() => _current = _current.copyWith(items: itemsList));
                            }
                          },
                          child: Container(
                            width: handleSize, height: handleSize,
                            decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle, boxShadow: handleShadow),
                            child: Center(
                              child: SvgPicture.asset('assets/system/icons/icon_zoom_inout.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(AppColors.f05, BlendMode.srcIn)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),

          // 6. 텍스트 입력창
          if (_isTextMode)
            Positioned(
              left: _textInputX,
              top: _textInputY,
              right: 40,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _textInputX += details.delta.dx;
                    _textInputY += details.delta.dy;
                  });
                },
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
                    decoration: currentTextUnderline ? TextDecoration.underline : TextDecoration.none,
                  ),
                  textAlign: currentTextAlign,
                  decoration: const InputDecoration(
                    hintText: '텍스트 입력',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

          // 7. UI 시트 패널들 (항상 캔버스 아이템들보다 위에 오도록 가장 하단에 배치)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: 0, right: 0,
            bottom: _showBackgroundPanel ? 0 : -400,
            child: BackgroundTabletPanel(
              // 패널을 열 때 현재 적용된 상태를 넘겨줌 (탭 위치 동기화)
              selectedColor: _current.background.color,
              selectedSvgPath: _current.background.svgPath,
              onClose: () => setState(() => _showBackgroundPanel = false),
              onSave: () => setState(() => _showBackgroundPanel = false),
              onColorChanged: (color) {
                _applyState(_current.copyWith(
                  // 색상 변경 시 기존의 svg 상태는 덮어씌워 무지로 만듦
                  background: BackgroundState(color: color, svgPath: null),
                ));
              },
              // 추가된 부분: 개별 SVG 탭 클릭 시 상태 업데이트
              onSvgBackgroundChanged: (svgPath) {
                _applyState(_current.copyWith(
                  background: BackgroundState(
                    color: svgPath == null ? _current.background.color : Colors.white, // SVG일 경우 기본 흰색 배경
                    svgPath: svgPath,
                  ),
                ));
              },
            ),
          ),

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

          if (!_showBackgroundPanel && !_showDrawingPanel && !_showModalSheet)
            Positioned(
              left: 0, right: 0,
              bottom: 24 + MediaQuery.of(context).padding.bottom,
              child: Center(
                child: EditorIconBar(
                  isTextMode: _isTextMode,
                  selectedFontFamily: selectedTextItem?.fontFamily ?? currentTextFamily,
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
                      final newItem = CanvasStickerItem(
                        id: 'sticker_${DateTime.now().millisecondsSinceEpoch}',
                        svgPath: sticker.svgPath,
                        emoji: sticker.emoji,
                      );
                      final newItems = [..._current.items, newItem];
                      _applyState(_current.copyWith(items: newItems));
                      setState(() => _selectedItemId = newItem.id);
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
                            setState(() => currentTextFamily = family);
                            _updateSelectedText(fontFamily: family);
                          },
                          onTextAlignChanged: (align) {
                            setState(() => currentTextAlign = align);
                            _updateSelectedText(textAlign: align);
                          },
                          onClose: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  onTextClosed: _onTextConfirmed,
                  onFontFamilyChanged: (family) {
                    setState(() => currentTextFamily = family);
                    _updateSelectedText(fontFamily: family);
                  },
                  onTextColorChanged: (color) {
                    setState(() => currentTextColor = color);
                    _updateSelectedText(color: color);
                  },
                  onTextAlignChanged: (align) {
                    setState(() => currentTextAlign = align);
                    _updateSelectedText(textAlign: align);
                  },
                  onUnderlineChanged: (val) {
                    setState(() => currentTextUnderline = val);
                    _updateSelectedText(isUnderline: val);
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
                          style: AppTextStyle.body16M140.copyWith(color: AppColors.f02),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        '아래로 스크롤해서 앨범을 꾸며주세요.',
                        style: AppTextStyle.body16M120.copyWith(color: AppColors.f02),
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

// ================== Models ==================

class BackgroundState {
  final Color? color;
  final ImageProvider? image;
  final String? svgPath; // 추가된 부분

  BackgroundState({this.color, this.image, this.svgPath});
}

class EditorState {
  final List<DrawingPoint?> drawingPoints;
  final BackgroundState background;
  final List<CanvasItem> items; // 통합된 아이템 리스트

  EditorState({
    this.drawingPoints = const [],
    BackgroundState? background,
    this.items = const [],
  }) : background = background ?? BackgroundState();

  EditorState copyWith({
    List<DrawingPoint?>? drawingPoints,
    BackgroundState? background,
    List<CanvasItem>? items,
  }) {
    return EditorState(
      drawingPoints: drawingPoints ?? this.drawingPoints,
      background: background ?? this.background,
      items: items ?? this.items,
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
        final style = point1.lineStyle;

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

// --- 공통 캔버스 아이템 (텍스트, 스티커 통합용) ---
abstract class CanvasItem {
  final String id;
  final double x;
  final double y;
  final double angle;

  CanvasItem({
    required this.id,
    required this.x,
    required this.y,
    this.angle = 0.0,
  });

  CanvasItem copyWith({double? x, double? y, double? angle});
}

class CanvasTextItem extends CanvasItem {
  final String text;
  final double fontSize;
  final String fontFamily;
  final Color color;
  final TextAlign textAlign;
  final bool isUnderline;

  CanvasTextItem({
    required super.id,
    super.x = 80,
    super.y = 200,
    super.angle = 0.0,
    required this.text,
    this.fontSize = 20,
    this.fontFamily = 'Pretendard',
    this.color = Colors.black,
    this.textAlign = TextAlign.left,
    this.isUnderline = false,
  });

  @override
  CanvasTextItem copyWith({
    double? x,
    double? y,
    double? angle,
    String? text,
    double? fontSize,
    String? fontFamily,
    Color? color,
    TextAlign? textAlign,
    bool? isUnderline,
  }) {
    return CanvasTextItem(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      angle: angle ?? this.angle,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      color: color ?? this.color,
      textAlign: textAlign ?? this.textAlign,
      isUnderline: isUnderline ?? this.isUnderline,
    );
  }
}

class CanvasStickerItem extends CanvasItem {
  final String? svgPath;
  final String emoji;
  final double size;

  CanvasStickerItem({
    required super.id,
    super.x = 100,
    super.y = 200,
    super.angle = 0.0,
    this.svgPath,
    this.emoji = '',
    this.size = 80,
  });

  @override
  CanvasStickerItem copyWith({
    double? x,
    double? y,
    double? angle,
    String? svgPath,
    String? emoji,
    double? size,
  }) {
    return CanvasStickerItem(
      id: id,
      x: x ?? this.x,
      y: y ?? this.y,
      angle: angle ?? this.angle,
      svgPath: svgPath ?? this.svgPath,
      emoji: emoji ?? this.emoji,
      size: size ?? this.size,
    );
  }
}

// ================== Bottom Sheet Widget ==================

class AlbumTitleEditBottomSheet extends StatefulWidget {
  final String initialTitle;

  const AlbumTitleEditBottomSheet({super.key, required this.initialTitle});

  @override
  State<AlbumTitleEditBottomSheet> createState() => _AlbumTitleEditBottomSheetState();
}

class _AlbumTitleEditBottomSheetState extends State<AlbumTitleEditBottomSheet> {
  late TextEditingController _titleController;
  late FocusNode _focusNode;

  bool get _hasText => _titleController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _focusNode = FocusNode();

    // 바텀시트가 열리면 자동으로 텍스트 필드에 포커스를 줍니다
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onConfirm() {
    if (_hasText) {
      Navigator.pop(context, _titleController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 키보드 높이만큼 패딩 추가
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 28, 20, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목 텍스트
          Text(
            '앨범 제목',
            style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05),
          ),
          const SizedBox(height: 16),

          // 텍스트 입력 필드
          // 참고: AppTextField가 존재하지 않는다는 에러 발생 시 최상단에 import 경로를 추가해 주세요.
          AppTextField(
            controller: _titleController,
            focusNode: _focusNode,
            hintText: '앨범 제목을 입력해주세요',
            suffixIcon: _hasText
                ? IconButton(
              onPressed: () {
                _titleController.clear();
                setState(() {});
              },
              icon: SvgPicture.asset(
                'assets/system/icons/icon_close_big.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.f04,
                  BlendMode.srcIn,
                ),
              ),
            )
                : null,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),

          // 취소 / 확인 버튼
          Row(
            children: [
              // 취소
              Expanded(
                child: GestureDetector(
                  onTap: _onCancel,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gray02),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '취소',
                      style: AppTextStyle.body16R120.copyWith(color: AppColors.f05),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 확인
              Expanded(
                child: GestureDetector(
                  onTap: _hasText ? _onConfirm : null,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: _hasText ? AppColors.black : AppColors.bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _hasText ? AppColors.gray05 : AppColors.gray01,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '확인',
                      style: AppTextStyle.body16R120.copyWith(
                        color: _hasText ? AppColors.white : AppColors.f03,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}