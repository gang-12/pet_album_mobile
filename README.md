## 해야할일

- 아이콘 -> svg로 수정
- 로그인 화면 SNS 로그인 로고 svg 로 바꾸기 (원도 만들어줘야함)
- 
- 
- 반려동물 캐릭터관리 페이지 수정
- - 삭제 버튼 , 플러스 버튼 ( 버튼은 core 페이지에서 수정해야할듯)
- 
- 그리고 core 페이지 버튼 한번더 확인하기

# 2026-02-27-수정사할
- 메인화면 버튼 app_common_button_styles.dart 사용하여 수정
- 로그아웃, 회원탈퇴 버튼 app_custom_button.dart 페이지 새로 생성하여 수정
- 로그인화면 -SNS 로그인- 길이 수정
- 반려동물 캐릭터 관리화면 svg로 수정 pet_list.dart / +버튼  스타일 수정
- 펫카드 삭제 선택 라디오버튼 -> 전체 스트로크로 수정 / 삭제 팝업 수정
- 반려동물 추가 수정중


# 2026-02-26-수정사항
- 설정페이지 로그아웃 팝업창 제작 / 취소,로그아웃 클릭시 각각의 화면으로 이동 ()
- - lib/widgets/withdrawal_page.dart(회원탈퇴페이지)
- 회원탈퇴 인증번호 페이지 제작 
- - lib/widgets/Withdrawal_Certification.dart(회원탈퇴인증 페이지)

# 2026-02-25-수정사항
- 회원가입 svg 오류 수정 /위치 수정
- 홈화면 앨범 생성으로 변경 / 홈화면 앱비 수정
- 알람 페이지 수정~~~~
- 펫카드 개발자님 정보로 변경

# 2026-02-24-수정사항
- 로그인 화면 버튼 하단으로 위치수정 -또는- 길이 수정~~~~
- 회원가입화면 텍스트 스타일 버튼 위치 수정
- 로그인 화면 png ->svg 수정 
- 마이페이지 설정 아이콘 SVG 수정
- 


# 2026-02-23-수정사항
- 펫카드 가로 길이 아래 정보카드랑 길이 통일
- 로그인 창 구글 로그인 폰트 버튼크기 아이콘 크기 위치 수정
- 설정 페이지 패딩값 수정
- 나의앨범 돋보기 선택 버튼  svg와 폰트로 변경
- 파일안에 모든 아이콘 svg 파일 저장
- 네비게이션바 아이콘svg로 수정


# 2026-02-20-수정사항
- 로그인 카카오 로그인에 맞춰서 구글 로그인 버튼 수정
- 로그인 화면 로고 디자인한 작업물로 수정
- 마이페이지 안 설정 텍스트스타일, 컬러 , 아이콘 svg 변경
- - 설정 _item 패딩값 수정중

# 2026-02-19-수정사항
- 마이페이지 아래 설정부분 패딩값 설정
- 반려동물 정보 패딩값 수정
  (성향, 건강, 복용약)
-
- 앱바 텍스트 수정, 앱바 배경 투명으로 설정(스크롤시 제외)
- 백 앱바 < 폰트 svg 파일로 수정, 

# 2026-02-13-수정사항
- 네비게이션바 색상 수정
- 마이페이지 아이디 카드를 제외한 부분 색상 간격 라운드 수정
- 나의앨범 아이콘 북마크, +버튼 수정
- 나의 앨범 미트볼 버튼(...) 안의 ~~~~요소 수정



# 2026-03-03-수정사항(Km)
- 앨범 그리드 아이템 UI 리팩토링
- 이미지 3:4 비율 고정 및 radius 12 적용
- 앨범 이미지 에셋 경로 오류 수정
- 이미지 로딩 오류(Unable to load asset) 해결
- 카드 그림자 Figma 기준(0 4px 12px rgba(0,0,0,0.08)) 통일
- 선택 모드(select mode) 기능 추가
- 선택 시 2.5px 메인 컬러 보더 적용
- 그라디언트 오버레이 및 우측 하단 선택 UI 구현
- 기본 모드 / 선택 모드 탭 동작 분기 처리
- 기본: 상세 페이지(AlbumViewPage) 이동
- 선택: onSelectTap 콜백 실행
- kebab 메뉴 SVG(icon_kebab_menu.svg) 교체 및 컬러 적용
- 선택 모드에서는 비노출
- 이미지가 없는 경우에도 레이아웃 유지하도록 기본 배경 처리
- 선택 라디오 아이콘 위치 수정

- 앨범 검색 페이지 UI 구조 개선
- 검색창 하단 고정 및 최근/검색 결과 분기 처리
- Grid 비율 동적 계산 적용
- 자동 포커스 기능 추가 (FocusNode 적용)
- AppTextField에 focusNode 파라미터 추가

