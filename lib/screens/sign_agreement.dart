import 'package:flutter/material.dart';
import '../common/ui_common.dart';
import '../common/style.dart';
import 'package:flutter_html/flutter_html.dart';
import 'sign_up.dart';

class AgreementScreen extends StatefulWidget {
	AgreementScreen({
		Key key,
		this.title
	}): super(key: key);
	final String title;
	@override
	_AgreementStat createState() => _AgreementStat();
}

class _AgreementStat extends State < AgreementScreen > {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			home: Scaffold(
				bottomNavigationBar: Padding(
					padding: EdgeInsets.all(0),
					child: RaisedButton(
						padding: EdgeInsets.all(15),
						onPressed: () async {
							if(!termsChecked || !privacyChecked){
								UICommon.alert(context, "이용 약관과 개인정보 수집에\n모두 동의하셔야 합니다.");
							}else{
								await Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
							}
						},
						color: BgColor.main,
						textColor: BgColor.white,
						child: Text('다음 단계'),
					),
				),
				appBar: AppBar(
					leading: IconButton(
						icon: Icon(
							Icons.arrow_back
						),
						tooltip: 'Navigation menu',
						onPressed: () {
							Navigator.of(context).pop();
						}
					),
					iconTheme: IconThemeData(
						color: Colors.black, //change your color here
					),
					title: Text(
						'약관 동의',
						style: TextFont.big_n,
					),
					backgroundColor: BgColor.white,
				),
				body: Container(
					padding: EdgeInsets.only(left: 20, right: 20),
					height: MediaQuery.of(context).size.height,
					decoration: BoxDecoration(
						color: BgColor.white
					),
					child: SingleChildScrollView(
						child: Column(
							children: [
								Container(
									child: Pagevle() // 테이블 넣기 하단에 위젯으로 빼둠
								)
							],
						)
					)
				)
			)
		);
	}
}

bool allChecked = false;
bool termsChecked = false;
bool privacyChecked = false;

//화면구성
class Pagevle extends StatefulWidget {
	@override
	_PagevleItem createState() => _PagevleItem();
}

class _PagevleItem extends State < Pagevle > {

	Widget build(BuildContext context) {
		return Column(
			children: [
				Container(
					decoration: BoxDecoration(
						color: BgColor.white,
						border: BorderDirectional(
							bottom: BorderSide(
								color: Color.fromRGBO(112, 112, 112, 0.25),
								style: BorderStyle.solid),
						),
					),
					child: Container(
						height: 60,
						child: Row(
							children: [
								Expanded(
									child: Text(
										'모두 동의 합니다',
										style: TextFont.semibig,
									)
								),
								Container(
									margin: EdgeInsets.only(right: 5),
									child: SizedBox(
										height: 24.0,
										width: 24.0,
										child: Checkbox(
											value: allChecked,
											onChanged: (bool value) {
												setState(() {
													allChecked = value;
													termsChecked = value;
													privacyChecked = value;
												});
											},
										),
									)
								),
								Container(
									child: Text(
										'동의',
										style: TextFont.medium,
									)
								),
							],
						),
					)
				),
				Container(
					decoration: BoxDecoration(
						color: BgColor.white,
						border: BorderDirectional(
							bottom: BorderSide(
								color: Color.fromRGBO(112, 112, 112, 0.25),
								style: BorderStyle.solid),
						),
					),
					child: Container(
						height: 60,
						child: Row(
							children: [
								Expanded(
									child: Text(
										'이용약관 동의 (필수)',
										style: TextFont.medium,
									)
								),
								Container(
									margin: EdgeInsets.only(right: 5),
									child: InkWell(
										child: Container(
											decoration: BoxDecoration(
												color: BgColor.black45,
												borderRadius: Radii.radi10
											),
											padding: EdgeInsets.only(top: 7, bottom: 7, left: 12, right: 12, ),
											child: Text(
												'이용약관보기',
												style: TextFont.normal_w
											),
										),
										onTap: () {
											showDialog(
												context: context,
												builder: (BuildContext newContext) {
													return PrivacyPop();
												},
											);
										},
									)
								),
								Container(
									margin: EdgeInsets.only(right: 5),
									child: SizedBox(
										height: 24.0,
										width: 24.0,
										child: Checkbox(
											value: termsChecked,
											onChanged: (bool value) {
												setState(() {
													termsChecked = value;
												});
											},
										),
									)
								),
								Container(
									child: Text(
										'동의',
										style: TextFont.medium,
									)
								),
							],
						),
					)
				),
				Container(
					decoration: BoxDecoration(
						color: BgColor.white,
						border: BorderDirectional(
							bottom: BorderSide(
								color: Color.fromRGBO(112, 112, 112, 0.25),
								style: BorderStyle.solid),
						),
					),
					child: Container(
						height: 60,
						child: Row(
							children: [
								Expanded(
									child: Text(
										'개인정보 수집 동의 (필수)',
										style: TextFont.medium,
									)
								),
								Container(
									margin: EdgeInsets.only(right: 5),
									child: InkWell(
										child: Container(
											decoration: BoxDecoration(
												color: BgColor.black45,
												borderRadius: Radii.radi10
											),
											padding: EdgeInsets.only(top: 7, bottom: 7, left: 12, right: 12, ),
											child: Text(
												'처리방침보기',
												style: TextFont.normal_w
											),
										),
										onTap: () {
											showDialog(
												context: context,
												builder: (BuildContext newContext) {
													return PolicyPop();
												},
											);
										},
									)
								),
								Container(
									margin: EdgeInsets.only(right: 5),
									child: SizedBox(
										height: 24.0,
										width: 24.0,
										child: Checkbox(
											value: privacyChecked,
											onChanged: (bool value) {
												setState(() {
													privacyChecked = value;
												});
											},
										),
									)
								),
								Container(
									child: Text(
										'동의',
										style: TextFont.medium,
									)
								),
							],
						),
					)
				),
			],
		);
	}
}

