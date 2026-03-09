import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/features/presentation/pages/pet_crud/pet_info_form.dart';

class PetTypCreatePage extends StatelessWidget {
  const PetTypCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonBackAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 16),
            _TitleText(),
            SizedBox(height: 80),
            _PetTypeRow(),
          ],
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      '어떤 반려동물을\n키우고 계신가요?',
      style: AppTextStyle.titlePage28Sb130.copyWith(
        color: AppColors.f05,
      ),
    );
  }
}

class _PetTypeRow extends StatelessWidget {
  const _PetTypeRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Row(
        children: const [
          Expanded(
            child: _PetTypeCard(
              label: '강아지',
              imagePath: 'assets/system/icons/maltese.svg',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _PetTypeCard(
              label: '고양이',
              imagePath: 'assets/system/icons/Orange_Tabby.svg',
            ),
          ),
        ],
      ),
    );
  }
}

class _PetTypeCard extends StatelessWidget {
  final String label;
  final String imagePath;

  const _PetTypeCard({
    required this.label,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PetInfoEditor(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gray01,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 152,
                height: 146,
                child: SvgPicture.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyle.body16M120.copyWith(
                  color: AppColors.f05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}