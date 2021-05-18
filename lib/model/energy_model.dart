///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class EnergyModelUsageList {
/*
{
  "period": "MONTH",
  "usage": 100.9,
  "sameAreaTypeUsage": 110.2,
  "allUsage": 110.2,
  "startDate": 1534901125,
  "endDate": 1534901125,
  "displayDate": 1534901125,
  "energyType": "ELEC"
} 
*/

  String period;
  double usage;
  double sameAreaTypeUsage;
  double allUsage;
  int startDate;
  int endDate;
  int displayDate;
  String energyType;

  EnergyModelUsageList({
    this.period,
    this.usage,
    this.sameAreaTypeUsage,
    this.allUsage,
    this.startDate,
    this.endDate,
    this.displayDate,
    this.energyType,
  });
  EnergyModelUsageList.fromJson(Map<String, dynamic> json) {
    period = json["period"]?.toString();
    usage = json["usage"]?.toDouble();
    sameAreaTypeUsage = json["sameAreaTypeUsage"]?.toDouble();
    allUsage = json["allUsage"]?.toDouble();
    startDate = json["startDate"]?.toInt();
    endDate = json["endDate"]?.toInt();
    displayDate = json["displayDate"]?.toInt();
    energyType = json["energyType"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["period"] = period;
    data["usage"] = usage;
    data["sameAreaTypeUsage"] = sameAreaTypeUsage;
    data["allUsage"] = allUsage;
    data["startDate"] = startDate;
    data["endDate"] = endDate;
    data["displayDate"] = displayDate;
    data["energyType"] = energyType;
    return data;
  }
}

class EnergyModel {
/*
{
  "usageList": [
    {
      "period": "MONTH",
      "usage": 100.9,
      "sameAreaTypeUsage": 110.2,
      "allUsage": 110.2,
      "startDate": 1534901125,
      "endDate": 1534901125,
      "displayDate": 1534901125,
      "energyType": "ELEC"
    }
  ]
} 
*/

  List<EnergyModelUsageList> usageList;

  EnergyModel({
    this.usageList,
  });
  EnergyModel.fromJson(Map<String, dynamic> json) {
  if (json["usageList"] != null) {
  var v = json["usageList"];
  var arr0 = List<EnergyModelUsageList>();
  v.forEach((v) {
  arr0.add(EnergyModelUsageList.fromJson(v));
  });
    usageList = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (usageList != null) {
      var v = usageList;
      var arr0 = List();
  v.forEach((v) {
  arr0.add(v.toJson());
  });
      data["usageList"] = arr0;
    }
    return data;
  }
}
