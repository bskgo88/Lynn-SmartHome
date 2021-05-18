import 'dart:convert';
//import 'package:double_back_to_close/double_back_to_close.dart';
//import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../common/globals.dart';
import '../model/routine_devices_model.dart';
import '../screens/config_favorite.dart';
import '../screens/config_locations.dart';
import '../screens/config_routines.dart';
import '../service/home_service.dart';
import '../service/user_service.dart';
import '../service/websocket_service.dart';
import '../bloc/user_home_bloc.dart';
import '../model/device_type_devices_model.dart';
import '../model/location_devices_model.dart';
import '../model/user_home_model.dart';
import '../common/style.dart';
import 'home.dart';
import 'widget/bottom_menu_bar.dart';
import 'widget/device_type_widget.dart';
import 'widget/devices_widget.dart';
import 'widget/home_mode_widget.dart';
import 'widget/locations_widget.dart';
import 'widget/weather_widget.dart';
import 'widget/left_menu_ber.dart';


class HomeScreen extends StatefulWidget {
	final UserHomeModel userHomeModel;
	HomeScreen({
		Key key,
		@required this.userHomeModel
	}): super(key: key);

	@override
	_HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State < HomeScreen > {
	UserHomeModel userHomeModel;


	@override
	void initState() {

		// 웹소켓 리스너 대기
		WebSocketListener.listen(context, widget.userHomeModel.id.toString());
		
		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		userHomeModel = widget.userHomeModel;
		final userEmail = globalUser.email;
		int idx = userHomeModel.users.indexWhere((user) => user.email == userEmail);
		String userImageBase64 = "";
		if (idx != -1) {
			userImageBase64 = userHomeModel.users[idx].picture;
		}
		MemoryImage userImage;
		if (userImageBase64 != null && userImageBase64 != "") {
			try {
				userImage = MemoryImage(base64Decode(userImageBase64));
			} catch (e) {}
		}

		return
		Scaffold(
			drawer: LeftMenuBarWidget(userHomeModel: userHomeModel),
			appBar: AppBar(
				iconTheme: IconThemeData(
					color: Colors.black, //change your color here
				),
				toolbarHeight: 70,
				backgroundColor: BgColor.white,
				leading: Builder(
					builder: (context) => SizedBox(
						width: 30,
						height: 30,
						child: IconButton(
							icon: Image.asset(
								"assets/images/nav.png",
								fit: BoxFit.fitHeight
							),
							tooltip: 'Navigation menu',
							onPressed: () => Scaffold.of(context).openDrawer(),
						),
					)
				),
				title: Container(
					width: double.infinity,
					height: 60,
					child: IconButton(
						alignment: Alignment.center,
						icon: Image.asset(
							"assets/images/logo.png",
							fit: BoxFit.fitHeight,
						),
						onPressed: () {
							Navigator.push(context, MaterialPageRoute(builder: (context) => Home()), );
						},
					),
				),
				actions: < Widget > [
					InkWell(
						onTap: () {
							_getImage();
						},
						child: Container( // Face
							margin: EdgeInsets.only(right: 10),
							child: CircleAvatar(
								radius: 24.0,
								backgroundImage: userImage == null ? AssetImage("assets/images/picture.png") : userImage
							),
						),
					),

				],
			),
			bottomNavigationBar: BottomAppBar(

				//하단 메뉴 바 표시
				child:
				BottomMenuBarWidget(userHomeModel: userHomeModel, menuCode: "smarthome"),

				// BlocBuilder < UserHomeBloc, UserHomeState > (
				// 	builder: (context, UserHomeState state) {
				// 		return BottomMenuBarWidget(userHomeModel: userHomeModel, menuCode: "smarthome");
				// 	}
				// )

				// BlocConsumer < UserHomeBloc, UserHomeState > ( ////BlocConsumer 사용 - listener 사용하기 위하여
				// listener: (context, state) {
				// 	print("bottomNavigationBar BlocConsumer listener!!");
				// 	setState(() {}); //삭제시 바로 반영되게 하기 위하여 추가함.
				// },
				// builder: (context, UserHomeState state) {
				// 	return BottomMenuBarWidget(userHomeModel: userHomeModel, menuCode: "smarthome");
				// }
				//)

			),
			body:
			DoubleBack(
				message: "'뒤로' 버튼을 한번 더 누르시면 앱이 종료됩니다.",
				child:
				Container(
					constraints: BoxConstraints.expand(),
					decoration: BoxDecoration(color: BgColor.lgray),
					child: SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: < Widget > [

								//날씨정보 설정
								_buildWeather(context),

								Container(
									decoration: BoxDecoration(
										color: BgColor.white
									),
									margin: EdgeInsets.only(top: 10),
									padding: EdgeInsets.only(top: 15),
									child: Column(
										children: < Widget > [
											InkWell(
												onTap: () {
													// 설정-즐겨찾기 관리화면으로 이동
													Navigator.push(
														context,
														MaterialPageRoute(
															builder: (_) => BlocProvider < UserHomeBloc > (
																create: (_) => UserHomeBloc(userHomeModel),
																child: ConfigFavorite(userHomeModel: userHomeModel, prevPage: "/smarthome", ),
															))
													);
												},
												child: Column(
													children: < Widget > [
														Row(
															mainAxisAlignment: MainAxisAlignment.start,
															children: < Widget > [
																Align(alignment: Alignment.centerLeft),
																Container(
																	padding: EdgeInsets.only(left: 15),
																	color: BgColor.white,
																	child: Text(
																		'즐겨찾기',
																		textAlign: TextAlign.right,
																		style: TextFont.medium
																	),
																),
																Container(
																	width: 14,
																	height: 14,
																	margin: EdgeInsets.only(left: 5),
																	child: Image.asset(
																		"assets/images/gear.png",
																		fit: BoxFit.fitHeight,
																	),
																),
															],
														),
													],
												),
											),
											Container(
												width: double.infinity,
												child: SingleChildScrollView(
													padding: EdgeInsets.only(left: 10, right: 10),
													scrollDirection: Axis.horizontal,
													child: Column(
														children: < Widget > [
															Container(
																child: Row(
																	mainAxisAlignment: MainAxisAlignment.start,
																	// 즐겨찾기 디바이스 Card 목록 
																	children: _buildDevices(context),

																),
															),

															// BlocConsumer < UserHomeBloc, UserHomeState > ( ////BlocConsumer 사용 - listener 사용하기 위하여
															// 	listener: (context, state) {
															// 		print("HomeScreen BlocConsumer listener!!");
															// 		setState(() {});
															// 	},
															// 	builder: (context, UserHomeState state) {
															// 		return 
															// 		Container(
															// 			child: Row(
															// 				mainAxisAlignment: MainAxisAlignment.start,
															// 				// 즐겨찾기 디바이스 Card 목록 
															// 				children: _buildDevices(context),

															// 			),
															// 		);
															// 	}
															// )
														],
													),
												)),
										]),
								),
								Container(
									color: BgColor.white,
									margin: EdgeInsets.only(top: 10),
									padding: EdgeInsets.only(top: 15),
									child: Column(children: < Widget > [
										InkWell(
											onTap: () {
												Navigator.push(
													context,
													MaterialPageRoute(
														builder: (_) => BlocProvider < UserHomeBloc > (
															create: (_) => UserHomeBloc(userHomeModel),
															child: ConfigLocations(userHomeModel: userHomeModel, prevPage: "/smarthome", ),
														))
												);
											},
											child: Column(
												children: < Widget > [
													Row(
														mainAxisAlignment: MainAxisAlignment.start,
														children: < Widget > [
															Align(alignment: Alignment.centerLeft),
															Container(
																padding: EdgeInsets.only(left: 15),
																color: BgColor.white,
																child: Text(
																	'공간별 제어',
																	textAlign: TextAlign.right,
																	style: TextFont.medium
																),
															),
															Container(
																width: 14,
																height: 14,
																margin: EdgeInsets.only(left: 5),
																child: Image.asset(
																	"assets/images/gear.png",
																	fit: BoxFit.fitHeight,
																),
															),
														],
													),
												],
											),
										),
										Container(
											width: double.infinity,
											child: SingleChildScrollView(
												padding: EdgeInsets.all(0),
												scrollDirection: Axis.horizontal,
												child: Column(
													children: < Widget > [
														Row(
															mainAxisAlignment: MainAxisAlignment.start,

															// 공간별제어 - 공간 목록
															children: _buildLocations(context),

														),
													],
												),
											)),
									]),
								),
								Container(
									color: BgColor.white,
									margin: EdgeInsets.only(top: 10),
									padding: EdgeInsets.only(top: 15),
									child: Column(children: < Widget > [
										InkWell(
											onTap: () {
												print('asd');
											},
											child: Column(
												children: < Widget > [
													Row(
														mainAxisAlignment: MainAxisAlignment.start,
														children: < Widget > [
															Align(alignment: Alignment.centerLeft),
															Container(
																padding: EdgeInsets.only(left: 15),
																color: BgColor.white,
																child: Text(
																	'기기별 제어',
																	textAlign: TextAlign.right,
																	style: TextFont.medium
																),
															),
														],
													),
												],
											),
										),
										Container(
											width: double.infinity,
											child: SingleChildScrollView(
												padding: EdgeInsets.only(left: 10, right: 10),
												scrollDirection: Axis.horizontal,
												child: Container(
													alignment: Alignment.centerLeft,
													child: Row(
														mainAxisAlignment: MainAxisAlignment.start,
														// 기기 구분 목록
														children: _buildDeviceTypes(context),
													),
												)
											)),
									]),
								),
								Container(
									color: BgColor.white,
									margin: EdgeInsets.only(top: 10),
									child: Column(children: < Widget > [
										InkWell(
											onTap: () {
												Navigator.push(
													context,
													MaterialPageRoute(
														builder: (_) => BlocProvider < UserHomeBloc > (
															create: (_) => UserHomeBloc(userHomeModel),
															child: ConfigRoutines(userHomeModel: userHomeModel, prevPage: "/smarthome", ),
														))
												);
											},
											child: Column(
												children: < Widget > [
													Row(
														mainAxisAlignment: MainAxisAlignment.start,
														children: < Widget > [
															Align(alignment: Alignment.centerLeft),
															Container(
																padding: EdgeInsets.only(
																	top: 15, left: 15),
																color: BgColor.white,
																child: Text(
																	'간편 모드',
																	textAlign: TextAlign.right,
																	style: TextFont.medium
																),
															),
															Container(
																width: 14,
																height: 14,
																margin: EdgeInsets.only(left: 5, top: 15),
																child: Image.asset(
																	"assets/images/gear.png",
																	fit: BoxFit.fitHeight,
																),
															),
														],
													),
												],
											),
										),
										Container(
											width: double.infinity,
											child: SingleChildScrollView(
												padding: EdgeInsets.only(left: 10, right: 10),
												scrollDirection: Axis.horizontal,
												child: Container(
													alignment: Alignment.centerLeft,
													child: Row(
														mainAxisAlignment: MainAxisAlignment.start,

														// 모드(루틴) 목록
														children: _buildHomeModes(context)

													),
												)
											)
										),
									]),
								),
							]
						)
					)
				)
			)
		);
	}

	/// 날씨 영역 표시
	Widget _buildWeather(BuildContext context) {
		String address = userHomeModel.village.address;
		print('단지 주소 : ' + address);
		address = "경기도 성남시 분당구 장미로 42";
		return WeatherWidget(address);
	}


	/// 즐겨찾기 기기 목록 표시
	List < Widget > _buildDevices(BuildContext context) {
		final _homeService = HomeService();
		final favoriteDevices = _homeService.getFavoriteDevices(userHomeModel); // 변경사항을 반영하려면 다시 얻어와야 함.

		//print("_buildDevices userHomeModel.favoriteDevices length : ${favoriteDevices.length}");
		if (favoriteDevices.length > 0) {
			return favoriteDevices.map((device) {
				return BlocBuilder < UserHomeBloc, UserHomeState > (
					//listener: (context, state) {},  //BlocConsumer 사용시
					builder: (context, UserHomeState state) {
						return DeviceCardWidget(device: device);
					}
				);
			}).toList();
		} else {
			return <Widget > [
				Container(
					// color: BgColor.white,
					margin: EdgeInsets.only(top: 10),
					padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 18),
					child: Text(
						'자주 사용하는 기기를 즐겨찾기로 설정하세요.',
						style: TextFont.normal
					)
				)
			];
		}
	}

	/// 공간 영역 표시
	List < Widget > _buildLocations(BuildContext context) {
		List < LocationModel > locations = userHomeModel.locations;
		List < Widget > locationList = [];
		for (LocationModel location in locations) {
			if (location.devices.length > 0) {
				locationList.add(
					BlocBuilder < UserHomeBloc, UserHomeState > (
						builder: (context, UserHomeState state) {
							return LocationCardWidget(userHomeModel: userHomeModel, location: location);
						}
					)
				);
			}
		}
		return locationList;
	}

	/// 기기구분 영역 표시
	List < Widget > _buildDeviceTypes(BuildContext context) {

		List < DeviceTypeModel > deviceType = userHomeModel.deviceTypes;

		return deviceType.map((deviceType) {
			return new DeviceTypeCardWidget(userHomeModel: userHomeModel, deviceType: deviceType);
		}).toList();
	}

	/// 모드(루틴) 영역 표시
	List < Widget > _buildHomeModes(BuildContext context) {
		List < RoutineModel > routines = userHomeModel.routines;
		List < Widget > routinesWidget = [];

		// 아래 2개는 기본적으로 표시한다.
		// 단지별 설정된 사용기기 구분에 엘리베이터와 일괄소등이 있는지 체크하여 있으면 기본적으로 간편모드에 넣는다.
		if(userHomeModel.village.devicemodels != null && userHomeModel.village.devicemodels.length > 0){
			int idx = userHomeModel.village.devicemodels.indexWhere((devicemodel) => devicemodel.devicemodel.modeltype.code == "ELEVATOR");
			if(idx >=0 ){
				routinesWidget.add(HomeModeWidget(routineId: -1, routineName: "승강기호출", deviceId: "ELEVATOR"));
			}
			idx = userHomeModel.village.devicemodels.indexWhere((devicemodel) => devicemodel.devicemodel.modeltype.code == "switch");
			if(idx >=0 ){
				//int sIdx = userHomeModel.homedevices.indexWhere((device) => device.devicemodel.modeltype.code == "switch");
				for(var device in userHomeModel.homedevices){
					if(device.devicemodel.modeltype.code == "switch" && device.deviceName == "일괄조명"){
						routinesWidget.add(HomeModeWidget(routineId: -1, routineName: "일괄소등", deviceId: device.deviceId));
						break;
					}
				}
			}
		}

		//routinesWidget.add(HomeModeWidget(routineId: -1, routineName: "방범설정", deviceId: "SECURITY"));
		for (var routine in routines) {
			routinesWidget.add(HomeModeWidget(routineId: routine.id, routineName: routine.routineName, deviceId: null));
		}
		return routinesWidget;
	}

	/// 상단 우측에 사용자 사진 변경 처리
	Future _getImage() async {
		final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 200, maxWidth: 200);
		var bytes;
		try {
			bytes = await pickedImage.readAsBytes();
		} catch (e) {
			return;
		}

		String base64Encode = base64.encode(bytes);
		dynamic userInfo = {
			"picture": base64Encode
		};
		final userService = UserService();
		bool isSuccess = await userService.doChangeUserInfo(userInfo);

		if (isSuccess) {
			final userEmail = globalUser.email;
			int idx = userHomeModel.users.indexWhere((user) => user.email == userEmail);
			if (idx != -1) {
				widget.userHomeModel.users[idx].picture = base64Encode;
			}
			setState(() {});
		}
	}

}
