import 'user_home_model.dart';

class DeviceTypeDevicesModel {
	/*
	{
	  "deviceType": [
	    {
	      "device_type_id": 6,
	      "device_type_name": "거실",
		  "device_cnt": 3,
	      "image_path": "",
	      "devices": [
	        {
	          "device_id": "012511",
	          "device_type_id": 1,
	          "device_name": "거실1",
	          "device_status": "on"
	        }
	      ]
	    }
	  ]
	} 
	*/

	List < DeviceTypeModel > deviceType;

	DeviceTypeDevicesModel({
		this.deviceType,
	});
	DeviceTypeDevicesModel.fromJson(Map < String, dynamic > json) {
		if (json["deviceType"] != null) {
			var v = json["deviceType"];
			var arr0 = List < DeviceTypeModel > ();
			v.forEach((v) {
				arr0.add(DeviceTypeModel.fromJson(v));
			});
			deviceType = arr0;
		}
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		if (deviceType != null) {
			var v = deviceType;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["deviceType"] = arr0;
		}
		return data;
	}
}



class DeviceTypeModel {
	/*
	{
	  "device_type_id": 6,
	  "device_type_name": "거실",
	  "image_path": "",
	  "devices": [
	    {
	      "device_id": "012511",
	      "device_type_id": 1,
	      "device_name": "거실1",
	      "device_status": "on"
	    }
	  ]
	} 
	*/

	int deviceTypeId;
	String deviceTypeCode;
	String deviceTypeName;
	String imagePath;
	int deviceCnt;
	List < UserHomeDevices > devices;

	DeviceTypeModel({
		this.deviceTypeId,
		this.deviceTypeCode,
		this.deviceTypeName,
		this.imagePath,
		this.devices,
		this.deviceCnt,
	});
	DeviceTypeModel.fromJson(Map < String, dynamic > json) {
		deviceTypeId = json["device_type_id"];
		deviceTypeCode = json["device_type_code"];
		deviceTypeName = json["device_type_name"];
		imagePath = json["image_path"];
		deviceCnt = json["device_cnt"];
		if (json["devices"] != null) {
			var v = json["devices"];
			var arr0 = List < UserHomeDevices > ();
			v.forEach((v) {
				arr0.add(UserHomeDevices.fromJson(v));
			});
			devices = arr0;
		}
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["device_type_id"] = deviceTypeId;
		data["device_type_code"] = deviceTypeCode;
		data["device_type_name"] = deviceTypeName;
		data["image_path"] = imagePath;
		data["device_cnt"] = deviceCnt;
		if (devices != null) {
			var v = devices;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["devices"] = arr0;
		}
		return data;
	}
}