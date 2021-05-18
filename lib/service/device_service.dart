import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_session/flutter_session.dart';
import '../bloc/user_home_bloc.dart';
import '../common/globals.dart';
import '../common/ui_common.dart';
import 'package:vibration/vibration.dart';

import 'user_service.dart';
import '../common/rest_api.dart';



class DeviceService {

	Map<String, String> deviceTypeApi = {
		"light" : "light",
		"heating" : "roomHeating",
		"aircon" : "airCon",
		"gas" : "valve",
		"fan" : "ventilation",
	};


	/// 기기 상태 제어 서버 요청 (전체 기기 상태 서버 요청 공통)
	Future < dynamic > controlDeviceStatus(String deviceType, String deviceId, dynamic controlModel) async {
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = deviceTypeApi[deviceType];
		if(deviceId != null && deviceId != ""){
			apiId += "/" + deviceId;
		}
		// 제어는 PUT 임
		return RestApi.doPutWithUser(apiId, _user, controlModel);
	}


	/// 디바이스 상태 변경 ( 모든 상태 변경 공통 함수) 
	Future<bool> changeStatus(BuildContext context, String deviceType, String deviceId, String commandName, String commandValue, String prevValue) async{
		print("DeviceService.changeStatus deviceType : $deviceType  deviceId : $deviceId  command : $commandName  value : $commandValue");
		if(deviceType == "gas" && commandValue == "on"){
			UICommon.showMessage(context, "가스는 밸브 잠금만 가능합니다.");
			return false;
		}
		dynamic requestModel;
		if (deviceType == "gas") {
			requestModel = {};
		} else {
			List< DeviceControlCommandList > commands = [];
			if(deviceType == "fan" && commandValue != "off"){  // 환기 - 약, 중, 강 이면 전원 on 명령어 같이 보낸다.
				DeviceControlCommandList commandModel = DeviceControlCommandList(command: "power", value: "on");
				commands.add(commandModel);
			}
			DeviceControlCommandList commandModel = DeviceControlCommandList(command: commandName, value: commandValue);
			commands.add(commandModel);
			DeviceControlModel controlModel = DeviceControlModel(commandList: commands);
			requestModel = controlModel;
		}
		if(prevValue != null){
			setDeviceChangedStatus(context, deviceId, commandName, commandValue);  // 화면 먼저 바뀌게 처리
		}
		dynamic success = await controlDeviceStatus(deviceType, deviceId, requestModel);    //dynamic success = await Future.delayed(Duration(milliseconds: 1000), () => true);  //테스트 용도
		if (success) {
			if(deviceType == "fan" && commandValue != "off"){ // fan 약/중/강 선택 시 전원도 on 으로 제어한다.
				setDeviceChangedStatus(context, deviceId, "power", "on");
			}

			if(prevValue == null){
				setDeviceChangedStatus(context, deviceId, commandName, commandValue);
			}

			// 전원 ON/FF 진동 추가 (2021.02.05 by yong100)
      if(USE_VIBRATION){
        if (await Vibration.hasVibrator()) {
            // 전원 ON 하는 경우만 두번 진동으로 설정
            if(commandName == "power" && commandValue == "on"){
              if (await Vibration.hasAmplitudeControl()) {
                //pattern (wait 0ms, vibrate 50ms, wait 10ms, vibrate 50ms)
                Vibration.vibrate(pattern: [0, 50, 10, 50], amplitude: 16);
              }else{
                Vibration.vibrate(pattern: [0, 50, 10, 50]);
              }
            }else{
              if (await Vibration.hasAmplitudeControl()) {
                Vibration.vibrate(pattern: [0, 50], amplitude: 16);
              }else{
                Vibration.vibrate(pattern: [0, 50]);
              }
            }
        }
      }
		} else {
			if(prevValue != null){
				setDeviceChangedStatus(context, deviceId, commandName, prevValue);  // 실패시 화면 먼저 바뀌게 처리한 것 원복
			}
			UICommon.showMessage(context, "기기가 연결 상태가 아닙니다.");
		}
		return success;
	}


