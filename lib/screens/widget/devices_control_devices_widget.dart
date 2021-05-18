import 'dart:ui';

import 'package:flutter/material.dart';
import '../../model/device_type_devices_model.dart';
import '../../model/location_devices_model.dart';
import '../../model/user_home_model.dart';
import '../../common/ui_common.dart';
import '../../common/style.dart';
import '../../service/device_service.dart';
//import 'devices_control_common_widget.dart';

// 공간 별 / 기기구분 별 상세화면에 보여지는 상단 탭
class DeviceControlTabWidget extends StatefulWidget {
  final LocationModel location;
  DeviceControlTabWidget({Key key, @required this.location}) : super(key: key);

  @override
  _DeviceControlTabWidgetState createState() {
    return _DeviceControlTabWidgetState();
  }
}

class _DeviceControlTabWidgetState extends State<DeviceControlTabWidget> {
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        width: 140,
        alignment: Alignment.center,
        child: Text(
          widget.location.locationName,
        ),
      ),
    );
  }
}

// 기기구분 별 상세화면에 보여지는 상단 탭
class DeviceControlTypesTabWidget extends StatefulWidget {
  final DeviceTypeModel typeModel;
  DeviceControlTypesTabWidget({Key key, @required this.typeModel})
      : super(key: key);

  @override
  _DeviceControlTypesTabWidgetState createState() {
    return _DeviceControlTypesTabWidgetState();
  }
}

class _DeviceControlTypesTabWidgetState
    extends State<DeviceControlTypesTabWidget> {
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        width: 140,
        alignment: Alignment.center,
        child: Text(
          // widget.typeModel.deviceTypeName,  // 설정이름이 길고 어려움.
          UICommon.deviceTypeNames[widget.typeModel.deviceTypeCode], // 기기구분 명
        ),
      ),
    );
  }
}

// 공간 별 / 기기구분 별 상세화면에 보여지는 기기목록
class DeviceControlWidget extends StatefulWidget {
  final UserHomeDevices device;
  final bool isSelected;
  final Function(String)
      changeDevice; // 기기 변경 선택 시 해당 기기아이디를  상위 위젯에 넘길 수 있는 함수
  DeviceControlWidget(
      {Key key,
      this.device,
      @required this.isSelected,
      @required this.changeDevice})
      : super(key: key);

  @override
  _DeviceControlWidgetState createState() => _DeviceControlWidgetState();
}

class _DeviceControlWidgetState extends State<DeviceControlWidget> {
  bool isPowerOn = false;
  bool isButtonEnable = true;

  Widget build(BuildContext context) {
    final _deviceService = DeviceService();
    UserHomeDevices device = widget.device;
    String deviceTypeCode = device.devicemodel.modeltype.code;
    bool isSelected = widget.isSelected;
    //print("_DeviceControlWidgetState build isSelected : ${isSelected}");

    //초기 기기 전원 상태 설정
    isPowerOn = device.power == "on" ? true : false;

    String imageSuffix = isPowerOn ? "_on" : "_off";

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
        decoration: BoxDecoration(
          color: isSelected ? Color.fromRGBO(0, 0, 0, 0) : BgColor.white,
          borderRadius: Radii.radi10,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: BgColor.shadow,
                  ),
                  BoxShadow(
                    color: BgColor.white,
                    spreadRadius: -5.0,
                    blurRadius: 8.0,
                  )
                ]
              : [Shadows.fshadow],
        ),
        width: 85,
        height: 85,
        child: FlatButton(
          child: Stack(alignment: FractionalOffset(0, 0), children: <Widget>[
            Positioned(
              top: 12,
              left: 0,
              child: Text(
                device.deviceName, // 기기 명
                textAlign: TextAlign.left,
                style:TextFont.normal
              ),
            ),
            Positioned(
              top: 35,
              left: 10,
              child: Container(
                width: 35,
                height: 35,
                child: Image.asset(
                  UICommon.deviceIcons[deviceTypeCode] + (isPowerOn? "_on" : "") + ".png", // 기기 이미 지
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ]),
          onPressed: () {
            //print("Selected Device Id : ${device.deviceId}");
            widget.changeDevice(device.deviceId);
          },                        
          onLongPress: () async {
            if (isButtonEnable) {
              isButtonEnable = false;
              isPowerOn = await _deviceService.powerOnOff(context, deviceTypeCode, device.deviceId, isPowerOn);
              isButtonEnable = true;
            }
          },
        ),
      ),
    );
  }
}
