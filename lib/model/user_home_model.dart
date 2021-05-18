import 'device_type_devices_model.dart';
import 'location_devices_model.dart';
import 'routine_devices_model.dart';

class UserHomeModel {
	/*
	{
	  "id": 122,
	  "village_id": 3,
	  "dong_no": "101",
	  "ho_no": "101",
	  "createdAt": "2020-09-23T07:21:55.663Z",
	  "updatedAt": "2020-09-23T07:21:55.663Z",
	  "village": {
	    "id": 3,
	    "village_name": "woomi lynn iot test 단지",
	    "address": "경기도 모처",
	    "homenet_id": 0,
	    "site_id": "572",
	    "createdAt": "2020-09-23T07:21:27.855Z",
	    "updatedAt": "2020-09-23T07:21:27.855Z"
	  },
	  "homedevices": [
	    {
	      "id": 12,
	      "home_id": 122,
	      "device_id": "012711",
	      "device_model_id": 4,
	      "device_name": "주방",
	      "home_location_id": null,
	      "createdAt": "2020-09-23T10:53:06.861Z"
	    }
	  ],
	  "users": [
	    {
	      "id": 3,
	      "home_id": 122,
	      "name": "전용백",
	      "mobile": "+8201047536703",
	      "email": "yong100@wikey.co.kr",
	      "vendor_token": "2c72554d-2236-4b33-99f4-1d5f0b10f3e3",
	      "vendor_refresh_token": "e1f97559-7589-42de-a8a3-5fe1b9269fa9",
	      "createdAt": "2020-09-22T12:05:54.279Z",
	      "updatedAt": "2020-09-28T02:37:07.234Z"
	    }
	  ],
	  "homelocations": [
        {
            "id": 6,
            "home_id": 122,
            "location_name": "거실",
            "image_path": null,
            "createdAt": "2020-10-08T07:12:04.796Z",
            "updatedAt": "2020-10-08T07:12:04.796Z"
        }
	  ]
	} 
	*/

	int id;
	int villageId;
	String dongNo;
	String hoNo;
	String createdAt;
	String updatedAt;
	UserHomeModelVillage village;
	List < UserHomeDevices > homedevices;
	List < UserHomeModelUsers > users;
	List < UserHomeModelHomelocations > homelocations;

	List < UserHomeDevices > favoriteDevices;  // 별도 로직으로 즐겨찾기 기기 목록 설정
	List < LocationModel > locations;  // 별도 로직으로 공간별로 기기를 분류한 모델 
	List < DeviceTypeModel > deviceTypes;  // 별도 로직으로 기기 구분별로 
	List < RoutineModel > routines;  // 별도 로직으로 설정 한 루틴 목록

	UserHomeModel({
		this.id,
		this.villageId,
		this.dongNo,
		this.hoNo,
		this.createdAt,
		this.updatedAt,
		this.village,
		this.homedevices,
		this.users,
		this.homelocations,
	});
	UserHomeModel.fromJson(Map < String, dynamic > json) {
		id = json["id"];
		villageId = json["village_id"];
		dongNo = json["dong_no"];
		hoNo = json["ho_no"];
		createdAt = json["createdAt"];
		updatedAt = json["updatedAt"];
		village = json["village"] != null ? UserHomeModelVillage.fromJson(json["village"]) : null;
		if (json["homedevices"] != null) {
			var v = json["homedevices"];
			var arr0 = List < UserHomeDevices > ();
			v.forEach((v) {
				arr0.add(UserHomeDevices.fromJson(v));
			});
			homedevices = arr0;
		}
		if (json["users"] != null) {
			var v = json["users"];
			var arr0 = List < UserHomeModelUsers > ();
			v.forEach((v) {
				arr0.add(UserHomeModelUsers.fromJson(v));
			});
			users = arr0;
		}
		if (json["homelocations"] != null) {
			var v = json["homelocations"];
			var arr0 = List < UserHomeModelHomelocations > ();
			v.forEach((v) {
				arr0.add(UserHomeModelHomelocations.fromJson(v));
			});
			homelocations = arr0;
		}
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["village_id"] = villageId;
		data["dong_no"] = dongNo;
		data["ho_no"] = hoNo;
		data["createdAt"] = createdAt;
		data["updatedAt"] = updatedAt;
		if (village != null) {
			data["village"] = village.toJson();
		}
		if (homedevices != null) {
			var v = homedevices;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["homedevices"] = arr0;
		}
		if (users != null) {
			var v = users;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["users"] = arr0;
		}

		if (homelocations != null) {
			var v = homelocations;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["homelocations"] = arr0;
		}
		return data;
	}
}


