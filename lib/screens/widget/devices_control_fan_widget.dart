import 'package:flutter/material.dart';
import '../../common/ui_common.dart';
import '../../service/device_service.dart';
import '../../model/user_home_model.dart';
import '../../common/style.dart';
import 'name_change_widget.dart';
import 'favorite_icon_widget.dart';

// 공간 별 / 기기구분 별 상세화면에 기기 - 조명 (전등)
class DeviceControlFanWidget extends StatefulWidget {
  final UserHomeDevices device;
  const DeviceControlFanWidget({Key key, this.device}) : super(key: key);
  @override
  DeviceControlFanWidgetState createState() => DeviceControlFanWidgetState();
}

class DeviceControlFanWidgetState extends State<DeviceControlFanWidget> {
  int selectedIndex;
  bool isPowerOn;

  Widget build(BuildContext context) {
    DeviceService _deviceService = DeviceService();
    UserHomeDevices device = widget.device;
    String deviceTypeCode = device.devicemodel.modeltype.code;
    isPowerOn = device.power == "on" ? true : false; //초기 기기 전원 상태 설정
    print("ispowerOn : $isPowerOn");
    String imageSuffix = isPowerOn ? "_on" : "_off";
    bool isButtonEnable = true;

    if (device.wind == "light") {
      selectedIndex = 0;
    } else if (device.wind == "middle") {
      selectedIndex = 1;
    } else if (device.wind == "power") {
      selectedIndex = 2;
    } else {
      selectedIndex = null;
    } // light, middle, power

    List<bool> _selections = List.generate(3, (_) => false);
    if (selectedIndex != null) {
      print("@@@selectedIndex@@@ + $selectedIndex");
      _selections[selectedIndex] = true;
    }
    return Container(
      padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        color: isPowerOn ? BgColor.white : BgColor.rgray,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  onLongPress: () async {
                    // 기기 명 변경 다이얼로그 표시
                    bool result = await DeviceNameChangeDialog(
                        context,
                        device.deviceId,
                        device.deviceName,
                        device.homeLocationId);
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
                      )),
                ),

                // 즐겨찾기 아이콘
                FavoriteIconWidget(device: device)
              ],
            ),
          ),
          Expanded(
              child: Container(
                  width: double.infinity,
                  child: Column(children: [
                    Expanded(
                      child: Text(''),
                    ),
                    Row(children: [
                      Expanded(
                        child: Text(''),
                      ),
                      Container(
                        child: InkWell(
                            onLongPress: () async {
                              if (isButtonEnable) {
                                isButtonEnable = false;
                                isPowerOn = !isPowerOn;
                                String commandName;
                                String commandValue;
                                if (isPowerOn) {
                                  commandName = "wind";
                                  commandValue = "light";
                                } else {
                                  commandName = "power";
                                  commandValue = "off";
                                }
                                bool success =
                                    await _deviceService.changeStatus(
                                        context,
                                        widget
                                            .device.devicemodel.modeltype.code,
                                        widget.device.deviceId,
                                        commandName,
                                        commandValue,
                                        null);
                                if (success) {
                                  if (isPowerOn) {
                                    _selections[0] = true;
                                    _selections[1] = false;
                                    _selections[2] = false;
                                    isPowerOn = true;
                                  } else {
                                    device.wind = "";
                                    isPowerOn = false;
                                  }
                                }
                                isButtonEnable = true;
                                setState(() {});
                              }
                            },
                            onTap: () async {
                              if (isButtonEnable) {
                                isButtonEnable = false;
                                isPowerOn = !isPowerOn;
                                String commandName;
                                String commandValue;
                                if (isPowerOn) {
                                  commandName = "wind";
                                  commandValue = "light";
                                } else {
                                  commandName = "power";
                                  commandValue = "off";
                                }
                                bool success =
                                    await _deviceService.changeStatus(
                                        context,
                                        widget
                                            .device.devicemodel.modeltype.code,
                                        widget.device.deviceId,
                                        commandName,
                                        commandValue,
                                        null);
                                if (success) {
                                  if (isPowerOn) {
                                    _selections[0] = true;
                                    _selections[1] = false;
                                    _selections[2] = false;
                                    isPowerOn = true;
                                  } else {
                                    device.wind = "";
                                    isPowerOn = false;
                                  }
                                }
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          child: Image.asset(
                                            "assets/images/power$imageSuffix.png", // 전원 ON/OFF 이미지
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ]),
                                ))),
                      ),
                      Expanded(
                        child: Text(''),
                      ),
                    ]),
                    Expanded(
                      child: Text(''),
                    ),
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                          Container(
                            child: ToggleButtons(
                              fillColor: BgColor.main,
                              borderColor: BgColor.lgray,
                              selectedBorderColor: BgColor.main,
                              selectedColor: BgColor.white,
                              color: BgColor.black45,
                              textStyle: TextFont.big,
                              borderRadius: Radii.radi10,
                              children: <Widget>[
                                // Container(
                                //   alignment: Alignment.center,
                                //   width: 60,
                                //   height: 50,
                                //   child: Text('꺼짐'),
                                // ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 50,
                                  child: Text('약'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 50,
                                  child: Text('중'),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 50,
                                  child: Text('강'),
                                ),
                              ],
                              onPressed: (int index) async {
                                if (isButtonEnable) {
                                  String windValue;
                                  switch (index) {
                                    case 0:
                                      windValue = "light";
                                      break;
                                    case 1:
                                      windValue = "middle";
                                      break;
                                    case 2:
                                      windValue = "power";
                                      break;
                                  }
                                  String commandName;
                                  String commandValue;

                                  commandName = "wind";
                                  commandValue = windValue;

                                  isButtonEnable = false;
                                  bool success =
                                      await _deviceService.changeStatus(
                                          context,
                                          widget.device.devicemodel.modeltype
                                              .code,
                                          widget.device.deviceId,
                                          commandName,
                                          commandValue,
                                          null);
                                  if (success) {
                                    setState(() {
                                      print(
                                          "_DeviceControlFanWidgetState index : $index");
                                      for (int buttonIndex = 0;
                                          buttonIndex < _selections.length;
                                          buttonIndex++) {
                                        if (buttonIndex == index) {
                                          _selections[buttonIndex] = true;
                                        } else {
                                          _selections[buttonIndex] = false;
                                        }
                                      }
                                    });
                                  }
                                  isButtonEnable = true;
                                }
                              },
                              isSelected: _selections,
                            ),
                          )
                        ])),
                  ]))),
        ],
      ),
    );
  }
}
