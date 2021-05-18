class VillageModel {
/*
{
  "id": 1,
  "village_name": "테스트 단지 1차",
  "address": "경기도 화성시 동탄대로시범길",
  "homenet_id": 0,
  "site_id": "1",
  "createdAt": "2020-09-22T12:05:54.305Z",
  "updatedAt": "2020-09-22T12:05:54.318Z"
} 
*/

  int id;
  String villageName;
  String address;
  int homenetId;
  String siteId;
  String createdAt;
  String updatedAt;

  VillageModel({
    this.id,
    this.villageName,
    this.address,
    this.homenetId,
    this.siteId,
    this.createdAt,
    this.updatedAt,
  });
  VillageModel.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    villageName = json["village_name"]?.toString();
    address = json["address"]?.toString();
    homenetId = json["homenet_id"]?.toInt();
    siteId = json["site_id"]?.toString();
    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["village_name"] = villageName;
    data["address"] = address;
    data["homenet_id"] = homenetId;
    data["site_id"] = siteId;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    return data;
  }
}
