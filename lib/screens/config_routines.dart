import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/user_home_bloc.dart';
import '../common/ui_common.dart';
import '../common/validation.dart';
import '../model/routine_devices_model.dart';
import '../model/user_home_model.dart';
import '../screens/widget/name_change_widget.dart';
import '../service/config_service.dart';
import '../common/style.dart';

class ConfigRoutines extends StatefulWidget {
	final UserHomeModel userHomeModel;
	final prevPage;
	ConfigRoutines({
		Key key,
		@required this.userHomeModel, 
		this.prevPage
	}): super(key: key);

	@override
	_ConfigRoutinesState createState() => _ConfigRoutinesState();
}

class _ConfigRoutinesState extends State < ConfigRoutines > {

	void initState() {
		print("_ConfigRoutinesState initState");
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
					'모드(루틴) 관리',
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
								// 루틴 목록
								children: _buildRoutines(context),
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

										// 루틴 생성 다이얼로그 표시
										bool result = await _createRoutineDialog(context);
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
										'루틴추가',
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

	/// 루틴 영역 표시
	List < Widget > _buildRoutines(BuildContext context) {
		List < RoutineModel > routines = widget.userHomeModel.routines;
		return routines.map((routine) {
			return BlocConsumer < UserHomeBloc, UserHomeState > ( ////BlocConsumer 사용 - listener 사용하기 위하여
				listener: (context, state) {
					print("_buildRoutines BlocConsumer listener!!");
					setState(() {}); //삭제시 바로 반영되게 하기 위하여 추가함.
				},
				builder: (context, UserHomeState state) {
					return ConfigRoutineCardWidget(userHomeModel: widget.userHomeModel, routine: routine);
				}
			);
		}).toList();
	}
}


/// 루틴 위젯
class ConfigRoutineCardWidget extends StatefulWidget {
	//final List < RoutineModel > routines;
	final UserHomeModel userHomeModel;
	final RoutineModel routine; //선택된 루틴 정보
	ConfigRoutineCardWidget({
		Key key,
		this.userHomeModel,
		this.routine
	}): super(key: key);

	@override
	_ConfigRoutineCardWidgetState createState() => _ConfigRoutineCardWidgetState();
}

class _ConfigRoutineCardWidgetState extends State < ConfigRoutineCardWidget > {
	final _configService = ConfigService();
	Widget build(BuildContext context) {
		RoutineModel routine = widget.routine;
		UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

		return Material(
			color: Colors.transparent,
			child: Container(
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
					padding: EdgeInsets.only(top: 5, bottom: 5),
					child: Column(
						children: [
							Container(
								padding: EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
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
													bool result = await RoutineNameChangeDialog(context, routine.id, routine.routineName);
													if (result != null && result) {
														UICommon.showMessage(context, "수정 되었습니다.");
													} else if (result != null && !result) {
														UICommon.showMessage(context, "실패 되었습니다.");
													}
												},
												child: Text(
													routine.routineName, // 루틴 이름 
													style: TextFont.big,
												),
											),
										),

										Visibility(
											visible: routine.id == -1 ? false : true,
											maintainSize: true,
											maintainAnimation: true,
											maintainState: true,
											child: InkWell(
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

															// 기기 목록 다이얼로그 표시
															return AddListDevicesWidget(userHomeModel: widget.userHomeModel, routineId: routine.id, userHomeBloc: BlocProvider.of < UserHomeBloc > (context), callback: addDeviceCallback);

														},
													);
												},
											),
										),