//약관동의 팝업
class PrivacyPop extends StatefulWidget {
	PrivacyPop({
		Key key
	}): super(key: key);
	@override
	_PrivacyPopIn createState() => _PrivacyPopIn();
}

class _PrivacyPopIn extends State < PrivacyPop > {
	Widget build(BuildContext context) {
		return AlertDialog(
			titlePadding: EdgeInsets.all(0),
			actionsPadding: EdgeInsets.all(0),
			contentPadding: EdgeInsets.all(0),
			title: Container(
				padding: EdgeInsets.all(15),
				width: double.infinity,
				decoration: BoxDecoration(
					color: BgColor.main
				),
				child: Text(
					'이용약관',
					style: TextFont.medium_w,
				),
			),
			content: SingleChildScrollView(
				padding: EdgeInsets.all(15),
				child: Container(
					width: MediaQuery.of(context).size.width,
					child: PrivacyTexts()
				)
			),
			actions: < Widget > [
				Container(
					decoration: BoxDecoration(
						color: BgColor.lgray
					),
					width: MediaQuery.of(context).size.width,
					child: FlatButton(
						onPressed: () {
							Navigator.of(context).pop();
						},
						textColor: Theme.of(context).primaryColor,
						child: Text(
							'닫기',
							style: TextFont.medium
						),
					),
				),
			],
		);
	}
}

//개인정보 수집 팝업
class PolicyPop extends StatefulWidget {
	PolicyPop({
		Key key
	}): super(key: key);
	@override
	_PolicyPopIn createState() => _PolicyPopIn();
}

class _PolicyPopIn extends State < PolicyPop > {
	Widget build(BuildContext context) {
		return AlertDialog(
			titlePadding: EdgeInsets.all(0),
			actionsPadding: EdgeInsets.all(0),
			contentPadding: EdgeInsets.all(0),
			title: Container(
				padding: EdgeInsets.all(15),
				width: double.infinity,
				decoration: BoxDecoration(
					color: BgColor.main
				),
				child: Text(
					'개인정보 수집',
					style: TextFont.medium_w,
				),
			),
			content: SingleChildScrollView(
				padding: EdgeInsets.all(15),
				child: Container(
					width: MediaQuery.of(context).size.width,
					child: PolicyTexts()
				)
			),
			actions: < Widget > [
				Container(
					decoration: BoxDecoration(
						color: BgColor.lgray
					),
					width: MediaQuery.of(context).size.width,
					child: FlatButton(
						onPressed: () {
							Navigator.of(context).pop();
						},
						textColor: Theme.of(context).primaryColor,
						child: Text(
							'닫기',
							style: TextFont.medium
						),
					),
				),
			],
		);
	}
}

class PrivacyTexts extends StatefulWidget {
	PrivacyTexts({
		Key key
	}): super(key: key);
	@override
	_PrivacyTextsIn createState() => _PrivacyTextsIn();
}

class _PrivacyTextsIn extends State < PrivacyTexts > {
	Widget build(BuildContext context) {
		return Container(
			child: Html(
				data: htmlData,
			)
		);
	}
}

class PolicyTexts extends StatefulWidget {
	PolicyTexts({
		Key key
	}): super(key: key);
	@override
	_PolicyTextsIn createState() => _PolicyTextsIn();
}

class _PolicyTextsIn extends State < PolicyTexts > {
	Widget build(BuildContext context) {
		return Container(
			child: Html(
				data: htmlDataPolice,
			)
		);
	}
}