class UserHomeDevices {
	/*
	{
	  "id": 8,
	  "home_id": 122,
	  "device_id": "012411",
	  "device_model_id": 3,
	  "device_name": "거실 전등 1",
	  "home_location_id": 6,
	  "createdAt": "2020-09-23T10:53:06.702Z",
	  "updatedAt": "2020-10-08T07:32:19.729Z",
	  "devicemodel": {
	    "id": 3,
	    "model_name": "현대통신 난방",
	    "max_temperature": null,
	    "min_temperature": null,
	    "model_type_code_id": 9,
	    "air_volume_id": null,
	    "operation_mode_id": null,
	    "createdAt": "2020-09-23T10:14:41.033Z",
	    "updatedAt": "2020-09-23T10:14:49.681Z",
	    "modeltype": {
	      "id": 9,
	      "code": "heating",
	      "code_name": "난방",
	      "use_yn": "Y",
	      "parent_id": 6,
	      "createdAt": "2020-09-22T12:05:54.147Z",
	      "updatedAt": "2020-09-23T04:10:54.739Z"
	    }
	  },
		"statusList": [{
				"power": "off"
			},
			{
				"currTemperature": 25
			}
		]
	} 
	*/

	int id;
	int homeId;
	String deviceId;
	int deviceModelId;
	String deviceName;
	int homeLocationId;
	String createdAt;
	String updatedAt;
	String deviceStatus;
	HomeDevicesDevicemodel devicemodel;
	List < UserHomeDevicesStatusModel > statusList;
	String power;
	String fire;
	String currTemperature;
	String setTemperature;
	String gasSwitch;
	String level;
	String mode;
	String wind;
	String sleep;
	String openclose;
	String gasDetection;
	String fireDetection;
	String light;
	String gas;
	String isFavorite;


