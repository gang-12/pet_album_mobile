// album_create_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/features/presentation/pages/album_crud/album_edit_form.dart';

/// 앨범 추가 버튼(+) 클릭 시 올라오는 바텀시트
/// 사용법: showAlbumCreateSheet(context);
void showAlbumCreateSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 키보드가 올라와도 시트가 가려지지 않게
    backgroundColor: Colors.transparent,
    builder: (_) => const _AlbumCreateSheet(),
  );
}

class _AlbumCreateSheet extends StatefulWidget {
  const _AlbumCreateSheet();

  @override
  State<_AlbumCreateSheet> createState() => _AlbumCreateSheetState();
}

class _AlbumCreateSheetState extends State<_AlbumCreateSheet> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 시트가 열리면 자동으로 키보드 올라오게
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

  bool get _hasText => _titleController.text.trim().isNotEmpty;

  void _onConfirm() {
    if (!_hasText) return;
    final title = _titleController.text.trim();
    Navigator.pop(context); // 시트 닫기
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AlbumEditFormPage(),
      ),
    );
  }

  void _onCancel() {
    Navigator.pop(context);
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
                      style: AppTextStyle.body16R120
                          .copyWith(color: AppColors.f05),
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