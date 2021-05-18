//import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import '../model/user_home_model.dart';
//import '../screens/community_gps.dart';
import '../screens/widget/bottom_menu_bar.dart';
import '../common/style.dart';

class CommunityListScreen extends StatelessWidget {
	final UserHomeModel userHomeModel;

	const CommunityListScreen({
		Key key,
		this.userHomeModel
	}): super(key: key);

	@override
	Widget build(BuildContext context) {
		// Scaffold is a layout for the major Material Components.
		return Scaffold(
			appBar: AppBar(
				automaticallyImplyLeading: false,
				iconTheme: IconThemeData(
					color: Colors.black, //change your color here
				),
				backgroundColor: BgColor.white,
				title: Text('커뮤니티', style: TextStyle(color: BgColor.black), ),
			),
			bottomNavigationBar: BottomAppBar(
				child: BottomMenuBarWidget(userHomeModel: userHomeModel, menuCode: "community"),
			),
			body:
      WillPopScope(
				onWillPop:() async{
          Navigator.pushNamedAndRemoveUntil(context, '/smarthome', (route) => false);
          return false;
        },
				child:

				Container(
					padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 10),
					constraints: BoxConstraints.expand(),
					decoration: BoxDecoration(
						color: BgColor.white,
						image: DecorationImage(
							image: AssetImage("assets/images/community_bg.png"),
							fit: BoxFit.cover,
						),
					),
					child: SingleChildScrollView(
						child: Column(
							children: [
								Container(
									child: Row(
										children: [
											Expanded(
												child: Container(
													padding: EdgeInsets.all(10),
													child: InkWell(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: Radii.radi10,
																color: BgColor.white,
																boxShadow: [Shadows.fshadow],
															),
															width: double.infinity,
															padding: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 35),
															alignment: Alignment.center,
															child: Column(
																children: [
																	Container(
																		width: 36,
																		height: 36,
																		child: Image.asset(
																			"assets/images/notice.png",
																			fit: BoxFit.fitHeight,
																		),
																		margin: EdgeInsets.only(bottom: 15, ),
																	),
																	Container(
																		child: Text(
																			'공지 사항',
																			textAlign: TextAlign.center,
																			style: TextFont.big,
																		),
																	)
																],
															)
														),
														onTap: () {
															//Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityNoticeScreen()), );
															Navigator.pushNamed(context, '/notice');
														},
													),
												)
											),
											Expanded(
												child: Container(
													padding: EdgeInsets.all(10),
													child: InkWell(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: Radii.radi10,
																color: BgColor.white,
																boxShadow: [Shadows.fshadow],
															),
															width: double.infinity,
															padding: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 35),
															alignment: Alignment.center,
															child: Column(
																children: [
																	Container(
																		width: 36,
																		height: 36,
																		child: Image.asset(
																			"assets/images/faq.png",
																			fit: BoxFit.fitHeight,
																		),
																		margin: EdgeInsets.only(bottom: 15, ),
																	),
																	Container(
																		child: Text(
																			'FAQ',
																			textAlign: TextAlign.center,
																			style: TextFont.big,
																		),
																	)
																],
															)
														),
														onTap: () {
															//Navigator.push(context, MaterialPageRoute(builder: (context) => FaqScreen(noticeTypeCode: "FAQ", )), );
															Navigator.pushNamed(context, '/faq');
														},
													),
												)
											)
										],
									),
								),



