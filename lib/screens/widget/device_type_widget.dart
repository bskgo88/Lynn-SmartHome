import 'package:flutter/material.dart';
import '../../model/user_home_model.dart';
import '../../common/ui_common.dart';
import '../../common/style.dart';
import '../../model/device_type_devices_model.dart';


/// 기기 구분별 제어 영역 표시 
class DeviceTypeCardWidget extends StatefulWidget {

	final UserHomeModel userHomeModel;
	final DeviceTypeModel deviceType;
	DeviceTypeCardWidget({
		Key key,
		this.userHomeModel,
		this.deviceType
	}): super(key: key);

	@override
	_DeviceTypeCardWidgetState createState() => _DeviceTypeCardWidgetState();
}

class _DeviceTypeCardWidgetState extends State < DeviceTypeCardWidget > {

	Widget build(BuildContext context) {

		final typeModel = widget.deviceType;
		String deviceTypeCode = typeModel.deviceTypeCode;
		String imageSuffix = "";

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
												child: Image.asset(
													UICommon.deviceIcons[deviceTypeCode] + imageSuffix + ".png", // 기기구분 이미지
													fit: BoxFit.fitWidth,
												),
												margin: EdgeInsets.only(bottom: 5, ),
											),
											Container(
												child: Text(
													UICommon.deviceTypeNames[deviceTypeCode],
													style: TextFont.normal
												), // 기기구분 명 ,
											),
										],
									)
								),
								Positioned(
									right: 5,
									top: 5,
									child: Container(
										width: 24,
										height: 24,
										alignment: Alignment.center,
										decoration: BoxDecoration(
											borderRadius: Radii.radi20,
											color: BgColor.lgray,
										),
										child: Text(
											'${typeModel.deviceCnt}',
											style: TextFont.normal,
										),
									)
								)
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

						Navigator.pushNamed(context, '/controlDeviceTypes', arguments: {'typeModel':typeModel});

					},
				),
			),
		);
	}

}