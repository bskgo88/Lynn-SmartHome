import 'user_home_model.dart';

class LocationDevicesModel {
	/*
	{
	  "locations": [
	    {
	      "location_id": 6,
	      "location_name": "거실",
		  "device_cnt": 3,
	      "image_path": "",
	      "devices": [
	        {
	          "device_id": "012511",
	          "device_model_id": 1,
	          "device_name": "거실1",
	          "device_status": "on"
	        }
	      ]
	    }
	  ]
	} 
	*/

	List < LocationModel > locations;

	LocationDevicesModel({
		this.locations,
	});
	LocationDevicesModel.fromJson(Map < String, dynamic > json) {
		if (json["locations"] != null) {
			var v = json["locations"];
			var arr0 = List < LocationModel > ();
			v.forEach((v) {
				arr0.add(LocationModel.fromJson(v));
			});
			locations = arr0;
		}
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		if (locations != null) {
			var v = locations;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["locations"] = arr0;
		}
		return data;
	}
}



class LocationModel {
	/*
	{
	  "location_id": 6,
	  "location_name": "거실",
	  "image_path": "",
	  "devices": [
	    {
	      "device_id": "012511",
	      "device_model_id": 1,
	      "device_name": "거실1",
	      "device_status": "on"
	    }
	  ]
	} 
	*/

	int locationId;
	String locationName;
	String imagePath;
	int deviceCnt;
	List < UserHomeDevices > devices;

	LocationModel({
		this.locationId,
		this.locationName,
		this.imagePath,
		this.devices,
		this.deviceCnt,
	});
	LocationModel.fromJson(Map < String, dynamic > json) {
		locationId = json["location_id"];
		locationName = json["location_name"];
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
		data["location_id"] = locationId;
		data["location_name"] = locationName;
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







/// 서버로부터 가져온 데이타를 필요정보만 간략하게 모델로 정의   /homeloaction  API 호출 결과
class LocationsServerModel {
	/*
	{
	  "id": 6,
	  "location_name": "거실",
	  "image_path": "",
	  "homedevices": [
	    {
	      "id": 9,
	      "device_id": "012511",
	      "device_name": "거실1"
	    }
	  ]
	} 
	*/

	int id;
	String locationName;
	String imagePath;
	List < LocationsServerModelHomedevices > homedevices;

	LocationsServerModel({
		this.id,
		this.locationName,
		this.imagePath,
		this.homedevices,
	});
	LocationsServerModel.fromJson(Map < String, dynamic > json) {
		id = json["id"] ?.toInt();
		locationName = json["location_name"] ?.toString();
		imagePath = json["image_path"] ?.toString();
		if (json["homedevices"] != null) {
			var v = json["homedevices"];
			var arr0 = List < LocationsServerModelHomedevices > ();
			v.forEach((v) {
				arr0.add(LocationsServerModelHomedevices.fromJson(v));
			});
			homedevices = arr0;
		}
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["location_name"] = locationName;
		data["image_path"] = imagePath;
		if (homedevices != null) {
			var v = homedevices;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["homedevices"] = arr0;
		}
		return data;
	}
}


class LocationsServerModelHomedevices {
	/*
	{
	  "id": 9,
	  "device_id": "012511",
	  "device_name": "거실1"
	} 
	*/

	int id;
	String deviceId;
	String deviceName;

	LocationsServerModelHomedevices({
		this.id,
		this.deviceId,
		this.deviceName,
	});
	LocationsServerModelHomedevices.fromJson(Map < String, dynamic > json) {
		id = json["id"] ?.toInt();
		deviceId = json["device_id"] ?.toString();
		deviceName = json["device_name"] ?.toString();
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["device_id"] = deviceId;
		data["device_name"] = deviceName;
		return data;
	}
}


