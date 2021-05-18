import 'package:flutter/material.dart';
import '../../common/ui_common.dart';
import '../../service/device_service.dart';
import '../../model/user_home_model.dart';
import '../../common/style.dart';
import 'name_change_widget.dart';
import 'favorite_icon_widget.dart';

// 공간 별 / 기기구분 별 상세화면에 기기 - 조명 (전등)
class DeviceControlGasWidget extends StatefulWidget {
	final UserHomeDevices device;
  	const DeviceControlGasWidget({Key key, this.device}) : super(key: key);
	@override
	DeviceControlGasWidgetState createState() => DeviceControlGasWidgetState();
}

class DeviceControlGasWidgetState extends State < DeviceControlGasWidget > {

	Widget build(BuildContext context) {

		DeviceService _deviceService = DeviceService();
		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;
		bool isPowerOn = device.power == "on" ? true : false; //초기 기기 전원 상태 설정 
		String imageSuffix = isPowerOn ? "_on" : "_off";
		bool isButtonEnable = true;	

		return Container(
			padding: EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
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
						),
					),
					Expanded(
						child: Container(
              width: double.infinity,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Text(
                          '닫힘',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: const Color(0xff333333),
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40,right:40),
                        child: Transform.scale(
                          scale: 3.2,
                          child: Switch(
                            value: isPowerOn,
                            onChanged: (value) async {
                              if(isButtonEnable){
                                isButtonEnable = false;
                                isPowerOn = await _deviceService.powerOnOff(context, deviceTypeCode, device.deviceId, isPowerOn);
                                isButtonEnable = true;
                              }
                            },
                            activeTrackColor: BgColor.lgray,
                            activeColor: BgColor.main,
                          ),
                        )
                      ),
                      Container(
                        child: Text(
                          '열림',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: const Color(0xff333333),
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(''),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(''),
                  ),
                ]
              )
            )
					),
				],
			),
		);
	}
}