										Container( // 플레이버튼 가상영역
											margin: EdgeInsets.only(left: 10),
											child: InkWell(
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
															"assets/images/play.png",
															fit: BoxFit.fitWidth,
														),
													)
												), onTap: () async {
													// 해당 루틴에 기기가 있으면 삭제할 수 없음
													int index = widget.userHomeModel.routines.indexWhere((searchRoutine) => searchRoutine.id == widget.routine.id);
													if (widget.userHomeModel.routines[index].devices.length == 0) {
														UICommon.alert(context, "설정된 기기가 없습니다.");
													} else {
														// 루틴 실행 확인 다이얼 로그
														bool isConfirm = await UICommon.confirmDialog(context, "실행 확인", '${ widget.routine.routineName} 루틴을 실행 하시겠습니까?', "취소", "실행");
														if (isConfirm != null && isConfirm) {
															bool isSuccess = await _configService.doExecuteRoutine(context, widget.routine.id);
															if (isSuccess) {
																UICommon.showMessage(context, "실행 되었습니다.");
															} else {
																UICommon.showMessage(context, "실패 하였습니다.");
															}
														}
													}
												},
											),
										),

                    Container( // 삭제 신규
											margin: EdgeInsets.only(left: 10),
											child: InkWell(
												child: Container(
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
													if (widget.routine.id == -1) {
                            return false;
                          }
                          // 해당 루틴에 기기가 있으면 삭제할 수 없음
                          int index = widget.userHomeModel.routines.indexWhere((searchRoutine) => searchRoutine.id == widget.routine.id);
                          if (widget.userHomeModel.routines[index].devices.length > 0) {
                            UICommon.alert(context, "기기가 있는 루틴은 삭제할 수 없습니다.");
                          } else {
                            // 루틴 삭제 확인 다이얼 로그
                            bool isConfirm = await UICommon.confirmDialog(context, "삭제 확인", '${widget.routine.routineName }루틴을 삭제 하시겠습니까?', "취소", "삭제");
                            if (isConfirm != null && isConfirm) {
                              bool isSuccess = await _configService.doDeleteRoutine(context, widget.routine.id);
                              if (isSuccess) {
                                // 성공 시 화면 State 변경 처리
                                userHomeBloc.add(HomeRoutineChangedEvent(changeMode: "DELETE", routineId: widget.routine.id, routineName: ""));
                                UICommon.showMessage(context, "삭제 되었습니다.");
                              } else {
                                UICommon.showMessage(context, "실패 하였습니다.");
                              }
                            }
                          }
												},
											),
										)
									],
								),
							),
							Container(
								width: double.infinity,
								child: SingleChildScrollView(
									padding: EdgeInsets.only(left: 10, right: 10),
									scrollDirection: Axis.horizontal,
									child: Row(
										mainAxisAlignment: MainAxisAlignment.start,

										//루틴에 들어가는 기기 목록 
										children: _buildRoutineDevices(context)

									),
								),
							),
						],
					),
					onPressed: () {},
					onLongPress: () async {
						//기타 루틴은 삭제 대상아님
						
					},
				),
			),
		);
	}

	/// 루틴에 들어가는 기기 목록 표시
	List < Widget > _buildRoutineDevices(BuildContext context) {
		if (widget.routine.devices.length > 0) {
			return widget.routine.devices.map((device) {
				//print("_buildRoutineDevices routineId: ${widget.routine.id}, device routineId: ${device.routineId} ");
				return DeviceSmallCardWidget(routineId: widget.routine.id, device: device);
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

	/// 기기 추가 처리 결과를 받기 위한 콜백 함수
	addDeviceCallback(isSuccess) {
		if (isSuccess) {
			UICommon.showMessage(context, "추가 하였습니다.");
		} else {
			UICommon.showMessage(context, "실패 하였습니다.");
		}
	}
}




/// 루틴에 들어가는 기기 목록 위젯
class DeviceSmallCardWidget extends StatefulWidget {
	final routineId;
	final RoutineModelDevices device;
	DeviceSmallCardWidget({
		this.routineId,
		this.device
	});
	@override
	_DeviceSmallCardWidgetState createState() => _DeviceSmallCardWidgetState();
}

class _DeviceSmallCardWidgetState extends State < DeviceSmallCardWidget > {
	bool isPowerOn = false;
	final _configService = ConfigService();

	Widget build(BuildContext context) {
		UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);
		RoutineModelDevices device = widget.device;
		String deviceTypeCode = device.homedevice.devicemodel.modeltype.code;

		//초기 기기 전원 상태 설정 
		//isPowerOn = device.power == "on" ? true : false;
		String imageSuffix = isPowerOn ? "_on" : "";

		return Material(
			color: Colors.transparent,
			child: Container(
				margin: EdgeInsets.only(
					top: 10, bottom: 15, left: 5, right: 5),
				decoration: BoxDecoration(
					color: BgColor.white,
					borderRadius: Radii.radi10,
					boxShadow: [Shadows.fshadow],
				),
				width: 140,
				height: 110,
				child: FlatButton(
					padding: EdgeInsets.all(10),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.start,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							Container(
								width: double.infinity,
								margin: EdgeInsets.only(bottom: 5),
								child: Row(
									children: [
										Container(
											child: Text(
												device.homedevice.deviceName,
												style: TextFont.semibig,
												textAlign: TextAlign.left,
											),
										),
										Expanded(
											child: Text(''),
										),
										Container(
											child: InkWell(
												child: Container(
													decoration: BoxDecoration(
														color: BgColor.white,
														borderRadius: Radii.radi20,
														boxShadow: [Shadows.fshadow],
													),
													width: 20,
													height: 20,
													padding: EdgeInsets.all(5),
													child: Image.asset(
														"assets/images/close.png",
														fit: BoxFit.fitWidth,
													),
												),
												onTap: () async {
													if (widget.routineId == -1) {
														UICommon.alert(context, "기타 루틴의 기기는 삭제할 수 없습니다.");
														return;
													}
													// 해당 루틴의 기기 삭제 확인 다이얼로그 창 표시 
													bool isConfirm = await UICommon.confirmDialog(context, "삭제 확인", '${device.homedevice.deviceName} 을(를) 해당 루틴에서\n삭제 하시겠습니까?', "취소", "삭제");
													if (isConfirm != null && isConfirm) {
														bool isSuccess = await _configService.doRemoveRoutineDevice(context, device.id);
														if (isSuccess) {
															// 화면 state 변경 
															userHomeBloc.add(HomeRoutineDeviceChangedEvent(changeMode: "DELETE", routineId: device.routineId, deviceId: device.homedevice.deviceId, routineDeviceId: device.id));
															UICommon.showMessage(context, "삭제 되었습니다.");
														} else {
															Navigator.of(context).pop(false);
															UICommon.showMessage(context, "실패 하였습니다.");
														}
													}
												}
											)
										),
									],
								)
							),
							Expanded(
								child: Row(
									children: [
										Container(
											width: 30,
											height: 30,
											margin: EdgeInsets.only(right: 15),
											child: Image.asset(
												UICommon.deviceIcons[deviceTypeCode] + imageSuffix + ".png",
												fit: BoxFit.fitHeight,
											),
										),
										Expanded(
											child: SingleChildScrollView(
												child: Column(
													// 기기별 Command 설정 목록 표시 
													children: _buildRoutineDeviceCommands(context)
												)
											)
										),
									],
								),
							)
						]
					),
					onPressed: () async {

						// 일괄소등과 엘리베이터호출은 설정이 필요없음.
						if (deviceTypeCode == "LIGHTOFF" || deviceTypeCode == "ELEVATOR") {
							return;
						}

						// 해당 루틴의 기기 설정 다이얼로그 창 표시
						bool result = await _createDeviceConfigDialog(context, widget.device);
						if (result == null) { //취소 시 
							return;
						} else if (result) {
							final snackBar = SnackBar(content: Text('설정 되었습니다.'));
							Scaffold.of(context).showSnackBar(snackBar);
						} else {
							final snackBar = SnackBar(content: Text('실패 하였습니다.'));
							Scaffold.of(context).showSnackBar(snackBar);
						}
					},
				),
			),
		);
	}

	/// 루틴에 들어가는 기기의 Command 목록 표시
	List < Widget > _buildRoutineDeviceCommands(BuildContext context) {
		String deviceTypeCode = widget.device.homedevice.devicemodel.modeltype.code;
		String message = "클릭하여 설정";
		if (deviceTypeCode == "LIGHTOFF") {
			message = "소등";
		} else if (deviceTypeCode == "ELEVATOR") {
			message = "호출";
		}
		print("_buildRoutineDeviceCommands : ${widget.device.traits}");
		if (widget.device.traits != null && widget.device.traits.commandList != null && widget.device.traits.commandList.length > 0) {
			return widget.device.traits.commandList.map((command) {
				return DeviceRoutineCommandWidget(deviceTypeCode: deviceTypeCode, command: command);
			}).toList();
		} else {
			return <Widget > [
				Container(
					width: double.infinity,
					child: Text(
						message,
						style: TextFont.normal,
						textAlign: TextAlign.left,
					)
				)
			];
		}
	}

}


