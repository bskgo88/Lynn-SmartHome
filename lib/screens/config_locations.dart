import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_home_bloc.dart';
import '../common/ui_common.dart';
import '../common/validation.dart';
import '../model/location_devices_model.dart';
import '../model/user_home_model.dart';
import '../screens/widget/name_change_widget.dart';
import '../service/config_service.dart';
import '../common/style.dart';

class ConfigLocations extends StatefulWidget {
	final UserHomeModel userHomeModel;
	final prevPage;
	ConfigLocations({
		Key key,
		@required this.userHomeModel, 
		this.prevPage
	}): super(key: key);

	@override
	_ConfigLocationsState createState() => _ConfigLocationsState();
}

class _ConfigLocationsState extends State < ConfigLocations > {

	void initState() {
		print("_ConfigLocationsState initState");
		super.initState();
		try {
			BlocProvider.of < UserHomeBloc > (context);
		} catch (e) {
			print("Error $e");
		}
	}

	@override
	Widget build(BuildContext context) {
		// Scaffold is a layout for the major Material Components.
		return Scaffold(
			appBar: AppBar(
				title: Text(
					'공간 관리',
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
						if(widget.prevPage != null){
							Navigator.pushNamed(context, widget.prevPage);
							//Navigator.pushReplacementNamed(context, widget.prevPage);
						}else{
							Navigator.of(context).pop();
						}
					}
				),
				backgroundColor: BgColor.white,
			),
			body: Container(
				constraints: BoxConstraints.expand(),
				decoration: BoxDecoration(color: BgColor.lgray),
				child: SingleChildScrollView(
					padding: EdgeInsets.all(20),
					child: Column(
						children: < Widget > [

							Column(
								mainAxisAlignment: MainAxisAlignment.start,

								// 공간 목록
								children: _buildLocations(context),
							),

							Container( // 버튼영역
								width: double.infinity,
								height: 50,
								margin: EdgeInsets.only(top: 13),
								decoration: BoxDecoration(
									color: BgColor.main,
									boxShadow: [Shadows.fshadow],
									borderRadius: Radii.radi10,
								),
								child: FlatButton(
									onPressed: () async {

										// 공간 생성 다이얼로그 표시
										bool result = await _createLocationDialog(context);
										if (result != null && result) {
											//final snackBar = SnackBar(content: Text('등록 되었습니다.'));
											//Scaffold.of(context).showSnackBar(snackBar);
											setState(() {});
										} else if (result != null && !result) {
											//final snackBar = SnackBar(content: Text('실패 하였습니다.'));
											//Scaffold.of(context).showSnackBar(snackBar);
										}
									},
									child: Text(
										'공간추가',
										style: TextFont.semibig_w,
									)
								)
							),
						],
					),
				)
			),
		);
	}

	/// 공간 영역 표시
	List < Widget > _buildLocations(BuildContext context) {
		List < LocationModel > locations = widget.userHomeModel.locations;
		return locations.map((location) {
			return BlocConsumer < UserHomeBloc, UserHomeState > ( ////BlocConsumer 사용 - listener 사용하기 위하여
				listener: (context, state) {
					print("_buildLocations BlocConsumer listener!!");
					setState(() {}); //삭제시 바로 반영되게 하기 위하여 추가함.
				},
				builder: (context, UserHomeState state) {
					return ConfigLocationCardWidget(userHomeModel: widget.userHomeModel, location: location);
				}
			);
		}).toList();
	}

}


/// 공간 위젯
class ConfigLocationCardWidget extends StatefulWidget {
	//final List < LocationModel > locations;
	final UserHomeModel userHomeModel;
	final LocationModel location; //선택된 공간 정보
	ConfigLocationCardWidget({
		Key key,
		this.userHomeModel,
		this.location, 
	}): super(key: key);

	@override
	_ConfigLocationCardWidgetState createState() => _ConfigLocationCardWidgetState();
}

