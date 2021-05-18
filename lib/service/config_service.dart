import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/user_home_bloc.dart';
import '../common/globals.dart';
import '../common/ui_common.dart';
import '../model/routine_devices_model.dart';
import '../model/user_home_model.dart';

import 'user_service.dart';
import '../common/rest_api.dart';



class ConfigService {

	Map<String, String> deviceTypeApi = {
		"light" : "light",
		"heating" : "roomHeating",
		"aircon" : "airCon",
		"gas" : "valve",
		"fan" : "ventilation",
	};


	/// 즐겨찾기 설정
	/// deviceId 는 기기의 id 임 (deviceId 아님)
	/// isFavorite 바꾸려는 상태임 
	Future<String> doFavorite(BuildContext context, String deviceId, dynamic id, String isFavorite, bool showMessage) async{
		List<dynamic> targetDevices = [];
		targetDevices.add(id); // Favorite은 id 를 넘김
		var requestBody = {"home_device_ids": targetDevices};

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		String apiId = "favorite";
		if(isFavorite == "no"){
			apiId += "/delete";
		}
		dynamic response = await RestApi.doPostWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			if(showMessage) UICommon.showMessage(context, "즐겨찾기 설정에 실패하였습니다.");
			return isFavorite == "yes"? "no" : "yes";
		} else {
			if(showMessage){
				if(isFavorite == "yes"){
					UICommon.showMessage(context, "즐겨찾기 설정되었습니다.");
				}else{
					UICommon.showMessage(context, "즐겨찾기 해제되었습니다.");
				}
				setDeviceChangedStatus(context, deviceId, "isFavorite", isFavorite);
			}
			
			return isFavorite;
		}
	}



	/// 기기 정보 변경
	Future<bool> doChangeDeviceInfo(BuildContext context, String deviceId, String deviceName, dynamic locationId) async{
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		var requestBody = {"device_name": deviceName, "home_location_id": locationId};
		String apiId = "homedevice/" + deviceId;

		//locationId -1 이면 기기 공간 삭제 임
		if(locationId == -1){
			apiId += "/locationDelete";
		}
		dynamic response = await RestApi.doPutWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return false;
		} else {
			return true;
		}
	}

  // ignore: non_constant_identifier_names
  static dynamic _NEW_LOCATION_ID = 100;
	/// 공간 생성 
	Future<dynamic> doCreateLocation(BuildContext context, String locationName) async{  //, List < LocationModel > locations
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		var requestBody = {"location_name": locationName};  //location_name  이 맞음  api 정의서에  home_location_name 으로 되어 있음
		String apiId = "homelocation";

		dynamic response = await RestApi.doPostWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return null;
		} else {
      if(!IS_SERVER_MODE) return _NEW_LOCATION_ID++;
			final homeLocation = UserHomeModelHomelocations.fromJson(response);
			print("doCreateLocation homeLocation.id : ${homeLocation.id}");
			return homeLocation.id; // 추가된 locationId 를 리턴한다.
		}
	}

	/// 공간 정보 수정
	Future<bool> doChangeLocation(BuildContext context, dynamic locationId, String locationName) async{
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		var requestBody = {"location_name": locationName};   // spec 에는 home_location_name 으로 되어 있음.
		String apiId = "homelocation/$locationId";

		dynamic response = await RestApi.doPutWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return null;
		} else {
			return true;
		}
	}

	/// 공간 삭제
	Future<bool> doDeleteLocation(BuildContext context, dynamic locationId) async{
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		var requestBody = {};
		String apiId = "homelocation/$locationId/delete";

		dynamic response = await RestApi.doPostWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return false;
		} else {
			return true;
		}
	}

	
 	// ignore: non_constant_identifier_names
	dynamic _ROUTINE_ID = 1;
 	// ignore: non_constant_identifier_names
	dynamic _ROUTINE_DEVICE_ID = 1;

	/// 루틴 생성 
	Future<dynamic> doCreateRoutine(BuildContext context, String routineName) async{  //, List < RoutineModel > routines

		if(!IS_SERVER_MODE) return _ROUTINE_ID++;

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		var requestBody = {"routine_name": routineName};  //routine_name  이 맞음  api 정의서에  home_routine_name 으로 되어 있음
		String apiId = "routine";

		dynamic response = await RestApi.doPostWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return null;
		} else {
			final homeRoutine = RoutineModel.fromJson(response);
			print("doCreateRoutine homeRoutine.id : ${homeRoutine.id}");
			return homeRoutine.id; // 추가된 routineId 를 리턴한다.
		}
	}


	/// 루틴 정보 수정
	Future<bool> doChangeRoutine(BuildContext context, dynamic routineId, String routineName) async{
		if(!IS_SERVER_MODE) return true;

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		var requestBody = {"routine_id": routineId, "routine_name": routineName};
		String apiId = "routine";

		dynamic response = await RestApi.doPutWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return null;
		} else {
			return true;
		}
	}

	/// 루틴 삭제
	Future<bool> doDeleteRoutine(BuildContext context, dynamic routineId) async{
		if(!IS_SERVER_MODE) return true;

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "routine/$routineId";

		dynamic response = await RestApi.doDeleteWithUser(apiId, _user);
		if(response is bool && !response){  // 실패 시 
			return false;
		} else {
			return true;
		}
	}

	/// 루틴 실행
	Future<bool> doExecuteRoutine(BuildContext context, dynamic routineId) async{
		if(!IS_SERVER_MODE) return true;

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		var requestBody = {};
		String apiId = "routine/execute/$routineId";

		dynamic response = await RestApi.doPutWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return false;
		} else {
			return true;
		}
	}


	/// 루틴 기기 추가
	/// 추가의 경우 추가된 routineDeviceId 를 리턴한다.
	/// deviceId는 int id
	Future<dynamic> doAddRoutineDevice(BuildContext context, dynamic routineId, dynamic deviceId) async{
		if(!IS_SERVER_MODE){
			return _ROUTINE_DEVICE_ID++;
		}

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		var requestBody = {"routine_id": routineId, "home_device_id": deviceId, "traits":{"commandList":[]}};
		String apiId = "routineDevice";
		dynamic response = await RestApi.doPostWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return null;
		} else {
			// Response 는 추가된 루틴 정보를 리턴한다. 단 배열로 하나만 들어옴

			final homeRoutine = response.cast<Map<String, dynamic>>();
			final List<RoutineModel> routineList = homeRoutine.map<RoutineModel>((json) => RoutineModel.fromJson(json)).toList();
			if(routineList.length > 0){
				dynamic  routineDeviceId = routineList[0].devices[routineList[0].devices.length-1].id;
				print("doAddRoutineDevice routineDeviceId : $routineDeviceId");
				return routineDeviceId;
			}else{
				return null;
			}
		}
	}

	/// 루틴 기기 삭제 
	/// routineDeviceId 는 루틴 별 별도 디바이스 아이디 임 (int)
	Future<dynamic> doRemoveRoutineDevice(BuildContext context, dynamic routineDeviceId) async{
		if(!IS_SERVER_MODE){
			return true;
		}
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "routineDevice/$routineDeviceId";
		return await RestApi.doDeleteWithUser(apiId, _user);
	}

	
	/// 루틴 기기 설정 정보 수정
	/// routineDeviceId - int
	Future<bool> doChangeRoutineDevice(BuildContext context, dynamic routineDeviceId, dynamic traits) async{
		if(!IS_SERVER_MODE){
			return true;
		}
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		var requestBody = {"traits" : traits};
		String apiId = "routineTraits/$routineDeviceId";
		dynamic response = await RestApi.doPostWithUser(apiId, _user, requestBody);
		if(response is bool && !response){  // 실패 시 
			return false;
		} else {
			return true;
		}
	}


	/// context 와 디바이스의 변경된 정보를 받아 상태를 변경한다.
	void setDeviceChangedStatus(BuildContext context, String deviceId, String command, String value){
		BlocProvider.of<UserHomeBloc>(context).add(StatusChangedEvent(deviceId: deviceId, statusName: command, statusValue: value ));
	}


	dynamic getCommandName(String deviceTypeCode, String command){
		//print("ConfigService.getCommandName  deviceTypeCode : $deviceTypeCode   command : $command");
		String commandName = "";
		List<dynamic> commandList = UICommon.deviceTypeCommands[deviceTypeCode];
		int idx = commandList.indexWhere((commandInfo) => commandInfo["command"] == command);
		if(idx != -1){
			commandName =commandList[idx]["name"];
		}

		// for(var commandInfo in commandList){
		// 	if(commandInfo["command"] == command){
		// 		commandName = commandInfo["name"];
		// 		break;
		// 	}
		// }
		return commandName;
	}

	dynamic getCommandValueLabel(String deviceTypeCode, String command, String value){
		//print("ConfigService.getCommandName  deviceTypeCode : $deviceTypeCode   command : $command     value :  $value");
		String valueLabel = value;
		try{
		List<dynamic> commandList = UICommon.deviceTypeCommands[deviceTypeCode];
		int idx = commandList.indexWhere((commandInfo) => commandInfo["command"] == command);
		if(idx != -1){
			List<dynamic> valueList = commandList[idx]["values"];
			int vIdx = valueList.indexWhere((valueInfo) => valueInfo["value"] == value);
			if(vIdx != -1){
				valueLabel = valueList[vIdx]["label"];
			}
		}
		if(command == "setTemperature") valueLabel += "˚c";  //온도는 ˚c 표시
		}catch(e){
			print(e);
		}
		//print("ConfigService.getCommandName  valueLabel : $valueLabel");
		return valueLabel;
	}

}