import 'package:flutter/material.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/common_app_back_bar_scaffold.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonBackAppBar(title: '개인정보처리방침 및 이용약관'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: '개인정보 보호정책',
              content: '본 개인정보 처리방침은\n'
                  '주식회사 하이비츠(이하 "서비스 제공자")가\n'
                  '무료 서비스로 개발한 모바일 기기용 모아 앱\n'
                  '(이하 "애플리케이션")에 적용됩니다.\n'
                  '본 서비스는 있는 그대로 제공됩니다.',
            ),
            _Section(
              title: '정보 수집 및 이용',
              content: '이 애플리케이션은 사용자가 다운로드하고 사용할 때\n정보를 수집합니다.\n'
                  '이 정보에는 다음과 같은 내용이 포함될 수 있습니다.\n\n'
                  '• 기기의 인터넷 프로토콜 주소 (예: IP 주소)\n'
                  '• 사용자가 애플리케이션에서 방문한 페이지\n'
                  '• 방문 시간 및 날짜\n'
                  '• 해당 페이지에서 머문 시간\n'
                  '• 지원서 작성에 소요된 시간\n'
                  '• 모바일 기기에서 사용하는 운영 체제\n\n'
                  '이 애플리케이션은 사용자의 모바일 기기 위치에 대한 정확한 정보를 수집하지 않습니다.\n\n'
                  '서비스 제공업체는 귀하가 제공한 정보를 이용하여 중요 정보, 필수 고지 사항 및 마케팅 프로모션을 제공하기 위해 때때로 귀하에게 연락할 수 있습니다.\n\n'
                  '더 나은 서비스 경험을 위해 애플리케이션 사용 중 서비스 제공자는 hivits01@hi-vits.com을 포함하되 이에 국한되지 않는 특정 개인 식별 정보를 제공하도록 요청할 수 있습니다. 서비스 제공자가 요청하는 정보는 서비스 제공자가 보관하며 본 개인정보 처리방침에 설명된 대로 사용됩니다.',
            ),
            _Section(
              title: '제3자 접근',
              content: '집계되고 익명화된 데이터만 주기적으로 외부 서비스로 전송되어 서비스 제공업체가 애플리케이션 및 서비스를 개선하는 데 도움을 줍니다. 서비스 제공업체는 본 개인정보 처리방침에 설명된 방식으로 귀하의 정보를 제3자와 공유할 수 있습니다.\n\n'
                  '서비스 제공자는 사용자가 제공한 정보와 자동으로 수집된 정보를 공개할 수 있습니다.\n\n'
                  '• 법률에 따라 요구되는 경우, 예를 들어 소환장이나 유사한 법적 절차를 준수하기 위해;\n'
                  '• 정보 공개가 그들의 권리를 보호하거나, 귀하 또는 타인의 안전을 보호하거나, 사기 행위를 조사하거나, 정부의 요청에 응하기 위해 필요하다고 선의로 판단하는 경우;\n'
                  '• 당사가 공개하는 정보를 당사를 대신하여 업무를 수행하는 신뢰할 수 있는 서비스 제공업체는 해당 정보를 독립적으로 사용하지 않으며, 본 개인정보 보호정책에 명시된 규칙을 준수하기로 동의했습니다.',
            ),
            _Section(
              title: '거부권',
              content: '앱을 삭제하면 앱의 모든 정보 수집을 간편하게 중단할 수 있습니다. 모바일 기기 또는 앱 스토어/네트워크에서 제공하는 표준 삭제 절차를 이용하시면 됩니다.',
            ),
            _Section(
              title: '데이터 보존 정책',
              content: '서비스 제공자는 사용자가 애플리케이션을 사용하는 동안 그리고 그 후 합리적인 기간 동안 사용자가 제공한 데이터를 보관합니다. 애플리케이션을 통해 제공한 사용자 제공 데이터의 삭제를 원하시는 경우 hivits01@hi-vits.com으로 문의해 주시면 합리적인 시간 내에 답변드리겠습니다.',
            ),
            _Section(
              title: '어린이들',
              content: '서비스 제공자는 13세 미만 아동으로부터 데이터를 고의로 수집하거나 아동을 대상으로 마케팅을 하기 위해 애플리케이션을 사용하지 않습니다.\n\n'
                  '서비스 제공자는 아동으로부터 고의로 개인 식별 정보를 수집하지 않습니다. 서비스 제공자는 모든 아동에게 애플리케이션 및/또는 서비스를 통해 개인 식별 정보를 절대 제출하지 않도록 권장합니다. 서비스 제공자는 부모 및 법정 보호자에게 자녀의 인터넷 사용을 모니터링하고, 자녀가 부모 또는 법정 보호자의 허락 없이 개인 식별 정보를 제공하지 않도록 지도함으로써 본 정책을 준수하도록 도와주시기를 권장합니다. 만약 아동이 서비스 제공자(hivits01@hi-vits.com)에게 연락하여 필요한 조치를 취할 수 있도록 협조해 주시기 바랍니다. 또한, 거주 국가에서 개인 식별 정보 처리에 동의하려면 만 16세 이상이어야 합니다\n(일부 국가에서는 부모 또는 법정 보호자가 대신 동의할 수 있습니다).',
            ),
            _Section(
              title: '보안',
              content: '서비스 제공업체는 고객 정보의 기밀 유지를 중요하게 생각합니다. 서비스 제공업체는 처리 및 보관하는 정보를 보호하기 위해 물리적, 전자적, 절차적 안전장치를 제공합니다.',
            ),
            _Section(
              title: '변경 사항',
              content: '본 개인정보 처리방침은 어떠한 이유로든 수시로 업데이트될 수 있습니다. 서비스 제공자는 본 페이지에 새로운 개인정보 처리방침을 게시하여 변경 사항을 알려드립니다. 변경 사항이 있는지 정기적으로 본 개인정보 처리방침을 확인하시기 바랍니다. 서비스를 계속 이용하는 것은 모든 변경 사항에 대한 동의로 간주됩니다.\n\n'
                  '본 개인정보 보호정책은 2026년 2월 12일부터 효력을 발생합니다.',
            ),
            _Section(
              title: '귀하의 동의',
              content: '본 애플리케이션을 사용함으로써 귀하는 현재 및 향후 당사가 수정할 수 있는 본 개인정보 처리방침에 명시된 바에 따라 귀하의 정보 처리에 동의하는 것입니다.',
            ),
            _Section(
              title: '문의하기',
              content: '애플리케이션 사용 중 개인정보 보호와 관련하여 궁금한 점이 있거나 개인정보 처리방침에 대해 문의 사항이 있는 경우,\nhivits01@hi-vits.com으로\n이메일을 보내 서비스 제공업체에 문의해 주세요.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.body16R140.copyWith(color: AppColors.f05)),
          const SizedBox(height: 8),
          Text(content, style: AppTextStyle.description14R140.copyWith(color: AppColors.f04)),
        ],
      ),
    );
  }
}