	UserHomeDevices({
		this.id,
		this.homeId,
		this.deviceId,
		this.deviceModelId,
		this.deviceName,
		this.homeLocationId,
		this.createdAt,
		this.updatedAt,
		this.devicemodel,
		this.power,
		this.fire,
		this.currTemperature,
		this.setTemperature,
		this.gasSwitch,
		this.level,
		this.mode,
		this.wind,
		this.sleep,
		this.openclose,
		this.gasDetection,
		this.fireDetection,
		this.light,
		this.gas,
		this.statusList,
		this.isFavorite  // 즐겨찾기 여부 ( 쉽게 조회할 수 있도록 추가)  yes / no  로 설정
	});
	UserHomeDevices.fromJson(Map < String, dynamic > json) {
		id = json["id"];
		homeId = json["home_id"];
		deviceId = json["device_id"];
		deviceModelId = json["device_model_id"];
		deviceName = json["device_name"];
		homeLocationId = json["home_location_id"];
		createdAt = json["createdAt"];
		updatedAt = json["updatedAt"];
		devicemodel = json["devicemodel"] != null ? HomeDevicesDevicemodel.fromJson(json["devicemodel"]) : null;
		deviceStatus = json["device_status"];
		if (json["statusList"] != null) {
			var v = json["statusList"];
			var arr0 = List < UserHomeDevicesStatusModel > ();
			//print("****************************  statusList : $deviceName   length  ${v.length} ");
			v.forEach((v) {
				arr0.add(UserHomeDevicesStatusModel.fromJson(v));
				/// 배열로 된 status 정보를 attribute 로 설정 한다.
				final status = UserHomeDevicesStatusModel.fromJson(v);
				//print("****************************  UserHomeDevicesStatusList : ${status.command}  ${status.value} ");
				if(status.command == 'power') power = status.value;
				else if(status.command == 'fire') fire = status.value;
				else if(status.command == 'currTemperature') currTemperature = status.value;
				else if(status.command == 'setTemperature') setTemperature = status.value;
				else if(status.command == 'switch') gasSwitch = status.value;
				else if(status.command == 'level') level = status.value;
				else if(status.command == 'mode') mode = status.value;
				else if(status.command == 'wind') wind = status.value;
				else if(status.command == 'sleep') sleep = status.value;
				else if(status.command == 'openclose') openclose = status.value;
				else if(status.command == 'gasDetection') gasDetection = status.value;
				else if(status.command == 'fireDetection') fireDetection = status.value;
				else if(status.command == 'light') light = status.value;
				else if(status.command == 'gas') gas = status.value;
				//reservationType??
			});
			statusList = arr0;
		}
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["home_id"] = homeId;
		data["device_id"] = deviceId;
		data["device_model_id"] = deviceModelId;
		data["device_name"] = deviceName;
		data["home_location_id"] = homeLocationId;
		data["createdAt"] = createdAt;
		data["updatedAt"] = updatedAt;
		if (devicemodel != null) {
			data["devicemodel"] = devicemodel.toJson();
		}
		///statusList 는 배열에 있는 값을 모델의 Attribute 로 전환하여 값을 설정 
		if (statusList != null) {
			var v = statusList;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
				if(v.command == 'power') data['power'] = v.value;
				else if(v.command == 'fire') data['fire'] = v.value;
				else if(v.command == 'currTemperature') data['currTemperature'] = v.value;
				else if(v.command == 'setTemperature') data['setTemperature'] = v.value;
				else if(v.command == 'switch') data['switch'] = v.value;
				else if(v.command == 'level') data['level'] = v.value;
				else if(v.command == 'mode') data['mode'] = v.value;
				else if(v.command == 'wind') data['wind'] = v.value;
				else if(v.command == 'sleep') data['sleep'] = v.value;
				else if(v.command == 'openclose') data['openclose'] = v.value;
				else if(v.command == 'gasDetection') data['gasDetection'] = v.value;
				else if(v.command == 'fireDetection') data['fireDetection'] = v.value;
				else if(v.command == 'light') data['light'] = v.value;
				else if(v.command == 'gas') data['gas'] = v.value;
			});
			data["statusList"] = arr0;
		}
		return data;
	}
}


class HomeDevicesDevicemodel {
	/*
	{
	  "id": 3,
	  "model_name": "현대통신 난방",
	  "max_temperature": null,
	  "min_temperature": null,
	  "model_type_code_id": 9,
	  "air_volume_id": null,
	  "operation_mode_id": null,
	  "createdAt": "2020-09-23T10:14:41.033Z",
	  "updatedAt": "2020-09-23T10:14:49.681Z",
	  "modeltype": {
	    "id": 9,
	    "code": "heating",
	    "code_name": "난방",
	    "use_yn": "Y",
	    "parent_id": 6,
	    "createdAt": "2020-09-22T12:05:54.147Z",
	    "updatedAt": "2020-09-23T04:10:54.739Z"
	  }
	} 
	*/

	int id;
	String modelName;
	String maxTemperature;
	String minTemperature;
	int modelTypeCodeId;
	String airVolumeId;
	String operationModeId;
	String createdAt;
	String updatedAt;
	HomeDevicesDevicemodelModeltype modeltype;

