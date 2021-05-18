import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
// import 'package:flutter_session/flutter_session.dart';
import '../common/globals.dart';
import '../model/favorite_model.dart';
import '../model/routine_devices_model.dart';
import '../model/village_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/device_type_devices_model.dart';
import '../model/location_devices_model.dart';
import '../model/user_home_model.dart';
import 'user_service.dart';
import '../common/rest_api.dart';


class HomeService {

	/*
	 * 홈넷 사용자 정보로 홈넷 Sync 정보 (기기 정보 등)를 가져온다.
	 */
	Future < dynamic > syncHomeNet(User _user) async {
		String apiId = "sync";
		Map < String, String > body = {
			"username": _user.homeNetUserId,
			"password": _user.homeNetUserPassword,
			"siteId": _user.siteId,
			"dong": _user.dong,
			"ho": _user.ho,
		};
		return RestApi.doPostWithUser(apiId, _user, body);
	}

	/// 사용자의 홈화면 정보를 가져온다.
	Future < dynamic > getHomeInfo(User _user) async {
		String apiId = "home";
		return RestApi.doGetWithUser(apiId, _user);
	}


	/// 사용자의 홈화면 정보를 가져온다. (Bloc 사용을 위한 추가 함수)
	Future < UserHomeModel > getHomeModel(User _user) async{
		if(!IS_SERVER_MODE){
			String jsonStr = await rootBundle.loadString("assets/sample_data/user_home.json");
			print("getHomeModel sample data json : $jsonStr");
			return UserHomeModel.fromJson(json.decode(jsonStr));
		}

		String apiId = "home";
		dynamic homeData = await RestApi.doGetWithUser(apiId, _user);
		if (!(homeData is bool) && homeData != null) {
			final userHomeModel = UserHomeModel.fromJson(homeData);
			final favoriteModel = await getFavorite(_user);

			// 즐겨찾기 정보 설정 
			if(userHomeModel != null && favoriteModel != null){
				for(var homeDevice in userHomeModel.homedevices){
					homeDevice.isFavorite = "no";
					for(var favoriteDevice in favoriteModel.favorites){
						if(homeDevice.deviceId == favoriteDevice.homedevice.deviceId){
							homeDevice.isFavorite = "yes";
							break;
						}
					}
				}
			}
			return userHomeModel;
		}else{
			return null;
		}
	}

	/// 사용자의 즐겨찾기 기기정보를  서버로 부터 가져온다.
	Future < FavoriteModel > getFavorite(User _user) async{
		String apiId = "favorite";
		dynamic favoriteData = await RestApi.doGetWithUser(apiId, _user);
		if (!(favoriteData is bool) && favoriteData != null) {
			return FavoriteModel.fromJson(favoriteData);
		}else{
			return null;
		}
	}

	/// 즐겨찾기 기기 목록 조회 - userHomeModel 에 있는  isFavorite 정보 
	List< UserHomeDevices > getFavoriteDevices(UserHomeModel userHomeModel ){
		List < UserHomeDevices > favoriteDevices = [];
		for(var homeDevice in userHomeModel.homedevices){
			if(homeDevice.isFavorite == "yes"){  // yes /no 
				favoriteDevices.add(homeDevice);
			}
		}
		return favoriteDevices;
	}

	/// 공간 별 기기 정보 - UserHomeModel 에 있는 homelocations 로 공간 정보 추출
	Future< List < LocationModel >> getLocationDevices(UserHomeModel userHomeModel ) async{

		//LocationDevicesModel locationDevicesModel = new LocationDevicesModel();
		List < LocationModel > locationDevices = [];

		for (UserHomeModelHomelocations location in userHomeModel.homelocations) {

			LocationModel newLocation = new LocationModel();
			newLocation.locationId = location.id;
			newLocation.locationName = location.locationName;
			newLocation.imagePath = location.imagePath;
			newLocation.devices = [];

			int deviceCnt = 0;
			for (UserHomeDevices device in userHomeModel.homedevices) {
				int deviceLocationId = device.homeLocationId;
				//print("getLocationDevices  deviceLocationId : ${deviceLocationId}  location.id : ${location.id}");
				if(deviceLocationId == location.id){
					newLocation.devices.add(device);
					deviceCnt++;
				}
			}
			newLocation.deviceCnt = deviceCnt;
			locationDevices.add(newLocation);
		}

		// 기타 공간 설정 (공간이 설정되지 않는 기기들은 기타 공간에 넣는다.)
		LocationModel newLocation = new LocationModel();
		newLocation.locationId = -1;  // 기타의  locationId : -1
		newLocation.locationName = "기타";
		newLocation.imagePath = "";
		newLocation.devices = [];
		newLocation.deviceCnt = 0;
		int deviceCnt = 0;
		for  (UserHomeDevices device in userHomeModel.homedevices) {
			int deviceLocationId = device.homeLocationId;
			if(deviceLocationId == null){
				newLocation.devices.add(device);
				deviceCnt++;
			}
		}
		if(deviceCnt > 0){
			newLocation.deviceCnt = deviceCnt;
			locationDevices.add(newLocation);
		}
		//print("locationDevices : ${json.encode(locationDevices)}");
		return locationDevices;
	}


