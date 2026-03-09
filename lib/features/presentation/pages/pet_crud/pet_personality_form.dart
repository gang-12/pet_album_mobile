import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/features/presentation/pages/pet_crud/pet_health_form.dart';
import 'package:petAblumMobile/features/presentation/pages/main/main_shell.dart';

class PetPersonalityEditor extends StatefulWidget {
  const PetPersonalityEditor({super.key});

  @override
  State<PetPersonalityEditor> createState() => _PetPersonalityEditorState();
}

class _PetPersonalityEditorState extends State<PetPersonalityEditor> {
  final Map<int, String?> _answers = {};

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();

  /// 1~3번 질문 모두 답변해야 활성화
  bool get _isFormValid =>
      _answers[1] != null &&
          _answers[2] != null &&
          _answers[3] != null;

  void _onAnswerSelected(int index, String answer) {
    setState(() {
      _answers[index] = answer;
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  void _showSkipDialog(BuildContext context) {
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

                    /// 🔵 페이지 인디케이터
                    const _PageIndicator(
                      currentIndex: 1,
                      totalCount: 3,
                    ),

                    const SizedBox(height: 24),
                    const _TitleText(),
                    const SizedBox(height: 40),

                    /// 1번 질문
                    _QuestionText(
                      1,
                      '예민하게 반응하거나\n   무서워하는 소리, 상황이 있나요?',
                    ),
                    const SizedBox(height: 16),
                    _AnswerGroup(
                      selectedAnswer: _answers[1],
                      onAnswerSelected: (v) => _onAnswerSelected(1, v),
                      controller: _controller1,
                      exampleText: '예) 큰소리로 이름을 부르기',
                    ),
                    const SizedBox(height: 32),

                    /// 2번 질문
                    _QuestionText(
                      2,
                      '이물질이나 장난감을\n    주워 먹은 적이 있나요?',
                    ),
                    const SizedBox(height: 16),
                    _AnswerGroup(
                      selectedAnswer: _answers[2],
                      onAnswerSelected: (v) => _onAnswerSelected(2, v),
                      controller: _controller2,
                      exampleText: '예) 간식봉투, 휴지',
                    ),
                    const SizedBox(height: 32),

                    /// 3번 질문
                    _QuestionText(
                      3,
                      '사람이나 다른 동물을 공격하거나\n     덤빈 적이 있나요?',
                    ),
                    const SizedBox(height: 16),
                    _AnswerGroup(
                      selectedAnswer: _answers[3],
                      onAnswerSelected: (v) => _onAnswerSelected(3, v),
                      controller: _controller3,
                      exampleText: '예) 간식을 뺏으려다 물었어요',
                    ),
                    const SizedBox(height: 32),

                    /// 4번 질문 (선택)
                    _QuestionText(
                      4,
                      '산책이나 돌봄 시 행동 / 환경 측면에서\n    주의할 점이 있나요?',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- 앞선 내용 외에, 산책이나 돌봄 시 행동·환경 측면에서,\n   더 알려주고 싶은 점이 있다면 작성해주세요.',
                      style: AppTextStyle.description14R140.copyWith(
                        color: AppColors.f03,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _AnswerGroup(
                      selectedAnswer: _answers[4],
                      onAnswerSelected: (v) => _onAnswerSelected(4, v),
                      controller: _controller4,
                      exampleText: '예) 엘리베이터보다 계단 이용을 선호해요.',
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            /// 하단 버튼
            _BottomDualButton(
              isActive: _isFormValid,
              onSkip: () => _showSkipDialog(context),
              onNext: _isFormValid
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PetHealthEditor(),
                  ),
                );
              }
                  : null,
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
  final int currentIndex;
  final int totalCount;

  const _PageIndicator({
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalCount,
            (index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _Dot(isActive: index == currentIndex),
        ),
      ),
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
    return const Text(
      '반려동물의 성향을\n알려주세요.',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.42,
        color: AppColors.f05,
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 질문 텍스트
////////////////////////////////////////////////////////////

class _QuestionText extends StatelessWidget {
  final int number;
  final String text;

  const _QuestionText(this.number, this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$number. $text',
      style: AppTextStyle.body16M140.copyWith(
        color: AppColors.f05,
        height: 1.4,
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 답변 그룹
////////////////////////////////////////////////////////////

class _AnswerGroup extends StatelessWidget {
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerSelected;
  final TextEditingController controller;
  final String exampleText;

  const _AnswerGroup({
    required this.selectedAnswer,
    required this.onAnswerSelected,
    required this.controller,
    required this.exampleText,
  });

  @override
  Widget build(BuildContext context) {
    final bool isYesSelected = selectedAnswer == '있어요';

    return Column(
      children: [
        _AnswerOption(
          text: '있어요',
          isSelected: isYesSelected,
          onTap: () => onAnswerSelected('있어요'),
        ),

        if (isYesSelected) ...[
          const SizedBox(height: 12),
          _InputField(
            controller: controller,
            hint: exampleText,
          ),
        ],

        const SizedBox(height: 12),

        _AnswerOption(
          text: '없어요',
          isSelected: selectedAnswer == '없어요',
          onTap: () => onAnswerSelected('없어요'),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 입력 필드 (힌트 색상 f03)
////////////////////////////////////////////////////////////

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyle.body16M120.copyWith(
          color: AppColors.f03,
        ),
        filled: true,
        fillColor: AppColors.gray01,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 답변 선택 옵션 (SVG 라디오 버튼)
////////////////////////////////////////////////////////////

class _AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.main : AppColors.gray02,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: AppTextStyle.body16M120.copyWith(
                color: AppColors.f05,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              isSelected
                  ? 'assets/system/icons/icon_radio_selected.svg'
                  : 'assets/system/icons/icon_radio_unselected.svg',
              width: 24,
              height: 24,
            ),
          ],
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