class _ConfigLocationCardWidgetState extends State < ConfigLocationCardWidget > {
	Widget build(BuildContext context) {
		LocationModel location = widget.location;

		UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);
		//return BlocBuilder<UserHomeBloc, UserHomeState>(
		//builder: (context, UserHomeState state) {
		return Material(
			color: Colors.transparent,
			child:


			Container(
				margin: EdgeInsets.only(bottom: 7, ),
				decoration: BoxDecoration(
					borderRadius: Radii.radi15,
					boxShadow: [Shadows.fshadow],
					color: BgColor.white,
				),
				width: double.infinity,
				child: FlatButton(
					shape: RoundedRectangleBorder(
						borderRadius: Radii.radi15,
					),
					padding: EdgeInsets.all(0),
					child: Column(
						children: [
							Container(
								padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
								decoration: BoxDecoration(
									borderRadius: Radii.radi15,
								),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.start,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										Expanded(
											child: InkWell(
												onTap: () {},
												onLongPress: () async {
													// 기기 명 변경 다이얼로그 표시 
													bool result = await LocationNameChangeDialog(context, location.locationId, location.locationName);
													if (result != null && result) {
														UICommon.showMessage(context, "수정 되었습니다.");
													} else if (result != null && !result) {
														UICommon.showMessage(context, "실패 되었습니다.");
													}
												},
												child: Text(
													location.locationName, // 공간 이름 
													style: TextFont.big,
												),
											),
										),


										Visibility(
											visible: location.locationId == -1 ? false : true,
											maintainSize: true,
											maintainAnimation: true,
											maintainState: true,
											child:
											InkWell(
												child: Container(
													width: 34,
													height: 34,
													padding: EdgeInsets.all(10),
													decoration: BoxDecoration(
														color: BgColor.white,
														boxShadow: [Shadows.fshadow],
														borderRadius: Radii.radi20,
													),
													child: Container(
														child: Image.asset(
															"assets/images/plus.png",
															fit: BoxFit.fitWidth,
														),
													)
												), onTap: () {
													showDialog(
														context: context,
														builder: (BuildContext newContext) {
															//UserHomeBloc userHomeBloc = BlocProvider.of<UserHomeBloc>(context);
															return AddListDevicesWidget(userHomeModel: widget.userHomeModel, locationId: location.locationId, userHomeBloc: BlocProvider.of < UserHomeBloc > (context));

															// 아래는 오류 발생 
															//return BlocBuilder < UserHomeBloc, UserHomeState > (
															// 	builder: (context, UserHomeState state) {
															// 		return AddListDevicesWidget(userHomeModel:widget.userHomeModel, locationId:location.locationId);
															// 	}
															// );
														},
													);
												},
											),
										),
										Visibility( // 삭제 신규
											visible: location.locationId == -1 ? false : true,
											child: InkWell(
												child: Container(
													margin: EdgeInsets.only(left: 10),
													width: 34,
													height: 34,
													padding: EdgeInsets.all(12),
													decoration: BoxDecoration(
														color: BgColor.white,
														boxShadow: [Shadows.fshadow],
														borderRadius: Radii.radi20,
													),
													child: Container(
														child: Image.asset(
															"assets/images/close.png",
															fit: BoxFit.fitWidth,
														),
													)
												), onTap: () async {
													if (widget.location.locationId == -1) {
														return false;
													}
													// 해당 공간에 기기가 있으면 삭제할 수 없음
													int index = widget.userHomeModel.locations.indexWhere((searchLocation) => searchLocation.locationId == widget.location.locationId);
													if (widget.userHomeModel.locations[index].devices.length > 0) {
														UICommon.alert(context, "기기가 있는 공간은\n삭제할 수 없습니다.");
													} else {
														// 공간 삭제 확인 다이얼 로그
														bool isConfirm = await UICommon.confirmDialog(context, "삭제 확인", '${location.locationName} 공간을 삭제 하시겠습니까?', "취소", "삭제");
														if (isConfirm != null && isConfirm) {
															bool isSuccess = await _configService.doDeleteLocation(context, location.locationId);
															if (isSuccess) {
																// 성공 시 화면 State 변경 처리
																userHomeBloc.add(HomeLocationsChangedEvent(changeMode: "DELETE", locationId: location.locationId, locationName: ""));
																UICommon.showMessage(context, "삭제 되었습니다.");
															} else {
																UICommon.showMessage(context, "실패 하였습니다.");
															}
														}
													}
												}
											),
										)
									],
								),
							),
							Container(
								width: double.infinity,
								child: SingleChildScrollView(
									padding: EdgeInsets.only(left: 10, right: 10, ),
									scrollDirection: Axis.horizontal,
									child: Row(
										mainAxisAlignment: MainAxisAlignment.start,

										//공간에 들어가는 기기 목록 
										children: _buildLocationDevices(context)


									),
								),
							),
						],
					),
					onPressed: () {},
				),
			),


		);
		//},
		//);
	}

	/// 공간에 들어가는 기기 목록 표시
	List < Widget > _buildLocationDevices(BuildContext context) {
		if (widget.location.devices.length > 0) {
			return widget.location.devices.map((device) {
				return DeviceSmallCardWidget(locationId: widget.location.locationId, device: device);
			}).toList();
		} else {
			return <Widget > [
				Container(
					constraints: BoxConstraints(minHeight: 50),
					padding: EdgeInsets.only(left: 10, right: 10, ),
					child: Text(
						"+ 버튼으로 기기를 추가하세요.",
						style: TextFont.normal,
						textAlign: TextAlign.left,
					)
				)
			];
		}
	}

}


