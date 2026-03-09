import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_custom_button.dart';
import 'package:petAblumMobile/features/presentation/pages/main/main_shell.dart';

////////////////////////////////////////////////////////////
/// 💊 약 정보 모델
////////////////////////////////////////////////////////////

class _MedicineEntry {
  final TextEditingController nameController;
  String? selectedTime;
  bool isPickerOpen;

  _MedicineEntry()
      : nameController = TextEditingController(),
        isPickerOpen = false;

  void dispose() => nameController.dispose();
}

////////////////////////////////////////////////////////////
/// 🏠 메인 위젯
////////////////////////////////////////////////////////////

class PetHealthEditor extends StatefulWidget {
  const PetHealthEditor({super.key});

  @override
  State<PetHealthEditor> createState() => _PetHealthState();
}

class _PetHealthState extends State<PetHealthEditor> {
  final Map<int, String?> _answers = {};

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();

  final List<_MedicineEntry> _medicines = [_MedicineEntry()];

  bool get _isFormValid =>
      _answers[1] != null &&
          _answers[2] != null &&
          _answers[3] != null;

  void _onAnswerSelected(int questionIndex, String answer) {
    setState(() => _answers[questionIndex] = answer);
  }

  void _addMedicine() {
    setState(() => _medicines.add(_MedicineEntry()));
  }

  void _onTimeSaved(int index, String time) {
    setState(() {
      _medicines[index].selectedTime = time;
      _medicines[index].isPickerOpen = false;
    });
  }

  void _togglePicker(int index) {
    setState(() {
      // 다른 피커 모두 닫기
      for (int i = 0; i < _medicines.length; i++) {
        if (i != index) _medicines[i].isPickerOpen = false;
      }
      _medicines[index].isPickerOpen = !_medicines[index].isPickerOpen;
    });
  }