/// 루틴에 들어가는 기기의 Command 설정 정보 
class DeviceRoutineCommandWidget extends StatefulWidget {
	final deviceTypeCode;
	final RoutineModelDevicesTraitsCommandList command;
	DeviceRoutineCommandWidget({
		this.deviceTypeCode,
		this.command
	});
	@override
	_DeviceRoutineCommandWidgetState createState() => _DeviceRoutineCommandWidgetState();
}

class _DeviceRoutineCommandWidgetState extends State < DeviceRoutineCommandWidget > {
	bool isPowerOn = false;
	final configService = ConfigService();
	Widget build(BuildContext context) {
		return Material(
			color: Colors.transparent,
			child: Container(
				margin: EdgeInsets.only(bottom: 1.5),
				child: Row(
					children: [
						Container(
							margin: EdgeInsets.only(right: 5, ),
							child: Text(configService.getCommandName(widget.deviceTypeCode, widget.command.command) + ' :', style: TextFont.normal),
						),
						Container(
							child: Text(configService.getCommandValueLabel(widget.deviceTypeCode, widget.command.command, widget.command.value), style: TextFont.medium), // 
						)
					]
				)
			)

		);
	}
}


/// 기기 추가 다이얼로그 창 화면 
class AddListDevicesWidget extends StatefulWidget {
	final UserHomeModel userHomeModel;
	final routineId;
	final userHomeBloc;
	final Function(dynamic) callback;
	AddListDevicesWidget({
		this.userHomeModel,
		this.routineId,
		this.userHomeBloc,
		this.callback
	});
	@override
	_AddListDevicesWidgetState createState() => _AddListDevicesWidgetState();
}

