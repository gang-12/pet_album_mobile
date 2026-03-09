// album_search.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/album/album_grid_item.dart';
import 'package:petAblumMobile/features/presentation/pages/album/album_common_actions.dart';
import 'package:petAblumMobile/features/presentation/pages/album/album_page.dart';

class AlbumSearch extends StatefulWidget {
  const AlbumSearch({super.key});

  @override
  State<AlbumSearch> createState() => _AlbumSearchState();
}

class _AlbumSearchState extends State<AlbumSearch> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final List<Map<String, String>> albums;

  @override
  void initState() {
    super.initState();
    albums = List.from(mockAlbums);
    // 페이지 진입 시 자동으로 키보드 올라오게
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get isSearching => _nameController.text.trim().isNotEmpty;

  List<Map<String, String>> get filteredAlbums {
    final query = _nameController.text.trim().toLowerCase();
    if (query.isEmpty) return [];
    return albums.where((album) {
      return album['title']!.toLowerCase().contains(query);
    }).toList();
  }

  List<Map<String, String>> get recentAlbums => albums.take(4).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // 키보드가 올라올 때 body 전체가 위로 밀리도록
      resizeToAvoidBottomInset: true,
      appBar: const CommonBackAppBar(title: '검색'),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 컨텐츠 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isSearching
                    ? _buildSearchResult()
                    : _buildRecentSection(),
              ),
            ),

            // 검색창 — 키보드 바로 위에 붙음
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(
                  color: AppColors.gray01,
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    offset: Offset(0, -4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: AppTextField(
                controller: _nameController,
                focusNode: _focusNode,
                hintText: '검색어를 입력해주세요.',
                style: AppTextStyle.body16M120.copyWith(color: AppColors.f05),
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
                  icon: const Icon(Icons.close, color: AppColors.gray03),
                  onPressed: () {
                    _nameController.clear();
                    setState(() {});
                  },
                )
                    : null,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '최근 항목',
          style: AppTextStyle.titlePage28Sb130.copyWith(
            color: AppColors.f05,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _buildGrid(recentAlbums),
        ),
      ],
    );
  }

  Widget _buildSearchResult() {
    if (filteredAlbums.isEmpty) {
      return Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: AppTextStyle.description14R120.copyWith(
            color: AppColors.f02,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Expanded(child: _buildGrid(filteredAlbums)),
      ],
    );
  }

  Widget _buildGrid(List<Map<String, String>> list) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const int crossAxisCount = 2;
        const double crossAxisSpacing = 16.0;
        const double labelHeight = 24.0;
        const double gap = 8.0;

        final double totalSpacing = crossAxisSpacing * (crossAxisCount - 1);
        final double itemWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;
        final double imageHeight = itemWidth * 4 / 3;
        final double childAspectRatio =
            itemWidth / (imageHeight + gap + labelHeight);

        return GridView.builder(
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: 20,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final album = list[index];
            return AlbumGridItem(
              title: album['title']!,
              imageUrl: album['imageUrl']!,
              isBookmarked: album['isBookmarked'] == 'true',
              onTap: () {
                _handleMenuTap(
                  album['title']!,
                  album['id']!,
                  album['isBookmarked'] == 'true',
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleMenuTap(String petName, String petId, bool isBookmarked) {
    showAlbumMenu(
      context: context,
      petName: petName,
      petId: petId,
      isBookmarked: isBookmarked,
      onBookmarkToggle: () => _toggleBookmark(petId),
      onDelete: () => _handleDelete(petId, petName),
    );
  }

  void _handleDelete(String petId, String petName) {
    showDeleteAlbumDialog(
      context: context,
      petName: petName,
      onConfirm: () {
        setState(() {
          albums.removeWhere((album) => album['id'] == petId);
        });
      },
    );
  }

  void _toggleBookmark(String petId) {
    setState(() {
      final index = albums.indexWhere((a) => a['id'] == petId);
      if (index != -1) {
        albums[index]['isBookmarked'] =
        albums[index]['isBookmarked'] == 'true' ? 'false' : 'true';
      }
    });
  }
}