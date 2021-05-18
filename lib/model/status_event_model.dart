class StatusEventModel {
	/*
	{
	  "updateDate": 1524181625169,
	  "eventList": [
	    {
	      "command": "power",
	      "value": "off"
	    }
	  ],
	  "deviceId": "123"
	} 
	*/

	int updateDate;
	List < StatusEventList > eventList;
	String deviceId;

	StatusEventModel({
		this.updateDate,
		this.eventList,
		this.deviceId,
	});
	StatusEventModel.fromJson(Map < String, dynamic > json) {
		updateDate = json["updateDate"] ?.toInt();
		if (json["eventList"] != null) {
			var v = json["eventList"];
			var arr0 = List < StatusEventList > ();
			v.forEach((v) {
				arr0.add(StatusEventList.fromJson(v));
			});
			eventList = arr0;
		}
		deviceId = json["deviceId"] ?.toString();
	}
	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["updateDate"] = updateDate;
		if (eventList != null) {
			var v = eventList;
			var arr0 = List();
			v.forEach((v) {
				arr0.add(v.toJson());
			});
			data["eventList"] = arr0;
		}
		data["deviceId"] = deviceId;
		return data;
	}
}


class StatusEventList {
	/*
	{
	  "command": "power",
	  "value": "off"
	} 
	*/

	String command;
	String value;

	StatusEventList({
		this.command,
		this.value,
	});
	StatusEventList.fromJson(Map < String, dynamic > json) {
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

