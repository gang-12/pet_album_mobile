import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_out_button.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart' show AppColors;
import 'package:petAblumMobile/features/presentation/pages/pet_crud/pet_personality_form.dart';
import 'package:petAblumMobile/features/presentation/pages/main/main_shell.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';

class PetInfoEditor extends StatefulWidget {
  const PetInfoEditor({super.key});

  @override
  State<PetInfoEditor> createState() => _PetInfoEditorState();
}

class _PetInfoEditorState extends State<PetInfoEditor> {
  late final TextEditingController _nameController;
  late final TextEditingController _birthController;
  late final TextEditingController _breedController;
  late final TextEditingController _weightController;

  String? _selectedGender;

  bool get _isFormValid =>
      _nameController.text.isNotEmpty &&
          _birthController.text.isNotEmpty &&
          _breedController.text.isNotEmpty &&
          _weightController.text.isNotEmpty &&
          _selectedGender != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController()..addListener(_update);
    _birthController = TextEditingController()..addListener(_update);
    _breedController = TextEditingController()..addListener(_update);
    _weightController = TextEditingController()..addListener(_update);
  }

  void _update() => setState(() {});
  void _onGenderChanged(String? gender) =>
      setState(() => _selectedGender = gender);

  void _navigateNext() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PetPersonalityEditor()),
    );
  }

  void _showSkipDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: 350,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '건너뛰시겠습니까?',
                    style: AppTextStyle.subtitle20M120.copyWith(
                      color: AppColors.f05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '미작성 시 다른 서비스 이용이 제한됩니다.\n입력한 내용은 자동저장됩니다.',
                    style: AppTextStyle.description14R120.copyWith(
                      color: AppColors.f04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppCustomButton(
                          text: '취소',
                          onTap: () => Navigator.of(context).pop(),
                          backgroundColor: AppColors.gray02,
                          textColor: AppColors.f05,
                          borderColor: AppColors.gray02,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppCustomButton(
                          text: '건너뛰기',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const MainShell(),
                              ),
                                  (route) => false,
                            );
                          },
                          backgroundColor: AppColors.black,
                          textColor: AppColors.f01,
                          borderColor: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonBackAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const _PageIndicator(),
                    const SizedBox(height: 12),
                    const _TitleText(),
                    const SizedBox(height: 40),
                    const _PetImagePicker(),
                    const SizedBox(height: 24),

                    _Label('이름'),
                    const SizedBox(height: 8),
                    _InputField(controller: _nameController, hint: '이름'),

                    const SizedBox(height: 24),
                    _Label('성별'),
                    const SizedBox(height: 12),
                    _GenderSelector(
                      selectedGender: _selectedGender,
                      onGenderChanged: _onGenderChanged,
                    ),

                    const SizedBox(height: 24),
                    _Label('생일'),
                    const SizedBox(height: 8),
                    _BirthdayInputField(controller: _birthController),

                    const SizedBox(height: 24),
                    _Label('품종'),
                    const SizedBox(height: 8),
                    _InputField(controller: _breedController, hint: '예) 말티즈'),

                    const SizedBox(height: 24),
                    _Label('몸무게'),
                    const SizedBox(height: 8),
                    _WeightInputField(controller: _weightController),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            _BottomDualButton(
              isActive: _isFormValid,
              onSkip: () => _showSkipDialog(),
              onNext: _isFormValid ? _navigateNext : null,
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔵 페이지 인디케이터
////////////////////////////////////////////////////////////

class _PageIndicator extends StatelessWidget {
  const _PageIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        _Dot(isActive: true),
        SizedBox(width: 8),
        _Dot(isActive: false),
        SizedBox(width: 8),
        _Dot(isActive: false),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;
  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.main : AppColors.gray02,
        shape: BoxShape.circle,
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 타이틀
////////////////////////////////////////////////////////////

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return Text(
      '반려동물의 기본정보를\n알려주세요.',
      style: AppTextStyle.titlePage28Sb130.copyWith(color: AppColors.f05),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 라벨
////////////////////////////////////////////////////////////

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyle.body16M120);
  }
}

////////////////////////////////////////////////////////////
/// 🔹 이미지 피커
////////////////////////////////////////////////////////////

class _PetImagePicker extends StatelessWidget {
  const _PetImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      height: 145,
      decoration: BoxDecoration(
        color: AppColors.gray03,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/system/icons/icon_camera.svg',
          width: 44,
          height: 44,
          color: AppColors.white,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 공통 입력 필드 (height: 55 고정)
////////////////////////////////////////////////////////////

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
        expands: false,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.gray01,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 생일 입력 (height: 55, YY/MM/DD 자동 포맷)
////////////////////////////////////////////////////////////

class _BirthdayInputField extends StatelessWidget {
  final TextEditingController controller;

  const _BirthdayInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
        expands: false,
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _BirthdayFormatter(),
        ],
        decoration: InputDecoration(
          hintText: 'YY/MM/DD',
          filled: true,
          fillColor: AppColors.gray01,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _BirthdayFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    var digits = newValue.text.replaceAll('/', '');
    if (digits.length > 6) digits = digits.substring(0, 6);

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i == 1 || i == 3) && i != digits.length - 1) {
        buffer.write('/');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 몸무게 입력 (height: 55, 자동 kg 포맷)
////////////////////////////////////////////////////////////

class _WeightInputField extends StatelessWidget {
  final TextEditingController controller;

  const _WeightInputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: controller,
        expands: false,
        maxLines: 1,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          _WeightFormatter(),
        ],
        decoration: InputDecoration(
          hintText: '예) 4.2kg',
          filled: true,
          fillColor: AppColors.gray01,
          isDense: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _WeightFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text.replaceAll('kg', '');
    if (text.isEmpty) return const TextEditingValue(text: '');

    final newText = '${text}kg';
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 성별 선택 (height: 55 고정)
////////////////////////////////////////////////////////////

class _GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const _GenderSelector({
    required this.selectedGender,
    required this.onGenderChanged,
  });

  void _handle(String gender) {
    final newGender = selectedGender == gender ? null : gender;
    onGenderChanged(newGender);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderButton(
            label: '여아',
            isSelected: selectedGender == '여아',
            onTap: () => _handle('여아'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GenderButton(
            label: '남아',
            isSelected: selectedGender == '남아',
            onTap: () => _handle('남아'),
          ),
        ),
      ],
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.main : AppColors.gray02,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                label == '여아'
                    ? 'assets/system/icons/icon_female.svg'
                    : 'assets/system/icons/icon_male.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.main : AppColors.f05,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyle.body16M120.copyWith(
                  color: isSelected ? AppColors.main : AppColors.f05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 하단 버튼
////////////////////////////////////////////////////////////

class _BottomDualButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  const _BottomDualButton({
    required this.isActive,
    this.onSkip,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, -4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 171,
              height: 55,
              child: AppCustomButton(
                text: '건너뛰기',
                onTap: onSkip,
                backgroundColor: Colors.white,
                textColor: AppColors.f05,
                borderColor: AppColors.gray02,
                borderRadius: 16,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 171,
              height: 55,
              child: AppCustomButton(
                text: '다음',
                onTap: onNext,
                backgroundColor: isActive ? AppColors.black : AppColors.bg,
                textColor: isActive ? AppColors.white : AppColors.f03,
                borderColor: isActive ? AppColors.gray05 : AppColors.gray01,
                borderRadius: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}