	/// 공간 별 기기 정보 - 서버 조회
	Future <List < LocationModel >> getLocationDevicesFromServer(UserHomeModel userHomeModel ) async {
		if(!IS_SERVER_MODE){
			return getLocationDevices(userHomeModel);
		}

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		
		String apiId = "homelocation";
		dynamic response = await RestApi.doGetWithUser(apiId, _user);

		List<LocationsServerModel> serverLocations = (response as List).map((data) => LocationsServerModel.fromJson(data)).toList();

		//LocationDevicesModel locationDevicesModel = new LocationDevicesModel();
		List < LocationModel > locationDevices = [];

		for (var location in serverLocations) {
			LocationModel newLocation = new LocationModel();
			newLocation.locationId = location.id;
			newLocation.locationName = location.locationName;
			newLocation.imagePath = location.imagePath;
			newLocation.devices = [];
			newLocation.deviceCnt = 0;

			for(var serverDevice in location.homedevices){
				for (var device in userHomeModel.homedevices) {
					if(serverDevice.deviceId == device.deviceId){
						newLocation.devices.add(device);
						break;
					}
				}
			}
			newLocation.deviceCnt = newLocation.devices.length;
			locationDevices.add(newLocation);
		}


		// 기타 공간 설정 (공간이 설정되지 않는 기기들은 기타 공간에 넣는다.)
		LocationModel newLocation = new LocationModel();
		newLocation.locationId = -1;  // 기타의  locationId : -1
		newLocation.locationName = "기타";
		newLocation.imagePath = "";
		newLocation.devices = [];
		int deviceCnt = 0;
		// serverDevice 안에 해당 기기가 들어갔는지 체크한다. (serverDevice는 공간이 있는 기기 목록 임)
		for  (UserHomeDevices device in userHomeModel.homedevices) {

			// 일괄소등과 엘리베이터호출은 공간별 목록에서 제외 처리
			if(device.devicemodel.modeltype.code == "LIGHTOFF" || device.devicemodel.modeltype.code == "ELEVATOR" ){
				continue;
			}

			bool isExist = false;
			for (var location in serverLocations) {
				for(var serverDevice in location.homedevices){
					if(serverDevice.deviceId == device.deviceId){
						isExist = true;
						break;
					}
				}
			}
			if(!isExist){
				newLocation.devices.add(device);
				deviceCnt++;
			}
		}
		if(deviceCnt > 0){
			newLocation.deviceCnt = deviceCnt;
			locationDevices.add(newLocation);
		}
		//print("locationDevices : ${json.encode(locationDevices)}");
		return locationDevices;
	}


	///기기 구분 별 기기 정보 
	List < DeviceTypeModel >  getDeviceTypeDevices(UserHomeModel userHomeModel ){
		List < DeviceTypeModel > deviceTypeDevices = [];

		int deviceCnt = 0;
		for (UserHomeDevices device in userHomeModel.homedevices) {
			// 일괄소등과 엘리베이터 호출은 기기 구분별 목록에서 제외 처리
			if(device.devicemodel.modeltype.code == "LIGHTOFF" || device.devicemodel.modeltype.code == "ELEVATOR" ){
				continue;
			}

			bool isTypeExists = false;
			for(DeviceTypeModel deviceType in deviceTypeDevices){
				if(device.devicemodel.modeltype.code == deviceType.deviceTypeCode) {
					List<UserHomeDevices> existsDevices = deviceType.devices;
					existsDevices.add(device);
					deviceType.devices = existsDevices;

					deviceCnt = deviceType.deviceCnt + 1;
					deviceType.deviceCnt = deviceCnt;

					isTypeExists = true;
					break;
				}
			}
			if(!isTypeExists){
				DeviceTypeModel newDeviceType = new DeviceTypeModel();
				newDeviceType.deviceTypeId = device.devicemodel.modeltype.id;
				newDeviceType.deviceTypeCode = device.devicemodel.modeltype.code;
				newDeviceType.deviceTypeName = device.devicemodel.modeltype.codeName;
				newDeviceType.devices = [];
				newDeviceType.deviceCnt = 1;
				newDeviceType.devices.add(device);

				deviceTypeDevices.add(newDeviceType);
			}
		}
		print("deviceTypeDevices : ${json.encode(deviceTypeDevices)}");
		return deviceTypeDevices;
	}


	/// 루틴(모드) 정보 조회.
	Future < List<RoutineModel> > getRoutine() async{
		if(!IS_SERVER_MODE){
			String jsonStr = await rootBundle.loadString("assets/sample_data/routine_devices.json");
			final routineModel = json.decode(jsonStr).cast<Map<String, dynamic>>();
			return routineModel.map<RoutineModel>((json) => RoutineModel.fromJson(json)).toList();
		}

		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;

		String apiId = "routine";
		dynamic routineData = await RestApi.doGetWithUser(apiId, _user);
		if (!(routineData is bool) && routineData != null) {
			final routineModel = routineData.cast<Map<String, dynamic>>();
			return routineModel.map<RoutineModel>((json) => RoutineModel.fromJson(json)).toList();
		}else{
			return null;
		}
	}

	/// 단지 목록 조회
	Future < List<VillageModel> > getVillages(String searchValue) async{
		// 단지목록은 서버 조회만 해야됨 
		// if(!IS_SERVER_MODE){
		// 	String jsonStr = await rootBundle.loadString("assets/sample_data/villages.json");
		// 	final villageModel = json.decode(jsonStr).cast<Map<String, dynamic>>();
		// 	return villageModel.map<VillageModel>((json) => VillageModel.fromJson(json)).toList();
		// }
		SharedPreferences _prefs = await SharedPreferences.getInstance();
		String userToken = _prefs.getString("_user_token");
		User _user = new User();
		_user.userToken = userToken;

		String apiId = "villages";
		if(searchValue != null && searchValue != ""){
			apiId += "?address=$searchValue";
		}
		dynamic villageData = await RestApi.doGetWithUser(apiId, _user);
		if (!(villageData is bool) && villageData != null) {
			final villageModel = villageData.cast<Map<String, dynamic>>();
			return villageModel.map<VillageModel>((json) => VillageModel.fromJson(json)).toList();
		}else{
			return null;
		}
	}
}
