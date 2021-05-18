import 'dart:async';
import 'dart:math';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../common/globals.dart';
import '../common/style.dart';
import '../screens/config_favorite.dart';
import '../service/fcm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user_home_bloc.dart';
import '../common/ui_common.dart';
import '../service/home_service.dart';
import '../service/user_service.dart';
import '../model/user_home_model.dart';
import 'community_notice.dart';
import 'communiy.dart';
import 'config.dart';
import 'config_locations.dart';
import 'config_routines.dart';
import 'device_control.dart';
import 'device_control_types.dart';
import 'facility.dart';
import 'home_screen.dart';
import 'login.dart';
import 'community_faq.dart';
import 'config_app_info.dart';
import 'config_family.dart';
import 'facility_car_in_out.dart';
import 'facility_delivery.dart';
import 'facility_energe.dart';
import 'facility_visiting_car.dart';
import 'homenet_login.dart';


class Home extends StatefulWidget {
	@override
	_HomeState createState() => _HomeState();
}

class _HomeState extends State < Home > {
	UserHomeModel userHomeModel;
	var refreshKey = GlobalKey < RefreshIndicatorState > ();
	var random;

	
	@override
	void dispose() {
		print("_HomeState dispose() called!");
		// if(_streamController != null){
		// 	print("_HomeState dispose() called!  WebSocket  _streamController.close()");
		// 	_streamController.close();
		// }else{
		// 	print("_HomeState dispose() WebSocket  _streamController is null");
		// }
		super.dispose();
	}

	@override
	void initState() {
		super.initState();
		random = Random();
	}


	///사용자 홈 데이터 설정 (로그인 시 얻은 사용자 토큰으로 조회)
	Future < String > setUserHomeData() async {
		SharedPreferences _prefs = await SharedPreferences.getInstance();
		String userToken = _prefs.getString("_user_token");
		//print("_HomeScreenState userToken : $userToken");

		// 서버모드 설정
		await setServerMode();

		if (userToken != null && userToken != "") {
			User _user = new User();
			_user.userToken = userToken;
			final _homeService = HomeService();
			dynamic homeData = await _homeService.getHomeModel(_user); //getHomeModel  //getHomeInfo

      // 단지서버에 연결이 안되는 경우 (홈넷사 연결에 문제가 있는 경우) --> 데모모드로 화면을 보여준다.
      if(homeData == null){
        print("홈넷사 연결에 문제가 있습니다.");
        _prefs.setString("_is_server_mode", "N");
        IS_SERVER_MODE = false;
        homeData = await _homeService.getHomeModel(_user);
      }

			if (homeData != null) {
				userHomeModel = homeData;

				//즐겨찾기 기기정보 설정
				userHomeModel.favoriteDevices = _homeService.getFavoriteDevices(userHomeModel);

				//공간별 기기정보 설정
				userHomeModel.locations = await _homeService.getLocationDevicesFromServer(userHomeModel);

				//기기구분별  기기정보 설정
				userHomeModel.deviceTypes = _homeService.getDeviceTypeDevices(userHomeModel);

				//루틴 설정 정보
				userHomeModel.routines = await _homeService.getRoutine();
				//print("_HomeState  setUserHomeData userHomeModel.routines.length : ${userHomeModel.routines.length}");

				// WebSocket 초기화
				// 여기서 웹소켓을 얻어오면 Listen 시에 기기 상태값 변경이 화면에 적용이 안됨
				// initWebSocket();

				// Firebase 초기화
				initFcmMessage();

				//print("_HomeState setUserHomeData User HomeId : ${userHomeModel.id}");
				return userToken;
			}
		}
		return null;
	}

	// void initWebSocket() {
	// 	// 웹소켓 연결 및 Listen
	// 	if (IS_SERVER_MODE && _streamController == null) {
	// 		print("_HomeState build  WebSocket initialize - ${DateTime.now()}");
	// 		try {
	// 			_streamController = WebsocketService(userHomeModel.id.toString()).streamController;
	// 			_streamController.stream.listen((message) {
	// 				try {
	// 					//print("setWebSocketChannel receive message : $message");
	// 					final statusEventModel = StatusEventModel.fromJson(json.decode(message));
	// 					for (var event in statusEventModel.eventList) {
	// 						print("WebSocketChannel receive message device_id : ${statusEventModel.deviceId} command : ${event.command}  value : ${event.value}");
	// 						DeviceService().setDeviceChangedStatus(context, statusEventModel.deviceId, event.command, event.value);
	// 					}
	// 				} catch (e) {
	// 					//print(e);
	// 				}
	// 			});
	// 		} catch (e) {
	// 			print("_HomeState WebSocket Initialize Error : $e");
	// 		}
	// 	}
	// }

	void initFcmMessage() async {
		print("Firebase initFcmMessage - ${DateTime.now()}");
		try {
			FcmService(context, userHomeModel);
		} catch (e) {
			print("Firebase initFcmMessage Error : $e");
		}
	}