	HomeDevicesDevicemodel({
		this.id,
		this.modelName,
		this.maxTemperature,
		this.minTemperature,
		this.modelTypeCodeId,
		this.airVolumeId,
		this.operationModeId,
		this.createdAt,
		this.updatedAt,
		this.modeltype,
	});
	HomeDevicesDevicemodel.fromJson(Map < String, dynamic > json) {
		id = json["id"];
		modelName = json["model_name"];
		maxTemperature = json["max_temperature"];
		minTemperature = json["min_temperature"];
		modelTypeCodeId = json["model_type_code_id"];
		airVolumeId = json["air_volume_id"];
		operationModeId = json["operation_mode_id"];
		createdAt = json["createdAt"];
		updatedAt = json["updatedAt"];
		modeltype = json["modeltype"] != null ? HomeDevicesDevicemodelModeltype.fromJson(json["modeltype"]) : null;
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["model_name"] = modelName;
		data["max_temperature"] = maxTemperature;
		data["min_temperature"] = minTemperature;
		data["model_type_code_id"] = modelTypeCodeId;
		data["air_volume_id"] = airVolumeId;
		data["operation_mode_id"] = operationModeId;
		data["createdAt"] = createdAt;
		data["updatedAt"] = updatedAt;
		if (modeltype != null) {
			data["modeltype"] = modeltype.toJson();
		}
		return data;
	}
}


class HomeDevicesDevicemodelModeltype {
	/*
	{
	  "id": 9,
	  "code": "heating",
	  "code_name": "난방",
	  "use_yn": "Y",
	  "parent_id": 6,
	  "createdAt": "2020-09-22T12:05:54.147Z",
	  "updatedAt": "2020-09-23T04:10:54.739Z"
	} 
	*/

	int id;
	String code;
	String codeName;
	String useYn;
	int parentId;
	String createdAt;
	String updatedAt;

	HomeDevicesDevicemodelModeltype({
		this.id,
		this.code,
		this.codeName,
		this.useYn,
		this.parentId,
		this.createdAt,
		this.updatedAt,
	});
	HomeDevicesDevicemodelModeltype.fromJson(Map < String, dynamic > json) {
		id = json["id"];
		code = json["code"];
		codeName = json["code_name"];
		useYn = json["use_yn"];
		parentId = json["parent_id"];
		createdAt = json["createdAt"];
		updatedAt = json["updatedAt"];
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["code"] = code;
		data["code_name"] = codeName;
		data["use_yn"] = useYn;
		data["parent_id"] = parentId;
		data["createdAt"] = createdAt;
		data["updatedAt"] = updatedAt;
		return data;
	}
}



class UserHomeDevicesStatusModel {
/*
{
"command": "power",
"value": "off"
}
*/

	String command;
	String value;

	UserHomeDevicesStatusModel({
		this.command,
		this.value,
	});
	UserHomeDevicesStatusModel.fromJson(Map < String, dynamic > json) {
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



class UserHomeModelVillage {
	/*
	{
	  "id": 3,
	  "village_name": "woomi lynn iot test 단지",
	  "address": "경기도 모처",
	  "homenet_id": 0,
	  "site_id": "572",
	  "createdAt": "2020-09-23T07:21:27.855Z",
	  "updatedAt": "2020-09-23T07:21:27.855Z"
	} 
	*/

	int id;
	String villageName;
	String address;
	int homenetId;
	String siteId;
	String createdAt;
	String updatedAt;
	List<UserHomeModelVillageDevicemodels> devicemodels;
	List<UserHomeModelVillageEmstypes> emstypes;

	UserHomeModelVillage({
		this.id,
		this.villageName,
		this.address,
		this.homenetId,
		this.siteId,
		this.createdAt,
		this.updatedAt,
		this.devicemodels,
		this.emstypes,
	});

	/*
	UserHomeModelVillage.fromJson(Map < String, dynamic > json) {
		id = json["id"];
		villageName = json["village_name"];
		address = json["address"];
		homenetId = json["homenet_id"];
		siteId = json["site_id"];
		createdAt = json["createdAt"];
		updatedAt = json["updatedAt"];
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["village_name"] = villageName;
		data["address"] = address;
		data["homenet_id"] = homenetId;
		data["site_id"] = siteId;
		data["createdAt"] = createdAt;
		data["updatedAt"] = updatedAt;
		return data;
	}
	*/


	UserHomeModelVillage.fromJson(Map < String, dynamic > json) {
		id = json["id"] ?.toInt();
		villageName = json["village_name"] ?.toString();
		address = json["address"] ?.toString();
		homenetId = json["homenet_id"] ?.toInt();
		siteId = json["site_id"] ?.toString();
		createdAt = json["createdAt"] ?.toString();
		updatedAt = json["updatedAt"] ?.toString();
		if (json["devicemodels"] != null) {
			var v = json["devicemodels"];
			var arr0 = List < UserHomeModelVillageDevicemodels > ();
			v.forEach((v) {
				arr0.add(UserHomeModelVillageDevicemodels.fromJson(v));
			});
			devicemodels = arr0;
		}
		if (json["emstypes"] != null) {
			var v = json["emstypes"];
			var arr0 = List < UserHomeModelVillageEmstypes > ();
			v.forEach((v) {
				arr0.add(UserHomeModelVillageEmstypes.fromJson(v));
			});
			emstypes = arr0;
		}
	}

	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["village_name"] = villageName;
		data["address"] = address;
		data["homenet_id"] = homenetId;
		data["site_id"] = siteId;
		data["createdAt"] = createdAt;
		data["updatedAt"] = updatedAt;
		if (devicemodels != null) {
			var v = devicemodels;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["devicemodels"] = arr0;
		}
		if (emstypes != null) {
			var v = emstypes;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["emstypes"] = arr0;
		}
		return data;
	}
}



class UserHomeModelUsers {
	/*
	{
	  "id": 3,
	  "home_id": 122,
	  "name": "전용백",
	  "mobile": "+8201047536703",
	  "email": "yong100@wikey.co.kr",
	  "vendor_token": "2c72554d-2236-4b33-99f4-1d5f0b10f3e3",
	  "vendor_refresh_token": "e1f97559-7589-42de-a8a3-5fe1b9269fa9",
	  "createdAt": "2020-09-22T12:05:54.279Z",
	  "updatedAt": "2020-09-28T02:37:07.234Z"
	} 
	*/