	/// 디바이스 전원 On/Off Toggle  - 전원 on/off  리턴은 변경된 상태를 리턴한다.
	/// in parameter isPowerOn 은 현재 상태임
	Future<bool> powerOnOff(BuildContext context, String deviceType, String deviceId, bool isPowerOn) async{
		String commandName = "power";
		String prevValue = isPowerOn? "on" : "off";
		String commandValue = !isPowerOn? "on" : "off";
		bool success = await changeStatus(context, deviceType, deviceId, commandName, commandValue, prevValue);
		if(success){
			return !isPowerOn;
		}else{
			return isPowerOn;
		}
			
	}

	/// 디바이스 온도 설정  - 설정된 온도를 리턴한다 (실패시 이전 온도 리턴)
	Future<double> setTemperature(BuildContext context, String deviceType, String deviceId, double settingValue, double prevValue) async{
		//print("setTemperature deviceType : $deviceType  deviceId : $deviceId  settingValue : $settingValue  prevValue : $prevValue" );
		String commandName = "setTemperature";
		String commandValue = settingValue.toInt().toString();
		bool success =  await changeStatus(context, deviceType, deviceId, commandName, commandValue, prevValue.toInt().toString());
		if(success){
			return settingValue;
		}else {
			return prevValue;
		}
	}

	/// 전등 일괄  On/Off 
	/// in parameter isPowerOn 은 현재 상태임
	Future<bool> lightAllPowerOff(BuildContext context, bool isPowerOn) async{
		String commandName = "power";
		String commandValue = !isPowerOn? "on" : "off";
		
		List< DeviceControlCommandList > commands = [];
		DeviceControlCommandList commandModel = DeviceControlCommandList(command: commandName, value: commandValue);
		commands.add(commandModel);
		DeviceControlModel controlModel = DeviceControlModel(commandList: commands);

		dynamic success = await controlDeviceStatus("light", "", controlModel);    //dynamic success = await Future.delayed(Duration(milliseconds: 1000), () => true);  //테스트 용도
		if (success) {
			setDeviceTypeChangedStatus(context, "light", commandName, commandValue);
			return !isPowerOn;
		} else {
			print("기기가 연결 상태가 아닙니다.");
			UICommon.showMessage(context, "기기가 연결 상태가 아닙니다.");
			return isPowerOn;
		}	
	}


	/// 방범 설정
	Future<bool> setSecurity(BuildContext context) async{
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "security"; 

		dynamic requestBody = {"settingMode": "stay"};
		dynamic success =  await RestApi.doPostWithUser(apiId, _user, requestBody);
		if (success is bool && !success) {
			UICommon.showMessage(context, "설정되었습니다.");
			return false;
		}else{
			UICommon.alert(context, "설정하지 못하였습니다.");
			return true;
		}
	}


	/// context 와 디바이스의 변경된 정보를 받아 상태를 변경한다.
	void setDeviceChangedStatus(BuildContext context, String deviceId, String command, String value){
		BlocProvider.of<UserHomeBloc>(context).add(StatusChangedEvent(deviceId: deviceId, statusName: command, statusValue: value ));
	}

	/// context 와 디바이스타입 정보를 받아 해당 타입의 모든 기기 상태를 변경한다.
	void setDeviceTypeChangedStatus(BuildContext context, String deviceType, String command, String value){
		BlocProvider.of<UserHomeBloc>(context).add(StatusDeviceTypeChangedEvent(deviceType: deviceType, statusName: command, statusValue: value ));
	}

}



class DeviceControlModel {
	/*
	{
	  "commandList": [
	    {
	      "command": "power",
	      "value": "off"
	    }
	  ]
	} 
	*/

	List < DeviceControlCommandList > commandList;

	DeviceControlModel({
		this.commandList,
	});

	DeviceControlModel.fromJson(Map < String, dynamic > json) {
		if (json["commandList"] != null) {
			var v = json["commandList"];
			var arr0 = List < DeviceControlCommandList > ();
			v.forEach((v) {
				arr0.add(DeviceControlCommandList.fromJson(v));
			});
			commandList = arr0;
		}
	}

	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		if (commandList != null) {
			var v = commandList;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["commandList"] = arr0;
		}
		return data;
	}
}


class DeviceControlCommandList {
	/*
	{
	  "command": "power",
	  "value": "off"
	} 
	*/

	String command;
	String value;

	DeviceControlCommandList({
		this.command,
		this.value,
	});
	DeviceControlCommandList.fromJson(Map < String, dynamic > json) {
		command = json["command"] ?.toString();
		value = json["value"] ?.toString();
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["command"] = command;
		data["value"] = value;
		return data;
	}
}