const htmlData = """
<pre>
서비스 이용 약관
[우미건설 정책]

이용약관

제1조 목적
이 약관은 우미건설(주)(이하 [회사]라 함)이 제공하는 제품 및 온라인 서비스(이하 합하여 [서비스]라 함)를 [회원]에 가입하여 이용하거나 가입 없이 이용함에 있어서 회사와 [이용자]의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
웹페이지, 모바일 어플리케이션 또는 모바일 웹 등을 이용하는 온라인 서비스에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용 합니다.

제2조 정의
이 약관에서 사용하는 용어의 정의는 다음과 같습니다.
(1) 제품 및 인터넷 관련서비스(이하 [서비스])라 웹페이지 및 모바일 어플리케이션 또는 모바일 웹 상에서 제공하는 제품 및 온라인 서비스를 말합니다.
(2) [[이용자]]란 회원으로 가입하거나 가입하지 아니하고 이 약관에 따라 회사가 제공하는 서비스를
받는 사람을 말합니다.
(3) 이 약관에 사용되는 용어 중 본 조에서 정하지 않은 부분은 관계법령 및 일반 관례에 따릅니다.

제3조 약관의 명시와 개정
(1) [회사]는 이 약관의 내용과 상호, 영업소 소재지, 대표자의 성명, 사업자등록 번호, 연락처 등을 [회원]이 알 수 있도록 [서비스]내 화면에 게시합니다.
(2) [회사]는 약관의 규제 등에 관한 법률, 전자거래 기본법, 전자서명법, 정보통신망 이용 촉진 등에 관한 법률, 방문 판매 등에 관한 법률, 소비자 보호법 등 관련 법을 위배하지 않는 범위 에서 이 약관을 개정할 수 있습니다.
(3) [회사]가 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행 약관과 함께 [서비스] 화면에 적용일자 전일까지 공지합니다.
(4) [회사]가 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정전의 약관 조항이 그대로 적용됩니다.
(5) [이용자]가 개정약관의 적용에 동의하지 않는 경우 [회사]는 해당 [회원]에 대해 개정 약관의 내용을 적용할 수 없으며, 이 경우 [이용자]는 이용계약을 해지할 수 있습니다.

제4조 서비스의 제공 및 변경
[회사]는 다음과 같은 업무를 수행합니다.
(1) [회사]는 [서비스] 사양의 변경 등의 경우에는 장차 체결되는 계약에 의해 제공할 [서비스]의 내용을 변경할 수 있습니다.
이 경우에는 변경된 [서비스]의 내용 및 제공일자를 명시하여 현재의 [서비스] 내용을 게시한 곳에 공지합니다.
(2) [회사]는 [이용자]가 서비스 이용 중 필요하다고 인정되는 다양한 정보에 대해서 전자메일이나 서신우편 등의 방법으로 [이용자]에게 제공할 수 있으며, [이용자]는 원하지 않을 경우 가입신청 메뉴와 회원정보수정 메뉴에서 정보수신거부를 할 수 있습니다.
(3) 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 정부가 제정한 전자거래 소비자 보호지침 및 관계 법령 또는 상 관례에 따릅니다. [회사]는 [이용자]의 메일, SMS 등의 내용에 대해 감시하지 않으며 다음의 경우에 해당 될 경우 책임지지 않습니다.
- [회사]는 [이용자]의 메일 및 SMS 내용을 편집하거나 감시하지 않습니다.
- 그 내용에 대한 책임은 각 [이용자]에게 있습니다.
- [이용자]는 허가를 받지 않고서는 음란물이나 불온한 내용, 정크 메일(junk mail), 스팸 메일(spam mail) 및 타인에게 피해를 주거나 미풍양속을 해치는 메일을 보내서는 안됩니다.
- 음란물이나 불온한 내용을 전송 함으로써 발생하는 모든 법적인 책임은 [이용자]에게 있으며 회사는 책임지지 않습니다.
- 본 서비스를 이용하여 타인에게 피해를 주거나 미풍양속을 해치는 행위를 하신 [이용자]의 아이디와 메일은 보호 받을 수 없습니다.

제5조 서비스의 중단
(1) [회사]는 컴퓨터 등 정보통신설비의 보수 점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.
(2) [회사]는 제1항의 사유로 [서비스]의 제공이 일시적으로 중단됨으로 인하여 [이용자] 또는 제3자가 입은 손해에 대하여 배상할 수 있습니다. 다만, [회사]의 고의 또는 과실이 없는 경우에는 그러하지 아니합니다.
(3) 사업 종목의 전환, 사업의 포기, 업체 간의 통합 등의 이유로 [서비스]를 제공할 수 없게 되는 경우 [회사]는 제8조에 정한 방법으로 [이용자]에게 통지합니다.

제6조 [회원] 가입
(1) [이용자]는 [회사]가 정한 가입 양식에 따라 [회원]정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 [회원]가입을 신청합니다.
(2) [회사]는 제 1항과 같이 [회원]으로 가입할 것을 신청한 [이용자] 중 다음 각 호에 해당하지 않는 한 [회원]으로 등록합니다.
- 가입신청자가 이 약관 제 7조 제 2항에 의하여 이전에 [회원]자격을 상실한 적이 있는 경우. 다만 제 7조 제 2항에 의한 [회원]자격 상실 후 3년이 경과한 자로서 [회사]의 [회원] 재가입 승낙을 얻은 경우에는 예외로 한다.
- 등록내용에 허위, 기재누락, 오기입이 있는 경우.
- 기타 [회원]로 등록하는 것이 [회사]의 기술상 현저히 지장이 있다고 판단되는 경우.
- 본 서비스를 이용하여 타인에게 피해를 주거나 미풍양속을 해치는 행위를 하신 [회원]의 아이디와 메일은 보호 받을 수 없습니다.
(3) [회원]가입 계약의 성립시기는 [회사]의 승낙이 [회원]에게 도달한 시점으로 합니다.

제7조 회원 탈퇴 및 자격 상실 등
(1) [회원]은 [회사]에 언제든지 회원탈퇴를 요청할 수 있으며 회사는 즉시 회원 탈퇴를 처리합니다.
(2) [회원]이 다음 각 호의 사유에 해당하는 경우 [회사]는 회원자격을 제한 및 정지 시킬 수 있습니다.
- 가입 신청 시에 허위 내용을 등록한 경우
- [회사]를 이용하여 법령과 이 약관이 금지하거나 공서양속(공공의 질서와 선량한 풍속, 법률 사상의 지도적 이념으로 법률행위를 판단하는 기준이 되는 사회적 타당성)에 반하는 행위를 하는 경우
- [회사]가 회원자격을 제한, 정지시킨 후 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 [회사]는 [회원]자격을 상실 시킬수 있습니다.
- [회사]가 회원자격을 상실시키는 경우에는 회원등록을 말소할 수 있습니다.
이 경우 [회원]에게 이를 통지하고 회원 등록 말소 전에 소명할 기회를 부여합니다.
단, [회원]에게 이 통지가 도달한 날로부터 7일 이내에 전자우편 등을 통해 웹 사이트에 소명해야 합니다.

제8조 [회원]에 대한 통지
(1) [회사]가 [회원]에 대한 통지를 하는 경우 [회원]이 [회사]에 제출한 전자우편주소로 할 수 있습니다.
(2) [회사]는 불특정 다수 [회원]에 대한 통지의 경우 1주일 이상 [서비스] 게시판에 게시함으로써 개별 통지에 갈음할 수 있습니다.
(3) [회사]는 [회원]의 연락처 미기재, 변경 후 미수정 등으로 인하여 개별 통지가 어려운 경우에 한하여 전항의 공지를 함으로써 개별 통지를 한 것으로 간주합니다.

제9조 (개인정보보호 의무)
[회사]는 '정보통신망 이용촉진 및 정보보호 등에 관한 법률' 등 관계 법령이 정하는 바에 따라 [회원]의 개인정보를 보호하기 위해 노력합니다. 개인정보의 보호 및 사용에 대해서는 관련법 및 [회사]의 개인정보처리방침이 적용됩니다. 다만, [회사]의 공식 사이트 이외의 링크된 사이트에서는 [회사]의 개인정보처리방침이 적용되지 않습니다.

제10조 (회원의 '아이디' 및 '비밀번호'의 관리에 대한 의무)
(1) [회원]의 '아이디'와 '비밀번호'에 관한 관리책임은 [회원]에게 있으며, 이를 제3자가 이용하도록 하여서는 안 됩니다.
(2) [회사]는 [회원]의 '아이디'가 개인정보 유출 우려가 있거나, 반사회적 또는 미풍양속에 어긋나거나 [회사] 및 [회사]의 운영자로 오인한 우려가 있는 경우, 해당 "아이디"의 이용을 제한할 수 있습니다.
(3) [회원]은 '아이디' 및 '비밀번호'가 도용되거나 제3자가 사용하고 있음을 인지한 경우에는 이를 즉시 [회사]에 통지하고 [회사]의 안내에 따라야 합니다.
(4) 제3항의 경우에 해당 [회원]이 [회사]에 그 사실을 통지하지 않거나, 통지한 경우에도 [회사]의 안내에 따르지 않아 발생한 불이익에 대하여 [회사]는 책임지지 않습니다.

이 약관은 2021년 01 월 20 일부터 시행합니다.
공지일자 : 2021년 01 월 20 일
적용일자 : 2021년 01 월 20 일
 
</pre>
""";