ConfigService _configService = ConfigService();

/// 공간에 들어가는 기기 목록 위젯
class DeviceSmallCardWidget extends StatefulWidget {
	final locationId;
	final UserHomeDevices device;

	DeviceSmallCardWidget({
		this.locationId,
		this.device
	});

	@override
	_DeviceSmallCardWidgetState createState() => _DeviceSmallCardWidgetState();
}

class _DeviceSmallCardWidgetState extends State < DeviceSmallCardWidget > {
	bool isPowerOn = false;
	Widget build(BuildContext context) {
		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;

		UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);



		//초기 기기 전원 상태 설정 
		isPowerOn = device.power == "on" ? true : false;
		String imageSuffix = isPowerOn ? "_on" : "";

		return Material(
			color: Colors.transparent,
			child:

			Container(
				margin: EdgeInsets.only(
					top: 10, bottom: 15, left: 5, right: 5),
				decoration: BoxDecoration(
					color: BgColor.white,
					borderRadius: Radii.radi10,
					boxShadow: [Shadows.fshadow],
				),
				width: 90,
				height: 90,
				child: FlatButton(
					//padding: EdgeInsets.all(0),
					child: Stack(
						children: < Widget > [
							Positioned(
								width: 90,
								height: 90,
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										Container(
											width: 54,
											height: 34,
											margin: EdgeInsets.only(bottom: 5),
											child: Image.asset(
												UICommon.deviceIcons[deviceTypeCode] + imageSuffix + ".png",
												fit: BoxFit.fitHeight,
											),
										),
										Text(device.deviceName, style: TextFont.normal),
									]
								)
							),
							Positioned(
								right: 5,
								top: 5,
								child: InkWell(
									child: Container(
										width: 24,
										height: 24,
										padding: EdgeInsets.all(8),
										alignment: Alignment.center,
										decoration: BoxDecoration(
											borderRadius: Radii.radi20,
											color: BgColor.white,
											boxShadow: [Shadows.fshadow],
										),
										child: Image.asset(
											"assets/images/close.png",
											fit: BoxFit.fitWidth,
										),
									),
									onTap: () async {
										if (widget.locationId == -1) {
											UICommon.alert(context, "기타 공간의 기기는 삭제할 수 없습니다.");
											return;
										}

										bool isConfirm = await UICommon.confirmDialog(context, "삭제 확인", '${device.deviceName} 을(를) 해당 공간에서 삭제 하시겠습니까?', "취소", "삭제");
										if (isConfirm != null && isConfirm) {
											bool isSuccess = await _configService.doChangeDeviceInfo(context, device.deviceId, device.deviceName, -1); // locationId -1 이면 삭제
											if (isSuccess) {
												// 화면 state 변경 
												userHomeBloc.add(DeviceLocationChangedEvent(changeMode: "DELETE", deviceId: device.deviceId, locationId: widget.locationId));
												UICommon.showMessage(context, "삭제 되었습니다.");
											} else {
												Navigator.of(context).pop(false);
												UICommon.showMessage(context, "실패 하였습니다.");
											}
										}


									},
								),
							)
						]
					),
					onPressed: () {},
				),
			),
		);
	}

}


/// 기기 추가 다이얼로그 창 화면 
class AddListDevicesWidget extends StatefulWidget {
	final UserHomeModel userHomeModel;
	final locationId;
	final userHomeBloc;
	AddListDevicesWidget({
		this.userHomeModel,
		this.locationId,
		this.userHomeBloc
	});

	@override
	_AddListDevicesWidgetState createState() => _AddListDevicesWidgetState();
}

