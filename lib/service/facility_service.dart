import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_session/flutter_session.dart';
import '../common/globals.dart';
import '../model/car_in_out_model.dart';
import '../model/delivery_model.dart';
import '../model/ems_usage_model.dart';
import '../model/visiting_car_model.dart';


import 'user_service.dart';
import '../common/rest_api.dart';

class FacilityService {

	/// 엘리베이터 호출 요청
	Future < bool > callElevator(BuildContext context) async {
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "elevator";  //elevator-call
		// 엘리베이터 호출은 Post
		dynamic success =  await RestApi.doPostWithUser(apiId, _user, {});
		if (success is bool && !success) {
			return false;
		}else{
			return true;
		}
	}


	/// 에너지 사용량 조회
	Future < EmsUsageModel > getEnergyUsageList(BuildContext context, dynamic searchCondition) async {
		if(!IS_SERVER_MODE){
			String jsonStr = await rootBundle.loadString("assets/sample_data/ems_usage.json");
			//return DeliveryModel.fromJson(json.decode(jsonStr));
			return Future.delayed(Duration(milliseconds : 500), () => EmsUsageModel.fromJson(json.decode(jsonStr)));
		}
		
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "ems/usage";
		//print("searchCondition energyType : " + searchCondition["energyType"]);
		if(searchCondition != null && searchCondition.containsKey("energyType")) {
			apiId += "?energyType=${searchCondition["energyType"]}";
		}
		if(searchCondition != null && searchCondition.containsKey("period")) {
			if(apiId.indexOf("?") >= 0) apiId += "&";
			else apiId += "?";
			apiId += "period=${searchCondition["period"]}";
		}
		if(searchCondition != null && searchCondition.containsKey("date")) {
			if(apiId.indexOf("?") >= 0) apiId += "&";
			else apiId += "?";
			apiId += "date=${searchCondition["date"]}";
		}


		dynamic energyData =  await RestApi.doGetWithUser(apiId, _user);
		if (!(energyData is bool) && energyData != null) {
			return EmsUsageModel.fromJson(energyData);
		}else{
			return null;
		}
	}

	/// 에너지 리포트 (기간별) 조회
	Future < EmsUsageReportModel > getEnergyUsageReportList(BuildContext context, dynamic searchCondition) async {
		if(!IS_SERVER_MODE){
			String sampleJson = "assets/sample_data/ems_usage_report_year.json";
			if(searchCondition != null && searchCondition["period"] == "MONTH" ) {
				sampleJson = "assets/sample_data/ems_usage_report_month.json";
			}
			String jsonStr = await rootBundle.loadString(sampleJson);
			//return DeliveryModel.fromJson(json.decode(jsonStr));
			return Future.delayed(Duration(milliseconds : 500), () => EmsUsageReportModel.fromJson(json.decode(jsonStr)));
		}
		
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "ems/usage/details";
		if(searchCondition != null && searchCondition.containsKey("energyType")) {
			apiId += "?energyType=${searchCondition["energyType"]}";
		}
		if(searchCondition != null && searchCondition.containsKey("period")) {
			if(apiId.indexOf("?") >= 0) apiId += "&";
			else apiId += "?";
			apiId += "period=${searchCondition["period"]}";
		}
		if(searchCondition != null && searchCondition.containsKey("date")) {
			if(apiId.indexOf("?") >= 0) apiId += "&";
			else apiId += "?";
			apiId += "date=${searchCondition["date"]}";
		}

		dynamic energyData =  await RestApi.doGetWithUser(apiId, _user);
		if (!(energyData is bool) && energyData != null) {
			return EmsUsageReportModel.fromJson(energyData);
		}else{
			return null;
		}
	}



	/// 방문차량 조회
	Future < VisitingCarModel > getVisitingCarList(BuildContext context, pageNum, listCount) async {
		if(!IS_SERVER_MODE){
			if(pageNum > 5){
				return Future.delayed(Duration(milliseconds : 500), () => null);
			}
			String jsonStr = await rootBundle.loadString("assets/sample_data/visiting_car.json");
			return Future.delayed(Duration(milliseconds : 500), () => VisitingCarModel.fromJson(json.decode(jsonStr)));
		}
		
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "visitingCar?pageNum=$pageNum&listCount=$listCount";

		dynamic carData =  await RestApi.doGetWithUser(apiId, _user);
		if (!(carData is bool) && carData != null) {
			return VisitingCarModel.fromJson(carData);
		}else{
			return null;
		}
	}

