import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
class CommonBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;

  const CommonBackAppBar({
    super.key,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      backgroundColor: AppColors.gray00,
      elevation: 0,
      toolbarHeight: kToolbarHeight + 40, // ✅ 상하 20씩 높이 추가
      leading: Padding(
        padding: const EdgeInsets.only(left: 20), // ✅ 왼쪽 20
        child: IconButton(
          icon: SvgPicture.asset(
            'assets/system/icons/icon_back.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.f05,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
      ),
      title: title == null
          ? null
          : Text(
        title!,
        style: AppTextStyle.subtitle20M120.copyWith(
          color: AppColors.f05,
        ),
      ),
      centerTitle: false,
      actions: actions,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}