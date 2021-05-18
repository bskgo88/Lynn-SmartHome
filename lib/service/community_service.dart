import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_session/flutter_session.dart';
import '../common/globals.dart';
import '../model/notice_model.dart';


import 'user_service.dart';
import '../common/rest_api.dart';

class CommunityService {


	/// 공지사항 조회
	Future < NoticeModel > getNoticeList(BuildContext context, noticeType, pageNum, listCount) async {
		//print("getNoticeList noticeType : $noticeType");
		if(!IS_SERVER_MODE){
			if(pageNum > 3){
				return Future.delayed(Duration(milliseconds : 500), () => null);
			}
			String jsonStr = await rootBundle.loadString("assets/sample_data/notice_${noticeType.toLowerCase()}.json");
			return Future.delayed(Duration(milliseconds : 500), () => NoticeModel.fromJson(json.decode(jsonStr)));
		}
		
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "notice?bulletinDiv=$noticeType&pageNum=$pageNum&listCount=$listCount";
		dynamic noticeData =  await RestApi.doGetWithUser(apiId, _user);
		if (!(noticeData is bool) && noticeData != null) {
			return NoticeModel.fromJson(noticeData);
		}else{
			return null;
		}
	}

	/// 홈넷공지사항 상세 조회 - 홈넷사 공지사항은 상세 내용 별도 요청으로 받아와야 되는 구조임
	Future < NoticeModelNoticeList > getNoticeDetail(BuildContext context, noticeType, bbsId) async {
		if(!IS_SERVER_MODE){
			String jsonStr = await rootBundle.loadString("assets/sample_data/notice_${noticeType.toLowerCase()}.json");
			return Future.delayed(Duration(milliseconds : 500), () => NoticeModel.fromJson(json.decode(jsonStr)).noticeList[0]);
		}
		
		dynamic userToken = (await SharedPreferences.getInstance()).getString('_user_token');
		User _user = new User();
		_user.userToken = userToken;
		String apiId = "notice/$bbsId?bulletinDiv=$noticeType";
		dynamic noticeData =  await RestApi.doGetWithUser(apiId, _user);
		if (!(noticeData is bool) && noticeData != null) {
			return NoticeModelNoticeList.fromJson(noticeData);
		}else{
			return null;
		}
	}
		
}