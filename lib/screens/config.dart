//import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import '../common/ui_common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_home_model.dart';
import '../common/style.dart';
import 'login.dart';
import 'widget/bottom_menu_bar.dart';

class ConfigListScreen extends StatelessWidget {
	final UserHomeModel userHomeModel;

	const ConfigListScreen({
		Key key,
		this.userHomeModel
	}): super(key: key);


	@override
	Widget build(BuildContext context) {
		// Scaffold is a layout for the major Material Components.
		return Scaffold(
			appBar: AppBar(
				automaticallyImplyLeading: false,
				title: Text('설정', style: TextStyle(color: BgColor.black), ),
				iconTheme: IconThemeData(
					color: Colors.black,
				),
				backgroundColor: BgColor.white,
			),
			bottomNavigationBar: BottomAppBar(
				child: BottomMenuBarWidget(userHomeModel: userHomeModel, menuCode: "config"),
			),
			body:
			WillPopScope(
				onWillPop:() async{
          Navigator.pushNamedAndRemoveUntil(context, '/smarthome', (route) => false);
          return false;
        },
				child:
				Container(
					constraints: BoxConstraints.expand(),
					decoration: BoxDecoration(color: BgColor.lgray),
					child: SingleChildScrollView(
						padding: EdgeInsets.all(0),
						child: Column(
							children: [
								Container(
									width: double.infinity,
									padding: EdgeInsets.only(
										top: 20,
										left: 15,
										right: 15,
										bottom: 10,
									),
									child: Text(
										'기능 관리',
										style: TextFont.big,
										textAlign: TextAlign.left,
									),
								),

								Container(
									decoration: BoxDecoration(
										color: BgColor.white,
										border: Border(
											bottom: BorderSide(width: 1, color: BgColor.rgray))),
									width: double.infinity,
									child: FlatButton(
										padding: EdgeInsets.all(0),
										child: Container(
											padding: EdgeInsets.only(
												top: 15,
												bottom: 15,
												right: 20,
												left: 20,
											),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														alignment: Alignment.center,
														width: 30,
														height: 30,
														child: Image.asset(
															"assets/images/star.png",
															fit: BoxFit.fitWidth,
														),
														margin: EdgeInsets.only(
															right: 15,
														),
													),
													Expanded(
														child: Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'즐겨찾기 관리',
																		style: TextFont.semibig,
																	),
																	margin: EdgeInsets.only(
																		bottom: 2,
																	)),
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'자주 사용하는 기기를 즐겨찾기 하세요.',
																		style: TextFont.normal_g,
																	),
																),
															],
														))
												],
											),
										),
										onPressed: () {
											// Navigator.push(
											// 	context,
											// 	MaterialPageRoute(
											// 		builder: (_) => BlocProvider < UserHomeBloc > (
											// 			create: (_) => UserHomeBloc(userHomeModel),
											// 			child: ConfigLocations(
											// 				userHomeModel: userHomeModel),
											// 		)));

											Navigator.pushNamed(context, '/configFavorite');
										},
									),
								),

								Container(
									decoration: BoxDecoration(
										color: BgColor.white,
										border: Border(
											bottom: BorderSide(width: 1, color: BgColor.rgray))),
									width: double.infinity,
									child: FlatButton(
										padding: EdgeInsets.all(0),
										child: Container(
											padding: EdgeInsets.only(
												top: 15,
												bottom: 15,
												right: 20,
												left: 20,
											),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														alignment: Alignment.center,
														width: 30,
														height: 30,
														child: Image.asset(
															"assets/images/set_rooms.png",
															fit: BoxFit.fitWidth,
														),
														margin: EdgeInsets.only(
															right: 15,
														),
													),
													Expanded(
														child: Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'공간 관리',
																		style: TextFont.semibig,
																	),
																	margin: EdgeInsets.only(
																		bottom: 2,
																	)),
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'공간을 구성하고 기기를 배치할 수 있습니다.',
																		style: TextFont.normal_g,
																	),
																),
															],
														))
												],
											),
										),
										onPressed: () {
											// Navigator.push(
											// 	context,
											// 	MaterialPageRoute(
											// 		builder: (_) => BlocProvider < UserHomeBloc > (
											// 			create: (_) => UserHomeBloc(userHomeModel),
											// 			child: ConfigLocations(
											// 				userHomeModel: userHomeModel),
											// 		)));

											Navigator.pushNamed(context, '/configLocations');
										},
									),
								),

								Container(
									decoration: BoxDecoration(
										color: BgColor.white,
										border: Border(
											bottom: BorderSide(width: 1, color: BgColor.rgray))),
									width: double.infinity,
									child: FlatButton(
										padding: EdgeInsets.all(0),
										child: Container(
											padding: EdgeInsets.only(
												top: 15,
												bottom: 15,
												right: 20,
												left: 20,
											),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														alignment: Alignment.center,
														width: 30,
														height: 30,
														child: Image.asset(
															"assets/images/set_mode.png",
															fit: BoxFit.fitWidth,
														),
														margin: EdgeInsets.only(
															right: 15,
														),
													),
													Expanded(
														child: Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'모드(루틴) 관리',
																		style: TextFont.semibig,
																	),
																	margin: EdgeInsets.only(
																		bottom: 2,
																	)),
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'모드별 루틴을 설정 할 수 있습니다.',
																		style: TextFont.normal_g,
																	),
																),
															],
														))
												],
											),
										),
										onPressed: () {
											// Navigator.push(
											// 	context,
											// 	MaterialPageRoute(
											// 		builder: (_) => BlocProvider < UserHomeBloc > (
											// 			create: (_) => UserHomeBloc(userHomeModel),
											// 			child: ConfigRoutines(
											// 				userHomeModel: userHomeModel),
											// 		)));

											Navigator.pushNamed(context, '/configRoutines');
										},
									),
								),

								Container(
									width: double.infinity,
									padding: EdgeInsets.only(
										top: 20,
										left: 15,
										right: 15,
										bottom: 10,
									),
									child: Text(
										'연동',
										style: TextFont.big,
										textAlign: TextAlign.left,
									),
								),

								Container(
									decoration: BoxDecoration(
										color: BgColor.white,
										border: Border(
											bottom: BorderSide(width: 1, color: BgColor.rgray))),
									width: double.infinity,
									child: FlatButton(
										padding: EdgeInsets.all(0),
										child: Container(
											padding: EdgeInsets.only(
												top: 15,
												bottom: 15,
												right: 20,
												left: 20,
											),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														alignment: Alignment.center,
														width: 30,
														height: 30,
														child: Image.asset(
															"assets/images/set_homenet.png",
															fit: BoxFit.fitWidth,
														),
														margin: EdgeInsets.only(
															right: 15,
														),
													),
													Expanded(
														child: Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'홈넷사 연동',
																		style: TextFont.semibig,
																	),
																	margin: EdgeInsets.only(
																		bottom: 2,
																	)),
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'홈넷사 계정을 연동 합니다.',
																		style: TextFont.normal_g,
																	),
																),
															],
														))
												],
											),
										),
										onPressed: () {
											// Navigator.push(
											// 	context,
											// 	MaterialPageRoute(
											// 		builder: (_) => BlocProvider < UserHomeBloc > (
											// 			create: (_) => UserHomeBloc(userHomeModel),
											// 			child: SignInHomenet(),
											// 		)));

											Navigator.pushNamed(context, '/homenetLogin');
										},
									),
								),

								Container(
									width: double.infinity,
									padding: EdgeInsets.only(
										top: 20,
										left: 15,
										right: 15,
										bottom: 10,
									),
									child: Text(
										'회원 정보',
										style: TextFont.big,
										textAlign: TextAlign.left,
									),
								),

								Container(
									decoration: BoxDecoration(
										color: BgColor.white,
										border: Border(
											bottom: BorderSide(width: 1, color: BgColor.rgray))),
									width: double.infinity,
									child: FlatButton(
										padding: EdgeInsets.all(0),
										child: Container(
											padding: EdgeInsets.only(
												top: 15,
												bottom: 15,
												right: 20,
												left: 20,
											),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														alignment: Alignment.center,
														width: 30,
														height: 30,
														child: Image.asset(
															"assets/images/set_family.png",
															fit: BoxFit.fitWidth,
														),
														margin: EdgeInsets.only(
															right: 15,
														),
													),
													Expanded(
														child: Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'가족 구성원',
																		style: TextFont.semibig,
																	),
																	margin: EdgeInsets.only(
																		bottom: 2,
																	)),
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'가족 구성원을 조회하고 본인의 비밀번호를 변경할 수 있습니다.',
																		style: TextFont.normal_g,
																	),
																),
															],
														))
												],
											),
										),
										onPressed: () {
											//Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigFamilyScreen(userHomeModel: userHomeModel, )),);
											Navigator.pushNamed(context, '/familyMember');
										}),
								),

								//로그아웃
								Container(
									decoration: BoxDecoration(
										color: BgColor.white,
										border: Border(
											bottom: BorderSide(width: 1, color: BgColor.rgray))),
									width: double.infinity,
									child: FlatButton(
										padding: EdgeInsets.all(0),
										child: Container(
											padding: EdgeInsets.only(
												top: 15,
												bottom: 15,
												right: 20,
												left: 20,
											),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														alignment: Alignment.center,
														width: 30,
														height: 30,
														child: Image.asset(
															"assets/images/homeout.png",
															fit: BoxFit.fitWidth,
														),
														margin: EdgeInsets.only(
															right: 15,
														),
													),
													Expanded(
														child: Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'로그아웃',
																		style: TextFont.semibig,
																	),
																	margin: EdgeInsets.only(
																		bottom: 2,
																	)),
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'접속된 계정을 로그아웃 합니다.',
																		style: TextFont.normal_g,
																	),
																),
															],
														))
												],
											),
										),
										onPressed: () async {
											bool isConfirm = await UICommon.confirmDialog(context, "확인", "로그아웃 하시겠습니까?.", "취소", "확인");
											if (isConfirm) {
												//자동로그인시 아용하는 sharedPreference 초기화
												SharedPreferences sharedPreference = await SharedPreferences.getInstance();
												sharedPreference.remove("_user_token");
												sharedPreference.remove("_vendor_token");
												sharedPreference.remove("_user_email");

												//Navigator.push(context, MaterialPageRoute(builder: (context) => LynnStartPage()));
												//Navigator.pushNamed(context, '/home');
												//Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Login()));
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
											}
										},
									),
								),

								Container(
									width: double.infinity,
									padding: EdgeInsets.only(
										top: 20,
										left: 15,
										right: 15,
										bottom: 10,
									),
									child: Text(
										'기타',
										style: TextFont.big,
										textAlign: TextAlign.left,
									),
								),


								Container(
									decoration: BoxDecoration(
										color: BgColor.white,
										border: Border(bottom: BorderSide(width: 1, color: BgColor.rgray))
									),
									width: double.infinity,
									child: FlatButton(
										padding: EdgeInsets.all(0),
										child: Container(
											padding: EdgeInsets.only(
												top: 15,
												bottom: 15,
												right: 20,
												left: 20,
											),
											child: Row(
												mainAxisAlignment: MainAxisAlignment.start,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														alignment: Alignment.center,
														width: 30,
														height: 30,
														child: Image.asset(
															"assets/images/app.png",
															fit: BoxFit.fitWidth,
														),
														margin: EdgeInsets.only(
															right: 15,
														),
													),
													Expanded(
														child: Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.center,
															children: [
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'앱정보',
																		style: TextFont.semibig,
																	),
																	margin: EdgeInsets.only(
																		bottom: 2,
																	)
																),
																Container(
																	alignment: Alignment.centerLeft,
																	child: Text(
																		'앱 정보와 기타 정보를 확인 할 수 있습니다.',
																		style: TextFont.normal_g,
																	),
																),
															],
														)
													)
												],
											),
										),
										onPressed: () {
											//Navigator.push(context, MaterialPageRoute(builder: (context) => AppInfoScreen()),);
											Navigator.pushNamed(context, '/appInfo');
										}
									),
								),

							],
						),
					)
				),
			)
		);
	}
}