	int id;
	int homeId;
	String name;
	String mobile;
	String email;
	String vendorToken;
	String vendorRefreshToken;
	String createdAt;
	String updatedAt;
	String adminYn;
	String picture;
	String fcmToken;


	UserHomeModelUsers({
		this.id,
		this.homeId,
		this.name,
		this.mobile,
		this.email,
		this.vendorToken,
		this.vendorRefreshToken,
		this.createdAt,
		this.updatedAt,
		this.adminYn,
		this.picture,
		this.fcmToken,
	});
	UserHomeModelUsers.fromJson(Map < String, dynamic > json) {
		id = json["id"];
		homeId = json["home_id"];
		name = json["name"];
		mobile = json["mobile"];
		email = json["email"];
		vendorToken = json["vendor_token"];
		vendorRefreshToken = json["vendor_refresh_token"];
		createdAt = json["createdAt"];
		updatedAt = json["updatedAt"];
		adminYn = json["adminYn"];
		picture = json["picture"];
		fcmToken = json["fcm_token"];
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["home_id"] = homeId;
		data["name"] = name;
		data["mobile"] = mobile;
		data["email"] = email;
		data["vendor_token"] = vendorToken;
		data["vendor_refresh_token"] = vendorRefreshToken;
		data["createdAt"] = createdAt;
		data["updatedAt"] = updatedAt;
		data["adminYn"] = adminYn;
		data["picture"] = picture;
		data["fcm_token"] = fcmToken;
		return data;
	}
}



class UserHomeModelHomelocations {
	/*
	{
		"id": 6,
		"home_id": 122,
		"location_name": "거실",
		"image_path": null,
		"createdAt": "2020-10-08T07:12:04.796Z",
		"updatedAt": "2020-10-08T07:12:04.796Z"
	} 
	*/

	int id;
	int homeId;
	String locationName;
	String imagePath;
	String createdAt;

	UserHomeModelHomelocations({
		this.id,
		this.homeId,
		this.locationName,
		this.imagePath,
		this.createdAt,
	});
	UserHomeModelHomelocations.fromJson(Map < String, dynamic > json) {
		id = json["id"];
		homeId = json["home_id"];
		locationName = json["location_name"];
		imagePath = json["image_path"];
		createdAt = json["createdAt"];
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["home_id"] = homeId;
		data["location_name"] = locationName;
		data["image_path"] = imagePath;
		data["createdAt"] = createdAt;
		return data;
	}
}







class UserHomeModelVillageEmstypesEms {
/*
{
  "id": 21,
  "code": "ELEC",
  "code_name": "전기",
  "use_yn": "Y",
  "parent_id": 20,
  "createdAt": "2020-10-06T04:41:26.839Z",
  "updatedAt": "2020-10-06T04:41:45.844Z"
} 
*/