class _AddListDevicesWidgetState extends State < AddListDevicesWidget > {

	Widget build(BuildContext context) {

		selectedDevices = []; // 새로 팝업 창 열 때 초기화 해야함.

		//UserHomeBloc userHomeBloc = BlocProvider.of<UserHomeBloc>(context);  //에러 
		bool isButtonEnable = true;
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
					'등록된 기기 목록',
					style: TextFont.medium_w,
				),
			),
			content: SingleChildScrollView(
				padding: EdgeInsets.all(15),
				child: Column(

					children: _buildAddListDevices(context) // 기기 목록 위젯 

				)
			),
			actions: < Widget > [
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Container(
							width: MediaQuery.of(context).size.width / 2 - 50,
							decoration: BoxDecoration(
								color: BgColor.lgray
							),
							child: FlatButton(
								onPressed: () {
									Navigator.pop(context);
								},
								child: Text(
									'취소',
									style: TextFont.medium
								),
							),
						),
						Container(
							width: MediaQuery.of(context).size.width / 2 - 50,
							decoration: BoxDecoration(
								color: BgColor.main
							),
							child: FlatButton(
								onPressed: () async {
									// 선택된 기기 저장 처리
									if (isButtonEnable) {
										if (selectedDevices.length == 0) {
											UICommon.alert(context, "선택된 기기가 없습니다.");
											return;
										}
										isButtonEnable = false;
										for (String deviceId in selectedDevices) {
											//print("selectedDeviceId : $deviceId");
											for (var device in widget.userHomeModel.homedevices) {
												if (deviceId == device.deviceId) {
													// 기기 추가 - 서버 전송 처리
													_configService.doChangeDeviceInfo(context, device.deviceId, device.deviceName, widget.locationId).then((isSuccess) {
														if (isSuccess) {
															// 화면 state 변경 처리
															widget.userHomeBloc.add(DeviceLocationChangedEvent(changeMode: "INSERT", deviceId: device.deviceId, locationId: widget.locationId));
														}
													});
													break;
												}
											}
										}
										isButtonEnable = true;
										Navigator.of(context).pop();
									}
								},
								child: Text(
									'저장',
									style: TextFont.medium_w
								),
							),
						)
					]
				)
			]
		);
	}


	/// 기기 추가 팝업 다이얼로그에 들어가는 기기 목록 위젯
	List < Widget > _buildAddListDevices(BuildContext context) {

		final homedevices = widget.userHomeModel.homedevices;
		int index = widget.userHomeModel.locations.indexWhere((location) => location.locationId == widget.locationId);
		final locationDevices = widget.userHomeModel.locations[index].devices;

		print("_buildAddListDevices  locationId : $widget.locationId  index : $index   locationDevices.length : ${locationDevices.length}");

		List < Widget > devicesWidget = [];
		for (var device in homedevices) {
			// 일괄소등과 엘리베이터호출은 공간에 기기 추가 화면 목록에서 제외 처리
			if (device.devicemodel.modeltype.code == "LIGHTOFF" || device.devicemodel.modeltype.code == "ELEVATOR") {
				continue;
			}

			if (locationDevices.indexWhere((locationDevice) => locationDevice.deviceId == device.deviceId) < 0) {
				devicesWidget.add(AddListDeviceWidget(device: device, locationId: widget.locationId, userHomeBloc: widget.userHomeBloc));
			}
		}
		return devicesWidget;

		// 아래는 homedevices 전체임 - 해당 공간에 이미 있는 기기는 제외 로직 적용 (위)
		// return homedevices.map((device) {
		// 	return AddListDeviceWidget(device: device, locationId: widget.locationId, userHomeBloc: widget.userHomeBloc);
		// }).toList();
	}
}


List < String > selectedDevices = [];

/// 기기 추가에 들어가는 기기 위젯 
class AddListDeviceWidget extends StatefulWidget {
	final UserHomeDevices device;
	final locationId;
	final userHomeBloc;
	AddListDeviceWidget({
		Key key,
		@required this.device,
		@required this.locationId,
		this.userHomeBloc
	}): super(key: key);