class _AddListDevicesWidgetState extends State < AddListDevicesWidget > {
	Widget build(BuildContext context) {
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

					children: _buildAddListDevices(context, widget.callback) // 기기 목록 위젯 

				)
			),
			actions: < Widget > [
				Container(
					decoration: BoxDecoration(
						color: BgColor.main
					),
					width: 290,
					child: FlatButton(
						onPressed: () {
							Navigator.of(context).pop();
						},
						textColor: Theme.of(context).primaryColor,
						child: Text(
							'닫기',
							style: TextFont.medium_w
						),
					),
				),
			],
		);
	}


	/// 기기 추가 팝업 다이얼로그에 들어가는 기기 목록 위젯
	List < Widget > _buildAddListDevices(BuildContext context, Function callback) {
		final homedevices = widget.userHomeModel.homedevices;
		int index = widget.userHomeModel.routines.indexWhere((routine) => routine.id == widget.routineId);
		final routineDevices = widget.userHomeModel.routines[index].devices;
		//print("_buildAddListDevices  routineId : ${widget.routineId}  routineDevices.length : ${routineDevices.length}");

		List < Widget > devicesWidget = [];
		for (var device in homedevices) {
			if (routineDevices.indexWhere((routineDevice) => routineDevice.homedevice.deviceId == device.deviceId) < 0) {
				devicesWidget.add(AddListDeviceWidget(device: device, routineId: widget.routineId, userHomeBloc: widget.userHomeBloc, callback: callback));
			}
		}
		return devicesWidget;
	}
}



/// 기기 추가에 들어가는 기기 위젯 
class AddListDeviceWidget extends StatefulWidget {
	final UserHomeDevices device;
	final routineId;
	final userHomeBloc;
	final Function(dynamic) callback;
	AddListDeviceWidget({
		Key key,
		@required this.device,
		@required this.routineId,
		@required this.userHomeBloc,
		@required this.callback
	}): super(key: key);

	@override
	_AddListDeviceWidgetState createState() => _AddListDeviceWidgetState();
}
class _AddListDeviceWidgetState extends State < AddListDeviceWidget > {
	bool isSuccess = false;
	bool isButtonEnable = true;
	final _configService = ConfigService();

