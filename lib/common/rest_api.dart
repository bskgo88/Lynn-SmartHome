import 'dart:convert';

import 'package:http/http.dart' as http;
import '../common/globals.dart';
import '../service/user_service.dart';

class URLS {
	static
	// const String BASE_URL = 'https://lynn.wikey.co.kr';
	const String BASE_URL = 'https://2rcsuw7t01.execute-api.ap-northeast-2.amazonaws.com/Prod';  // 운영 URL로 변경
}

class RestApi {

	static Future < dynamic > doPostWithUser(String apiId, User _user, dynamic body) async {
		Map < String, String > headers = {
			"Content-type": "application/json",
			"X-COG-TOKEN": _user.userToken,
		};
		return doPost(apiId, headers, body);
	}

	static Future < dynamic > doPost(String apiId, Map < String, String > headers, dynamic body) async {
		if(!IS_SERVER_MODE && apiId != "sync") {  // 홈넷연동 제외
			return Future.delayed(Duration(milliseconds : 300), () => true);
		}

		print("Request URL (POST) : " + '${URLS.BASE_URL}/' + apiId);
		//print("Request Header : " + json.encode(headers));
		print("Request Body : " + json.encode(body));

		final response = await http.post(Uri.parse('${URLS.BASE_URL}/' + apiId), headers: headers, body: json.encode(body));
		print("response.statusCode : ${response.statusCode}");
		print("response.body : ${response.body}");
		if (response.statusCode == 200) {
			if(response.body != null && response.body != ""){
				return json.decode(response.body);
			}else{
				return true;
			}
		} else {
			return false;
		}
	}


	static Future < dynamic > doGetWithUser(String apiId, User _user) async {
		Map < String, String > headers = {
			"Content-type": "application/json",
			"X-COG-TOKEN": _user.userToken,
		};
		return doGet(apiId, headers);
	}

	static Future < dynamic > doGet(String apiId, Map < String, String > headers) async {
		if(!IS_SERVER_MODE && apiId != "user" && apiId.indexOf("villages") < 0) {
			return Future.delayed(Duration(milliseconds : 300), () => true);
		}

		if(headers == null){
			headers = {"Content-type": "application/json"};
		}

		print("Request URL (GET) : " + '${URLS.BASE_URL}/' + apiId);
		//print("Request Header : " + json.encode(headers));

		final response = await http.get(Uri.parse('${URLS.BASE_URL}/' + apiId), headers: headers);
		print("response.statusCode : ${response.statusCode}");
		print("response.body : ${response.body}");
		if (response.statusCode == 200) {
			if(response.body != null && response.body != ""){
				print("response.body : " + response.body);
				return json.decode(response.body);
			}else{
				return true;
			}
		} else {
			return false;
		}
	}

	

	static Future < dynamic > doPutWithUser(String apiId, User _user, dynamic body) async {
		Map < String, String > headers = {
			"Content-type": "application/json",
			"X-COG-TOKEN": _user.userToken,
		};
		return doPut(apiId, headers, body);
	}

	static Future < dynamic > doPut(String apiId, Map < String, String > headers, dynamic body) async {
		if(!IS_SERVER_MODE) return Future.delayed(Duration(milliseconds : 300), () => true);

		print("Request URL (PUT) : " + '${URLS.BASE_URL}/' + apiId);
		//print("Request Header : " + json.encode(headers));
		print("Request Body : " + json.encode(body));

		final response = await http.put(Uri.parse('${URLS.BASE_URL}/' + apiId), headers: headers, body: json.encode(body));
		print("response.statusCode : ${response.statusCode}");
		print("response.body : ${response.body}");
		if (response.statusCode == 200) {
			return true;
		} else {
			return false;
		}
	}

	static Future < dynamic > doDeleteWithUser(String apiId, User _user) async {
		Map < String, String > headers = {
			"Content-type": "application/json",
			"X-COG-TOKEN": _user.userToken,
		};
		return doDelete(apiId, headers);
	}

	static Future < dynamic > doDelete(String apiId, Map < String, String > headers) async {
		if(!IS_SERVER_MODE) return Future.delayed(Duration(milliseconds : 300), () => true);

		print("Request URL (DELETE) : " + '${URLS.BASE_URL}/' + apiId);
		//print("Request Header : " + json.encode(headers));

		final response = await http.delete(Uri.parse('${URLS.BASE_URL}/' + apiId), headers: headers);
		print("response.statusCode : ${response.statusCode}");
		print("response.body : ${response.body}");
		if (response.statusCode == 200) {
			return true;
		} else {
			return false;
		}
	}
}
