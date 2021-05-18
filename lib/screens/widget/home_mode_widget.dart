import 'package:flutter/material.dart';
import '../../service/config_service.dart';
import '../../service/device_service.dart';
import '../../service/facility_service.dart';
import '../../common/ui_common.dart';
import '../../common/style.dart';


/// 모드 
class HomeModeWidget extends StatefulWidget {

	final routineId;
	final routineName;
	final deviceId;
	HomeModeWidget({
		Key key,
		this.routineId, 
		this.routineName,
		this.deviceId, 
	}): super(key: key);

	@override
	_HomeModeWidgetState createState() => _HomeModeWidgetState();
}

class _HomeModeWidgetState extends State < HomeModeWidget > {

	Widget build(BuildContext context) {

		String imageSuffix = "";
		final _facillityService = FacilityService();
		final _deviceService = DeviceService();
		final _configService = ConfigService();
		bool isButtonEnable = true;
		String modeImage = "assets/images/play.png";
		// 엘리베이터, 일괄소등, 방범설정 인 경우만  deviceId 가 있음.
		if(widget.routineName == "일괄소등"){
			modeImage = "assets/images/switch.png";
		}else if(widget.deviceId != null){
			modeImage = UICommon.deviceIcons[widget.deviceId] + imageSuffix + ".png";  // 기기구분 이미지
		}

		return Material(
			color: Colors.transparent,
			child: Container(
				margin: EdgeInsets.only(
					top: 15, bottom: 15, left: 5, right: 5),
				decoration: BoxDecoration(
					color: BgColor.white,
					borderRadius: Radii.radi10,
					boxShadow: [Shadows.fshadow],
				),
				width: 90,
				height: 90,
				child: FlatButton(
					padding: EdgeInsets.all(0),
					child: Container(
						width: 90,
						height: 90,
						child: Stack(
							children: < Widget > [
								Positioned(
									width: 90,
									height: 90,
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										mainAxisAlignment: MainAxisAlignment.center,
										children: [
											Container(
												width: 34,
												height: 34,
												child: Image.asset(modeImage,fit: BoxFit.fitWidth,),  // 모드 이미지 
												margin: EdgeInsets.only(bottom: 5, ),
											),
											Container(
												child: Text(
													widget.routineName , // 루틴 명 ,
													style: TextFont.normal
												), 
											),
										],
									)
								),
							]
						),
					),

					onPressed: () async {
						// BlocProvider 사용을 위해서는 아래와 같이 Navigator.push
						// await Navigator.push(context, MaterialPageRoute(
						// 	builder: (_) => BlocProvider < UserHomeBloc > (
						// 		create: (_) => UserHomeBloc(widget.userHomeModel),
						// 		child: DeviceControlTypes(userHomeModel: widget.userHomeModel, typeModel: typeModel),
						// 	)
						// ));
						if(isButtonEnable){
							isButtonEnable = false;
							bool isSuccess;
							String message;
							if(widget.deviceId == "ELEVATOR"){ // 엘리베이터 호출
								isSuccess = await _facillityService.callElevator(context);
								message = "호출하였습니다.";
							}else if(widget.routineName == "일괄소등"){
								//isSuccess = await _deviceService.lightAllPowerOff(context, true); //일괄 소등
								isSuccess = await _deviceService.powerOnOff(context, "switch", widget.deviceId, true); //일괄 소등 스위치는 true(on)이 소등하는 것임
								message = "소등하였습니다.";
							}else if(widget.deviceId == "SECURITY"){
								isSuccess = await _deviceService.setSecurity(context); // 방범 설정
								message = "방범 설정을 하였습니다.";
							}else{
								isSuccess =  await _configService.doExecuteRoutine(context, widget.routineId); // 설정된 루틴 실행
								message = "모드를 실행하였습니다.";
							}
							if(isSuccess){
								UICommon.alert(context, message);
							}else{
								UICommon.alert(context, "실패하였습니다.");
							}
							isButtonEnable = true;
						}
					},
				),
			),
		);
	}

}