  bool get _showAddButton {
    final last = _medicines.last;
    return last.nameController.text.isNotEmpty || last.selectedTime != null;
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    for (final m in _medicines) {
      m.dispose();
    }
    super.dispose();
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                                builder: (_) => MainShell(),
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

                    const _PageIndicator(currentIndex: 2, totalCount: 3),
                    const SizedBox(height: 24),
                    const _TitleText(),
                    const SizedBox(height: 40),

                    /// 1번 질문
                    _QuestionText(1, '현재 반려동물에게 관절 질환이 있나요?'),
                    const SizedBox(height: 16),
                    _AnswerGroup(
                      selectedAnswer: _answers[1],
                      onAnswerSelected: (a) => _onAnswerSelected(1, a),
                      controller: _controller1,
                      exampleText: '예) 관절염',
                    ),
                    const SizedBox(height: 32),

                    /// 2번 질문
                    _QuestionText(2, '현재 반려동물에게 피부 질환이 있나요?'),
                    const SizedBox(height: 16),
                    _AnswerGroup(
                      selectedAnswer: _answers[2],
                      onAnswerSelected: (a) => _onAnswerSelected(2, a),
                      controller: _controller2,
                      exampleText: '예) 아토피',
                    ),
                    const SizedBox(height: 32),

                    /// 3번 질문
                    _QuestionText(
                      3,
                      '산책이나 돌봄 시\n건강상 특별히 주의해야 할 점이 있나요?',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '앞선 내용 외에, 산책이나 돌봄 시 행동·환경 측면에서\n더 알려주고 싶은 점이 있다면 작성해주세요.',
                      style: AppTextStyle.description14R120
                          .copyWith(color: AppColors.f03),
                    ),
                    const SizedBox(height: 16),
                    _AnswerGroup(
                      selectedAnswer: _answers[3],
                      onAnswerSelected: (a) => _onAnswerSelected(3, a),
                      controller: _controller3,
                      exampleText: '예) 체력이 약해 중간중간 휴식이 필요해요.',
                    ),
                    const SizedBox(height: 32),

                    /// 4번 질문
                    _QuestionText(4, '반려동물이 복용하는 약과 시간을\n작성해 주세요.'),
                    const SizedBox(height: 16),

                    /// 약 목록
                    for (int i = 0; i < _medicines.length; i++) ...[
                      _MedicineRowWithPicker(
                        key: ValueKey(i),
                        entry: _medicines[i],
                        onTogglePicker: () => _togglePicker(i),
                        onTimeSaved: (time) => _onTimeSaved(i, time),
                        onNameChanged: () => setState(() {}),
                      ),
                      if (i < _medicines.length - 1)
                        const SizedBox(height: 12),
                    ],

                    /// + 추가 버튼
                    if (_showAddButton) ...[
                      const SizedBox(height: 12),
                      _AddMedicineButton(onTap: _addMedicine),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            _BottomDualButton(
              isActive: _isFormValid,
              onSkip: () => _showSkipDialog(),
              onNext: _isFormValid
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MainShell()),
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
/// 💊 약 행 + 인라인 피커
////////////////////////////////////////////////////////////

class _MedicineRowWithPicker extends StatefulWidget {
  final _MedicineEntry entry;
  final VoidCallback onTogglePicker;
  final ValueChanged<String> onTimeSaved;
  final VoidCallback onNameChanged;

  const _MedicineRowWithPicker({
    super.key,
    required this.entry,
    required this.onTogglePicker,
    required this.onTimeSaved,
    required this.onNameChanged,
  });

  @override
  State<_MedicineRowWithPicker> createState() =>
      _MedicineRowWithPickerState();
}

class _MedicineRowWithPickerState
    extends State<_MedicineRowWithPicker> {
  // 피커 내부 선택값 (저장 전) - 기본값 오전 1:00
  int _amPmIndex = 0;
  int _hourIndex = 0;
  int _minuteIndex = 0;

  final List<String> _amPmList = ['오전', '오후'];
  final List<String> _hourList =
  List.generate(12, (i) => '${i + 1}');
  final List<String> _minuteList =
  List.generate(60, (i) => i.toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    _parseInitialTime();
  }

  void _parseInitialTime() {
    if (widget.entry.selectedTime != null) {
      try {
        final parts = widget.entry.selectedTime!.split(' ');
        _amPmIndex = parts[0] == '오전' ? 0 : 1;
        final timeParts = parts[1].split(':');
        _hourIndex = int.parse(timeParts[0]) - 1;
        _minuteIndex = int.parse(timeParts[1]);
      } catch (_) {}
    }
  }

  String get _formattedTime {
    final amPm = _amPmList[_amPmIndex];
    final hour = _hourList[_hourIndex];
    final minute = _minuteList[_minuteIndex];
    return '$amPm $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final bool isOpen = widget.entry.isPickerOpen;
    final bool hasTime = widget.entry.selectedTime != null;

    return Column(
      children: [
        /// 약 이름 + 시간/아이콘 행
        Container(
          width: double.infinity,
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.gray02,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.entry.nameController,
                  onChanged: (_) => widget.onNameChanged(),
                  style: AppTextStyle.body16M120
                      .copyWith(color: AppColors.f05),
                  decoration: InputDecoration(
                    hintText: '예)비타민, 철분',
                    hintStyle: AppTextStyle.body16M120
                        .copyWith(color: AppColors.f03),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: widget.onTogglePicker,
                child: hasTime
                    ? Text(
                  widget.entry.selectedTime!,
                  style: AppTextStyle.body16M120
                      .copyWith(color: AppColors.f05),
                )
                    : SvgPicture.asset(
                  'assets/system/icons/icon_timer.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.f03,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// 인라인 피커 (isOpen일 때만 표시)
        if (isOpen)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                /// 드럼롤 피커
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// 선택 하이라이트
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 44,
                          color: AppColors.gray02.withOpacity(0.4),
                        ),
                      ),

                      Row(
                        children: [
                          /// 오전/오후
                          Expanded(
                            flex: 2,
                            child: _DrumrollPicker(
                              items: _amPmList,
                              selectedIndex: _amPmIndex,
                              onChanged: (i) {
                                _amPmIndex = i;
                              },
                            ),
                          ),
                          /// 시
                          Expanded(
                            flex: 2,
                            child: _DrumrollPicker(
                              items: _hourList,
                              selectedIndex: _hourIndex,
                              onChanged: (i) {
                                _hourIndex = i;
                              },
                            ),
                          ),
                          /// 분
                          Expanded(
                            flex: 2,
                            child: _DrumrollPicker(
                              items: _minuteList,
                              selectedIndex: _minuteIndex,
                              onChanged: (i) {
                                _minuteIndex = i;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// 저장 버튼
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GestureDetector(
                    onTap: () => widget.onTimeSaved(_formattedTime),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.gray02, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          '저장',
                          style: AppTextStyle.body16M120
                              .copyWith(color: AppColors.f05),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// 🎡 드럼롤 피커 (CupertinoPicker 기반)
////////////////////////////////////////////////////////////

class _DrumrollPicker extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _DrumrollPicker({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<_DrumrollPicker> createState() => _DrumrollPickerState();
}

class _DrumrollPickerState extends State<_DrumrollPicker> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(
      initialItem: widget.selectedIndex,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: _controller,
      itemExtent: 44,
      onSelectedItemChanged: widget.onChanged,
      selectionOverlay: const SizedBox.shrink(),
      children: widget.items.map((item) {
        return Center(
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.f05,
            ),
          ),
        );
      }).toList(),
    );
  }
}

////////////////////////////////////////////////////////////
/// ➕ 약 추가 버튼
////////////////////////////////////////////////////////////

class _AddMedicineButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMedicineButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray02, width: 1),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/system/icons/icon_add.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              AppColors.f03,
              BlendMode.srcIn,
            ),
          ),
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
      '반려동물의 건강 상태를\n알려주세요.',
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
      style: AppTextStyle.body16M120.copyWith(
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
          _InputField(controller: controller, hint: exampleText),
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
/// 🔹 입력 필드
////////////////////////////////////////////////////////////

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputField({required this.controller, required this.hint});

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
        fillColor: AppColors.gray02,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              style: AppTextStyle.body16M120
                  .copyWith(color: AppColors.f05),
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
                backgroundColor:
                isActive ? AppColors.black : AppColors.bg,
                textColor: isActive ? AppColors.white : AppColors.f03,
                borderColor:
                isActive ? AppColors.gray05 : AppColors.gray01,
                borderRadius: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}