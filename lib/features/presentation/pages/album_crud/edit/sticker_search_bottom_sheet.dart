import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petAblumMobile/core/theme/app_colors.dart';
import 'package:petAblumMobile/core/theme/font/app_fonts_style_suit.dart';
import 'package:petAblumMobile/core/widgets/app_text_field.dart';

// 스티커 모델
class Sticker {
  final String id;
  final String emoji;
  final String name;
  final String? svgPath;

  const Sticker({
    required this.id,
    required this.emoji,
    required this.name,
    this.svgPath,
  });
}

class StickerBottomSheet extends StatefulWidget {
  const StickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<StickerBottomSheet> createState() => _StickerBottomSheetState();

  static Future<Sticker?> show(BuildContext context) {
    return showModalBottomSheet<Sticker>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => const StickerBottomSheet(),
    );
  }
}

class _StickerBottomSheetState extends State<StickerBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final ScrollController _tabScrollController = ScrollController();

  final List<String> _categories = ['말풍선', '데코', '음식', '마스킹테이프', '문자', '자연', '메모지', '소품', '장난감'];

  final Map<String, List<Sticker>> _stickersByCategory = {
    // 말풍선: id 1~8
    '말풍선': [
      Sticker(id: '1', emoji: '', name: '말풍선1', svgPath: 'assets/system/sticker/bubble/말풍선1.svg'),
      Sticker(id: '2', emoji: '', name: '말풍선2', svgPath: 'assets/system/sticker/bubble/말풍선2.svg'),
      Sticker(id: '3', emoji: '', name: '말풍선3', svgPath: 'assets/system/sticker/bubble/말풍선3.svg'),
      Sticker(id: '4', emoji: '', name: '말풍선4', svgPath: 'assets/system/sticker/bubble/말풍선4.svg'),
      Sticker(id: '5', emoji: '', name: '말풍선5', svgPath: 'assets/system/sticker/bubble/말풍선5.svg'),
      Sticker(id: '6', emoji: '', name: '말풍선6', svgPath: 'assets/system/sticker/bubble/말풍선6.svg'),
      Sticker(id: '7', emoji: '', name: '말풍선7', svgPath: 'assets/system/sticker/bubble/말풍선7.svg'),
      Sticker(id: '8', emoji: '', name: '말풍선8', svgPath: 'assets/system/sticker/bubble/말풍선8.svg'),
    ],
    // 데코: id 9~52
    '데코': [
      Sticker(id: '9',  emoji: '', name: 'zzz',      svgPath: 'assets/system/sticker/deco/데코_zzz.svg'),
      Sticker(id: '10', emoji: '', name: '금',        svgPath: 'assets/system/sticker/deco/데코_금.svg'),
      Sticker(id: '11', emoji: '', name: '깜짝',      svgPath: 'assets/system/sticker/deco/데코_깜짝.svg'),
      Sticker(id: '12', emoji: '', name: '날개',      svgPath: 'assets/system/sticker/deco/데코_날개.svg'),
      Sticker(id: '13', emoji: '', name: '내강아지',  svgPath: 'assets/system/sticker/deco/데코_내강아지.svg'),
      Sticker(id: '14', emoji: '', name: '내고양이',  svgPath: 'assets/system/sticker/deco/데코_내고양이.svg'),
      Sticker(id: '15', emoji: '', name: '느낌표',    svgPath: 'assets/system/sticker/deco/데코_느낌표.svg'),
      Sticker(id: '16', emoji: '', name: '땀1',       svgPath: 'assets/system/sticker/deco/데코_땀1.svg'),
      Sticker(id: '17', emoji: '', name: '땀3',       svgPath: 'assets/system/sticker/deco/데코_땀3.svg'),
      Sticker(id: '18', emoji: '', name: '목',        svgPath: 'assets/system/sticker/deco/데코_목.svg'),
      Sticker(id: '19', emoji: '', name: '비눗방울',  svgPath: 'assets/system/sticker/deco/데코_비눗방울.svg'),
      Sticker(id: '20', emoji: '', name: '선물상자',  svgPath: 'assets/system/sticker/deco/데코_선물상자.svg'),
      Sticker(id: '21', emoji: '', name: '수',        svgPath: 'assets/system/sticker/deco/데코_수.svg'),
      Sticker(id: '22', emoji: '', name: '시계2',     svgPath: 'assets/system/sticker/deco/데코_시계2.svg'),
      Sticker(id: '23', emoji: '', name: '쓰레기통',  svgPath: 'assets/system/sticker/deco/데코_쓰레기통.svg'),
      Sticker(id: '24', emoji: '', name: '액자',      svgPath: 'assets/system/sticker/deco/데코_액자.svg'),
      Sticker(id: '25', emoji: '', name: '어질',      svgPath: 'assets/system/sticker/deco/데코_어질.svg'),
      Sticker(id: '26', emoji: '', name: '엑스',      svgPath: 'assets/system/sticker/deco/데코_엑스.svg'),
      Sticker(id: '27', emoji: '', name: '오케이',    svgPath: 'assets/system/sticker/deco/데코_오케이.svg'),
      Sticker(id: '28', emoji: '', name: '와이드집게',svgPath: 'assets/system/sticker/deco/데코_와이드집게.svg'),
      Sticker(id: '29', emoji: '', name: '왕관',      svgPath: 'assets/system/sticker/deco/데코_왕관.svg'),
      Sticker(id: '30', emoji: '', name: '운동기구',  svgPath: 'assets/system/sticker/deco/데코_운동기구.svg'),
      Sticker(id: '31', emoji: '', name: '웃음',      svgPath: 'assets/system/sticker/deco/데코_웃음.svg'),
      Sticker(id: '32', emoji: '', name: '월',        svgPath: 'assets/system/sticker/deco/데코_월.svg'),
      Sticker(id: '33', emoji: '', name: '일',        svgPath: 'assets/system/sticker/deco/데코_일.svg'),
      Sticker(id: '34', emoji: '', name: '집3',       svgPath: 'assets/system/sticker/deco/데코_집3.svg'),
      Sticker(id: '35', emoji: '', name: '차',        svgPath: 'assets/system/sticker/deco/데코_차.svg'),
      Sticker(id: '36', emoji: '', name: '체크',      svgPath: 'assets/system/sticker/deco/데코_체크.svg'),
      Sticker(id: '37', emoji: '', name: '클립1',     svgPath: 'assets/system/sticker/deco/데코_클립1.svg'),
      Sticker(id: '38', emoji: '', name: '클립2',     svgPath: 'assets/system/sticker/deco/데코_클립2.svg'),
      Sticker(id: '39', emoji: '', name: '터짐효과',  svgPath: 'assets/system/sticker/deco/데코_터짐효과.svg'),
      Sticker(id: '40', emoji: '', name: '토',        svgPath: 'assets/system/sticker/deco/데코_토.svg'),
      Sticker(id: '41', emoji: '', name: '튜브1',     svgPath: 'assets/system/sticker/deco/데코_튜브1.svg'),
      Sticker(id: '42', emoji: '', name: '튜브2',     svgPath: 'assets/system/sticker/deco/데코_튜브2.svg'),
      Sticker(id: '43', emoji: '', name: '폴라로이드',svgPath: 'assets/system/sticker/deco/데코_폴라로이드.svg'),
      Sticker(id: '44', emoji: '', name: '핀1',       svgPath: 'assets/system/sticker/deco/데코_핀1.svg'),
      Sticker(id: '45', emoji: '', name: '핀2',       svgPath: 'assets/system/sticker/deco/데코_핀2.svg'),
      Sticker(id: '46', emoji: '', name: '핀3',       svgPath: 'assets/system/sticker/deco/데코_핀3.svg'),
      Sticker(id: '47', emoji: '', name: '핀4',       svgPath: 'assets/system/sticker/deco/데코_핀4.svg'),
      Sticker(id: '48', emoji: '', name: '핀5',       svgPath: 'assets/system/sticker/deco/데코_핀5.svg'),
      Sticker(id: '49', emoji: '', name: '핀6',       svgPath: 'assets/system/sticker/deco/데코_핀6.svg'),
      Sticker(id: '50', emoji: '', name: '핀7',       svgPath: 'assets/system/sticker/deco/데코_핀7.svg'),
      Sticker(id: '51', emoji: '', name: '하트',      svgPath: 'assets/system/sticker/deco/데코_하트.svg'),
      Sticker(id: '52', emoji: '', name: '하트4',     svgPath: 'assets/system/sticker/deco/데코_하트4.svg'),
      Sticker(id: '53', emoji: '', name: '하트4-1',   svgPath: 'assets/system/sticker/deco/데코_하트4-1.svg'),
      Sticker(id: '54', emoji: '', name: '하트5',     svgPath: 'assets/system/sticker/deco/데코_하트5.svg'),
      Sticker(id: '55', emoji: '', name: '화',        svgPath: 'assets/system/sticker/deco/데코_화.svg'),
    ],
    // 음식: id 56~73
    '음식': [
      Sticker(id: '56', emoji: '', name: '계란',    svgPath: 'assets/system/sticker/food/음식_계란.svg'),
      Sticker(id: '57', emoji: '', name: '고구마',  svgPath: 'assets/system/sticker/food/음식_고구마.svg'),
      Sticker(id: '58', emoji: '', name: '딸기',    svgPath: 'assets/system/sticker/food/음식_딸기.svg'),
      Sticker(id: '59', emoji: '', name: '레몬',    svgPath: 'assets/system/sticker/food/음식_레몬.svg'),
      Sticker(id: '60', emoji: '', name: '막대사탕',svgPath: 'assets/system/sticker/food/음식_막대사탕.svg'),
      Sticker(id: '61', emoji: '', name: '물',      svgPath: 'assets/system/sticker/food/음식_물.svg'),
      Sticker(id: '62', emoji: '', name: '밥그릇',  svgPath: 'assets/system/sticker/food/음식_밥그릇.svg'),
      Sticker(id: '63', emoji: '', name: '사과',    svgPath: 'assets/system/sticker/food/음식_사과.svg'),
      Sticker(id: '64', emoji: '', name: '사료',    svgPath: 'assets/system/sticker/food/음식_사료.svg'),
      Sticker(id: '65', emoji: '', name: '식빵',    svgPath: 'assets/system/sticker/food/음식_식빵.svg'),
      Sticker(id: '66', emoji: '', name: '아보카도',svgPath: 'assets/system/sticker/food/음식_아보카도.svg'),
      Sticker(id: '67', emoji: '', name: '커피',    svgPath: 'assets/system/sticker/food/음식_커피.svg'),
      Sticker(id: '68', emoji: '', name: '케이크',  svgPath: 'assets/system/sticker/food/음식_케이크.svg'),
      Sticker(id: '69', emoji: '', name: '케이크3', svgPath: 'assets/system/sticker/food/음식_케이크3.svg'),
      Sticker(id: '70', emoji: '', name: '쿠키',    svgPath: 'assets/system/sticker/food/음식_쿠키.svg'),
      Sticker(id: '71', emoji: '', name: '토마토',  svgPath: 'assets/system/sticker/food/음식_토마토.svg'),
      Sticker(id: '72', emoji: '', name: '토마토2', svgPath: 'assets/system/sticker/food/음식_토마토2.svg'),
      Sticker(id: '73', emoji: '', name: '푸딩',    svgPath: 'assets/system/sticker/food/음식_푸딩.svg'),
    ],
    // 마스킹테이프: id 74~94
    '마스킹테이프': [
      Sticker(id: '74', emoji: '', name: '동물1',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_동물1.svg'),
      Sticker(id: '75', emoji: '', name: '동물2',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_동물2.svg'),
      Sticker(id: '76', emoji: '', name: '동물3',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_동물3.svg'),
      Sticker(id: '77', emoji: '', name: '동물4',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_동물4.svg'),
      Sticker(id: '78', emoji: '', name: '땡떙이1', svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_땡떙이1.svg'),
      Sticker(id: '79', emoji: '', name: '땡떙이2', svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_땡떙이2.svg'),
      Sticker(id: '80', emoji: '', name: '땡떙이3', svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_땡떙이3.svg'),
      Sticker(id: '81', emoji: '', name: '무늬1',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무늬1.svg'),
      Sticker(id: '82', emoji: '', name: '무늬2',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무늬2.svg'),
      Sticker(id: '83', emoji: '', name: '무늬3',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무늬3.svg'),
      Sticker(id: '84', emoji: '', name: '무늬4',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무늬4.svg'),
      Sticker(id: '85', emoji: '', name: '무지1',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무지1.svg'),
      Sticker(id: '86', emoji: '', name: '무지2',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무지2.svg'),
      Sticker(id: '87', emoji: '', name: '무지3',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무지3.svg'),
      Sticker(id: '88', emoji: '', name: '무지4',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무지4.svg'),
      Sticker(id: '89', emoji: '', name: '무지5',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_무지5.svg'),
      Sticker(id: '90', emoji: '', name: '체크1',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_체크1.svg'),
      Sticker(id: '91', emoji: '', name: '체크2',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_체크2.svg'),
      Sticker(id: '92', emoji: '', name: '체크3',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_체크3.svg'),
      Sticker(id: '93', emoji: '', name: '체크4',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_체크4.svg'),
      Sticker(id: '94', emoji: '', name: '체크5',   svgPath: 'assets/system/sticker/maskingtape/마스킹테이프_체크5.svg'),
    ],
    // 문자: id 95~172
    '문자': [
      Sticker(id: '95',  emoji: '', name: '대사1',  svgPath: 'assets/system/sticker/message/문자_대사1.svg'),
      Sticker(id: '96',  emoji: '', name: '대사2',  svgPath: 'assets/system/sticker/message/문자_대사2.svg'),
      Sticker(id: '97',  emoji: '', name: '밈1',    svgPath: 'assets/system/sticker/message/문자_밈1.svg'),
      Sticker(id: '98',  emoji: '', name: '밈2',    svgPath: 'assets/system/sticker/message/문자_밈2.svg'),
      Sticker(id: '99',  emoji: '', name: '밈3',    svgPath: 'assets/system/sticker/message/문자_밈3.svg'),
      Sticker(id: '100', emoji: '', name: '밈4',    svgPath: 'assets/system/sticker/message/문자_밈4.svg'),
      Sticker(id: '111', emoji: '', name: '숫자공0', svgPath: 'assets/system/sticker/message/숫자공0.svg'),
      Sticker(id: '112', emoji: '', name: '숫자공1', svgPath: 'assets/system/sticker/message/숫자공1.svg'),
      Sticker(id: '113', emoji: '', name: '숫자공2', svgPath: 'assets/system/sticker/message/숫자공2.svg'),
      Sticker(id: '114', emoji: '', name: '숫자공3', svgPath: 'assets/system/sticker/message/숫자공3.svg'),
      Sticker(id: '115', emoji: '', name: '숫자공4', svgPath: 'assets/system/sticker/message/숫자공4.svg'),
      Sticker(id: '116', emoji: '', name: '숫자공5', svgPath: 'assets/system/sticker/message/숫자공5.svg'),
      Sticker(id: '117', emoji: '', name: '숫자공6', svgPath: 'assets/system/sticker/message/숫자공6.svg'),
      Sticker(id: '118', emoji: '', name: '숫자공7', svgPath: 'assets/system/sticker/message/숫자공7.svg'),
      Sticker(id: '119', emoji: '', name: '숫자공8', svgPath: 'assets/system/sticker/message/숫자공8.svg'),
      Sticker(id: '120', emoji: '', name: '숫자공9', svgPath: 'assets/system/sticker/message/숫자공9.svg'),
      Sticker(id: '121', emoji: '', name: '대A',    svgPath: 'assets/system/sticker/message/영어_대a.svg'),
      Sticker(id: '122', emoji: '', name: '대B',    svgPath: 'assets/system/sticker/message/영어_대b.svg'),
      Sticker(id: '123', emoji: '', name: '대C',    svgPath: 'assets/system/sticker/message/영어_대c.svg'),
      Sticker(id: '124', emoji: '', name: '대D',    svgPath: 'assets/system/sticker/message/영어_대d.svg'),
      Sticker(id: '125', emoji: '', name: '대E',    svgPath: 'assets/system/sticker/message/영어_대e.svg'),
      Sticker(id: '126', emoji: '', name: '대F',    svgPath: 'assets/system/sticker/message/영어_대f.svg'),
      Sticker(id: '127', emoji: '', name: '대G',    svgPath: 'assets/system/sticker/message/영어_대g.svg'),
      Sticker(id: '128', emoji: '', name: '대H',    svgPath: 'assets/system/sticker/message/영어_대h.svg'),
      Sticker(id: '129', emoji: '', name: '대I',    svgPath: 'assets/system/sticker/message/영어_대i.svg'),
      Sticker(id: '130', emoji: '', name: '대J',    svgPath: 'assets/system/sticker/message/영어_대j.svg'),
      Sticker(id: '131', emoji: '', name: '대K',    svgPath: 'assets/system/sticker/message/영어_대k.svg'),
      Sticker(id: '132', emoji: '', name: '대L',    svgPath: 'assets/system/sticker/message/영어_대l.svg'),
      Sticker(id: '133', emoji: '', name: '대M',    svgPath: 'assets/system/sticker/message/영어_대m.svg'),
      Sticker(id: '134', emoji: '', name: '대N',    svgPath: 'assets/system/sticker/message/영어_대n.svg'),
      Sticker(id: '135', emoji: '', name: '대O',    svgPath: 'assets/system/sticker/message/영어_대o.svg'),
      Sticker(id: '136', emoji: '', name: '대P',    svgPath: 'assets/system/sticker/message/영어_대p.svg'),
      Sticker(id: '137', emoji: '', name: '대Q',    svgPath: 'assets/system/sticker/message/영어_대q.svg'),
      Sticker(id: '138', emoji: '', name: '대R',    svgPath: 'assets/system/sticker/message/영어_대r.svg'),
      Sticker(id: '139', emoji: '', name: '대S',    svgPath: 'assets/system/sticker/message/영어_대s.svg'),
      Sticker(id: '140', emoji: '', name: '대T',    svgPath: 'assets/system/sticker/message/영어_대t.svg'),
      Sticker(id: '141', emoji: '', name: '대U',    svgPath: 'assets/system/sticker/message/영어_대u.svg'),
      Sticker(id: '142', emoji: '', name: '대V',    svgPath: 'assets/system/sticker/message/영어_대v.svg'),
      Sticker(id: '143', emoji: '', name: '대W',    svgPath: 'assets/system/sticker/message/영어_대w.svg'),
      Sticker(id: '144', emoji: '', name: '대X',    svgPath: 'assets/system/sticker/message/영어_대x.svg'),
      Sticker(id: '145', emoji: '', name: '대Y',    svgPath: 'assets/system/sticker/message/영어_대y.svg'),
      Sticker(id: '146', emoji: '', name: '대Z',    svgPath: 'assets/system/sticker/message/영어_대z.svg'),
      Sticker(id: '147', emoji: '', name: '소a',    svgPath: 'assets/system/sticker/message/영어_소a.svg'),
      Sticker(id: '148', emoji: '', name: '소b',    svgPath: 'assets/system/sticker/message/영어_소b.svg'),
      Sticker(id: '149', emoji: '', name: '소c',    svgPath: 'assets/system/sticker/message/영어_소c.svg'),
      Sticker(id: '150', emoji: '', name: '소d',    svgPath: 'assets/system/sticker/message/영어_소d.svg'),
      Sticker(id: '151', emoji: '', name: '소e',    svgPath: 'assets/system/sticker/message/영어_소e.svg'),
      Sticker(id: '152', emoji: '', name: '소f',    svgPath: 'assets/system/sticker/message/영어_소f.svg'),
      Sticker(id: '153', emoji: '', name: '소g',    svgPath: 'assets/system/sticker/message/영어_소g.svg'),
      Sticker(id: '154', emoji: '', name: '소h',    svgPath: 'assets/system/sticker/message/영어_소h.svg'),
      Sticker(id: '155', emoji: '', name: '소i',    svgPath: 'assets/system/sticker/message/영어_소i.svg'),
      Sticker(id: '156', emoji: '', name: '소j',    svgPath: 'assets/system/sticker/message/영어_소j.svg'),
      Sticker(id: '157', emoji: '', name: '소k',    svgPath: 'assets/system/sticker/message/영어_소k.svg'),
      Sticker(id: '158', emoji: '', name: '소l',    svgPath: 'assets/system/sticker/message/영어_소l.svg'),
      Sticker(id: '159', emoji: '', name: '소m',    svgPath: 'assets/system/sticker/message/영어_소m.svg'),
      Sticker(id: '160', emoji: '', name: '소n',    svgPath: 'assets/system/sticker/message/영어_소n.svg'),
      Sticker(id: '161', emoji: '', name: '소o',    svgPath: 'assets/system/sticker/message/영어_소o.svg'),
      Sticker(id: '162', emoji: '', name: '소p',    svgPath: 'assets/system/sticker/message/영어_소p.svg'),
      Sticker(id: '163', emoji: '', name: '소q',    svgPath: 'assets/system/sticker/message/영어_소q.svg'),
      Sticker(id: '164', emoji: '', name: '소r',    svgPath: 'assets/system/sticker/message/영어_소r.svg'),
      Sticker(id: '165', emoji: '', name: '소s',    svgPath: 'assets/system/sticker/message/영어_소s.svg'),
      Sticker(id: '166', emoji: '', name: '소t',    svgPath: 'assets/system/sticker/message/영어_소t.svg'),
      Sticker(id: '167', emoji: '', name: '소u',    svgPath: 'assets/system/sticker/message/영어_소u.svg'),
      Sticker(id: '168', emoji: '', name: '소v',    svgPath: 'assets/system/sticker/message/영어_소v.svg'),
      Sticker(id: '169', emoji: '', name: '소w',    svgPath: 'assets/system/sticker/message/영어_소w.svg'),
      Sticker(id: '170', emoji: '', name: '소x',    svgPath: 'assets/system/sticker/message/영어_소x.svg'),
      Sticker(id: '171', emoji: '', name: '소y',    svgPath: 'assets/system/sticker/message/영어_소y.svg'),
      Sticker(id: '172', emoji: '', name: '소z',    svgPath: 'assets/system/sticker/message/영어_소z.svg'),
    ],
    // 자연: id 173~203
    '자연': [
      Sticker(id: '173', emoji: '', name: '꽃',         svgPath: 'assets/system/sticker/nature/자연_꽃.svg'),
      Sticker(id: '174', emoji: '', name: '나무1',      svgPath: 'assets/system/sticker/nature/자연_나무1.svg'),
      Sticker(id: '175', emoji: '', name: '나무2',      svgPath: 'assets/system/sticker/nature/자연_나무2.svg'),
      Sticker(id: '176', emoji: '', name: '나뭇잎1',    svgPath: 'assets/system/sticker/nature/자연_나뭇잎1.svg'),
      Sticker(id: '177', emoji: '', name: '나뭇잎2',    svgPath: 'assets/system/sticker/nature/자연_나뭇잎2.svg'),
      Sticker(id: '178', emoji: '', name: '네잎클로버3', svgPath: 'assets/system/sticker/nature/자연_네잎믈로버3.svg'),
      Sticker(id: '179', emoji: '', name: '네잎클로버2', svgPath: 'assets/system/sticker/nature/자연_네잎클로버2.svg'),
      Sticker(id: '180', emoji: '', name: '눈사람1',    svgPath: 'assets/system/sticker/nature/자연_눈사람1.svg'),
      Sticker(id: '181', emoji: '', name: '눈사람2',    svgPath: 'assets/system/sticker/nature/자연_눈사람2.svg'),
      Sticker(id: '182', emoji: '', name: '달1',        svgPath: 'assets/system/sticker/nature/자연_달1.svg'),
      Sticker(id: '183', emoji: '', name: '딜2',        svgPath: 'assets/system/sticker/nature/자연_딜2.svg'),
      Sticker(id: '184', emoji: '', name: '땀2',        svgPath: 'assets/system/sticker/nature/자연_땀2.svg'),
      Sticker(id: '185', emoji: '', name: '무지개',     svgPath: 'assets/system/sticker/nature/자연_무지개.svg'),
      Sticker(id: '186', emoji: '', name: '번개1',      svgPath: 'assets/system/sticker/nature/자연_번개1.svg'),
      Sticker(id: '187', emoji: '', name: '번개2',      svgPath: 'assets/system/sticker/nature/자연_번개2.svg'),
      Sticker(id: '188', emoji: '', name: '번개3',      svgPath: 'assets/system/sticker/nature/자연_번개3.svg'),
      Sticker(id: '189', emoji: '', name: '번개4',      svgPath: 'assets/system/sticker/nature/자연_번개4.svg'),
      Sticker(id: '190', emoji: '', name: '별',         svgPath: 'assets/system/sticker/nature/자연_별.svg'),
      Sticker(id: '191', emoji: '', name: '별2',        svgPath: 'assets/system/sticker/nature/자연_별2.svg'),
      Sticker(id: '192', emoji: '', name: '별3',        svgPath: 'assets/system/sticker/nature/자연_별3.svg'),
      Sticker(id: '193', emoji: '', name: '붕어',       svgPath: 'assets/system/sticker/nature/자연_붕어.svg'),
      Sticker(id: '194', emoji: '', name: '비구름',     svgPath: 'assets/system/sticker/nature/자연_비구름.svg'),
      Sticker(id: '195', emoji: '', name: '산',         svgPath: 'assets/system/sticker/nature/자연_산.svg'),
      Sticker(id: '196', emoji: '', name: '연꽃잎',     svgPath: 'assets/system/sticker/nature/자연_연꽃잎.svg'),
      Sticker(id: '197', emoji: '', name: '클로버',     svgPath: 'assets/system/sticker/nature/자연_클로버.svg'),
      Sticker(id: '198', emoji: '', name: '튤립',       svgPath: 'assets/system/sticker/nature/자연_튤립.svg'),
      Sticker(id: '199', emoji: '', name: '풀숲',       svgPath: 'assets/system/sticker/nature/자연_풀숲.svg'),
      Sticker(id: '200', emoji: '', name: '해',         svgPath: 'assets/system/sticker/nature/자연_해.svg'),
      Sticker(id: '201', emoji: '', name: '해2',        svgPath: 'assets/system/sticker/nature/자연_해2.svg'),
      Sticker(id: '202', emoji: '', name: '해2-1',      svgPath: 'assets/system/sticker/nature/자연_해2-1.svg'),
      Sticker(id: '203', emoji: '', name: '햇빛',       svgPath: 'assets/system/sticker/nature/자연_햇빛.svg'),
    ],
    // 메모지: id 204~218
    '메모지': [
      Sticker(id: '204', emoji: '', name: '공책1',    svgPath: 'assets/system/sticker/notepaper/메모지_공책1.svg'),
      Sticker(id: '205', emoji: '', name: '공책2',    svgPath: 'assets/system/sticker/notepaper/메모지_공책2.svg'),
      Sticker(id: '206', emoji: '', name: '공책3',    svgPath: 'assets/system/sticker/notepaper/메모지_공책3.svg'),
      Sticker(id: '207', emoji: '', name: '공책4',    svgPath: 'assets/system/sticker/notepaper/메모지_공책4.svg'),
      Sticker(id: '208', emoji: '', name: '공책5',    svgPath: 'assets/system/sticker/notepaper/메모지_공책5.svg'),
      Sticker(id: '209', emoji: '', name: '공책6',    svgPath: 'assets/system/sticker/notepaper/메모_공책6.svg'),
      Sticker(id: '210', emoji: '', name: '꾸밈1',    svgPath: 'assets/system/sticker/notepaper/메모지_꾸밈1.svg'),
      Sticker(id: '211', emoji: '', name: '꾸밈2',    svgPath: 'assets/system/sticker/notepaper/메모지_꾸밈2.svg'),
      Sticker(id: '212', emoji: '', name: '꾸밈3',    svgPath: 'assets/system/sticker/notepaper/메모_꾸밈3.svg'),
      Sticker(id: '213', emoji: '', name: '모눈',     svgPath: 'assets/system/sticker/notepaper/메모지_모눈.svg'),
      Sticker(id: '214', emoji: '', name: '웹창',     svgPath: 'assets/system/sticker/notepaper/메모_웹창.svg'),
      Sticker(id: '215', emoji: '', name: '체크1',    svgPath: 'assets/system/sticker/notepaper/메모지_체크1.svg'),
      Sticker(id: '216', emoji: '', name: '체크2',    svgPath: 'assets/system/sticker/notepaper/메모지_체크2.svg'),
      Sticker(id: '217', emoji: '', name: '체크3',    svgPath: 'assets/system/sticker/notepaper/메모지_체크3.svg'),
      Sticker(id: '218', emoji: '', name: '체크리스트', svgPath: 'assets/system/sticker/notepaper/메모_체크리스트.svg'),
    ],
    // 소품: id 219~238
    '소품': [
      Sticker(id: '219', emoji: '', name: '공책',    svgPath: 'assets/system/sticker/props/소품_공책.svg'),
      Sticker(id: '220', emoji: '', name: '그림판',   svgPath: 'assets/system/sticker/props/소품_그림판.svg'),
      Sticker(id: '221', emoji: '', name: '디데이',   svgPath: 'assets/system/sticker/props/소품_디데이.svg'),
      Sticker(id: '222', emoji: '', name: '물감1',    svgPath: 'assets/system/sticker/props/소품_물감1.svg'),
      Sticker(id: '223', emoji: '', name: '물감2',    svgPath: 'assets/system/sticker/props/소품_물감2.svg'),
      Sticker(id: '224', emoji: '', name: '물감3',    svgPath: 'assets/system/sticker/props/소품_물감3.svg'),
      Sticker(id: '225', emoji: '', name: '발자국1',  svgPath: 'assets/system/sticker/props/소품_발자국1.svg'),
      Sticker(id: '226', emoji: '', name: '발자국2',  svgPath: 'assets/system/sticker/props/소품_발자국2.svg'),
      Sticker(id: '227', emoji: '', name: '베개',     svgPath: 'assets/system/sticker/props/소품_베개.svg'),
      Sticker(id: '228', emoji: '', name: '베개2',    svgPath: 'assets/system/sticker/props/소품_베개2.svg'),
      Sticker(id: '229', emoji: '', name: '시계',     svgPath: 'assets/system/sticker/props/소품_시계.svg'),
      Sticker(id: '230', emoji: '', name: '연필1',    svgPath: 'assets/system/sticker/props/소품_연필1.svg'),
      Sticker(id: '231', emoji: '', name: '연필2',    svgPath: 'assets/system/sticker/props/소품_연필2.svg'),
      Sticker(id: '232', emoji: '', name: '연필3',    svgPath: 'assets/system/sticker/props/소품_연필3.svg'),
      Sticker(id: '233', emoji: '', name: '연필4',    svgPath: 'assets/system/sticker/props/소품_연필4.svg'),
      Sticker(id: '234', emoji: '', name: '집1',      svgPath: 'assets/system/sticker/props/소품_집1.svg'),
      Sticker(id: '235', emoji: '', name: '집2',      svgPath: 'assets/system/sticker/props/소품_집2.svg'),
      Sticker(id: '236', emoji: '', name: '카메라1',  svgPath: 'assets/system/sticker/props/소품_카메라1.svg'),
      Sticker(id: '237', emoji: '', name: '카메라2',  svgPath: 'assets/system/sticker/props/소품_카메라2.svg'),
      Sticker(id: '238', emoji: '', name: '팔레트',   svgPath: 'assets/system/sticker/props/소품_팔레트.svg'),
    ],
    // 장난감: id 239~246
    '장난감': [
      Sticker(id: '239', emoji: '', name: '공1',    svgPath: 'assets/system/sticker/toy/장난감_공1.svg'),
      Sticker(id: '240', emoji: '', name: '공2',    svgPath: 'assets/system/sticker/toy/장난감_공2.svg'),
      Sticker(id: '241', emoji: '', name: '공3',    svgPath: 'assets/system/sticker/toy/장난감_공3.svg'),
      Sticker(id: '242', emoji: '', name: '목줄',   svgPath: 'assets/system/sticker/toy/장난감_목줄.svg'),
      Sticker(id: '243', emoji: '', name: '뼈다귀', svgPath: 'assets/system/sticker/toy/장난감_뼈다귀.svg'),
      Sticker(id: '244', emoji: '', name: '삑삑이', svgPath: 'assets/system/sticker/toy/장난감_삑삑이.svg'),
      Sticker(id: '245', emoji: '', name: '양말',   svgPath: 'assets/system/sticker/toy/장난감_양말.svg'),
      Sticker(id: '246', emoji: '', name: '털실',   svgPath: 'assets/system/sticker/toy/장난감_털실.svg'),
    ],
  };

  bool get isSearching => _searchController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // 검색창 포커스 시 80%로 확장
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _sheetController.animateTo(
          0.8,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    _sheetController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  void _onStickerTap(Sticker sticker) {
    Navigator.pop(context, sticker);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double initialHeight = 400.0;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: initialHeight / screenHeight,
      minChildSize: initialHeight / screenHeight,
      maxChildSize: 0.8,
      expand: true,
      builder: (context, scrollController) {
        // 스크롤 시작 시 80%로 확장
        scrollController.addListener(() {
          if (scrollController.offset > 0 &&
              _sheetController.size < 0.8) {
            _sheetController.animateTo(
              0.8,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(
              top: BorderSide(color: AppColors.gray01, width: 1.5),
              left: BorderSide(color: AppColors.gray01, width: 1.5),
              right: BorderSide(color: AppColors.gray01, width: 1.5),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                offset: Offset(0, -4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppTextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      hintText: '검색어를 입력해주세요.',
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
                        icon: SvgPicture.asset(
                          'assets/system/icons/icon_close_big.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.gray04,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )                          : null,
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryTabs(),
                  const SizedBox(height: 16),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) {
                    final stickers = _stickersByCategory[category] ?? [];

                    if (stickers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/system/icons/icon_image_not_supported.svg',
                              width: 64,
                              height: 64,
                              colorFilter: const ColorFilter.mode(
                                AppColors.gray03,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '스티커가 없습니다',
                              style: AppTextStyle.description14R120.copyWith(
                                color: AppColors.f03,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        const int crossAxisCount = 4;
                        const double spacing = 16;
                        const double padding = 20;
                        final double itemSize = (constraints.maxWidth - padding * 2 - spacing * (crossAxisCount - 1)) / crossAxisCount;
                        final double stickerSize = itemSize;

                        return GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(padding, 0, padding, 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: 1,
                          ),
                          itemCount: stickers.length,
                          itemBuilder: (context, index) {
                            final sticker = stickers[index];
                            return GestureDetector(
                              onTap: () => _onStickerTap(sticker),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: sticker.svgPath != null
                                      ? SvgPicture.asset(
                                    sticker.svgPath!,
                                    width: stickerSize * 0.65,
                                    height: stickerSize * 0.65,
                                  )
                                      : Text(
                                    sticker.emoji,
                                    style: TextStyle(fontSize: stickerSize * 0.5),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // ✕ 엑스: Navigator.pop (반환값 없음 = 취소)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/system/icons/icon_close_big.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.f05,
                BlendMode.srcIn,
              ),
            ),
          ),

          // 중앙 "스티커" 텍스트
          Expanded(
            child: Center(
              child: Text('스티커', style: AppTextStyle.description14R120),
            ),
          ),

          // ✓ 체크: Navigator.pop (반환값 없음 = 확인)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/system/icons/icon_check.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.f05,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      controller: _tabScrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_categories.length, (index) {
          final isSelected = _tabController.index == index;
          return GestureDetector(
            onTap: () => _tabController.animateTo(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < _categories.length - 1 ? 12 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isSelected ? AppColors.f05 : AppColors.f02,
                  width: 1.5,
                ),
              ),
              child: Text(
                _categories[index],
                style: AppTextStyle.description14M120.copyWith(
                  color: isSelected ? AppColors.f05 : AppColors.f02,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}