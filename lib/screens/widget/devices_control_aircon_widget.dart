import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/ui_common.dart';
import '../../service/device_service.dart';
import '../../model/user_home_model.dart';
import '../../common/style.dart';
import 'name_change_widget.dart';
import 'favorite_icon_widget.dart';


// 공간 별 / 기기구분 별 상세화면에 기기 - 난방 
class DeviceControlAirconWidget extends StatefulWidget {
	final UserHomeDevices device;
  const DeviceControlAirconWidget({Key key, this.device}) : super(key: key);
	@override
	DeviceControlAirconWidgetState createState() => DeviceControlAirconWidgetState();
}

class DeviceControlAirconWidgetState extends State < DeviceControlAirconWidget > {

	UserHomeDevices device;
	String deviceTypeCode;
	double _settingValue = 22;
	double _prevValue = 22; // 이전 설정 온도 ( 온도변경 실패시 이전값 설정하기 위함)
	double _minValue = 5;
	double _maxValue = 35;
	double _currentValue = 15;
	bool isButtonEnable = true;
	bool isPowerOn;
	DeviceService _deviceService = DeviceService();

	Widget build(BuildContext context) {
		device = widget.device;
		deviceTypeCode = device.devicemodel.modeltype.code;
		isPowerOn = device.power == "on" ? true : false; //초기 기기 전원 상태 설정 
		String imageSuffix = isPowerOn ? "_on" : "_off";
		if (device.currTemperature != null && device.currTemperature != "") {
			_currentValue = double.parse(device.currTemperature);
		}
		if (device.setTemperature != null && device.setTemperature != "") {
			_settingValue = double.parse(device.setTemperature);
		}

		return Container(
			constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: isPowerOn ? BgColor.white : BgColor.lgray,
      ),
			padding: EdgeInsets.only(top:20, left:20, bottom: 10),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				mainAxisAlignment: MainAxisAlignment.start,
				children: [

          //상단 이름
          Container(
            margin: EdgeInsets.only(
              bottom: 30,
            ),
            child : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container( // 기기명변경 레이아웃
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        onLongPress: () async {
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
                      // 즐겨찾기 아이콘
                      FavoriteIconWidget(device: device)
                    ],
                  )
                ), // 기기명변경 레이아웃 종료
              ], 
            ),
          ),
          //상단 이름

          //온도 조절 및 다른기능
          Expanded(
            child: Row(
              children: [
                Container(
                  padding:EdgeInsets.only(bottom:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      InkWell( // + 버튼
                        onLongPress: () {},
                        onTap: () async {
                          if (isPowerOn) {
                            if (isButtonEnable) {
                              if (_settingValue < _maxValue) {
                                _settingValue++;
                                setState(() {});
                                isButtonEnable = false;
                                _settingValue = await _deviceService.setTemperature(context, widget.device.devicemodel.modeltype.code, widget.device.deviceId, _settingValue, _prevValue);
                                setState(() {});
                                isButtonEnable = true;
                              } else {
                                UICommon.showMessage(context, "최대 설정 온도입니다.");
                              }
                            }
                          } else {
                            UICommon.showMessage(context, "전원이 꺼져 있습니다.");
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
                              borderRadius: Radii.radi10,
                              color: BgColor.white,
                              boxShadow: [Shadows.fshadow],
                            ),
                            width: 40,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    "assets/images/plus.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ]
                            ),
                          )
                        )
                      ),
                      // + 버튼

                      // 온도조절 게이지 (슬라이드)
                      Expanded(
                        child: FlutterSlider(
                          rtl: true,
                          axis: Axis.vertical,
                          values: [_settingValue],
                          max: _maxValue,
                          min: _minValue,
                          tooltip: FlutterSliderTooltip(
                            textStyle: TextStyle(fontSize: 16, color: Colors.lightBlue),
                          ),
                          onDragging: (handlerIndex, lowerValue, upperValue) {
                            if (isButtonEnable) {
                              _settingValue = lowerValue;
                            } else {
                              _settingValue = _prevValue;
                            }
                          },
                          onDragCompleted: (handlerIndex, lowerValue, upperValue) async {
                            if (isPowerOn) {
                              if (isButtonEnable) {
                                isButtonEnable = false;
                                _settingValue = await _deviceService.setTemperature(context, widget.device.devicemodel.modeltype.code, widget.device.deviceId, lowerValue, _prevValue);
                              }
                            } else {
                              _settingValue = _prevValue;
                              UICommon.showMessage(context, "전원이 꺼져 있습니다.");
                            }
                            setState(() {});
                            isButtonEnable = true;
                          },
                          handlerWidth: 40,
                          handlerHeight: 40,
                          handler: FlutterSliderHandler(
                            decoration: BoxDecoration(),
                            child: Material(
                              type: MaterialType.canvas,
                              color: Colors.transparent,
                              elevation: 1,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                padding: EdgeInsets.all(0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: BgColor.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                )
                              ),
                            ),
                          ),
                          trackBar: FlutterSliderTrackBar(
                            inactiveTrackBarHeight: 40,
                            activeTrackBarHeight: 40,
                            inactiveTrackBar: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.black12,
                              border: Border.all(width: 0, color: Colors.transparent),
                            ),
                            activeTrackBar: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40), ),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight, colors: [
                                  isPowerOn ? Color.fromARGB(255, 0, 75, 255): Color.fromARGB(255, 100, 100, 100),
                                  Color.fromARGB(255, 230, 230, 230),
                                ],
                                stops: [
                                  0,
                                  1
                                ]
                              )
                            ),
                          ),
                        )
                      ),

                      InkWell( // - 버튼
                        onLongPress: () {},
                        onTap: () async {
                          if (isPowerOn) {
                            if (isButtonEnable) {
                              if (_settingValue > _minValue) {
                                _settingValue--;
                                setState(() {});
                                isButtonEnable = false;
                                _settingValue = await _deviceService.setTemperature(context, widget.device.devicemodel.modeltype.code, widget.device.deviceId, _settingValue, _prevValue);
                                setState(() {});
                                isButtonEnable = true;
                              } else {
                                UICommon.showMessage(context, "최저 설정 온도입니다.");
                              }
                            }
                          } else {
                            UICommon.showMessage(context, "전원이 꺼져 있습니다.");
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
                              borderRadius: Radii.radi10,
                              color: BgColor.white,
                              boxShadow: [Shadows.fshadow],
                            ),
                            width: 40,
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    "assets/images/minus.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ]
                            ),
                          )
                        )
                      ),
                      // - 버튼

                    ],
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          '설정온도',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: const Color(0xff333333),
                          ),
                        )
                      ),
                      Container(
                        width:60,
                        margin: EdgeInsets.only(top: 2),
                        child: Text(
                          _settingValue.toInt().toString() + '˚c', // 설정온도 표시
                          textAlign: TextAlign.left,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: isPowerOn ?
                            const Color(0xff0000ff): Colors.grey,
                          ),
                        )
                      )
                    ],
                  ),
                ),
                
				
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // 실내온도 영역
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //padding: EdgeInsets.only(right: 20),
                              alignment: Alignment.topCenter,
                              child: Text(
                                '실내온도',
                                style: TextFont.semibig,
                                textAlign: TextAlign.right,
                              ),
                              margin: EdgeInsets.only(bottom: 2, )
                            ),
                            Container(
                              //padding: EdgeInsets.only(right: 20),
                              alignment: Alignment.topCenter,
                              child: Text(
                                _currentValue.toInt().toString() + '˚c', // 현재 실내 온도 표시
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24,
                                  color: (isPowerOn == true && _settingValue > 24)? const Color(0xffff0000) : (isPowerOn == true && _currentValue <= 24)? const Color(0xff0000ff) : Colors.grey
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 전원버튼 영역
                      Expanded(
                        child:Column(
                          children: [
                            Expanded(
                              child: Text(''),
                            ),
                            InkWell(
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
                            Expanded(
                              child: Text(''),
                            ),
                          ],
                        )
                      ),

                      Container(  // 모드 영역
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(bottom: 20, right: 10, top:20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // 모드 표시
                              Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: _buildDeviceMode(context, device)
                                )
                              )

                            ]
                          )
                        )
                      ),
                    ],
                  ),
                ),
              ],
            )
          )
				],
			),
		);
	}



	/// 기기에 정의된 모드 목록을 표시한다.
	List < Widget > _buildDeviceMode(BuildContext context, UserHomeDevices device) {
		String deviceTypeCode = device.devicemodel.modeltype.code;
		// 기기타입 별 사전 정의된 command 목록의 모드 위젯을 리턴한다.
		List < Widget > modeList = [];
		dynamic deviceCommands = UICommon.deviceTypeCommands[deviceTypeCode];
		int idx = deviceCommands.indexWhere((command) => command["command"] == "mode");
		if(idx == -1) return modeList;
		//print("_buildDeviceMode deviceCommands mode values : ${deviceCommands[idx]["values"]}");
		for (var deviceMode in deviceCommands[idx]["values"]) {
			print("_buildDeviceMode deviceMode  value : ${json.encode(deviceMode["value"])} ");
			if(deviceMode["value"] != null && deviceMode["value"] != "") {
				print("_buildDeviceMode deviceMode : ${json.encode(deviceMode)} ");
				modeList.add(
					DeviceModeWidget(device: device, deviceMode: deviceMode)
				);
			}
		}
		return modeList;
	}
}


