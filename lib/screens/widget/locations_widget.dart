import 'package:flutter/material.dart';
import '../../model/location_devices_model.dart';
import '../../model/user_home_model.dart';
import '../../common/ui_common.dart';
import '../../common/style.dart';
import '../../service/device_service.dart';
//import '../../publish/rooms.dart';


// 공간별 제어 영역 표시 
class LocationCardWidget extends StatefulWidget {
	//final List < LocationModel > locations;
	final UserHomeModel userHomeModel;
	final LocationModel location;  //선택된 공간 정보
	LocationCardWidget({Key key, this.userHomeModel, this.location}) : super(key: key);


	@override
	_LocationCardWidgetState createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends State < LocationCardWidget > {

	Widget build(BuildContext context) {
		LocationModel location = widget.location;

		return Material(
			color: Colors.transparent,
			child: Container(
			padding: EdgeInsets.all(0),
			margin: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
			width: 178,
			height: 115,
			decoration: BoxDecoration(
				boxShadow: [Shadows.fshadow]
			),
			child: ButtonTheme(
				shape: RoundedRectangleBorder(
					borderRadius: Radii.radi10,
				),
				highlightColor: BgColor.lgray,
				child: FlatButton(
					color: BgColor.white,
					padding: EdgeInsets.all(0),
					onPressed: () async {
						// BlocProvider 사용을 위해서는 아래와 같이 Navigator.push
						// await Navigator.push(context, MaterialPageRoute (
						// 			builder: (_) => BlocProvider < UserHomeBloc > (
						// 				create: (_) => UserHomeBloc(widget.userHomeModel),
						// 				child: DeviceControl(userHomeModel: widget.userHomeModel, location:location),
						// 			)
						// 	)
						// );

						Navigator.pushNamed(context, '/controlLocations', arguments: {'location':location});

					},
					onLongPress: () {
						//print('long');
					},
					child: Ink(
						decoration: BoxDecoration(
							borderRadius: Radii.radi10,
							gradient: OnItem.offset,
						),
						child: Container(
							width: 178,
							height: 115,
							padding: EdgeInsets.only(top:10, left: 10, right: 10),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(location.locationName, style: TextFont.big), // 공간 이름
									Container(
										width: 40,
										height: 2,
										decoration: BoxDecoration(color: BgColor.black45),
										margin: EdgeInsets.only(top: 13, bottom: 10),
									),
									Expanded(
                    //width: double.infinity,
										child: SingleChildScrollView(
										padding: EdgeInsets.only(top:10, left: 5, right: 5),
										scrollDirection: Axis.horizontal,
                      child: Column(children: < Widget > [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
    
                          //공간에 들어가는 기기 목록 
                          children: _buildLocationDevices(context)

                        )
                      ])
                    )
									),
								]
							),
						)
					)
				)
			),
			),
		);
	}

	/// 공간에 들어가는 기기 목록 표시
	List < Widget > _buildLocationDevices(BuildContext context) {
		List < Widget > devicesWidget = [];
		//int index = 0;
		for (var device in widget.location.devices) {
			//if ( index < 4) { // Max 4개 기기만 표시 한다.
				devicesWidget.add(DeviceSmallCardWidget(device));
			//}else{
			//	break;
			//}
			//index++;
		}
		return devicesWidget;

	// 	return widget.location.devices.map((device) {
	// 		return DeviceSmallCardWidget(device);
	// 	}).toList();
	}

}




/// 공간에 들어가는 기기 목록 위젯
class DeviceSmallCardWidget extends StatefulWidget {
	final UserHomeDevices device;
	DeviceSmallCardWidget(this.device); //Constructor

	@override
	_DeviceSmallCardWidgetState createState() => _DeviceSmallCardWidgetState();
}

class _DeviceSmallCardWidgetState extends State < DeviceSmallCardWidget > {
	bool isPowerOn = false;
	bool isButtonEnable = true;
	DeviceService _deviceService = new DeviceService();

	Widget build(BuildContext context) {
		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;

		//초기 기기 전원 상태 설정 
		isPowerOn = device.power == "on"? true : false;  
		String imageSuffix = isPowerOn? "_on" : "";

		return Material(
			color: Colors.transparent,
			child: Container(
				margin: EdgeInsets.only(right: 5),
				decoration: BoxDecoration(
					color: BgColor.white,
					borderRadius: Radii.radi5,
					boxShadow: [
						Shadows.fshadow
					],
				),
				width: 35,
				height: 35,
				child: FlatButton(
					padding: EdgeInsets.all(0),
					child: Container(
						width: 35,
						height: 4350,
						padding: EdgeInsets.all(5),
						child: Image.asset(
							UICommon.deviceIcons[deviceTypeCode] + imageSuffix + ".png",
							fit: BoxFit.fitWidth,
						),
					),
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
			),
			),
		);
	}
}