	/// 방문차량 등록
	Future < bool > addVisitingCar(context, VisitingCarModelVisitCarList carModel) async {
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "visitingCar";

		dynamic requestBody = {"carNo": carModel.carNo, "date": carModel.dateTime, "dateEnd": carModel.dateTimeEnd};
		dynamic response =  await RestApi.doPostWithUser(apiId, _user, requestBody);
		if (!(response is bool) && response != null) {
			return true;
		}else{
			return response;
		}
	}

	/// 방문차량 삭제
	Future < bool > removeVisitingCar(BuildContext context, VisitingCarModelVisitCarList carModel) async {
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "visitingCar";
		dynamic requestBody = {"id": carModel.id, "carNo": carModel.carNo};
		return  await RestApi.doPutWithUser(apiId, _user, requestBody);
	}


	/// 택배 조회
	Future < DeliveryModel > getDeliveryList(BuildContext context, pageNum, listCount, Map<String, dynamic> searchCondition) async {
		if(!IS_SERVER_MODE){
			if(pageNum > 5){
				return Future.delayed(Duration(milliseconds : 500), () => null);
			}
			String jsonStr = await rootBundle.loadString("assets/sample_data/delivery.json");
			return Future.delayed(Duration(milliseconds : 500), () => DeliveryModel.fromJson(json.decode(jsonStr)));
		}
		
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "delivery?pageNum=$pageNum&listCount=$listCount";
		if(searchCondition != null && searchCondition.containsKey("parcelStatus")) {
			apiId += "&parcelStatus=${searchCondition["parcelStatus"]}";
		}
		if(searchCondition != null && searchCondition.containsKey("isConfirm")) {
			apiId += "&isConfirm=${searchCondition["isConfirm"]}";
		}

		dynamic parcelData =  await RestApi.doGetWithUser(apiId, _user);
		if (!(parcelData is bool) && parcelData != null) {
			return DeliveryModel.fromJson(parcelData);
		}else{
			return null;
		}
	}

	/// 택배 삭제
	Future < bool > removeDelivery(BuildContext context, DeliveryModelParcelList parcelModel) async {
		if(!IS_SERVER_MODE){
			return true;
		}
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "delivery";
		dynamic requestBody = {"id": parcelModel.parcelGetId, "parcelNo": parcelModel.parcelBoxNo};
		return  await RestApi.doPutWithUser(apiId, _user, requestBody);
	}

	/// 차량 입출차 조회
	Future < CarInOutModel > getCarInOutList(BuildContext context, pageNum, listCount, Map<String, dynamic> searchCondition) async {
		if(!IS_SERVER_MODE){
			if(pageNum > 5){
				return Future.delayed(Duration(milliseconds : 500), () => null);
			}
			String jsonStr = await rootBundle.loadString("assets/sample_data/car_in_out.json");
			return Future.delayed(Duration(milliseconds : 500), () => CarInOutModel.fromJson(json.decode(jsonStr)));
		}
		
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "vehicle/entry?pageNum=$pageNum&listCount=$listCount";
		if(searchCondition != null && searchCondition.containsKey("inoutType")) {
			apiId += "&inoutType=${searchCondition["inoutType"]}";
		}
		if(searchCondition != null && searchCondition.containsKey("inoutCreDtFrom")) {
			apiId += "&inoutCreDtFrom=${searchCondition["inoutCreDtFrom"]}";
		}
		if(searchCondition != null && searchCondition.containsKey("inoutCreDtTo")) {
			apiId += "&inoutCreDtTo=${searchCondition["inoutCreDtTo"]}";
		}

		dynamic carInOutData =  await RestApi.doGetWithUser(apiId, _user);
		if (!(carInOutData is bool) && carInOutData != null) {
			return CarInOutModel.fromJson(carInOutData);
		}else{
			return null;
		}
	}

	/// 차량 입출차 삭제
	Future < bool > removeCarInOut(BuildContext context, CarInOutModelParkingControlList carModel) async {
		if(!IS_SERVER_MODE){
			return true;
		}
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "vehicle/entry/${carModel.id}";
		return  await RestApi.doDeleteWithUser(apiId, _user);
	}		
}