  int id;
  String code;
  String codeName;
  String useYn;
  int parentId;
  String createdAt;
  String updatedAt;

  UserHomeModelVillageEmstypesEms({
    this.id,
    this.code,
    this.codeName,
    this.useYn,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });
  UserHomeModelVillageEmstypesEms.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    code = json["code"]?.toString();
    codeName = json["code_name"]?.toString();
    useYn = json["use_yn"]?.toString();
    parentId = json["parent_id"]?.toInt();
    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["code"] = code;
    data["code_name"] = codeName;
    data["use_yn"] = useYn;
    data["parent_id"] = parentId;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    return data;
  }
}

class UserHomeModelVillageEmstypes {
/*
{
  "id": 1,
  "village_id": 4,
  "ems_id": 21,
  "createdAt": "2020-11-25T13:24:59.791Z",
  "updatedAt": "2020-11-25T13:24:59.805Z",
  "ems": {
    "id": 21,
    "code": "ELEC",
    "code_name": "전기",
    "use_yn": "Y",
    "parent_id": 20,
    "createdAt": "2020-10-06T04:41:26.839Z",
    "updatedAt": "2020-10-06T04:41:45.844Z"
  }
} 
*/

  int id;
  int villageId;
  int emsId;
  String createdAt;
  String updatedAt;
  UserHomeModelVillageEmstypesEms ems;

  UserHomeModelVillageEmstypes({
    this.id,
    this.villageId,
    this.emsId,
    this.createdAt,
    this.updatedAt,
    this.ems,
  });
  UserHomeModelVillageEmstypes.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    villageId = json["village_id"]?.toInt();
    emsId = json["ems_id"]?.toInt();
    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
    ems = (json["ems"] != null) ? UserHomeModelVillageEmstypesEms.fromJson(json["ems"]) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["village_id"] = villageId;
    data["ems_id"] = emsId;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    if (ems != null) {
      data["ems"] = ems.toJson();
    }
    return data;
  }
}

class UserHomeModelVillageDevicemodelsDevicemodelModeltype {
/*
{
  "id": 7,
  "code": "light",
  "code_name": "일반조명",
  "use_yn": "Y",
  "parent_id": 6,
  "createdAt": "2020-09-22T12:05:54.147Z",
  "updatedAt": "2020-09-22T12:05:54.182Z"
} 
*/

  int id;
  String code;
  String codeName;
  String useYn;
  int parentId;
  String createdAt;
  String updatedAt;

  UserHomeModelVillageDevicemodelsDevicemodelModeltype({
    this.id,
    this.code,
    this.codeName,
    this.useYn,
    this.parentId,
    this.createdAt,
    this.updatedAt,
  });
  UserHomeModelVillageDevicemodelsDevicemodelModeltype.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    code = json["code"]?.toString();
    codeName = json["code_name"]?.toString();
    useYn = json["use_yn"]?.toString();
    parentId = json["parent_id"]?.toInt();
    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["code"] = code;
    data["code_name"] = codeName;
    data["use_yn"] = useYn;
    data["parent_id"] = parentId;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    return data;
  }
}

class UserHomeModelVillageDevicemodelsDevicemodel {
/*
{
  "id": 1,
  "model_name": "현대통신 조명",
  "max_temperature": null,
  "min_temperature": null,
  "model_type_code_id": 7,
  "air_volume_id": null,
  "operation_mode_id": null,
  "control_api": "lights/",
  "is_virtual_device": false,
  "default_traits": null,
  "createdAt": "2020-09-15T11:38:13.345Z",
  "updatedAt": "2020-11-04T03:35:03.097Z",
  "modeltype": {
    "id": 7,
    "code": "light",
    "code_name": "일반조명",
    "use_yn": "Y",
    "parent_id": 6,
    "createdAt": "2020-09-22T12:05:54.147Z",
    "updatedAt": "2020-09-22T12:05:54.182Z"
  }
} 
*/

