import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';


/// 갤러리 사진 선택 바텀시트
class PhotoGalleryBottomSheet extends StatefulWidget {
  const PhotoGalleryBottomSheet({Key? key}) : super(key: key);


  @override
  State<PhotoGalleryBottomSheet> createState() => _PhotoGalleryBottomSheetState();

  static Future<List<int>?> show(BuildContext context) {
    return showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => const PhotoGalleryBottomSheet(),
    );
  }
}

class _PhotoGalleryBottomSheetState extends State<PhotoGalleryBottomSheet> {
  final Set<int> selectedPhotos = {};
  String selectedFilter = '최근항목';
  bool _isDropdownOpen = false;
  final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // mock 데이터 (이미지 없이 카메라 셀 + 빈 셀)
  final List<PhotoItem> photos = List.generate(
    20,
        (index) {
      if (index == 0) return PhotoItem(type: PhotoType.camera);
      return PhotoItem(
        type: PhotoType.image,
        hasVideo: index % 3 == 0,
      );
    },
  );

  void toggleSelection(int index) {
    if (index == 0) return;
    setState(() {
      if (selectedPhotos.contains(index)) {
        selectedPhotos.remove(index);
      } else {
        selectedPhotos.add(index);
      }
    });
  }

  void _onConfirm() {
    if (selectedPhotos.isEmpty) return;
    Navigator.pop(context, selectedPhotos.toList());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final initialSize = 359 / screenHeight;

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: initialSize,
      minChildSize: initialSize,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
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
          child: Column(
            children: [
              // 헤더 (드래그 감지 포함)
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  final delta = details.primaryDelta! / screenHeight;
                  final newSize = (_controller.size - delta).clamp(initialSize, 0.95);
                  _controller.jumpTo(newSize);
                },
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // ✅ 핸들바 삭제 → 헤더(엑스 / "사진" / 체크)
                      _buildHeader(),
                      const SizedBox(height: 20),

                      // 필터 드롭다운
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            PopupMenuButton<String>(
                              offset: const Offset(0, 40),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onOpened: () => setState(() => _isDropdownOpen = true),
                              onCanceled: () => setState(() => _isDropdownOpen = false),
                              onSelected: (value) => setState(() {
                                selectedFilter = value;
                                _isDropdownOpen = false;
                              }),
                              itemBuilder: (_) => [
                                _buildPopupMenuItem('최근항목'),
                                _buildPopupMenuItem('다운로드'),
                                _buildPopupMenuItem('즐겨찾기'),
                                _buildPopupMenuItem('폴더이름'),
                              ],
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    selectedFilter,
                                    style: AppTextStyle.body16M120.copyWith(
                                      color: AppColors.f05,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  // ✅ 열리면 180° 회전 (∨ → ∧)
                                  AnimatedRotation(
                                    turns: _isDropdownOpen ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SvgPicture.asset(
                                      'assets/system/icons/icon_expand_more.svg',
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
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 갤러리 그리드
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(2),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final photo = photos[index];
                            final isSelected = selectedPhotos.contains(index);

                            return GestureDetector(
                              onTap: () => toggleSelection(index),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // 카메라 셀
                                  if (photo.type == PhotoType.camera)
                                    Container(
                                      color: AppColors.gray01,
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/system/icons/icon_camera.svg',
                                          width: 32,
                                          height: 32,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.gray04,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    )
                                  // ✅ 이미지 없이 빈 회색 셀
                                  else
                                    Container(color: AppColors.gray01),

                                  // 선택 오버레이
                                  if (isSelected)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0x4D000000),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),

                                  // 선택 체크 아이콘
                                  if (photo.type == PhotoType.image)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? const Color(0xFFFBBC05)
                                              : const Color(0xCCFFFFFF),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFFFBBC05)
                                                : Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Center(
                                          child: Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        )
                                            : null,
                                      ),
                                    ),

                                  // 비디오 아이콘
                                  if (photo.hasVideo)
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0x99000000),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                          childCount: photos.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // ✕ 엑스: 닫기
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 24, color: AppColors.f05),
          ),

          // 중앙 "사진" 텍스트
          Expanded(
            child: Center(
              child: Text('사진', style: AppTextStyle.description14R120),
            ),
          ),

          // ✓ 체크: 선택한 사진 확인 후 닫기
          GestureDetector(
            onTap: _onConfirm,
            child: const Icon(Icons.check, size: 24, color: AppColors.f05),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String title) {
    final isSelected = selectedFilter == title;
    return PopupMenuItem<String>(
      value: title,
      child: Text(
        title,
        style: AppTextStyle.body16M120.copyWith(
          color: isSelected ? AppColors.f05 : AppColors.f03,
        ),
      ),
    );
  }
}

enum PhotoType { camera, image }

class PhotoItem {
  final PhotoType type;
  final bool hasVideo;

  PhotoItem({
    required this.type,
    this.hasVideo = false,
  });
}