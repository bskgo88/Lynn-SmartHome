import 'package:flutter/material.dart';
import '../../common/ui_common.dart';
import '../../service/device_service.dart';
import '../../model/user_home_model.dart';
import '../../common/style.dart';
import 'name_change_widget.dart';
import 'favorite_icon_widget.dart';

// 공간 별 / 기기구분 별 상세화면에 기기 - 조명 (전등)
class DeviceControlLightWidget extends StatefulWidget {
	final UserHomeDevices device;
	const DeviceControlLightWidget({Key key, this.device}) : super(key: key);

	@override
	DeviceControlLightWidgetState createState() => DeviceControlLightWidgetState();
}

class DeviceControlLightWidgetState extends State < DeviceControlLightWidget > {

	bool isNameEditable = false;
	bool isPowerOn; //초기 기기 전원 상태 설정 

	Widget build(BuildContext context) {
		final _deviceService = DeviceService();
		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;
		isPowerOn = device.power == "on" ? true : false; //초기 기기 전원 상태 설정
		String imageSuffix = isPowerOn ? "_on" : "_off";
		bool isButtonEnable = true;
		
		//print("_DeviceControlHeaterWidgetState build deviceId : ${device.deviceId} device.power : ${device.power}");

		return Container(
			padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: isPowerOn ? BgColor.white : BgColor.rgray,
      ),
      //child: SingleChildScrollView(
			//padding: EdgeInsets.all(0),

			child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					Container(
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.center,
							mainAxisAlignment: MainAxisAlignment.start,
							children: [
								Visibility(
									visible: !isNameEditable,
									child:
									InkWell(
										onTap: () {},
										onLongPress: () async{
											//isNameEditable = !isNameEditable;
											//print("isNameEditable : $isNameEditable");
											//setState(() {});

											// 기기 명 변경 다이얼로그 표시 
											bool result = await DeviceNameChangeDialog(context, device.deviceId, device.deviceName, device.homeLocationId);
											if (result != null && result) {
												UICommon.showMessage(context, "수정 되었습니다.");
											} else if (result != null && !result) {
												UICommon.showMessage(context, "실패 되었습니다.");
											}

										},
										child: Container(
											alignment: Alignment.topLeft,
											child: Text(
												widget.device.deviceName, // 기기명
												style: TextFont.item2,
												textAlign: TextAlign.left,
											),
											margin: EdgeInsets.only(
												bottom: 2,
												right: 10,
											)
										),
									),
								),

								// Visibility(
								// 	visible: isNameEditable,
								// 	child:
								// 	Container( 
								// 		width: 100,
								// 		child: Form(
								// 			key: _formKey,
								// 			child: 
								// 			TextFormField(
								// 				initialValue: widget.device.deviceName,
								// 				validator: Validation.checkEmpty,
								// 				onSaved: (String newDeviceName) {
								// 					isNameEditable = !isNameEditable;
								// 					print("onSaved isNameEditable : $isNameEditable");
								// 					setState(() {});
								// 					//locationName = newLocationName;
								// 				},
								// 			),
								// 		),
								// 	),
								// ),
								//),
								// 즐겨찾기 아이콘
								FavoriteIconWidget(device: device)

							],
						),
					),
					Expanded(
						child: Container(
              /*
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/lightbg.png",),
                  fit: BoxFit.fitHeight
                ),
              ),
              */
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Text(''),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(''),
                      ),
                      Container(
                        child:InkWell(
                          onLongPress: () async {
                            if (isButtonEnable) {
                              isButtonEnable = false;
                              isPowerOn = !isPowerOn;
                              setState(() {});
                              isPowerOn = await _deviceService.powerOnOff(context, deviceTypeCode, device.deviceId, !isPowerOn);
                              isButtonEnable = true;
                              setState(() {});
                            }
                          },
                          onTap: () async {
                            if (isButtonEnable) {
                              isButtonEnable = false;
                              isPowerOn = !isPowerOn;
                              setState(() {});
                              isPowerOn = await _deviceService.powerOnOff(context, deviceTypeCode, device.deviceId, !isPowerOn);
                              isButtonEnable = true;
                              setState(() {});
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: Radii.radi10,
                              gradient: OnItem.offset,
                              boxShadow: [Shadows.fshadow],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: Radii.radi60,
                                color: BgColor.transWhite,
                                boxShadow: [Shadows.fshadow],
                              ),
                              width: 120,
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    child: Image.asset(
                                      "assets/images/power$imageSuffix.png", // 전원 ON/OFF 이미지
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ]
                              ),
                            )
                          )
                        ),
                      ),
                      Expanded(
                        child: Text(''),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(''),
                  ),
                ],
              ) 
						)
					),
					Container(
						child: Row(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
                /*
								Container(
									child: Text(
										'OFF',
										style: GoogleFonts.montserrat(
											fontWeight: FontWeight.w400,
											fontSize: 24,
											color: const Color(0xff333333),
										),
									)
								),
								Container(
									margin: EdgeInsets.only(left: 30),
									child: Transform.scale(
										scale: 2.5,
										child: Switch(
											value: isPowerOn,
											onChanged: (value) async {
												if (isButtonEnable) {
													isButtonEnable = false;
													isPowerOn = await _deviceService.powerOnOff(context, deviceTypeCode, device.deviceId, isPowerOn);
													isButtonEnable = true;
												}
											},
											activeTrackColor: BgColor.lgray,
											activeColor: BgColor.main,
										),
									),
								),
								Container(
									margin: EdgeInsets.only(left: 30),
									child: Text(
										'ON',
										style: GoogleFonts.montserrat(
											fontWeight: FontWeight.w400,
											fontSize: 24,
											color: const Color(0xff333333),
										),
									)
								),
                */
							]
						)
					),
				],
			),
      //)
		);
	}
}
