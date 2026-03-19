import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/features/presentation/pages/album/album_menu_board_sheet.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/album_edit_form.dart';
import 'package:petAblumMobile/core/widgets/delete_modal.dart';


class AlbumViewPage extends StatefulWidget {
  final Map<String, String> album;
  final VoidCallback? onBookmarkToggle;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;

  const AlbumViewPage({
    super.key,
    required this.album,
    this.onBookmarkToggle,
    this.onCopy,
    this.onDelete,
  });

  @override
  State<AlbumViewPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumViewPage> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.album['isBookmarked'] == 'true';
  }

  String get _title => widget.album['title'] ?? '';
  String get _imageUrl => widget.album['imageUrl'] ?? '';

  // 공유: 클립보드 복사 + 토스트 SnackBar
  void _handleShare() {
    final link = 'petalbum://album/${widget.album['id'] ?? ''}';
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '링크가 복사되었습니다.',
          style: AppTextStyle.description14M120.copyWith(
            color: const Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xB3424242),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 삭제 확인 팝업
  void _handleDelete() {
    DeleteConfirmDialog.show(
      context: context,
      title: '앨범 삭제',
      content: '"$_title" 앨범을 삭제하시겠습니까?',
      onConfirm: () {
        widget.onDelete?.call();  // 앨범 목록에서 삭제
        Navigator.pop(context);   // 뷰 페이지 닫기
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: _imageUrl.isNotEmpty
                ? Image.asset(
              _imageUrl,
              fit: BoxFit.cover,
            )
                : const ColoredBox(color: AppColors.gray01),
          ),

          // 상단 앱바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 64,
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 56,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 정중앙 타이틀
                      Text(
                        _title,
                        style: AppTextStyle.subtitle20M120.copyWith(
                          color: AppColors.f05,
                        ),
                      ),

                      // 왼쪽 닫기 버튼 (20px 여백)
                      Positioned(
                        left: 20,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
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
                      ),

                      // 오른쪽 더보기 버튼 (20px 여백)
                      Positioned(
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            MenuBottomSheet.show(
                              context: context,
                              petName: _title,
                              onEdit: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AlbumEditFormPage(),
                                  ),
                                );
                              },
                              onCopy: () {
                                // 복사 후 앨범 페이지로 이동
                                widget.onCopy?.call();
                                Navigator.pop(context);
                              },
                              onShare: _handleShare,
                              isBookmarked: _isBookmarked,
                              onBookmark: () {
                                setState(() => _isBookmarked = !_isBookmarked);
                                widget.onBookmarkToggle?.call();
                              },
                              onDelete: _handleDelete,
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/system/icons/icon_kebab_menu.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              AppColors.f05,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 편집 버튼 (오른쪽 20px, 아래 56px)
          Positioned(
            right: 20,
            bottom: 56,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AlbumEditFormPage(),
                  ),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.black,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/system/icons/icon_edit.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
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
  }
}