								// Container(
								// 	child: Row(
								// 		children: [
								// 			// Expanded(
								// 			// 	child: Container(
								// 			// 		padding: EdgeInsets.all(10),
								// 			// 		child: InkWell(
								// 			// 			child: Container(
								// 			// 				decoration: BoxDecoration(
								// 			// 					borderRadius: Radii.radi10,
								// 			// 					color: BgColor.white,
								// 			// 					boxShadow: [Shadows.fshadow],
								// 			// 				),
								// 			// 				width: double.infinity,
								// 			// 				padding: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 35),
								// 			// 				alignment: Alignment.center,
								// 			// 				child: Column(
								// 			// 					children: [
								// 			// 						Container(
								// 			// 							width: 36,
								// 			// 							height: 36,
								// 			// 							child: Image.asset(
								// 			// 								"assets/images/familymemo.png",
								// 			// 								fit: BoxFit.fitHeight,
								// 			// 							),
								// 			// 							margin: EdgeInsets.only(bottom: 15, ),
								// 			// 						),
								// 			// 						Container(
								// 			// 							child: Text(
								// 			// 								'가족 메모',
								// 			// 								textAlign: TextAlign.center,
								// 			// 								style: TextFont.big,
								// 			// 							),
								// 			// 						)
								// 			// 					],
								// 			// 				)
								// 			// 			),
								// 			// 			onTap: () {
								// 			// 				//Navigator.push(context, MaterialPageRoute(builder: (context) => FamilySticker()), );
								// 			// 				Navigator.push(context, MaterialPageRoute(builder: (context) => FamilyMessageScreen(userHomeModel: userHomeModel)), );
								// 			// 			},
								// 			// 		),
								// 			// 	)
								// 			// ),

								// 			Expanded(
								// 				child: Container(
								// 					padding: EdgeInsets.all(10),
								// 					child: InkWell(
								// 						child: Container(
								// 							decoration: BoxDecoration(
								// 								borderRadius: Radii.radi10,
								// 								color: BgColor.white,
								// 								boxShadow: [Shadows.fshadow],
								// 							),
								// 							width: double.infinity,
								// 							padding: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 35),
								// 							alignment: Alignment.center,
								// 							child: Column(
								// 								children: [
								// 									Container(
								// 										width: 36,
								// 										height: 36,
								// 										child: Image.asset(
								// 											"assets/images/familymemo.png",
								// 											fit: BoxFit.fitHeight,
								// 										),
								// 										margin: EdgeInsets.only(bottom: 15, ),
								// 									),
								// 									Container(
								// 										child: Text(
								// 											'메모 NEW',
								// 											textAlign: TextAlign.center,
								// 											style: TextFont.big,
								// 										),
								// 									)
								// 								],
								// 							)
								// 						),
								// 						onTap: () {
								// 							Navigator.push(context, MaterialPageRoute(builder: (context) => FamilySticker()), );
								// 						},
								// 					),
								// 				)
								// 			),
								// 		],
								// 	),
								// ),


								// Container(
								// 	child: Row(
								// 		children: [
								// 			Expanded(
								// 				child: Container(
								// 					padding: EdgeInsets.all(10),
								// 					child: InkWell(
								// 						child: Container(
								// 							decoration: BoxDecoration(
								// 								borderRadius: Radii.radi10,
								// 								color: BgColor.white,
								// 								boxShadow: [Shadows.fshadow],
								// 							),
								// 							width: double.infinity,
								// 							padding: EdgeInsets.only(top: 35, left: 15, right: 15, bottom: 35),
								// 							alignment: Alignment.center,
								// 							child: Column(
								// 								children: [
								// 									Container(
								// 										width: 36,
								// 										height: 36,
								// 										child: Image.asset(
								// 											"assets/images/familycheck.png",
								// 											fit: BoxFit.fitHeight,
								// 										),
								// 										margin: EdgeInsets.only(bottom: 15, ),
								// 									),
								// 									Container(
								// 										child: Text(
								// 											'가족 위치 확인',
								// 											textAlign: TextAlign.center,
								// 											style: TextFont.big,
								// 										),
								// 									)
								// 								],
								// 							)
								// 						),
								// 						onTap: () {
								// 							Navigator.push(context, MaterialPageRoute(builder: (context) => FamilyMAP()), );
								// 						},
								// 					),
								// 				)
								// 			),
								// 		],
								// 	),
								// ),
							],
						),
					)
				)
			)
		);
	}
}