// album_common_actions.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/delete_modal.dart';
import 'package:petAblumMobile/features/presentation/pages/album/album_menu_board_sheet.dart';
import 'dart:ui';

// Mock 데이터
final List<Map<String, String>> mockAlbums = List.generate(
  10,
      (index) => {
    'id': 'pet_$index',
    'title': '우리 강아지 $index',
    'imageUrl': 'assets/system/logo/logo.png',
    'isBookmarked': index == 6 ? 'true' : 'false',
  },
);

// 헬퍼 함수들
void showAlbumMenu({
  required BuildContext context,
  required String petName,
  required String petId,
  required bool isBookmarked,
  required VoidCallback onCopy,
  required VoidCallback onBookmarkToggle,
  required VoidCallback onDelete,
}) {
  MenuBottomSheet.show(
    context: context,
    petName: petName,
    onEdit: () {},
    isBookmarked: isBookmarked,
    onCopy: onCopy,
    onShare: () async {
      final link = '$petName 앨범\nhttps://yourapp.com/album/$petId';
      await Clipboard.setData(ClipboardData(text: link));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,

            content: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x99000000),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '공유 링크가 복사되었습니다.',
                    style: AppTextStyle.description14M120.copyWith(
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }    },
    onBookmark: onBookmarkToggle,
    onDelete: onDelete,
  );
}

void showDeleteAlbumDialog({
  required BuildContext context,
  required String petName,
  required VoidCallback onConfirm,
}) {
  DeleteConfirmDialog.show(
    context: context,
    content: '$petName을(를) 삭제하시겠습니까?',
    onConfirm: onConfirm,
  );
}