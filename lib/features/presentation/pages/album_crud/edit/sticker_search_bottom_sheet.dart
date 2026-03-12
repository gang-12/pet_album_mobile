import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';

// 스티커 모델
class Sticker {
  final String id;
  final String emoji;
  final String name;

  const Sticker({
    required this.id,
    required this.emoji,
    required this.name,
  });
}

class StickerBottomSheet extends StatefulWidget {
  const StickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<StickerBottomSheet> createState() => _StickerBottomSheetState();

  static Future<Sticker?> show(BuildContext context) {
    return showModalBottomSheet<Sticker>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => const StickerBottomSheet(),
    );
  }
}

class _StickerBottomSheetState extends State<StickerBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  final List<String> _categories = ['전체', '문자', '장난감', '데코', '음식', '자연'];

  final Map<String, List<Sticker>> _stickersByCategory = {
    '전체': [
      Sticker(id: '1', emoji: '😀', name: '웃음'),
      Sticker(id: '2', emoji: '😂', name: '기쁨'),
      Sticker(id: '3', emoji: '😍', name: '사랑'),
      Sticker(id: '4', emoji: '🥰', name: '행복'),
      Sticker(id: '5', emoji: '😎', name: '멋짐'),
      Sticker(id: '6', emoji: '🤔', name: '생각'),
      Sticker(id: '7', emoji: '😭', name: '슬픔'),
      Sticker(id: '8', emoji: '😱', name: '놀람'),
      Sticker(id: '9', emoji: '🐶', name: '강아지'),
      Sticker(id: '10', emoji: '🐱', name: '고양이'),
      Sticker(id: '11', emoji: '🍕', name: '피자'),
      Sticker(id: '12', emoji: '🍔', name: '햄버거'),
    ],
    '문자': [
      Sticker(id: '13', emoji: '👨‍🏫', name: '선생님'),
      Sticker(id: '14', emoji: '📚', name: '책'),
      Sticker(id: '15', emoji: '✏️', name: '연필'),
    ],
    '장난감': [
      Sticker(id: '16', emoji: '🚚', name: '트럭'),
      Sticker(id: '17', emoji: '📦', name: '상자'),
      Sticker(id: '18', emoji: '🏃', name: '달리기'),
    ],
    '데코': [
      Sticker(id: '19', emoji: '🎯', name: '목표'),
      Sticker(id: '20', emoji: '💪', name: '힘'),
      Sticker(id: '21', emoji: '🏆', name: '우승'),
    ],
    '음식': [
      Sticker(id: '22', emoji: '⭐', name: '별'),
      Sticker(id: '23', emoji: '🌙', name: '달'),
      Sticker(id: '24', emoji: '☀️', name: '태양'),
    ],
    '자연': [
      Sticker(id: '25', emoji: '🎨', name: '미술'),
      Sticker(id: '26', emoji: '🎵', name: '음악'),
      Sticker(id: '27', emoji: '💃', name: '춤'),
    ],
  };

  bool get isSearching => _searchController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() => setState(() {}));

    // 검색창 포커스 시 80%로 확장
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _sheetController.animateTo(
          0.8,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _onStickerTap(Sticker sticker) {
    Navigator.pop(context, sticker);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double initialHeight = 400.0;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: initialHeight / screenHeight,
      minChildSize: initialHeight / screenHeight,
      maxChildSize: 0.8,
      expand: true,
      builder: (context, scrollController) {
        // 스크롤 시작 시 80%로 확장
        scrollController.addListener(() {
          if (scrollController.offset > 0 &&
              _sheetController.size < 0.8) {
            _sheetController.animateTo(
              0.8,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppTextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      hintText: '검색어를 입력해주세요.',
                      prefixIcon: SvgPicture.asset(
                        'assets/system/icons/icon_search.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray03,
                          BlendMode.srcIn,
                        ),
                      ),
                      suffixIcon: isSearching
                          ? IconButton(
                        icon: SvgPicture.asset(
                          'assets/system/icons/icon_close_big.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.gray04,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )                          : null,
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryTabs(),
                  const SizedBox(height: 16),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    final stickers = _stickersByCategory[category] ?? [];

                    if (stickers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/system/icons/icon_image_not_supported.svg',
                              width: 64,
                              height: 64,
                              colorFilter: const ColorFilter.mode(
                                AppColors.gray03,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '스티커가 없습니다',
                              style: AppTextStyle.description14R120.copyWith(
                                color: AppColors.f03,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: stickers.length,
                      itemBuilder: (context, index) {
                        final sticker = stickers[index];
                        return GestureDetector(
                          onTap: () => _onStickerTap(sticker),
                          child: Center(
                            child: Text(
                              sticker.emoji,
                              style: const TextStyle(fontSize: 52),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
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
          // ✕ 엑스: Navigator.pop (반환값 없음 = 취소)
          GestureDetector(
            onTap: () => Navigator.pop(context),
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

          // 중앙 "스티커" 텍스트
          Expanded(
            child: Center(
              child: Text('스티커', style: AppTextStyle.description14R120),
            ),
          ),

          // ✓ 체크: Navigator.pop (반환값 없음 = 확인)
          GestureDetector(
            onTap: () => Navigator.pop(context),
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

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_categories.length, (index) {
            final isSelected = _tabController.index == index;
            return GestureDetector(
              onTap: () => _tabController.animateTo(index),
              child: Container(
                margin: EdgeInsets.only(
                  right: index < _categories.length - 1 ? 12 : 0,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: isSelected ? AppColors.f05 : AppColors.f02,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _categories[index],
                  style: AppTextStyle.description14M120.copyWith(
                    color: isSelected ? AppColors.f05 : AppColors.f02,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}