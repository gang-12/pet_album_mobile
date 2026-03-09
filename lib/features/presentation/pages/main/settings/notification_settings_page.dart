import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';

class Notification_settings_page extends StatefulWidget {
  const Notification_settings_page({super.key});

  @override
  State<Notification_settings_page> createState() => _Notification_settings_pageState();
}

class _Notification_settings_pageState extends State<Notification_settings_page> {
  bool _smsAlarm = false;
  bool _pushAlarm = false;
  bool _nightPushAlarm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: CommonBackAppBar(title: '알림설정'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '혜택 및 이벤트 알림',
                style: AppTextStyle.subtitle20M120.copyWith(color: AppColors.f05),
              ),
              const SizedBox(height: 8),
              _ToggleItem(
                label: '문자 알림',
                value: _smsAlarm,
                onChanged: (v) => setState(() => _smsAlarm = v),
              ),
              _ToggleItem(
                label: '푸시 알림',
                value: _pushAlarm,
                onChanged: (v) => setState(() => _pushAlarm = v),
              ),
              _ToggleItem(
                label: '야간 푸시 알림(21 ~ 08시)',
                value: _nightPushAlarm,
                onChanged: (v) => setState(() => _nightPushAlarm = v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.body16R120.copyWith(color: AppColors.f04),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: SvgPicture.asset(
              value
                  ? 'assets/system/icons/icon_toggle_on.svg'
                  : 'assets/system/icons/icon_toggle_off.svg',
              width: 46,
              height: 23,
            ),
          ),
        ],
      ),
    );
  }
}