const htmlDataPolice = """
<pre>
개인정보 취급방침
[우미건설 정책]

개인정보 취급방침

우미건설 주식회사(이하 '회사')는 '정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하'법')' 등 모든 관련법규를 준수하며 회원님의 개인정보가 보호받을 수 있도록 최선을 다하고 있습니다. 회사는 개인정보처리방침의 공개를 통하여 회원 여러분의 개인정보가 어떠한 목적과 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지를 알려드립니다.본 개인정보처리방침은 관련법령의 개정이나 당사 내부 방침에 의해 변경될 수 있으며 회원가입 시나 사이트 이용 시에 수시로 확인하여 주시기 바랍니다.
1. 총칙
2. 개인정보의 수집방법
3. 개인정보 자동수집장치의 설치∙운영 및 그 거부방법
4. 개인정보의 이용 및 제3자 제공
5. 개인정보의 처리위탁
6. 개인정보의 이용·보관 기간
7. 개인정보의 파기
8. 고객의 권리와 그 행사방법
9. 개인정보 수집·이용·제공에 대한 동의철회
10. 서비스의 링크사이트
11. 서비스의 게시물
12. 의견수렴 및 불만처리
13. 개인정보보호책임자
14. 고지의 의무
15. 개인정보의 국외이전

1. 총칙
(1) 개인정보란 생존하는 개인에 관한 정보로서 성명, 주민등록번호 등에 의하여 특정한 개인을 알아볼 수 있는 부호 · 문자 · 음성 · 음향 및 영상 등의 정보
해당 정보만으로는 특정 개인을 알아볼 수 없어도 다른 정보와 쉽게 결합하여 알아 볼 수 있는 경우에는 그 정보를 포함)를 말합니다.
(2) 회사는 개인정보처리방침을 통하여 고객의 개인정보가 어떤 용도와 방식으로 이용되고 있으며 개인정보 보호를 위하여 어떤 조치가 취해지고 있는지 알려드립니다.
(3) 회사는 개인정보처리방침을 관련 법령 또는 내부 운영규정의 변경에 따라 개정할 수 있으며, 개인정보처리방침을 개정하는 경우 버전번호 등을 부여하여 개정된 사항을 고객이 쉽게 알아볼 수 있도록 하고 있습니다.
(4) 회사는 고객의 개인정보를 수집하는 경우 관련 법령에 따라 가입신청서 또는 이용약관 등을 통하여 그 수집범위 및 수집 · 이용 목적을 사전에 고지합니다.
(5) 회사는 다음 각호와 같이 고유식별 정보를 수집 및 이용하고 있습니다.
- 고유식별정보의 수집·이용 목적 : 휴대폰 본인확인 서비스 제공, 본인확인, 본인인증, 실명인증
- 수집 고유식별 정보의 항목 : 주민등록번호, 여권번호, 운전면허번호, 외국인등록번호 (본인·대리인 신분확인 이미지 및 내용 포함)
※ 주민등록번호는 전기통신사업법 시행령 제65조의2에 근거하여 기간통신 사업자는 수집·이용이 가능합니다.
- 고유식별 정보의 보유 및 이용기간 : 서비스 가입기간 동안 이용 (보존기간 3개월)
(6) 회사는 다음 각호의 개인정보를 아래와 같은 목적을 위하여 수집하고 있습니다.
- 성명(상호), 고유식별정보, 대리인(성명,고유식별정보,연락처,주소,본인과의 관계),
- 성명(상호), 주소(설치장소 등), 휴대폰번호, 유선전화번호, 이메일
- 서비스 · 상품제공 및 안내, 물품배송, 고지사항 전달, 본인의사 확인 등 원활한 의사소통 경로 확보
- 성명, 생년월일, 이동전화번호, 이동통신사정보, 연계정보(CI), 중복가입확인정보(DI)

2. 개인정보의 수집방법
(1) 회사는 고객이 가입신청서, 명의변경신청서 등 각종 서면을 작성하는 경우, 회사의 유 · 무선 서비스에서 회원가입을 하는 경우, 특정 서비스 화면상으로 동의한 경우, 전화(SMS, MMS를 포함), 스마트폰 APP등의 온라인을 통하여 회원가입을 하는 경우, 우편, 이메일, 팩스, 기타 매체를 통하여 동의한 경우에 개인정보를 수집합니다.
(2) 그 밖에 회사의 이동전화, 유 · 무선 인터넷상의 생성정보 수집 툴 등을 통하여 개인정보를 수집할 수 있습니다.

3. 개인정보 자동수집장치의 설치·운영 및 그 거부방법
1) 쿠키(cookie)란? 쿠키는 서비스가 고객의 온라인 서비스로 전송하는 소량의 정보입니다. 고객이 서비스에 접속하면 회사의 컴퓨터는 온라인 서비스에 있는 쿠키의 내용을 읽고, 고객의 추가정보를 고객의 온라인서비스에서 찾아 접속에 따른 성명 등의 추가 입력 없이 서비스를 제공할 수 있습니다.
또한, 고객은 쿠키에 대한 선택권이 있습니다. 단, 고객에게서 쿠키 설치를 거부하였을 경우 서비스 이용에 불편이 있거나, 서비스 제공에 어려움이 있을 수 있습니다.
2) 통계데이터란? 온라인 서비스 이용 시 단말기의 특정 영역에 저장되고, 주기적으로 회사의 서버로 전달되는 아래와 같은 정보입니다.
① 서비스 사용 통계(호접속, 호절단, 호실패 시 망환경, 다운로드 실행오류, 무선인터넷 접속실패 및 접속시간 등)
② 사용 패턴 정보(고객의 메뉴 이동경로, 주로 이용하는 서비스, 서비스 이용횟수, 사용량 등
③ 고객은 서비스 제공에 관한 회사의 계약이행을 위하여 필요한 경우와 요금 정산을 위하여 필요한 경우 및 법령에서 정한 경우를 제외하고 단말기의 통계 데이터 차단 옵션을 통하여 회사의 통계 데이터 수집 · 이용을 거부할 수 있습니다.
3) 회사의 쿠키, 통계 데이터 운영 회사는 이용자의 편의를 위하여 쿠키, 통계데이터를 운영합니다. 회사의 쿠키, 통계 데이터 사용목적은 다음과 같습니다.
① 개인의 관심 분야에 따라 차별화된 정보를 제공
② 회원과 비회원의 접속빈도 또는 머문 시간 등을 분석하여 이용자의 취향과 관심분야를 파악하여 타겟(target) 마케팅에 활용
③ 관심있게 둘러본 내용들에 대한 자취를 추적하여 다음 번 접속 때 개인 맞춤 서비스를 제공
④ 유료서비스 이용 시 이용기간 안내
⑤ 회원들의 습관을 분석하여 서비스 개편 시 기준으로 이용
⑥ 게시판의 글 등록
4) 쿠키는 브라우저의 종료 시나 로그 아웃 시 만료됩니다.

4. 개인정보의 이용 및 제3자 제공
1) 회사는 고객의 개인정보를 가입신청서, 이용약관, 개인정보처리방침의 '개인정보 수집 · 이용 목적상 고지한 범위 내에서 이용 및 제공하고 있습니다. 특히, 다음의 경우는 주의를 기울여 개인정보를 이용 및 제공하고 있습니다.
1) 제휴관계
보다 나은 서비스 제공을 위하여 고객의 개인정보를 제휴사에게 제공하거나 제휴사와 공유할 수 있습니다. 이 경우 사전에 고객에게 제휴사가 누구인지, 제공 또는 공유되는 개인정보의 항목이 무엇인지, 왜 그러한 개인정보가 제공되거나 공유되어야 하는지, 그리고 언제까지 어떻게 보관 · 관리되는지에 관하여 개별적으로 이메일 등 전자적 방법이나, 전화, 서면, 팩스, 우편 등을 통해 고지하여 동의를 구하는 절차를 거치게 되며, 고객이 동의하지 않는 경우에는 제휴사에게 제공하거나 제휴사와 공유하지 않습니다.
2) 매각 · 인수합병 등
회사의 서비스제공자로서의 권리와 의무가 완전 승계 또는 이전되는 경우 사전에 개인정보를 이전하려는 사실, 개인정보의 이전을 받는 자(이하 '영업양수자 등')의 성명(법인인 경우 법인의 명칭) · 주소 · 전화번호 그 밖에 연락처, 고객이 개인정보의 이전을 원하지 아니하는 경우 그 동의를 철회할 수 있는 방법과 절차에 대해 고지할 것이며 고객의 개인정보에 대한 동의 철회의 선택권을 부여합니다.
(2) 고객의 동의가 있거나, 고객의 동의가 없더라도 요금정산을 위하여 필요한 경우, 법, 국세기본법, 지방세법, 통신비밀보호법, 금융실명거래 및 비밀보장에 관한 법률, 신용정보의 이용 및 보호에 관한 법률, 전기통신기본법, 전기통신사업법, 소비자기본법, 한국은행법, 형사소송법 등 관련 법령에 특별한 규정이 있는 경우 제(1)항의 규정에도 불구하고 회사는 고객의 개인정보 수집 시에 고객에게 고지한 범위 또는 이용약관에 명시한 범위를 넘어서 이용하거나 제3자에게 제공할 수 있습니다. 다만, 관련 법령에 의한 경우에도 고객의 개인정보를 무조건 제공하는 것은 아니며 법령에 정해진 절차와 방법에 따라 제공합니다.
(3) 회사는 서비스의 제공에 관한 계약을 이행하기 위하여 필요한 개인정보로서 경제적 · 기술적인 사유로 통상적인 동의를 받는 것이 곤란한 경우에는 고객의 동의가 없더라도 개인정보를 수집 · 이용할 수 있습니다.
(4) 회사가 고객의 개인정보를 제3자에게 제공하는 경우 그 제공하는 목적, 제공하는 개인정보의 항목, 개인정보를 제공받는 자, 이용기간 등의 정보는 고객의 사전 동의가 얻어야 합니다.


5. 개인정보의 처리위탁
(1) 회사는 보다 나은 서비스 제공과 고객편의 제공 등 업무 수행을 원활하게 하기 위하여 외부 전문업체에 고객의 개인정보에 대한 수집 · 보관 · 처리 · 이용 · 제공 · 관리 · 파기 등(이하 '처리')을 위탁할 수 있습니다.
(2) 회사가 외부 전문업체에 고객의 개인정보를 처리 위탁하는 경우 그 위탁업무의 내용, 수탁자를 명시하여야 합니다.
(3) 회사는 개인정보 처리위탁의 경우 계약 등을 통하여 법상 개인정보 보호규정의 준수, 개인정보에 관한 비밀유지, 제3자 제공 금지 및 사고 발생 시의 책임부담, 위탁기간, 개인정보의 반환 및 파기 등을 명확히 규정하고 당해 계약 내용을 서면 또는 전자적으로 보관합니다.
(4) 회사는 고객의 동의 없이 서비스 제공 이외의 목적으로 개인정보를 처리 위탁하지 않는 것을 원칙으로 하고있지만 필요한 경우 위탁업무의 내용과 수탁자를 고객에게 고지하고 동의를 받습니다.


6. 개인정보의 이용·보관 기간
(1) 고객의 개인정보는 서비스 가입기간 동안 이용 · 보관함을 원칙으로 합니다.
(2) 다음 각 호의 1에 해당하는 경우에는 그 기간이 도래하거나, 조건이 성취되는 때까지 필요한 범위 내에서 고객의 개인정보를 보관할 수 있습니다.
1) 상법 등 관련 법령의 규정에 의하여 일정기간 보유하여야 할 필요가 있을 경우에는 그 기간 동안 보유합니다. 그 예는 아래와 같습니다.
① 상업장부와 영업에 관한 중요서류에 포함된 개인정보 : 10년(상법)
② 전표 또는 이와 유사한 서류에 포함된 개인정보 : 5년(상법)
③ 고객의 성명, 주민등록번호, 전화번호, 주소, 요금납부내역(청구액, 수납액, 수납일시, 요금납부 방법 등), 기타 거래에 관한 장부: 관련 국세의 법정신고기한이 경과한 날로부터 5년(국세기본법)
④ 계약 또는 청약철회 등에 관한 기록 : 계약 또는 청약철회 시부터 5년(전자상거래 등에서의 소비자보호에 관한 법률)
⑤ 소비자의 불만 또는 분쟁처리에 관한 기록 : 불만 또는 분쟁 처리 시부터 3년(전자상거래 등에서의 소비자보호에 관한 법률)
⑥ 표시광고에 관한 기록 : 6개월(전자상거래 등에서의 소비자보호에 관한 법률)
⑦ 신용정보의 수집 처리 및 이용 등에 관한 기록 : 3년(신용정보의 이용 및 보호에 관한 법률)
⑧ 통신사실확인자료 제공 시 이용자 확인에 필요한 성명, 주민등록번호, 전화번호 등 : 12개월(통신비밀보호법)
⑨ 전기통신 일시, 전기통신 개시종료 시간, 발 · 착신 통신번호 등 상대방의 가입자 번호, 사용도수, 정보통신망에 접속된 정보통신기기의 위치를 확인할 수 있는 발신기지국의 위치추적자료 등 : 12개월(통신비밀보호법)
⑩ 컴퓨터 통신 또는 인터넷의 사용자가 전기통신역무를 이용한 사실에 관한 컴퓨터 통신 또는 인터넷의 로그기록자료, 컴퓨터 통신 또는 인터넷 사용자가 정보통신망에 접속하기 위하여 사용하는 정보통신기기의 위치를 확인할 수 있는 접속지의 추적자료 : 3개월(통신비밀보호법)
2) 개별적으로 고객의 동의를 받은 경우
그 동의 받은 기간
3) 회사와 고객 간에 민원, 소송 등 분쟁이 발생한 경우에 그 보유기간 내에 분쟁이 해결되지 않을 경우
그 분쟁이 해결될 때까지

7. 개인정보의 파기
(1) 회사는 수집한 개인정보의 수집 · 이용 목적이 달성되거나 그 보유 · 이용기간이 종료되는 경우 고객의 동의, 이용약관, 관련 법령에 따라 보관이 필요한 경우를 제외하고 해당 정보를 파기합니다.
(2) 회사는 서면에 기재된 개인정보의 경우에는 분쇄기로 분쇄하거나 소각하며 전자적 방법으로 저장된 개인정보의 경우에는 그 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.

8. 고객의 권리와 그 행사방법
(1) 고객은 언제든지 회사가 보유하는 개인정보, 개인정보의 이용 · 제공내역, 수집 · 이용 · 제공에 대한 동의내역을 열람하거나 정정할 수 있습니다. 해당 개인정보에 오류가 있거나 보존기간이 경과한 것으로 판명되는 등 정정 · 삭제를 할 필요가 있다고 인정되는 경우에는 회사는 이를 수정합니다.
(2) 온라인 가입정보의 열람 및 정정을 하고자 하는 고객의 경우에는 서비스 내의 "회원정보변경"을 클릭하여 직접 열람 및 정정을 하거나, 웹마스터에게 이메일로 연락하는 경우에도 회사는 필요한 조치를 취합니다.
(3) 회사는 대리인이 방문하여 열람 · 증명을 요구하는 경우에는 적법한 위임을 받았는지 확인할 수 있는 위임장 및 본인의 인감증명서와 대리인의 신분증 등을 제출 받아 정확히 대리인 여부를 확인합니다.
(4) 고객이 개인정보의 오류에 대한 정정을 요청한 경우, 정정이 완료되기 전까지 개인정보를 이용 또는 제공하지 않습니다.
(5) 회사는 잘못된 개인정보를 이미 제3자에게 제공한 경우 그 정정 처리결과를 제3자에게 통지하여 정정하도록 합니다.
(6) 고객은 개인정보를 최신의 상태로 정확하게 입력하고 변동 사항이 있는 경우, 이를 회사에 통보하여야 하며, 스스로 부정확한 정보를 입력하거나, 회사에 통보하지 않아서 회사가 알 수 없는 고객정보의 변동으로 인한 책임은 고객 자신에게 귀속됩니다.
(7) 고객이 타인 정보의 도용이나 침해, 허위정보를 입력하는 경우 서비스 해지 및 회원자격이 상실될 수 있으며 법 등 관련 법령에 따라 처벌받을 수 있습니다.
(8) 고객이 개인정보의 열람 · 제공을 반복적으로 요구하는 등 업무에 지장을 줄 우려가 있거나 그 분량이 상당하여 비용이 드는 경우, 회사는 고객의 요구를 연기 또는 거절하거나 업무처리에 따른 실비(복사비 등)를 고객에게 청구할 수 있습니다.

9. 개인정보 수집·이용·제공에 대한 동의철회
(1) 개인정보의 수집 · 이용 · 제공에 대해 고객은 동의한 내용을 언제든지 철회할 수 있습니다. 동의철회는 서비스 내 회원정보 또는 회원정보 변경 화면의 '회원탈퇴'를 클릭하거나 개인정보보호책임자 및 담당자에게 서면, 전화, 이메일 등으로 연락하면 하실 수 있으며 회사는 개인정보의 삭제 등 필요한 조치를 합니다.
o 주소 :  서울시 강남구 언주로 30길 39 린스퀘어(도곡동 467-14)
o 전화 :  우미건설 주식회사
o 이메일 :  hhykbk@naver.com
(2) 회사는 고객이 동의철회를 하여 개인정보를 파기하는 등의 조치를 취한 경우 고객의 요청에 따라 그 사실을 고객에게 통지합니다.

10. 서비스의 링크사이트
(1) 회사는 고객에게 다른 서비스 또는 자료에 대한 링크를 제공할 수 있습니다. 이 경우 회사는 외부 서비스 및 자료에 대한 통제권이 없으므로 그로부터 받는 서비스나 자료의 유용성에 대하여 보증하거나 책임을 지지 않습니다.
(2) 링크를 클릭하여 다른 서비스로 옮겨 갈 경우, 해당 서비스의 개인정보처리방침은 회사와 무관하므로 고객은 새로 방문한 서비스의 정책을 확인하여야 합니다.

11. 서비스의 게시물
(1) 다음의 경우 게시물에 대하여 삭제, 차단, 변경, 삭제 · 변경 요구, 경고, 이용정지, 기타 적절한 조치를 취할 수 있습니다.
1) 스팸성 게시물(예: 행운의 편지, 8억 메일, 특정사이트의 광고 등)
2) 타인을 비방할 목적으로 사실 또는 허위 사실을 유포하여 타인의 명예를 훼손하는 글
3) 동의 없는 신상공개, 초상권 또는 저작권 등 타인의 권리를 침해하는 내용
4) 기타 법령에 반하거나 미풍양속을 저해 또는 게시판의 주제와 다른 내용의 게시물
(2) 회사는 건전한 게시판 문화를 활성화하기 위하여 동의 없는 타인의 신상공개 시 특정부분을 삭제하거나 기호 등으로 수정하여 게시할 수 있습니다.
(3) 다른 주제의 게시판으로 이동 가능한 내용의 경우 해당 게시물에 이동 경로를 밝혀 오해가 없도록 합니다.
(4) 그 외의 경우 경고 후 삭제 조치할 수 있습니다.
(5) 원칙적으로 게시물에 관련된 제반 권리와 책임은 작성자 개인에게 있습니다. 또 게시물을 통해 자발적으로 공개된 정보는 보호받기 어려우므로 정보게시 전에 심사숙고 하기 바랍니다.

12. 개인정보 관리책임자
회사는 고객의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 관련 부서 및 개인정보 보호책임자를 지정하고 있습니다.
개인정보보호책임자
o 성 명 :  허화영
o 소 속 :  우미건설 주식회사
o 전 화 :  070-4323-4077
o 메 일 :  hhykbk@naver.com

13. 고지의 의무
회사의 개인정보처리방침은 2021년 01월 01일 제정되었으며, 정부의 정책 또는 보안기술의 변경에 따라 내용의 추가ㆍ삭제 및 수정이 있을 시에는 개정 전에 서비스의 '공지'란을 통해 고지합니다.
- 개인정보처리방침

14. 개인정보의 국외이전(1) 회사는 고객의 개인정보를 국외로 이전하고자 하는 때에는 고객에게 다음 사항을 미리 고지하고 동의를 얻습니다.
1) 이전되는 개인정보 항목
2) 개인정보가 이전되는 국가, 일시, 방법
3) 개인정보를 이전 받는 자의 성명(법인의 경우에는 그 명칭 및 정보보호책임자의 연락처)

15. 권익침해 구제방법
정보주체는 아래의 기관에 대해 개인정보 침해에 대한 피해구제, 상담 등을 문의하실 수 있습니다.(아래의 기관은 회사와는 별개의 기관으로서, 회사의 자체적인 개인정보 불만처리, 피해구제 결과에 만족하지 못하시거나 보다 자세한 도움이 필요하시면 문의하여 주시기 바랍니다.)
o 개인정보 침해신고센터 : (국번없이) 118 (http://privacy.kisa.or.kr)
o 개인정보 분쟁조정위원회 : 02-2100-2499 (http://www.kopico.go.kr)
o 대검찰청 사이버수사과 : (국번없이) 1301 (www.spo.go.kr)
o 경찰청 사이버안전국 : (국번없이) 182 (cyberbureau.police.go.kr)
</pre>
""";