	@override
	_AddListDeviceWidgetState createState() => _AddListDeviceWidgetState();
}
class _AddListDeviceWidgetState extends State < AddListDeviceWidget > {
	bool isSuccess = false;
	bool isButtonEnable = true;
	final _configService = ConfigService();
	bool isSelected;
	Widget build(BuildContext context) {
		//UserHomeBloc userHomeBloc = BlocProvider.of<UserHomeBloc>(context);  // 그냥 사용하면 에러 발생 --> 파라미터로 받아오게 변경 함.

		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;
		if (isSelected == null) isSelected = false;

		return Material(
			color: Colors.transparent,
			child:

			Container(
				margin: EdgeInsets.only(bottom: 7),
				decoration: BoxDecoration(
					boxShadow: [Shadows.fshadow],
					borderRadius: Radii.radi10,
					color: BgColor.white,
				),
				child: Row(
					children: [
						Expanded(
							child: FlatButton(
								padding: EdgeInsets.all(13),
								onPressed: () async {
									if (isButtonEnable) {
										isButtonEnable = false;
										// 기기 추가 - 서버 전송 처리
										isSuccess = await _configService.doChangeDeviceInfo(context, device.deviceId, device.deviceName, widget.locationId);
										isButtonEnable = true;
										if (isSuccess) {
											// 화면 state 변경 처리
											widget.userHomeBloc.add(DeviceLocationChangedEvent(changeMode: "INSERT", deviceId: device.deviceId, locationId: widget.locationId));
										} else {
											//UICommon.showMessage(context, "실패 하였습니다.");
										}
										Navigator.of(context).pop();
									}
								},
								child: Row(
									crossAxisAlignment: CrossAxisAlignment.center,
									mainAxisAlignment: MainAxisAlignment.start,
									children: [
										Container(
											width: 24,
											height: 24,
											margin: EdgeInsets.only(right: 10),
											child: Image.asset(
												UICommon.deviceIcons[deviceTypeCode] + ".png", // 기기 이미지
												fit: BoxFit.fitWidth,
											),
										),
										Expanded(
											child: Text(
												device.deviceName, // 기기 명 
												style: TextFont.normal,
												textAlign: TextAlign.left,
											)
										)
									],
								),
							)
						),
						Container(
							padding: EdgeInsets.only(right: 10),
							child: SizedBox(
								width: 24,
								height: 24,
								child: Checkbox(
									value: isSelected,
									onChanged: (flag) {
										if (flag) {
											selectedDevices.add(device.deviceId);
										} else {
											selectedDevices.removeWhere((deviceId) => deviceId == device.deviceId);
										}
										setState(() {
											isSelected = flag;
										});
									}
								),
							),
						)

					],
				)
			)

		);
	}
}



/// 공간 생성 다이얼 로그 
Future < bool > _createLocationDialog(BuildContext context) async {
	final _configService = ConfigService();
	String locationName;
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();

	UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

	return showDialog < bool > (
		context: context,
		builder: (context) {
			return AlertDialog(
				title: Text('공간 등록'),
				content: SingleChildScrollView(
					child: Column(
						children: [
							Form(
								key: _formKey,
								child:
								TextFormField(
									decoration: InputDecoration(
										filled: true,
										labelText: '등록하실 공간명을 입력하세요',
										fillColor: BgColor.white,
									),
									validator: Validation.checkEmpty,
									onSaved: (String newLocationName) {
										locationName = newLocationName;
									},
								),
							),
						]
					),
				),
				actions: < Widget > [
					Row(
						children: [
							Container(
								decoration: BoxDecoration(
									color: BgColor.lgray
								),
								width: 145,
								child: FlatButton(
									onPressed: () {
										Navigator.pop(context);
									},
									textColor: Theme.of(context).primaryColor,
									child: Text(
										'취소',
										style: TextFont.medium
									),
								),
							),
							Container(
								decoration: BoxDecoration(
									color: BgColor.main
								),
								width: 145,
								child: FlatButton(
									onPressed: () async {
										if (_formKey.currentState.validate()) {
											_formKey.currentState.save();
											dynamic newLocationId = await _configService.doCreateLocation(context, locationName);
											if (newLocationId != null) {
												print("newLocationId : $newLocationId");
												userHomeBloc.add(HomeLocationsChangedEvent(changeMode: "INSERT", locationId: newLocationId, locationName: locationName));
												//userHomeBloc.close();
												Navigator.of(context).pop(true);
											} else {
												Navigator.of(context).pop(false);
											}
										}
									},
									textColor: Theme.of(context).primaryColor,
									child: Text(
										'등록',
										style: TextFont.medium_w
									),
								),
							),
						]
					),
				],
			);
		},
	);
}