- AppTextField 내부 구조 리팩토링
- 내부 padding 10px 적용
- 아이콘 간 간격 8px 적용 (Row 기반 구조로 변경)
- InputDecoration 기본 padding 제거 및 레이아웃 단순화
- 검색 아이콘 SVG 에셋(icon_search.svg) 적용 및 컬러 필터 처리
- 검색창 컨테이너 상단 radius 16 및 상단 그림자 적용
- 키보드 노출 시 검색창이 하단에 고정되도록 구조 정리

# 2026-03-05-수정사항(Km)
- background_template_sheet
- 바 삭제
- 엑스 아이콘, 체크 아이콘, “배경” 추가
- “배경 템플릿” 삭제
- 사진추가 클릭 - photo_gallery_sheet.dart 연결
- const Expanded 오류 해결
- BackgroundTabletPanel 오류  - onSave 추가
- icon_check 오류 해결
- "색상" 텍스트 삭제
- 전체 높이 수정
- 배경템플릿 사이 간격 수정
- 사진 추가 템플릿 icon_add 색상 수정
- 
- color_pickup_sheet
- 바 삭제
- 엑스, 체크 아이콘 추가
- hex 삭제
- icon_dropper svg추가
- 색상 stroke 2.5로 수정
- 
- color_select_scale
- 색상 stroke 2.5로 수정

# 2026-03-06-수정사항(Km)
- photo_gallery_sheet 
- 바 삭제 
- 엑스, 체크, “사진” 추가
- 업로드 버튼 삭제 
- 최근항목 드롭다운 바 내리면 아이콘 변경 
- 사진 찍는 화면 연동
- 
- sticker_search_bottom_sheet
- 바 삭제
- 엑스 아이콘, 체크 아이콘, “스티커” 추가
- 카테고리 ui 수정 + 간격 수정
- 검색 필드 수정 (입력 시 상하 정렬)
- 시트 닫기 임시 기능 추가 

# 2026-03-09-수정사항
- app_text_field
- 기본 텍스트 스타일 고정  AppTextStyle.body16R120
- 입력 시 텍스트 컬러 f05로 수정
- 
- album_search_page
- 텍스트 필드 스타일 제거

# 2026-09-10-수정사항
- drawing_tool_sheet
- 바 삭제
- 엑스 아이콘, 체크 아이콘, “그리기” 추가
- +, - 아이콘 삭제
- 섹션라벨 삭제
- 전체 패딩, 간격 수정
- 선두께 ui 수정
- 선 스타일 ui 수정
- 시트 닫는 기능 오류 해결
- 
- photo_gallery_sheet
- 핸들바 아이콘 svg로 수정
- 비디오 아이콘 수정
- 
- album_create_sheet 페이지 생성
- icon svg로 변경
- 버튼 수정 ui 수정


# 2026-03-11-수정사항
- album 폴더 안 icon 모두 svg로 변경
- album_crud/edit 폴더 안 icon 모두 svg로 변경
- 
- album_create_sheet, album_search_page, sticker_search_sheet
- 검색 필드 icon_close 수정
- 
- album_create_sheet 
- 텍스트 문구 수정 
- 버튼 수정 
- 핸들 바 삭제 
- 
- album_menu_board_sheet 
- icon 모두 svg로 변경 
- 
- album_common_actions 
- showAlbumMenu에 onCopy 파라미터 추가 
- onShare SnackBar UI 수정
- 토스트 바 색상 수정 및 블러 효과 추가
- 
- album_page, album_search_page 
- 복사 기능 구현 (_duplicateAlbum: 앨범 복제 시 "제목(2)", "제목(3)" 형태로 생성)
- 
- album_page
- '선택' 텍스트 버튼 터치 영역 수정

# 2026-03-12-수정사항
- sticker_search_bottom_sheet
- 아이콘 검색, 스크롤 시 바텀 시트 영역 전체화면의 80%로 확장되도록 수정
- 
- drawing_tool_sheet
- x아이콘, v아이콘 클릭 시 Navigator.pop() → widget.onClose() 로 변경
- 선 종류 통일 (실선 / 점선 / 파선)
- 
- album_edit_form
- DrawingPoint에 lineStyle 필드 추가
- 선 스타일 변경 후 그리는 획부터만 새 스타일 적용, 이전 획 유지
- 점선 두께 반영: dotRadius / dotGap을 strokeWidth 기준으로 변경
- 파선 두께 반영: dashWidth / dashSpace를 strokeWidth 기준으로 변경
- 그리기 터치 영역 / 획 표시 레이어 분리
- x/v 클릭 시 드로잉 모드 비활성화

