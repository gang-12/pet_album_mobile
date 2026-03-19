import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';

class CommonNavigationScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CommonNavigationScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          labelTextStyle: WidgetStateProperty.resolveWith(
                (states) => AppTextStyle.caption12R140.copyWith(
              fontSize: 12,
              color: states.contains(WidgetState.selected)
                  ? AppColors.fMain
                  : AppColors.f02,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: AppColors.white,
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/system/icons/icon_home.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 0 ? AppColors.fMain : AppColors.f02,
                  BlendMode.srcIn,
                ),
              ),
              label: '홈',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/system/icons/icon_album.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 1 ? AppColors.fMain : AppColors.f02,
                  BlendMode.srcIn,
                ),
              ),
              label: '앨범',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/system/icons/icon_mypage.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 2 ? AppColors.fMain : AppColors.f02,
                  BlendMode.srcIn,
                ),
              ),
              label: '마이페이지',
            ),
          ],
        ),
      ),
    );
  }
}