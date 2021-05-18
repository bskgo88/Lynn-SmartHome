import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_home_bloc.dart';
import '../service/websocket_service.dart';
import '../model/location_devices_model.dart';
import '../model/user_home_model.dart';
import '../common/style.dart';
import 'widget/devices_control_common_widget.dart';
import 'widget/devices_control_devices_widget.dart';


class DeviceControl extends StatefulWidget {
	final UserHomeModel userHomeModel;
	final LocationModel location;
	DeviceControl({
		Key key,
		this.userHomeModel,
		this.location
	}): super(key: key);

	@override
	_DeviceControlState createState() => _DeviceControlState();
}

class _DeviceControlState extends State < DeviceControl > {
	@override
	void initState() {
		WebSocketListener.listen(context, widget.userHomeModel.id.toString());
		
		super.initState();
		// try {
		// 	BlocProvider.of < UserHomeBloc > (context);
		// } catch (e) {
		// 	print("Error $e");
		// }
	}

 	// ignore: unused_field
	String _deviceId = ""; // 중요 
	changeDevice(String deviceId) {
		//print("_DeviceControlState.changeDevice called!! deviceId : $deviceId");
		setState(() {
			this._deviceId = deviceId;
		});
	}

	/// 공간에 들어가는 상단 탭 표시
	List < Widget > _buildDeviceControlTabs(BuildContext context) {

		// 기기가 존재하는 공간만 나오도록 수정 
		List < Widget > locationList = [];
		for (LocationModel location in widget.userHomeModel.locations) {
			if (location.devices.length > 0) {
				locationList.add(
					DeviceControlTabWidget(location: location)
				);
			}
		}
		return locationList;
	}

	/// 공간의 각 탭에 들어가는  상세 화면 - 기기 정보 조회 및 컨트롤 표시
	List < Widget > _buildDeviceControlDeviceTabs(BuildContext context) {

		// 기기가 존재하는 공간만 나오도록 수정 
		List < Widget > locationList = [];
		for (LocationModel location in widget.userHomeModel.locations) {
			if (location.devices.length > 0) {
				locationList.add(
					BlocBuilder < UserHomeBloc, UserHomeState > (
						builder: (context, UserHomeState state) {
							return DeviceControlCommonWidget(location: location);
						}
					)

					// BlocConsumer < UserHomeBloc, UserHomeState > ( ////BlocConsumer 사용 - listener 사용하기 위하여
					// 	listener: (context, state) {
					// 		print("_buildDeviceControlDeviceTabs BlocConsumer listener!!");
					// 		setState(() {});
					// 	},
					// 	builder: (context, UserHomeState state) {
					// 		return DeviceControlCommonWidget(location: location);
					// 	}
					// )
				);
			}
		}
		//print("_buildDeviceControlDeviceTabs locationList.length : ${locationList.length} ");
		return locationList;

		// return widget.userHomeModel.locations.map((location) {
		// 	// 이전화면에서 일반적으로 화면 이동한 경우
		// 	//await Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceControl(userHomeModel: widget.userHomeModel, location:location)));

		// 	// 아래와 같이 BlocProvider value 설정해야 함
		// 	// return BlocProvider.value(
		// 	// 	value: UserHomeBloc(widget.userHomeModel),
		// 	// 	child: BlocBuilder < UserHomeBloc, UserHomeState > (
		// 	// 		builder: (context, UserHomeState state) {
		// 	// 			return DeviceControlCommonWidget(location:location);
		// 	// 		}
		// 	// 	)
		// 	// );
		// 	return BlocBuilder < UserHomeBloc, UserHomeState > (
		// 		//listener: (context, state) {},  //BlocConsumer 사용시
		// 		builder: (context, UserHomeState state) {
		// 			return DeviceControlCommonWidget(location: location);
		// 		}
		// 	);
		// }).toList();
	}

	@override
	Widget build(BuildContext context) {

		int defaultIndex = 0;
		int locationCnt = 0;
		int index = 0;
		for (LocationModel location in widget.userHomeModel.locations) {
			if (location.devices.length == 0) {
				continue;
			}
			if (location.locationId == widget.location.locationId) { // 기기가 존재한 공간 체크 추가
				defaultIndex = index;
			}
			index++;
		}
		locationCnt = index;

		print("_buildDeviceControlDeviceTabs locationCnt :  $locationCnt  defaultIndex : $defaultIndex");

		// 웹소켓 리스너 대기  --> initState() 로 이동
		//WebSocketListener().listen(context, widget.userHomeModel.id.toString());

		return MaterialApp(
			debugShowCheckedModeBanner: false,
			home: DefaultTabController(
				length: locationCnt, // 탭 사이즈 - 공간 갯 수 
				initialIndex: defaultIndex, // 기본적으로 보여지는 탭 인텍스
				child: Scaffold(
					appBar: AppBar(
						title: Text(
							'공간별 기기 제어',
							style: TextFont.big_n,
						),
						iconTheme: IconThemeData(
							color: Colors.black, //change your color here
						),
						leading: IconButton(
							icon: Icon(
								Icons.arrow_back
							),
							tooltip: 'Navigation menu',
							onPressed: () {
								Navigator.pushNamed(context, '/smarthome');
								//Navigator.pushReplacementNamed(context, '/smarthome');
							}
						),
						elevation: 0,
						backgroundColor: BgColor.white,
						bottom: PreferredSize(
							preferredSize: const Size.fromHeight(kToolbarHeight),
								child: Container(
									padding: EdgeInsets.only(top: 10),
									color: BgColor.lgray,
                  //child: SingleChildScrollView(
			            //padding: EdgeInsets.all(0),
									child: Align(
										alignment: Alignment.centerLeft,
										child: TabBar(
											labelPadding: EdgeInsets.all(0),
											isScrollable: true,
											indicatorWeight: 0,
											unselectedLabelColor: BgColor.black,
											labelColor: BgColor.black,
											indicator: BoxDecoration(
												image: DecorationImage(
													image: AssetImage("assets/images/tabbg.png"),
													fit: BoxFit.fitWidth,
												)
											),
											indicatorSize: TabBarIndicatorSize.tab,
											labelStyle: TextFont.big_n,
											unselectedLabelStyle: TextFont.semibig,
											onTap: (index) {

											},
											// 상단탭 표시
											tabs: _buildDeviceControlTabs(context),
										),
									)
								)
                //)
						)
					),

					body: TabBarView(

						// 각 탭 내용(배열) - 기기목록 및 상세 기기 정보
						children: _buildDeviceControlDeviceTabs(context),

					),
				)
			)
		);
	}
}