/// 기기의 모드 정보 표시 
class DeviceModeWidget extends StatefulWidget {
	final UserHomeDevices device;
	final deviceMode;

	DeviceModeWidget({
		Key key,
		@required this.device, 
		@required this.deviceMode
	}) : super(key: key);

	@override
	_DeviceModeWidgetState createState() => _DeviceModeWidgetState();
}

class _DeviceModeWidgetState extends State < DeviceModeWidget > {
	final _deviceService = DeviceService();

	Widget build(BuildContext context) {
		UserHomeDevices device = widget.device;
		dynamic deviceMode = widget.deviceMode;
		String modeImage = deviceMode["icon"];
		if(device.mode == deviceMode["value"]){
			modeImage += "_on";
		}
		print("_DeviceModeWidgetState : $modeImage");

		bool isButtonEnable = true;
		return Container(
			margin: EdgeInsets.only(left: 15),
			child: InkWell(
				onLongPress: () {},
				onTap: () async{
					if (isButtonEnable) {
						isButtonEnable = false;
						await _deviceService.changeStatus(context, device.devicemodel.modeltype.code, widget.device.deviceId, "mode", deviceMode["value"], null);
						isButtonEnable = true;
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
							borderRadius: Radii.radi10,
							color: BgColor.white,
							boxShadow: [Shadows.fshadow],
						),
						width: 60,
						height: 60,
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							crossAxisAlignment: CrossAxisAlignment.center,
							children: [
								Container(
									width: 24,
									height: 24,
									child: Image.asset(
										"assets/images/$modeImage.png",
										fit: BoxFit.fitWidth,
									),
									margin: EdgeInsets.only(bottom: 3, ),
								),
								Container(
									child: Text(
										deviceMode["label"],  // 모드 라벨
										style: TextFont.small_n,
									),
								)
							]
						),
					)
				)
			)
		);
	}
}