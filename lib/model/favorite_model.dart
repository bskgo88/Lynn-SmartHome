class FavoriteModel {
	/*
	{
	  "id": 3,
	  "home_id": 122,
	  "name": "전용백",
	  "mobile": "+8200000000000",
	  "email": "myaddress@wikey.co.kr",
	  "vendor_token": "5e3c0743-9d21-473a-a03f-b4957ff12489",
	  "vendor_refresh_token": "e1f97559-7589-42de-a8a3-5fe1b9269fa9",
	  "favorites": [
	    {
	      "id": 19,
	      "user_id": 6,
	      "home_device_id": 8,
	      "homedevice": {
	        "id": 12,
	        "home_id": 122,
	        "device_id": "012711",
	        "device_model_id": 4,
	        "device_name": "주방",
	        "home_location_id": 0
	      }
	    }
	  ]
	} 
	*/

	int id;
	int homeId;
	String name;
	String mobile;
	String email;
	String vendorToken;
	String vendorRefreshToken;
	List < FavoriteFavorites > favorites;

	FavoriteModel({
		this.id,
		this.homeId,
		this.name,
		this.mobile,
		this.email,
		this.vendorToken,
		this.vendorRefreshToken,
		this.favorites,
	});
	FavoriteModel.fromJson(Map < String, dynamic > json) {
		id = json["id"] ?.toInt();
		homeId = json["home_id"] ?.toInt();
		name = json["name"] ?.toString();
		mobile = json["mobile"] ?.toString();
		email = json["email"] ?.toString();
		vendorToken = json["vendor_token"] ?.toString();
		vendorRefreshToken = json["vendor_refresh_token"] ?.toString();
		if (json["favorites"] != null) {
			var v = json["favorites"];
			var arr0 = List < FavoriteFavorites > ();
			v.forEach((v) {
				arr0.add(FavoriteFavorites.fromJson(v));
			});
			favorites = arr0;
		}
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
		if (favorites != null) {
			var v = favorites;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["favorites"] = arr0;
		}
		return data;
	}
}




class FavoriteFavoritesHomedevice {
	/*
	{
	  "id": 12,
	  "home_id": 122,
	  "device_id": "012711",
	  "device_model_id": 4,
	  "device_name": "주방",
	  "home_location_id": 0
	} 
	*/

	int id;
	int homeId;
	String deviceId;
	int deviceModelId;
	String deviceName;
	int homeLocationId;

	FavoriteFavoritesHomedevice({
		this.id,
		this.homeId,
		this.deviceId,
		this.deviceModelId,
		this.deviceName,
		this.homeLocationId,
	});
	FavoriteFavoritesHomedevice.fromJson(Map < String, dynamic > json) {
		id = json["id"] ?.toInt();
		homeId = json["home_id"] ?.toInt();
		deviceId = json["device_id"] ?.toString();
		deviceModelId = json["device_model_id"] ?.toInt();
		deviceName = json["device_name"] ?.toString();
		homeLocationId = json["home_location_id"] ?.toInt();
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["home_id"] = homeId;
		data["device_id"] = deviceId;
		data["device_model_id"] = deviceModelId;
		data["device_name"] = deviceName;
		data["home_location_id"] = homeLocationId;
		return data;
	}
}

class FavoriteFavorites {
	/*
	{
	  "id": 19,
	  "user_id": 6,
	  "home_device_id": 8,
	  "homedevice": {
	    "id": 12,
	    "home_id": 122,
	    "device_id": "012711",
	    "device_model_id": 4,
	    "device_name": "주방",
	    "home_location_id": 0
	  }
	} 
	*/

	int id;
	int userId;
	int homeDeviceId;
	FavoriteFavoritesHomedevice homedevice;

	FavoriteFavorites({
		this.id,
		this.userId,
		this.homeDeviceId,
		this.homedevice,
	});
	FavoriteFavorites.fromJson(Map < String, dynamic > json) {
		id = json["id"] ?.toInt();
		userId = json["user_id"] ?.toInt();
		homeDeviceId = json["home_device_id"] ?.toInt();
		homedevice = json["homedevice"] != null ? FavoriteFavoritesHomedevice.fromJson(json["homedevice"]) : null;
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["id"] = id;
		data["user_id"] = userId;
		data["home_device_id"] = homeDeviceId;
		if (homedevice != null) {
			data["homedevice"] = homedevice.toJson();
		}
		return data;
	}
}