	@override
	Widget build(BuildContext context) {
		// 화면 스크롤로 새로 고침 - RefreshIndicator 사용
		return RefreshIndicator(
			key: refreshKey,
			onRefresh: screenRefresh,
			child: FutureBuilder < String > (
				future: setUserHomeData(),
				builder: (context, AsyncSnapshot < String > snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return ShowLoading();
					} else {
						if (snapshot.data == null) {
							return Login();
						} else {
							return MaterialApp(
								debugShowCheckedModeBanner: false,
								routes: {
									'/home': (_) => Home(),
									'/smarthome': (_) => BlocProvider < UserHomeBloc > (create: (_) => UserHomeBloc(userHomeModel), child: HomeScreen(userHomeModel: userHomeModel), ),
									'/login': (_) => Login(),
									'/community': (_) => CommunityListScreen(userHomeModel: userHomeModel),
									'/facility': (_) => FacilityListScreen(userHomeModel: userHomeModel),
									'/config': (_) => BlocProvider < UserHomeBloc > (create: (_) => UserHomeBloc(userHomeModel), child: ConfigListScreen(userHomeModel: userHomeModel), ),
									'/notice': (_) => CommunityNoticeScreen(),
									'/faq': (_) => FaqScreen(noticeTypeCode: 'faq'),
									'/energy': (_) => FacilityEnergeScreen(userHomeModel: userHomeModel),
									'/carInOut': (_) => CarInOutScreen(),
									'/delivery': (_) => DeliveryScreen(),
									'/visitingCar': (_) => VisitingCarScreen(),
									'/configFavorite': (_) => BlocProvider < UserHomeBloc > (create: (_) => UserHomeBloc(userHomeModel), child: ConfigFavorite(userHomeModel: userHomeModel), ),
									'/configLocations': (_) => BlocProvider < UserHomeBloc > (create: (_) => UserHomeBloc(userHomeModel), child: ConfigLocations(userHomeModel: userHomeModel), ),
									'/configRoutines': (_) => BlocProvider < UserHomeBloc > (create: (_) => UserHomeBloc(userHomeModel), child: ConfigRoutines(userHomeModel: userHomeModel), ),
									'/homenetLogin': (_) => BlocProvider < UserHomeBloc > (create: (_) => UserHomeBloc(userHomeModel), child: SignInHomenet(), ),
									'/familyMember': (_) => ConfigFamilyScreen(userHomeModel: userHomeModel),
									'/appInfo': (_) => AppInfoScreen(userHomeModel: userHomeModel),
								},
								
								onGenerateRoute: (routeSettings){ // Navigator.pushNamed() 가 호출된 때 실행됨
									// 라우트 이름이 PassArgementScreen의 routeName과 같은 라우트가 생성될 수 있도록 함
									print("onGenerateRoute routeSettings.name : ${routeSettings.name}");
									if(routeSettings.name == "/controlLocations"){
										Map<String, dynamic> args = routeSettings.arguments; // 라우트세팅에서 파라미터 추출
										final location = args["location"];
										return MaterialPageRoute (
											builder: (_) => BlocProvider < UserHomeBloc > (
												create: (_) => UserHomeBloc(userHomeModel),
												child: DeviceControl(userHomeModel: userHomeModel, location:location),
											)
										);
									}else if(routeSettings.name == "/controlDeviceTypes"){
										Map<String, dynamic> args = routeSettings.arguments; // 라우트세팅에서 파라미터 추출
										final typeModel = args["typeModel"];
										return MaterialPageRoute (
											builder: (_) => BlocProvider < UserHomeBloc > (
												create: (_) => UserHomeBloc(userHomeModel),
												child: DeviceControlTypes(userHomeModel: userHomeModel, typeModel:typeModel),
											)
										);
									}else{
										return null;
									}
								},

								home:  
									DoubleBack(
										message: "'뒤로' 버튼을 한번 더 누르시면 앱이 종료됩니다.",
										child: 

									MultiBlocProvider(
										providers: [
											BlocProvider < UserHomeBloc > (
												create: (context) => UserHomeBloc(userHomeModel),
											),
										],
										child: HomeScreen(userHomeModel: userHomeModel)
									)
								)
							);
						}
					}
				}
			)
		);
	}


	/// 화면 새로 고침
	Future < Null > screenRefresh() async {
		refreshKey.currentState ?.show(atTop: false);
		//await Future.delayed(Duration(seconds: 0)); //시간 간격 설정
		setState(() {});
		return null;
	}
}

Future < bool > notConntectedInfoDialog(BuildContext context) {
    return showDialog < bool > (
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          actionsPadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          title: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(color: BgColor.main),
            child: Text(
              '안내',
              style: TextFont.medium_w,
            ),
          ),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text('세대 기기연결에 살패하였습니다.\n데모모드(체험모드)로 접속됩니다.',
                style: TextFont.medium),
            ),
          ),
          actions: < Widget > [
            FlatButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              textColor: Theme.of(context).primaryColor,
              child: Text('확인', style: TextFont.medium_w),
            ),
          ],
        );
      });
  }