	Widget build(BuildContext context) {
		//UserHomeBloc userHomeBloc = BlocProvider.of<UserHomeBloc>(context);  // 그냥 사용하면 에러 발생 --> 파라미터로 받아오게 변경 함.

		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;
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
				child: FlatButton(
					padding: EdgeInsets.all(13),
					onPressed: () async {
						if (isButtonEnable) {
							isButtonEnable = false;
							// 기기 추가 - 서버 전송 처리
							dynamic newRoutineDeviceId = await _configService.doAddRoutineDevice(context, widget.routineId, device.id);
							isButtonEnable = true;
							if (newRoutineDeviceId != null) {
								widget.callback(true);
								// 화면 state 변경 처리
								widget.userHomeBloc.add(HomeRoutineDeviceChangedEvent(changeMode: "INSERT", routineId: widget.routineId, deviceId: device.deviceId, routineDeviceId: newRoutineDeviceId));
							} else {
								widget.callback(false);
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
			)

		);
	}
}



/// 루틴 생성 다이얼 로그 
Future < bool > _createRoutineDialog(BuildContext context) async {
	final _configService = ConfigService();
	String routineName;
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();

	UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

	return showDialog < bool > (
		context: context,
		builder: (context) {
			return AlertDialog(
				title: Text('루틴 등록'),
				content: SingleChildScrollView(
					child: Column(
						children: [
							Form(
								key: _formKey,
								child:
								TextFormField(
									decoration: InputDecoration(
										filled: true,
										labelText: '등록하실 루틴명을 입력하세요',
										fillColor: BgColor.white,
									),
									validator: Validation.checkEmpty,
									onSaved: (String newRoutineName) {
										routineName = newRoutineName;
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
						    width: MediaQuery.of(context).size.width/2-50,
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
						    width: MediaQuery.of(context).size.width/2-50,
								child: FlatButton(
									onPressed: () async {
										if (_formKey.currentState.validate()) {
											_formKey.currentState.save();
											dynamic newRoutineId = await _configService.doCreateRoutine(context, routineName);
											if (newRoutineId != null) {

												print("newRoutineId : $newRoutineId");
												userHomeBloc.add(HomeRoutineChangedEvent(changeMode: "INSERT", routineId: newRoutineId, routineName: routineName));
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




RoutineModelDevices _configDevice; // 설정화면에서 설정하는 값을 임시적으로 가지고 있는다. ( 항목 별 관련있는 설정 Validation -  전원 OFF 시에는 온도 비활성 등)

/// 루틴 - 기기 설정  다이얼 로그 
Future < bool > _createDeviceConfigDialog(BuildContext context, RoutineModelDevices device) async {

	print("_createDeviceConfigDialog called!!");
	_configDevice = device.clone();  // deep copy 로 설정 (중요)

	print("_createDeviceConfigDialog settingCommand : ${json.encode(_configDevice.traits.commandList)}");

	final _configService = ConfigService();
	UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

	return showDialog < bool > (context: context, builder: (context) {

		return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {

			/// 하위 기기 목록 위젯에서 호츌 할 수 있도록  Function 자체를 DeviceControlWidget 에 파라미터로 넘겨 준다.
			_changeCommandConfig(dynamic changedCommand) {
				//print("_createDeviceConfigDialog _changeCommandConfig called!!   changedCommand : ${json.encode(changedCommand)}");
				int idx = _configDevice.traits.commandList.indexWhere((command) => command.command == changedCommand["command"]);
				if (idx != -1) {
					_configDevice.traits.commandList[idx].value = changedCommand["value"];

					if(changedCommand["value"] == ""){  // 설정을 안하는(해제) 경우 (모드 등)
						_configDevice.traits.commandList.removeAt(idx);
					}
				} else {
					RoutineModelDevicesTraitsCommandList newCommand = RoutineModelDevicesTraitsCommandList();
					newCommand.command = changedCommand["command"];
					newCommand.value = changedCommand["value"];
					if(changedCommand["value"] != ""){  // 설정을 안하는(해제) 경우는 추가 안함
						_configDevice.traits.commandList.add(newCommand);
					}
				}

				// 전원이 OFF 상태이면 나머지 설정들은 모두 제거
				if(changedCommand["command"] == "power" && changedCommand["value"] == "off"){
					_configDevice.traits.commandList = [];
					RoutineModelDevicesTraitsCommandList newCommand = RoutineModelDevicesTraitsCommandList();
					newCommand.command = changedCommand["command"];
					newCommand.value = changedCommand["value"];
					_configDevice.traits.commandList.add(newCommand);
				}

				print("_createDeviceConfigDialog settingCommand : ${json.encode(_configDevice.traits.commandList)}");
				/// 변경된 값을 AlertDialog 에 다시 반영한다. ( 온도 조정시  Power- On 되게 설정 등)
				setState((){});
			}


			return AlertDialog(
				title: Text(device.homedevice.deviceName),
				content: SingleChildScrollView(
					child: Column(

						// 디바이스 Command 설정 다이얼로그 창 표시  _changeCommandConfig 은 변경된 값을 callback 하기 위한 함수
						children: _buildDeviceConfigCommands(context, _configDevice, _changeCommandConfig)


					),
				),
				actions: < Widget > [
					Row(
						children: [
							Container(
								decoration: BoxDecoration(
									color: BgColor.lgray
								),
						    width: MediaQuery.of(context).size.width/2-50,
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
						    width: MediaQuery.of(context).size.width/2-50,
								child: FlatButton(

									// 루틴 설정 저장 
									onPressed: () async {
										 // 설정된 정보가 없는 경우 ( Power의 경우 사용자가 클릭하지 않으면 설정정보가 없음) - 기본적으로 Power Off 설정 추가
										if(_configDevice.traits.commandList.length == 0){ 
											RoutineModelDevicesTraitsCommandList newCommand = RoutineModelDevicesTraitsCommandList();
											newCommand.command = "power";
											newCommand.value = "off";
											_configDevice.traits.commandList.add(newCommand);
										}

										bool isSuccess = await _configService.doChangeRoutineDevice(context, _configDevice.id, _configDevice.traits);
										if (isSuccess) {
											userHomeBloc.add(HomeRoutineDeviceCommandChangedEvent(routineId: _configDevice.routineId, deviceId: _configDevice.homedevice.deviceId, commandList: _configDevice.traits.commandList));
										}
										Navigator.of(context).pop(true);
									},

									textColor: Theme.of(context).primaryColor,
									child: Text(
										'설정',
										style: TextFont.medium_w
									),
								),
							),
						]
					),
				],
			);

		});
	});
}


/// 루틴 기기 설정화면의 설정 항목 (전원, 온도, 모드 등) 을 표시한다.
List < Widget > _buildDeviceConfigCommands(BuildContext context, RoutineModelDevices device, Function(dynamic) _changeCommandConfig) {
	String deviceTypeCode = device.homedevice.devicemodel.modeltype.code;
	// 기기타입 별 사전 정의된 command 목록의 위젯을 리턴한다.
	List < Widget > commandList = [];
	for (var defindedCommand in UICommon.deviceTypeCommands[deviceTypeCode]) {
		String commandValue = "";
		if (device.traits != null && device.traits.commandList.length > 0) {
			//commandValue = device.traits.commandList[0].value; // 기본적으로 첫번째 값을 설정
			for (var settingCommand in device.traits.commandList) {
				if (settingCommand.command == defindedCommand["command"]) {
					commandValue = settingCommand.value;
					break;
				}
			}
		}
		//print("_buildDeviceConfigCommands defindedCommand : ${json.encode(defindedCommand)} commandValue : $commandValue");
		commandList.add(
			ConfigDeviceRoutineCommamdWidget(device: device, command: defindedCommand, commandValue: commandValue, changeCommandConfig: _changeCommandConfig)
		);
	}
	return commandList;
}



/// 기기의 루틴을 설정하는 위젯 - 기기 루틴설정 다이얼로그 안에 보여지는 전원 / 온도 등 

class ConfigDeviceRoutineCommamdWidget extends StatefulWidget {
	final RoutineModelDevices device;
	final command; // UICommon.deviceTypeCommands에 기본 정의된 command   
	final commandValue; // 현재 설정된 값 
	final Function(dynamic) changeCommandConfig; // 기기 변경 선택 시 해당 기기아이디를  상위 위젯에 넘길 수 있는 함수 
	ConfigDeviceRoutineCommamdWidget({
		Key key,
		@required this.device,
		@required this.command,
		@required this.commandValue,
		@required this.changeCommandConfig,
	}): super(key: key);

	@override
	_ConfigDeviceRoutineCommandWidgetState createState() => new _ConfigDeviceRoutineCommandWidgetState();
}

class _ConfigDeviceRoutineCommandWidgetState extends State < ConfigDeviceRoutineCommamdWidget > {

	int _selectedIndex; // 모드 타입의 경우 선택된 index
	bool _isPowerOn; // 전원 타입의 on / off
	int _setTemperature; // 온도
	int _minValue = 5; // 최소 설정 온도
	int _maxValue = 35; // 최대 설정 온도
	bool _isOnLongPressUp; // 온도 + - 버튼 longpress up 이벤트 여부

	@override
	void initState() {
		super.initState();
	}

	@override
 	// ignore: missing_return
	Widget build(BuildContext context) {
		String deviceTypeCode = widget.device.homedevice.devicemodel.modeltype.code;
		dynamic defindedCommand = widget.command;
		String commandKey = defindedCommand["command"];

		// 전원
		if (commandKey == "power") {
			//print("_ConfigDeviceRoutineCommandWidgetState build  commandKey : $commandKey  commandValue : ${widget.commandValue}  _isPowerOn : $_isPowerOn"); 
			_isPowerOn = widget.commandValue == "on" ? true : false;

			return Container(
				margin: EdgeInsets.only(bottom: 10, ),
				child: Row(
					children: [
						Container(
							width: 60,
							padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
							decoration: BoxDecoration(
								color: BgColor.lgray,
							),
							child: Text(
								defindedCommand["name"], // command name - 설정항목 명 
								style: TextFont.normal,
							)
						),
						Container(
							padding: EdgeInsets.only(left: 20),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									Container(
										child: Text(
											'OFF',
											style: GoogleFonts.montserrat(
												fontWeight: FontWeight.w400,
												fontSize: 16,
												color: const Color(0xff333333),
											),
										)
									),
									Container(
										margin: EdgeInsets.only(left: 5),
										child: Transform.scale(
											scale: 1.25,
											child: Switch(
												value: _isPowerOn, // power  on/off
												onChanged: (value) async {
													if (deviceTypeCode == "gas" && value) {
														UICommon.alert(context, "가스는 밸브 잠금만 가능합니다.");
														value = false;
													}
													setState(() {
														_isPowerOn = value;
													});

													widget.changeCommandConfig({"command": commandKey, "value": _isPowerOn? "on":"off"});
												},
												activeTrackColor: BgColor.lgray,
												activeColor: BgColor.main,
											),
										),
									),
									Container(
										margin: EdgeInsets.only(left: 5),
										child: Text(
											'ON',
											style: GoogleFonts.montserrat(
												fontWeight: FontWeight.w400,
												fontSize: 16,
												color: const Color(0xff333333),
											),
										)
									),
								]
							)
						),
					],
				)
			);


		// 모드 설정 ( mode, level, wind)
		} else if (commandKey == "level" || commandKey == "mode" || commandKey == "wind") {
			//print("_buildDeviceConfigCommands defindedCommand values: ${json.encode(defindedCommand["values"])}");
			//if (_selectedIndex == null) {
				_selectedIndex = defindedCommand["values"].indexWhere((valueLabel) => valueLabel["value"] == widget.commandValue);
				if (_selectedIndex == -1) _selectedIndex = 0;
			//}

			//설정값 상위 위젯으로 전달 - 초기 로드시와 위젯이 변경될때 마다 값 전달해야 함
   			// ignore: unused_local_variable
			dynamic configValue = defindedCommand["values"][_selectedIndex]["value"];
			// widget.changeCommandConfig({
			// 	"command": commandKey,
			// 	"value": configValue
			// });

			int modeLength = defindedCommand["values"].length;
			List < bool > _selections = List.generate(modeLength, (_) => false);

			//if(_selectedIndex != -1){  // 기존 설정된 값이 없으면 모두 선택 안되게 한다.
			_selections[_selectedIndex] = true;
			//}

			return Container(
				margin: EdgeInsets.only(bottom: 10, ),
				child: Row(
					children: [
						Container(
							width: 60,
							padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
							decoration: BoxDecoration(
								color: BgColor.lgray,
							),
							child: Text(
								defindedCommand["name"], // '모드',
								style: TextFont.normal,
							)
						),
						Container(
							padding: EdgeInsets.only(left: 20, ),
							child: ToggleButtons(
								fillColor: BgColor.lgray,
								borderColor: BgColor.lgray,
								selectedBorderColor: BgColor.lgray,
								selectedColor: BgColor.main,
								color: BgColor.black45,
								textStyle: TextFont.medium,
								borderRadius: Radii.radi10,

								children: _buildDeviceConfigCommandValueLabels(context, defindedCommand["values"]),

								onPressed: (int index) async {
									dynamic configValue = defindedCommand["values"][index]["value"];
									//print("_buildDeviceConfigCommands configValue : $configValue  index: $index");
									setState(() {
										_selectedIndex = index;
									});

									widget.changeCommandConfig({"command": commandKey, "value": configValue});
									if(deviceTypeCode == "heating" && index != 0) { // 난방의 모드가 선택된 경우 
										widget.changeCommandConfig({"command": "power", "value": "on"});
										widget.changeCommandConfig({"command": "setTemperature", "value": ""});
									}
								},
								isSelected: _selections,
							),
						),
					],
				)
			);


		// 온도 설정	
		} else if (commandKey == "setTemperature") {
			// 초기값(기존 설정된 값) 설정
			if (_setTemperature == null) {
				if (widget.commandValue != null && widget.commandValue != "")
					_setTemperature = int.parse(widget.commandValue);
				else
					_setTemperature = 24;
			}

			return Container(
				margin: EdgeInsets.only(bottom: 10, ),
				child: Row(
					children: [
						Container(
							width: 60,
							padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
							decoration: BoxDecoration(
								color: BgColor.lgray,
							),
							child: Text(
								defindedCommand["name"], // Command 항목 타이틀
								style: TextFont.normal,
							)
						),
						Container(
							padding: EdgeInsets.only(left: 20),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.end,
								children: [
									GestureDetector( // - 버튼
										onTap: () async {
											if (_setTemperature > _minValue) {
												_setTemperature--;
												widget.changeCommandConfig({"command": "power", "value":"on"});
												widget.changeCommandConfig({"command": commandKey, "value": _setTemperature.toString()});
												if(deviceTypeCode == "heating") widget.changeCommandConfig({"command": "mode", "value": ""});
											}
										},
										onLongPress: () async {
											_isOnLongPressUp = false;
											while (!_isOnLongPressUp && _setTemperature > _minValue) {
												await Future.delayed(Duration(milliseconds: 300), () => _setTemperature--);
												setState(() {});
											}
										},
										onLongPressUp: () {
											_isOnLongPressUp = true;
											widget.changeCommandConfig({"command": "power", "value":"on"});
											widget.changeCommandConfig({"command": commandKey, "value": _setTemperature.toString()});
											if(deviceTypeCode == "heating") widget.changeCommandConfig({"command": "mode", "value": ""});
										},

										child: Container(
											decoration: BoxDecoration(
												borderRadius: Radii.radi10,
												color: BgColor.white,
												boxShadow: [Shadows.fshadow],
											),
											width: 30,
											height: 30,
											child: Column(
												mainAxisAlignment: MainAxisAlignment.center,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														width: 16,
														height: 16,
														child: Image.asset(
															"assets/images/minus.png",
															fit: BoxFit.fitWidth,
														),
													),
												]
											),
										)
									),
									Container(
										width: 45,
										margin: EdgeInsets.only(left: 10, right: 10),
										child: Column(
											children: [
												Container(
													child: Text(
														"$_setTemperature ˚c", // 설정온도 표시
														textAlign: TextAlign.center,
														style: GoogleFonts.montserrat(
															fontWeight: FontWeight.w400,
															fontSize: 16,
															color: widget.commandValue != ""? const Color(0xff0000ff) : Colors.grey,  //온도 텍스트  색상
														),
													)
												)
											],
										),
									),
									GestureDetector( // + 버튼
										onTap: () async {
											if (_setTemperature < _maxValue) {
												_setTemperature++;
												widget.changeCommandConfig({"command": "power", "value":"on"});
												widget.changeCommandConfig({"command": commandKey, "value": _setTemperature.toString()});
												if(deviceTypeCode == "heating") widget.changeCommandConfig({"command": "mode", "value": ""});
											}
										},
										onLongPress: () async {
											_isOnLongPressUp = false;
											while (!_isOnLongPressUp && _setTemperature < _maxValue) {
												await Future.delayed(Duration(milliseconds: 350), () => _setTemperature++);
												setState(() {});
											}
										},
										onLongPressUp: () {
											_isOnLongPressUp = true;
											widget.changeCommandConfig({"command": "power", "value":"on"});
											widget.changeCommandConfig({"command": commandKey, "value": _setTemperature.toString()});
											if(deviceTypeCode == "heating") widget.changeCommandConfig({"command": "mode", "value": ""});
										},

										child: Container(
											decoration: BoxDecoration(
												borderRadius: Radii.radi10,
												color: BgColor.white,
												boxShadow: [Shadows.fshadow],
											),
											width: 30,
											height: 30,
											child: Column(
												mainAxisAlignment: MainAxisAlignment.center,
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Container(
														width: 16,
														height: 16,
														child: Image.asset(
															"assets/images/plus.png",
															fit: BoxFit.fitWidth,
														),
													),
												]
											),
										)
									),
								]
							)
						),
					],
				)
			);

		}
	}

	/// // 기기타입 별 사전 정의된 해당 command의  value label 위젯을 표시한다. (mode, wind, level 등 만 해당 )
	List < Widget > _buildDeviceConfigCommandValueLabels(BuildContext context, dynamic values) {
		List < Widget > valueList = [];
		for (var value in values) {
			//print("_buildDeviceConfigCommandValueLabels defindedCommandValue : ${json.encode(value)}");
			valueList.add(
				ConfigDeviceRoutineCommamdModeWidget(valueLabel: value["label"])
			);
		}
		return valueList;
	}

	// 현재 설정창에서 설정한 값 리턴
	dynamic getCurrentCommandValue(String commandKey) {
		int idx = _configDevice.traits.commandList.indexWhere((command) => command.command == commandKey);
		if (idx != -1) {
			return _configDevice.traits.commandList[idx].value;
		} else {
			return null;
		}
	}

	// 현재 설정창에서 설정 진행중인 값 변경 
	void setCurrentCommandValue(String commandKey, dynamic commandValue) {
		int idx = _configDevice.traits.commandList.indexWhere((command) => command.command == commandKey);
		if (idx != -1) {
			 _configDevice.traits.commandList[idx].value = commandValue;
		} 
	}
}

/// command 모드 값의 라벨 표시 위젯 
class ConfigDeviceRoutineCommamdModeWidget extends StatelessWidget {
	final valueLabel;
	ConfigDeviceRoutineCommamdModeWidget({
		Key key,
		@required this.valueLabel,
	}): super(key: key);
	Widget build(BuildContext context) {
		return Container(
			alignment: Alignment.center,
			child: Text(valueLabel),
		);
	}
}