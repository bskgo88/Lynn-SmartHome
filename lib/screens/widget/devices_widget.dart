import 'package:flutter/material.dart';
import '../../model/user_home_model.dart';
import '../../common/ui_common.dart';
import '../../common/style.dart';
import '../../service/device_service.dart';


// 즐겨찾기 영역 위젯
class DeviceCardWidget extends StatefulWidget {
	final UserHomeDevices device;
	DeviceCardWidget({Key key, this.device}) : super(key: key);

	@override
	_DeviceCardWidgetState createState() => _DeviceCardWidgetState();
}

class _DeviceCardWidgetState extends State < DeviceCardWidget > {

	Widget build(BuildContext context) {
		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;
		final _deviceService = DeviceService();

		 //초기 기기 전원 상태 설정 
		bool isPowerOn = device.power == "on"? true : false; 
		String imageSuffix = isPowerOn? "_on" : "";
		bool isButtonEnable = true;

		//print("DeviceCardWidget build deviceType : $deviceTypeCode  deviceName : ${device.deviceName}  isPowerOn : ${device.power}");

		return Material(
			color: Colors.transparent,
			child: Container(
				padding: EdgeInsets.all(0),
				margin: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 8),
				width: 90,
				height: 90,
				decoration: BoxDecoration(
					borderRadius: Radii.radi10,
					color: isPowerOn ? Color.fromRGBO(0,0,0,0) : BgColor.white,
					boxShadow: isPowerOn ? [
            BoxShadow(
              color: BgColor.shadow,
            ),
            BoxShadow(
              color: BgColor.white,
              spreadRadius: -5.0,
              blurRadius: 8.0,
            )] : [Shadows.fshadow],
				),
				child: ButtonTheme(
					shape: RoundedRectangleBorder(
						borderRadius: Radii.radi10,
					),
					child: FlatButton(
						padding: EdgeInsets.all(0),
						onPressed: () async {
							if(isButtonEnable){
								isButtonEnable = false;
								isPowerOn = await _deviceService.powerOnOff(context, deviceTypeCode, device.deviceId, isPowerOn);
								isButtonEnable = true;
							}
						},
						onLongPress: () async{
							if(isButtonEnable){
								isButtonEnable = false;
								isPowerOn = await _deviceService.powerOnOff(context, deviceTypeCode, device.deviceId, isPowerOn);
								isButtonEnable = true;
							}
						},
						child: Ink(
							decoration: BoxDecoration(
								borderRadius: Radii.radi10,
							),
							child: Container(
								width: 90,
								height: 90,
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										Container(
											width: 50,
											height: 34,
											margin: EdgeInsets.only(bottom: 5),
											child: Image.asset(
												UICommon.deviceIcons[deviceTypeCode] + imageSuffix + ".png",  //
												fit: BoxFit.fitHeight,
											),
										),
										Text(
											device.deviceName,
											style: isPowerOn ? TextFont.normal_m : TextFont.normal
										),
									]
								),
							)
						)
					)
				)
			),

		);
			//}
		//);
	}
}
