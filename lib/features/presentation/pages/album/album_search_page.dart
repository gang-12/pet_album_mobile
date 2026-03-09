// album_search.dart
import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/features/presentation/pages/album/album_grid_item.dart';
import 'package:petAblumMobile/features/presentation/pages/album/album_common_actions.dart';

class AlbumSearch extends StatefulWidget {
  const AlbumSearch({super.key});

  @override
  State<AlbumSearch> createState() => _AlbumSearchState();
}

class _AlbumSearchState extends State<AlbumSearch> {
  final TextEditingController _nameController = TextEditingController();
  late final List<Map<String, String>> albums;

  @override
  void initState() {
    super.initState();
    albums = List.from(mockAlbums);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredAlbums {
    final query = _nameController.text.trim().toLowerCase();
    if (query.isEmpty) return []; // 👈 빈 배열 반환

    return albums.where((album) {
      return album['title']!.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonBackAppBar(title: ' 검색'),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.gray01,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AppTextField(
              controller: _nameController,
              hintText: '검색어를 입력해주세요.',
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: AppColors.gray02,
              ),
              suffixIcon: _nameController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.close),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: filteredAlbums.isEmpty && _nameController.text.isNotEmpty
                  ? Center(
                child: Text(
                  '검색 결과가 없습니다.',
                  style: TextStyle(
                    color: AppColors.f01,
                    fontSize: 14,
                  ),
                ),
              )
                  : GridView.builder(
                itemCount: filteredAlbums.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final album = filteredAlbums[index];

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
              ),
            ),
          ),
        ],
      ),
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