  int id;
  String modelName;
  String maxTemperature;
  String minTemperature;
  int modelTypeCodeId;
  String airVolumeId;
  String operationModeId;
  String controlApi;
  bool isVirtualDevice;
  String defaultTraits;
  String createdAt;
  String updatedAt;
  UserHomeModelVillageDevicemodelsDevicemodelModeltype modeltype;

  UserHomeModelVillageDevicemodelsDevicemodel({
    this.id,
    this.modelName,
    this.maxTemperature,
    this.minTemperature,
    this.modelTypeCodeId,
    this.airVolumeId,
    this.operationModeId,
    this.controlApi,
    this.isVirtualDevice,
    this.defaultTraits,
    this.createdAt,
    this.updatedAt,
    this.modeltype,
  });
  UserHomeModelVillageDevicemodelsDevicemodel.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    modelName = json["model_name"]?.toString();
    maxTemperature = json["max_temperature"]?.toString();
    minTemperature = json["min_temperature"]?.toString();
    modelTypeCodeId = json["model_type_code_id"]?.toInt();
    airVolumeId = json["air_volume_id"]?.toString();
    operationModeId = json["operation_mode_id"]?.toString();
    controlApi = json["control_api"]?.toString();
    isVirtualDevice = json["is_virtual_device"];
    defaultTraits = json["default_traits"]?.toString();
    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
    modeltype = (json["modeltype"] != null) ? UserHomeModelVillageDevicemodelsDevicemodelModeltype.fromJson(json["modeltype"]) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["model_name"] = modelName;
    data["max_temperature"] = maxTemperature;
    data["min_temperature"] = minTemperature;
    data["model_type_code_id"] = modelTypeCodeId;
    data["air_volume_id"] = airVolumeId;
    data["operation_mode_id"] = operationModeId;
    data["control_api"] = controlApi;
    data["is_virtual_device"] = isVirtualDevice;
    data["default_traits"] = defaultTraits;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    if (modeltype != null) {
      data["modeltype"] = modeltype.toJson();
    }
    return data;
  }
}

class UserHomeModelVillageDevicemodels {
/*
{
  "id": 1,
  "village_id": 4,
  "device_model_id": 1,
  "createdAt": "2020-11-25T13:24:59.708Z",
  "updatedAt": "2020-11-25T13:24:59.729Z",
  "devicemodel": {
    "id": 1,
    "model_name": "현대통신 조명",
    "max_temperature": null,
    "min_temperature": null,
    "model_type_code_id": 7,
    "air_volume_id": null,
    "operation_mode_id": null,
    "control_api": "lights/",
    "is_virtual_device": false,
    "default_traits": null,
    "createdAt": "2020-09-15T11:38:13.345Z",
    "updatedAt": "2020-11-04T03:35:03.097Z",
    "modeltype": {
      "id": 7,
      "code": "light",
      "code_name": "일반조명",
      "use_yn": "Y",
      "parent_id": 6,
      "createdAt": "2020-09-22T12:05:54.147Z",
      "updatedAt": "2020-09-22T12:05:54.182Z"
    }
  }
} 
*/

  int id;
  int villageId;
  int deviceModelId;
  String createdAt;
  String updatedAt;
  UserHomeModelVillageDevicemodelsDevicemodel devicemodel;

  UserHomeModelVillageDevicemodels({
    this.id,
    this.villageId,
    this.deviceModelId,
    this.createdAt,
    this.updatedAt,
    this.devicemodel,
  });
  UserHomeModelVillageDevicemodels.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    villageId = json["village_id"]?.toInt();
    deviceModelId = json["device_model_id"]?.toInt();
    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
    devicemodel = (json["devicemodel"] != null) ? UserHomeModelVillageDevicemodelsDevicemodel.fromJson(json["devicemodel"]) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["village_id"] = villageId;
    data["device_model_id"] = deviceModelId;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    if (devicemodel != null) {
      data["devicemodel"] = devicemodel.toJson();
    }
    return data;
  }
}