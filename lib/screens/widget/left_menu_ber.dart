import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../common/style.dart';
import '../../model/user_home_model.dart';
import '../../common/globals.dart';

class LeftMenuBarWidget extends StatefulWidget {
	final UserHomeModel userHomeModel;
	const LeftMenuBarWidget({Key key, this.userHomeModel}) : super(key: key);
	@override
	_LeftMenuBarWidgetState createState() => _LeftMenuBarWidgetState();
}

class _LeftMenuBarWidgetState extends State < LeftMenuBarWidget > {

	Widget build(BuildContext context) {
		return Container(
			width: MediaQuery.of(context).size.width * 0.65,
			child: Drawer(
				child: ListView(
					padding: EdgeInsets.zero,
					children: < Widget > [
						Container(
							width: double.infinity,
							padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 40),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								children: [
									Container(
										alignment: Alignment.centerLeft,
										width: double.infinity,
										height: 60,
										child: Image.asset(
											"assets/images/logo.png",
											fit: BoxFit.fitHeight,
										),
									),
									Container(
										margin: EdgeInsets.only(top: 15, ),
										width: double.infinity,
										child: Text(
											'${globalUser.name}님 환영합니다.',
											style: TextFont.semibig,
											textAlign: TextAlign.left,
										),
									)
								],
							),
							decoration: BoxDecoration(
								color: BgColor.white,
								border: BorderDirectional(
									bottom: BorderSide(
										color: BgColor.gray,
										style: BorderStyle.solid),
								),
							),
						),
						GFAccordion(
							margin: EdgeInsets.all(0),
							contentPadding: EdgeInsets.all(10),
							titlePadding: EdgeInsets.all(20),
							contentBackgroundColor: BgColor.lgray,
							title: '스마트홈',
							textStyle: TextFont.medium,
							contentChild: Column(
								children: [
									ListTile(
										title: Text('공간별 제어'),
										onTap: () {
											if (widget.userHomeModel.locations != null && widget.userHomeModel.locations.length > 0) {
												// Navigator.push(context, MaterialPageRoute(
												// 	builder: (_) => BlocProvider < UserHomeBloc > (
												// 		create: (_) => UserHomeBloc(widget.userHomeModel),
												// 		child: DeviceControl(userHomeModel: widget.userHomeModel, location: widget.userHomeModel.locations[0]),
												// 	)
												// ));

												Navigator.pushNamed(context, '/controlLocations', arguments: {'location':widget.userHomeModel.locations[0]});
											}
										},
									),
									ListTile(
										title: Text('기기별 제어'),
										onTap: () {
											if (widget.userHomeModel.deviceTypes != null && widget.userHomeModel.deviceTypes.length > 0) {
												// Navigator.push(context, MaterialPageRoute(
												// 	builder: (_) => BlocProvider < UserHomeBloc > (
												// 		create: (_) => UserHomeBloc(widget.userHomeModel),
												// 		child: DeviceControlTypes(userHomeModel: widget.userHomeModel, typeModel: widget.userHomeModel.deviceTypes[0]),
												// 	)
												// ));

												Navigator.pushNamed(context, '/controlDeviceTypes', arguments: {'typeModel':widget.userHomeModel.deviceTypes[0]});
											}
										},
									),
								],
							),
							collapsedIcon: Icon(Icons.add),
							expandedIcon: Icon(Icons.minimize),
						),
						GFAccordion(
							margin: EdgeInsets.all(0),
							contentPadding: EdgeInsets.all(10),
							titlePadding: EdgeInsets.all(20),
							contentBackgroundColor: BgColor.lgray,
							title: '커뮤니티',
							textStyle: TextFont.medium,
							contentChild: Column(
								children: [
									ListTile(
										title: Text('공지사항'),
										onTap: () {
											Navigator.pushNamed(context, '/notice');
										},
									),
									ListTile(
										title: Text('FAQ'),
										onTap: () {
											Navigator.pushNamed(context, '/faq');
										},
									),
								],
							),
							collapsedIcon: Icon(Icons.add),
							expandedIcon: Icon(Icons.minimize),
						),
						GFAccordion(
							margin: EdgeInsets.all(0),
							contentPadding: EdgeInsets.all(10),
							titlePadding: EdgeInsets.all(20),
							contentBackgroundColor: BgColor.lgray,
							title: '공용서비스',
							textStyle: TextFont.medium,
							contentChild: Column(
								children: [
									ListTile(
										title: Text('에너지 현황'),
										onTap: () {
											Navigator.pushNamed(context, '/energy');
										},
									),
									ListTile(
										title: Text('방문차량'),
										onTap: () {
											Navigator.pushNamed(context, '/visitingCar');
										},
									),
									ListTile(
										title: Text('택배조회'),
										onTap: () {
											Navigator.pushNamed(context, '/delivery');
										},
									),
									ListTile(
										title: Text('차량 입출차'),
										onTap: () {
											Navigator.pushNamed(context, '/carInOut');
										},
									),
								],
							),
							collapsedIcon: Icon(Icons.add),
							expandedIcon: Icon(Icons.minimize),
						),
						GFAccordion(
							margin: EdgeInsets.all(0),
							contentPadding: EdgeInsets.all(10),
							titlePadding: EdgeInsets.all(20),
							contentBackgroundColor: BgColor.lgray,
							title: '설정',
							textStyle: TextFont.medium,
							contentChild: Column(
								children: [
									ListTile(
										title: Text('모든 설정 보기'),
										onTap: () {
											Navigator.pushNamed(context, '/config');
										},
									),
								],
							),
							collapsedIcon: Icon(Icons.add),
							expandedIcon: Icon(Icons.minimize),
						),
					],
				),
			)
		);
	}
}