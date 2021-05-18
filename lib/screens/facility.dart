//import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import '../model/user_home_model.dart';
import '../common/style.dart';
import 'widget/bottom_menu_bar.dart';

class FacilityListScreen extends StatelessWidget {
	final UserHomeModel userHomeModel;

	const FacilityListScreen({
		Key key,
		this.userHomeModel
	}): super(key: key);

	@override
	Widget build(BuildContext context) {
		// Scaffold is a layout for the major Material Components.
		return Scaffold(
			appBar: AppBar(
        automaticallyImplyLeading : false,
				iconTheme: IconThemeData(
					color: Colors.black, //change your color here
				),
				backgroundColor: BgColor.white,
				title: Text('공용 서비스', style: TextStyle(color: BgColor.black),),
			),
			bottomNavigationBar: BottomAppBar(
				child: BottomMenuBarWidget(userHomeModel: userHomeModel, menuCode: "facility"),
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
						image: AssetImage("assets/images/public_bg.png"),
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
																		"assets/images/chart.png",
																		fit: BoxFit.fitHeight,
																	),
																	margin: EdgeInsets.only(bottom: 15, ),
																),
																Container(
																	child: Text(
																		'에너지 현황',
																		textAlign: TextAlign.center,
																		style: TextFont.big,
																	),
																)
															],
														)
													),
													onTap: () {
														//Navigator.push(context, MaterialPageRoute(builder: (context) => FacilityEnergeScreen()), );
														Navigator.pushNamed(context, '/energy');
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
																		"assets/images/visitcar.png",
																		fit: BoxFit.fitHeight,
																	),
																	margin: EdgeInsets.only(bottom: 15, ),
																),
																Container(
																	child: Text(
																		'방문차량',
																		textAlign: TextAlign.center,
																		style: TextFont.big,
																	),
																)
															],
														)
													),
													onTap: () {
														//Navigator.push(context, MaterialPageRoute(builder: (context) => VisitingCarScreen()), ); // VisitingCarScreen  //VisitCarScreen
														Navigator.pushNamed(context, '/visitingCar');
													},
												)
											)
										),
									]
								)
							),

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
																		"assets/images/delivery.png",
																		fit: BoxFit.fitHeight,
																	),
																	margin: EdgeInsets.only(bottom: 15, ),
																),
																Container(
																	child: Text(
																		'택배 조회',
																		textAlign: TextAlign.center,
																		style: TextFont.big,
																	),
																)
															],
														)
													),
													onTap: () {
														//Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreen()), );
														Navigator.pushNamed(context, '/delivery');
													},
												),
											),
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
																		"assets/images/carin.png",
																		fit: BoxFit.fitHeight,
																	),
																	margin: EdgeInsets.only(bottom: 15, ),
																),
																Container(
																	child: Text(
																		'차량 입출차',
																		textAlign: TextAlign.center,
																		style: TextFont.big,
																	),
																)
															],
														)
													),
													onTap: () {
														//Navigator.push(context, MaterialPageRoute(builder: (context) => CarInOutScreen()), );
														Navigator.pushNamed(context, '/carInOut');
													},
												)
											)
										),
									]
								)
							)
						]
					),
				)
			)
			)
		);
	}
}