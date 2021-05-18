
import '../service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
bool IS_SERVER_MODE = false;
// ignore: non_constant_identifier_names
bool USE_VIBRATION = true;  // 기기제어시 진동 사용여부

const String DATE_FORMAT = "yyyy-MM-dd";
const String TIME_FORMAT = "HH:mm";
const String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm";

User globalUser = User();


Future<bool> setServerMode() async{
	// vendorToken 이 없는 경우는  ServerMode false 임
	bool isServerMode = false;
	final prefs = await SharedPreferences.getInstance();
	final vendorToken = prefs.getString('_vendor_token'); 

	//사용자 정보 글로벌 변수 설정
	globalUser.name = prefs.getString('_user_name');
	globalUser.email = prefs.getString('_user_email');
	globalUser.userToken = prefs.getString('_user_token'); 
	globalUser.vendorToken = vendorToken;

  USE_VIBRATION = prefs.getString('_use_vibration') == null? true: (prefs.getString('_use_vibration') == "N"? false: true); 
	
	if(vendorToken != null && vendorToken != ""){
		isServerMode = true;  // vendorToken 있는 경우는 기본적으로 ServerMode true

		final serverMode = prefs.getString('_is_server_mode'); 
		// 설정화면에서 모드 데모모드로 변경한 경우.
		if(serverMode != null && serverMode == "N" ){
			isServerMode = false;
		}
	}
	IS_SERVER_MODE = isServerMode;
	return isServerMode;
}