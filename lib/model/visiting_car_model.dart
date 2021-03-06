///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class VisitingCarModelVisitCarList {
/*
{
  "id": "1",
  "carNo": "68오4753",
  "dateTime": 1528099560000,
  "dateTimeEnd": 1528185960000
} 
*/

  String id;
  String carNo;
  int dateTime;
  int dateTimeEnd;

  VisitingCarModelVisitCarList({
    this.id,
    this.carNo,
    this.dateTime,
    this.dateTimeEnd,
  });
  VisitingCarModelVisitCarList.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    carNo = json["carNo"]?.toString();
    dateTime = json["dateTime"]?.toInt();
    dateTimeEnd = json["dateTimeEnd"]?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["carNo"] = carNo;
    data["dateTime"] = dateTime;
    data["dateTimeEnd"] = dateTimeEnd;
    return data;
  }
}

class VisitingCarModel {
/*
{
  "totalCount": 1,
  "visitCarList": [
    {
      "id": "1",
      "carNo": "68오4753",
      "dateTime": 1528099560000,
      "dateTimeEnd": 1528185960000
    }
  ]
} 
*/

  int totalCount;
  List<VisitingCarModelVisitCarList> visitCarList;

  VisitingCarModel({
    this.totalCount,
    this.visitCarList,
  });
  VisitingCarModel.fromJson(Map<String, dynamic> json) {
    totalCount = json["totalCount"]?.toInt();
  if (json["visitCarList"] != null) {
  var v = json["visitCarList"];
  var arr0 = List<VisitingCarModelVisitCarList>();
  v.forEach((v) {
  arr0.add(VisitingCarModelVisitCarList.fromJson(v));
  });
    visitCarList = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["totalCount"] = totalCount;
    if (visitCarList != null) {
      var v = visitCarList;
      var arr0 = List();
  v.forEach((v) {
  arr0.add(v.toJson());
  });
      data["visitCarList"] = arr0;
    }
    return data;
  }
}