# 2026-03-13-수정사항
- album_view.dart
- album 데이터 파라미터 연결 (타이틀, 이미지, 북마크)
- 더보기 버튼 아이콘 수정
- 더보기 버튼 편집/복사/북마크/삭제 연결
- 편집 버튼 AlbumEditFormPage 이동 연결
- onDelete 콜백 호출 후 뷰 페이지만 닫도록 수정
- 
- album_page.dart
- _navigateToView 추가, AlbumGridItem onTap 연결
- AlbumGridItem에 album 파라미터 추가
- 
- album_search_page.dart
- AlbumGridItem에 album 파라미터 추가
- 
- album_grid_item.dart
- album 파라미터 추가, AlbumViewPage에 전달
- 
- album_menu_board_sheet
- 편집 Navigator.pop 후 onEdit() 콜백으로 변경
- 
- background_template_sheet 
- 사진 추가 선택 시 단일 선택 사진 시트 연결하도록 수정
- 기존 PhotoGalleryBottomSheet 유지
- 
- PhotoGallerySingleBottomSheet 추가
- 사진 단일 선택 전용 gallery_sheet
- 아이콘 변경
- 드롭다운 바 추가


## 바텀시트 기능을 전 페이지에서 동일하게 동작하도록 통일 요청
- 현재 앨범 더보기(바텀시트) 기능이 페이지마다 따로 동작하여 한 페이지에서 변경한 상태(북마크 등)가 다른 페이지에 반영되지 않습니다.
- 요청사항:
* 앨범 바텀시트 기능을 공통 로직으로 통합
* 어떤 페이지에서 상태를 변경해도 모든 페이지에 동일하게 반영되도록 수정
* 예) view에서 북마크 → album_page / 리스트 / 상세 / 더보기 모두 동일 적용

# 2026-03-16-수정사항
- Impact.ttf 폰트 추가
- MemomentKkukkukk.ttf 폰트 추가
- Pretendard-ExtraBold.otf 폰트 추가
- Pretendard-Regular.otf 폰트 추가
- Soap Regular.ttf 폰트 추가
- 
- text_style_sheet 추가


# 2026-03-17-수정사항
- text_edit_button_list_box
- import 수정
- 
- text_style_sheet
- FontItem 크기 수정
- 패딩값 전체 수정
- 
- album_view
- 더보기 - 삭제 팝업 창 수정 및 delete_modal 연결
- 
- album_icon_button_list_box
- 텍스트 색상 변경 시트 핸들바 수정 
- onFontPressed를 text_style_sheet 연결

# 2026-03-18-수정사항
- photo_gallery_single_sheet
- 카메라 셀 추가
- 
- color_pickup_sheet
- + 아이콘 선 추가
- 바 삭제
- 엑스, 체크 아이콘 추가
- 스포이드 svg추가
- hex 삭제
- 
- color_select_scale_sheet
- import 정리
- _addColor 이중 호출 제거

# 2026-03-19-수정사항
- Album edit form
- 완료 기능 추가
- 앱바 텍스트 가운데로 위치 
- 
- core/theme/font 경로 추가
- font style 파일 import 전체 수정
- 
- 텍스트 수정 바
- 색상 적용
- 폰트 스타일 적용
- 밑줄 적용
- 체크 아이콘 적용

# 2026-03-20-수정사항
- 폰트 추가
- 김씨 손맛체.ttf
- BMKkubulim.otf
  BookkMyungjo.ttf
- Cafe24PROUP.otf
- Caveat-VariableFont_wght.ttf
- IndieFlower.ttf
- TAEBAEK milkyway.otf
- TitanOne.ttf
- YoonChildfundkoreaManSeh.otf
- ZenSerif.otf
- 고령딸기체.otf
- 만년설체.ttf
- 
- text_style_sheet
- LTIM 삭제
- 텍스트 스타일 추가
- 스크롤 기능 추가
- 폰트 그리드 수정

# 2026-03-23-수정사항
- 스티커 파일 전체 추가
- 
- stiker_search_bottom_sheet
- 스티커 전체 삭제 및 추가

# 2026-03-24-수정사항
- stiker_search_bottom_sheet
- 카테고리 클릭시 가운데로 자동 스크롤
- 스티커 배경 색 추가 
- 간격 수정

# 2026-03-25-수정사항/tnrjs
- icon_zoom_inout.svg 추가
- 
- album_edit_form
- 텍스트 입력 후 텍스트 보조 아이콘, ui 수정 
- 텍스트 기본 크기 20으로 수정
- 
- photo_gallery_sheet
- 비디오 아이콘 삭제 (비디오는 안뜨도록
- 
- sticker_search_bottom_sheet
- 카테고리 자동 스크롤 추가
- 
- album_edit_form, text_edit_button_list_box
- 스티커 선택 시 편집 페이지에 추가
- 이동, 삭제, 크기 조절 가능

# 2026-03-26,27-수정사항
- background_template 추가
- icon_autorenew 추가
- 
- background_template_sheet
- template 추가
- 
- album_edit_form
- 레이어 순서 변경으로 background_sheet 위에 스티커, 텍스트 보이던 문제 해결
- 아이템 터치 시 최상단 레이어에 오도록 수정
- 회전 기능 추가 CanvasItem에 angle 속성을 추가
- 앱바에 앨범 제목 수정 기능 추가
- background_template 적용