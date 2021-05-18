import 'package:flutter/material.dart';
import '../../model/user_home_model.dart';
import '../../common/style.dart';


//const WEBSOCKET_URL = 'wss://0b6kf9xhc2.execute-api.ap-northeast-2.amazonaws.com/dev';

/// 하단 메뉴 영역
class BottomMenuBarWidget extends StatefulWidget {
	final UserHomeModel userHomeModel;
	final String menuCode;

	BottomMenuBarWidget({
		Key key,
		@required this.userHomeModel,
		@required this.menuCode
	}): super(key: key);

	@override
	_BottomMenuBarWidgetState createState() => _BottomMenuBarWidgetState();
}

class _BottomMenuBarWidgetState extends State < BottomMenuBarWidget > {
	//  @override
	//  void dispose() {
	//  	print("_BottomMenuBarWidgetState dispose!!");
	// 	_streamController.close();
	// 	super.dispose();
	//  }

	//var _streamController;
	Widget build(BuildContext context) {

		// 웹소켓 연결 및 Listen
		// if (IS_SERVER_MODE && _streamController == null) {
		// 	print("_BottomMenuBarWidgetState build  WebSocket initialize - ${DateTime.now()}");
		// 	try {
		// 		_streamController = WebsocketService(widget.userHomeModel.id.toString()).streamController;
		// 		_streamController.stream.listen((message) {
		// 			try {
		// 				//print("setWebSocketChannel receive message : $message");
		// 				final statusEventModel = StatusEventModel.fromJson(json.decode(message));
		// 				for (var event in statusEventModel.eventList) {
		// 					print("WebSocketChannel receive message device_id : ${statusEventModel.deviceId} command : ${event.command}  value : ${event.value}");
		// 					DeviceService().setDeviceChangedStatus(context, statusEventModel.deviceId, event.command, event.value);
		// 				}
		// 			} catch (e) {
		// 				//print(e);
		// 			}
		// 		});
		// 	} catch (e) {
		// 		print("_BottomMenuBarWidgetState WebSocket Initialize Error : $e");
		// 	}
		// }

		String menuCode = widget.menuCode;

		return Container(
			padding: EdgeInsets.only(left: 15, right: 15),
			decoration: BoxDecoration(
				boxShadow: [Shadows.fshadow],
				color: BgColor.white,
			),
			height: 60.0,
			child: Table(
				children: < TableRow > [
					TableRow(
						children: < Widget > [
							TableCell(
								child: SizedBox(
									width: double.infinity,
									height: 60,
									child: FlatButton(
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Container(
													width: 20,
													height: 20,
													child: Image.asset(
														menuCode == "smarthome" ? "assets/images/smarthome_on.png" : "assets/images/smarthome.png",
														fit: BoxFit.fitWidth,
													),
													margin: EdgeInsets.only(bottom: 5)
												),
												Text(
													'스마트홈',
													style: TextStyle(
														fontFamily: 'NanumBarunGothic',
														fontWeight: FontWeight.w400,
														fontSize: 10,
														color: menuCode == "smarthome" ? BgColor.main : BgColor.gray
													),
												),
											]),
										onPressed: () {
											if(menuCode != "smarthome"){
												//Navigator.pushNamed(context, '/smarthome');
												//Navigator.pushReplacementNamed(context, '/smarthome');
                        Navigator.pushNamedAndRemoveUntil(context, '/smarthome', (route) => false);
											}
										}
									),
								),
							),
							TableCell(
								child: SizedBox(
									width: double.infinity,
									height: 60,
									child: FlatButton(
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Container(
													width: 20,
													height: 20,
													child: Image.asset(
														menuCode == "community" ? "assets/images/community_on.png" : "assets/images/community.png",
														fit: BoxFit.fitWidth,
													),
													margin: EdgeInsets.only(bottom: 5)
												),
												Text(
													'커뮤니티',
													style: TextStyle(
														fontFamily: 'NanumBarunGothic',
														fontWeight: FontWeight.w400,
														fontSize: 10,
														color: menuCode == "community" ? BgColor.main : BgColor.gray
													),
												),
											]),
										onPressed: () {
											if(menuCode != "community"){
												//Navigator.pushNamed(context, '/community');
												//Navigator.pushReplacementNamed(context, '/community');
                        Navigator.pushNamedAndRemoveUntil(context, '/community', (route) => true);
											}
										}
									),
								),
							),
							TableCell(
								child: SizedBox(
									width: double.infinity,
									height: 60,
									child: FlatButton(
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Container(
													width: 20,
													height: 20,
													child: Image.asset(
														menuCode == "facility" ? "assets/images/public_on.png" : "assets/images/public.png",
														fit: BoxFit.fitWidth,
													),
													margin: EdgeInsets.only(bottom: 5)
												),
												Text(
													'공용서비스',
													style: TextStyle(
														fontFamily: 'NanumBarunGothic',
														fontWeight: FontWeight.w400,
														fontSize: 10,
														color: menuCode == "facility" ? BgColor.main : BgColor.gray
													),
												),
											]),
										onPressed: () {
											if(menuCode != "facility"){
												//Navigator.pushNamed(context, '/facility');
                        //Navigator.pushReplacementNamed(context, '/facility');
                        Navigator.pushNamedAndRemoveUntil(context, '/facility', (route) => true);
											}
										},
									),
								),
							),
							TableCell(
								child: SizedBox(
									width: double.infinity,
									height: 60,
									child: FlatButton(
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Container(
													width: 20,
													height: 20,
													child: Image.asset(
														menuCode == "config" ? "assets/images/setting_on.png" : "assets/images/setting.png",
														fit: BoxFit.fitWidth,
													),
													margin: EdgeInsets.only(bottom: 5)
												),
												Text(
													'설정',
													style: TextStyle(
														fontFamily: 'NanumBarunGothic',
														fontWeight: FontWeight.w400,
														fontSize: 10,
														color: menuCode == "config" ? BgColor.main : BgColor.gray
													),
												),
											]
										),
										onPressed: () {
											if(menuCode != "config"){
												//Navigator.pushNamed(context, '/config');
												//Navigator.pushReplacementNamed(context, '/config');
                        Navigator.pushNamedAndRemoveUntil(context, '/config', (route) => true);
											}
										}
									)
								)
							),
						]
					)
				]
			)
		);
	}
}