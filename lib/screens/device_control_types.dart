import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_home_bloc.dart';
import '../model/device_type_devices_model.dart';
import '../screens/widget/devices_control_common_types_widget.dart';
import '../service/websocket_service.dart';
import '../model/user_home_model.dart';
import '../common/style.dart';
import 'widget/devices_control_devices_widget.dart';


class DeviceControlTypes extends StatefulWidget {

	final UserHomeModel userHomeModel;
	final DeviceTypeModel typeModel;
	DeviceControlTypes({
		Key key,
		this.userHomeModel,
		this.typeModel
	}): super(key: key);

	@override
	_DeviceControlTypesState createState() => _DeviceControlTypesState();
}

class _DeviceControlTypesState extends State < DeviceControlTypes > {

	//UserHomeBloc _userHomeBloc;
	@override
	void initState() {
		
		// 웹소켓 리스너 대기
		WebSocketListener.listen(context, widget.userHomeModel.id.toString());

		super.initState();
		// try {
		// 	BlocProvider.of < UserHomeBloc > (context);
		// } catch (e) {
		// 	print("Error $e");
		// }
	}

	// String _deviceId = "";
	// changeDevice(String deviceId) {
	// 	print("_DeviceControlState.changeDevice called!! deviceId : $deviceId");
	// 	setState(() {
	// 		_deviceId = deviceId;
	// 	});
	// }

	/// 공간에 들어가는 상단 탭 표시
	List < Widget > _buildDeviceControlTabs(BuildContext context) {

		return widget.userHomeModel.deviceTypes.map((typeModel) {
			return new DeviceControlTypesTabWidget(typeModel: typeModel);
		}).toList();
	}

	/// 공간의 각 탭에 들어가는  상세 화면 - 기기 정보 조회 및 컨트롤 표시
	List < Widget > _buildDeviceControlDeviceTabs(BuildContext context) {

		return widget.userHomeModel.deviceTypes.map((typeModel) {

			// 이전화면에서 일반적으로 화면 이동한 경우
			//await Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceControl(userHomeModel: widget.userHomeModel, typeModel:typeModel)));

			// 아래와 같이 BlocProvider value 설정해야 함
			// return BlocProvider.value(
			// 	value: UserHomeBloc(widget.userHomeModel),
			// 	child: BlocBuilder < UserHomeBloc, UserHomeState > (
			// 		builder: (context, UserHomeState state) {
			// 			return DeviceControlCommonTypesWidget(typeModel:typeModel);
			// 		}
			// 	)
			// );

			return BlocBuilder < UserHomeBloc, UserHomeState > (
				//listener: (context, state) {},  //BlocConsumer 사용시
				builder: (context, UserHomeState state) {
					return DeviceControlCommonTypesWidget(typeModel: typeModel);
				}
			);

		}).toList();
	}

	@override
	Widget build(BuildContext context) {

		int defaultIndex = 0;
		for (DeviceTypeModel typeModel in widget.userHomeModel.deviceTypes) {
			if (typeModel.deviceTypeId == widget.typeModel.deviceTypeId) {
				break;
			}
			defaultIndex++;
		}

		// 웹소켓 리스너 대기  --> initState() 로 이동
		//WebSocketListener().listen(context, widget.userHomeModel.id.toString());

		return MaterialApp(
			debugShowCheckedModeBanner: false,
			home: DefaultTabController(
				length: widget.userHomeModel.deviceTypes.length, // 탭 사이즈 - 공간 갯 수 
				initialIndex: defaultIndex, // 기본적으로 보여지는 탭 인텍스
				child: Scaffold(
					appBar: AppBar(
						title: Text(
							'기기 구분별 제어',
							style:TextFont.big_n,
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
