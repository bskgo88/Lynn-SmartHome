import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_home_bloc.dart';
import '../../model/device_type_devices_model.dart';
import '../../screens/widget/devices_control_fan_widget.dart';
import '../../model/user_home_model.dart';
import '../../common/style.dart';
import 'devices_control_aircon_widget.dart';
import 'devices_control_gas_widget.dart';
import 'devices_control_fan_widget.dart';
import 'devices_control_heater_widget.dart';
import 'devices_control_light_widget.dart';
import 'devices_control_devices_widget.dart';

// 공간 별 / 기기구분 별 상세화면 - 모든 기기 공통 화면
class DeviceControlCommonTypesWidget extends StatefulWidget {
	final DeviceTypeModel typeModel;
	DeviceControlCommonTypesWidget({
		Key key,
		this.typeModel
	}): super(key: key);

	@override
	_DeviceControlCommonTypesWidgetState createState() => _DeviceControlCommonTypesWidgetState(typeModel); //commonState;
}

class _DeviceControlCommonTypesWidgetState extends State < DeviceControlCommonTypesWidget > {
	String _deviceId = "";
	DeviceTypeModel _typeModel;

	_DeviceControlCommonTypesWidgetState(this._typeModel){
		//print("_DeviceControlCommonTypesWidgetState _typeModel.devices.length : ${_typeModel.devices.length}");
		if(_typeModel.devices.length > 0){
			_deviceId = _typeModel.devices[0].deviceId;
		}
	}

	/// 하위 기기 목록 위젯에서 호츌 할 수 있도록  Function 자체를 DeviceControlWidget 에 파라미터로 넘겨 준다.						
	_changeDevice(String deviceId) {
		//print("_DeviceControlCommonTypesWidgetState changeDevice called!! deviceId : ${_deviceId}");
		int sIdx = widget.typeModel.devices.indexWhere((device) => device.deviceId == deviceId);
		if(sIdx == -1){
			sIdx = 0;
		}
		//print("_changeDevice _deviceId : ${widget.typeModel.devices[sIdx].deviceId}  sIdx : $sIdx");
		
		String deviceTypeCode = widget.typeModel.devices[sIdx].devicemodel.modeltype.code;
		setState(() {
			_deviceId = deviceId;
			switch (deviceTypeCode) {
				case 'light':
					if(_lightChild.currentState != null) _lightChild.currentState.setState(() {});
					break;
				case 'heating':
					if(_heaterChild.currentState != null) _heaterChild.currentState.setState(() {});
					break;
				case 'gas':
					if(_gasChild.currentState != null) _gasChild.currentState.setState(() {});
					break;
				case 'aircon':
					if(_airconChild.currentState != null) _airconChild.currentState.setState(() {});
					break;
				case 'fan':
					if(_fanChild.currentState != null) _fanChild.currentState.setState(() {});
					break;
				default :
					if(_lightChild.currentState != null) _lightChild.currentState.setState(() {});
			}
		});
	}

	/// 탭 별 상세화면에 들어가는 기기 목록 표시
	List < Widget > _buildDeviceControls(BuildContext context) {
		return widget.typeModel.devices.map((device) {
			bool isSelected = false;
			if(device.deviceId == this._deviceId){
				isSelected = true;
			}
			return 
				
				DeviceControlWidget(device: device, isSelected: isSelected, changeDevice: _changeDevice); // _changeDevice Function 을 파라미터로 넘김
		}).toList();
	}


	GlobalKey<DeviceControlLightWidgetState> _lightChild = GlobalKey();
	GlobalKey<DeviceControlHeaterWidgetState> _heaterChild = GlobalKey();
	GlobalKey<DeviceControlFanWidgetState> _fanChild = GlobalKey();
	GlobalKey<DeviceControlAirconWidgetState> _airconChild = GlobalKey();
	GlobalKey<DeviceControlGasWidgetState> _gasChild = GlobalKey();

	/// 탭 별 상세화면에 들어가는 기기 상세 조회/제어 화면 표시 - 기기구분 별로 별도 위젯을 불러온다.
	Widget _buildDeviceDetail(BuildContext context) {
		List < UserHomeDevices > devices = widget.typeModel.devices;
		// 처음 화면 로딩 시에는 첫번째 기기를 표시
		int sIdx = 0;
		if (_deviceId != null) {
			sIdx = devices.indexWhere((device) => device.deviceId == _deviceId);
			if(sIdx == -1){
				sIdx = 0;
			}
		}
		_deviceId = devices[sIdx].deviceId;
		String deviceTypeCode = devices[sIdx].devicemodel.modeltype.code;

		return BlocBuilder < UserHomeBloc, UserHomeState > (
			builder: (context, UserHomeState state) {
				switch (deviceTypeCode) {
					case 'light':
						return DeviceControlLightWidget(key: _lightChild, device: devices[sIdx]);
						break;
					case 'heating':
						return DeviceControlHeaterWidget(key: _heaterChild, device: devices[sIdx]);
						break;
					case 'gas':
						return DeviceControlGasWidget(key: _gasChild, device: devices[sIdx]);
						break;
					case 'aircon':
						return DeviceControlAirconWidget(key: _airconChild, device: devices[sIdx]);
						break;
					case 'fan':
						return DeviceControlFanWidget(key: _fanChild, device: devices[sIdx]);
						break;
				}
				return new DeviceControlLightWidget(key: _lightChild, device: devices[sIdx]);
			}
		);
	}

	Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
		return Container(
			constraints: BoxConstraints.expand(),
			decoration: BoxDecoration(color: BgColor.white),
			child: Column(
				children: < Widget > [
					Container(
						width: double.infinity,
						child: SingleChildScrollView(
							padding: EdgeInsets.only(left: 10, right: 10),
							scrollDirection: Axis.horizontal,
							child: Column(
								children: < Widget > [
									Row(
										mainAxisAlignment: MainAxisAlignment.start,
										// 공간 별, 기기 구분별 기기 목록 표시
										children: _buildDeviceControls(context),
									),
								],
							),
						)
					),
					Container(
						color: BgColor.lgray,
						height: 10,
					),
          Expanded(
              child: SingleChildScrollView(
                  child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 250,
              maxHeight: screenHeight > 450 ? screenHeight - 272 : 400,
            ),
            child: Material(

                /// 기기 정보 (조회/제어) 표시
                color: Colors.transparent,
                child: _buildDeviceDetail(context)),
          )))
				],
			),
		);
	}
}
