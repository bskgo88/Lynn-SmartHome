import 'dart:async';
import 'dart:convert';
//import 'package:async/async.dart';
import 'package:http/http.dart'
as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_service.dart';


// 공공테이터 포탈 서비스키
const _data_go_kr_auth_key = 'VXXDyqA7tfsHTaVyMnfgIApPmyQRd8bzNytqp2XSQZ%2F78EQnj886Jef4Vc7b8fKrHMtopEAIiBS%2BEEtllHCakQ%3D%3D';
const _data_go_kr_auth_key_decoding = "VXXDyqA7tfsHTaVyMnfgIApPmyQRd8bzNytqp2XSQZ/78EQnj886Jef4Vc7b8fKrHMtopEAIiBS+EEtllHCakQ==";

// 초단기 예보 : getUltraSrtFcst
const _data_go_kr_url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtFcst?pageNo=1&numOfRows=100&dataType=JSON';
// serviceKey=서비스키&&base_date=20201008&base_time=0630&nx=55&ny=127


// 한국환경공단 근접 관측소 정보 조회
const _airKorea_observatory_url = 'http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getNearbyMsrstnList?_returnType=json';
// 한국환경공단 --> 에어코리아  변경 됨 (2021.04.01)
//const _airKorea_observatory_url = 'http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc?returnType=json';
//tmX=TM_X좌표&tmY=tm_Y좌표&ServiceKey=서비스키';


// 한국환경공단 대기오염정보 조회
const _airKorea_url = 'http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?_returnType=json&dataTerm=daily&pageNo=1&numOfRows=1&ver=1.3';
//stationName=동구동&ServiceKey=서비스키';
// 한국환경공단 --> 에어코리아  변경 됨 (2021.04.01)
//const _airKorea_url = 'http://apis.data.go.kr/B552584/ArpltnInforInqireSvcgetMsrstnAcctoRltmMesureDnsty?returnType=json&dataTerm=daily&pageNo=1&numOfRows=1&ver=1.3';



LocationService _locationService = new LocationService(); // 위치관련 서비스

//하늘상태 코드 : 1:맑음,  3:구름많음, 4:흐림, 11:비, 12:눈 
Map < String, String > weatherIcons = {
	"1": "assets/images/weather/sunny.png",
	"3": "assets/images/weather/cloudy.png",
	"4": "assets/images/weather/gray.png",
	"11": "assets/images/weather/rainy.png",
	"12": "assets/images/weather/snowy.png",
};



class WeatherService {
	String _baseAddress;

	void setBaseAddress(String baseAddress) {
		this._baseAddress = baseAddress;
	}

	Future < dynamic > fetchWeather() async {
		SharedPreferences _prefs = await SharedPreferences.getInstance();
		String weatherJson = _prefs.getString("_weather");
		DateFormat dateFommater = DateFormat("yyyy-MM-dd HH:mm:ss");
		DateTime nowDateTime = new DateTime.now();
		String nowDateTimeStr = dateFommater.format(nowDateTime);
		//print("fetchWeather nowDateTime :  $nowDateTime   nowDateTimeStr : $nowDateTimeStr ");
		if (weatherJson == null) {
			Weather weatherModel = await getWeather();
			if (weatherModel != null) {
				print("fetchWeather weatherModel json encode : ${json.encode(weatherModel)} ");
				_prefs.setString('_weather', json.encode(weatherModel));

				String weatherDateTime = dateFommater.format(nowDateTime);
				_prefs.setString('_weatherDateTime', weatherDateTime);

			}
			return weatherModel;
		} else {
			String weatherDateTimeStr = _prefs.getString("_weatherDateTime");
			if (weatherDateTimeStr != null) {
				DateTime weatherDateTime = dateFommater.parse(weatherDateTimeStr);
				
				final diffMinutes = nowDateTime.difference(weatherDateTime).inMinutes;
				//print("fetchWeather weatherDateTime : $weatherDateTime  nowDateTime : $nowDateTime  difference : $diffMinutes ");

				// 시간차가 60분 이상이면 날씨정보를 다시 가져온다.
				if (diffMinutes > 60) {
					Weather weatherModel = await getWeather();
					if (weatherModel != null) {
						_prefs.setString('_weather', json.encode(weatherModel));
						_prefs.setString('_weatherDateTime', nowDateTimeStr);
					}
					return weatherModel;
				}
			}

			return Weather.fromJson(json.decode(weatherJson));
		}
	}

	// 날씨정보 조회 ( 날씨, 해당주소, 미세먼지 정보 모두 포함)
	Future < Weather > getWeather() async {
		String apiAddr = _data_go_kr_url;
		try {
			double longitude = 0; // 리스더빌딩의 경도, 위도 : 127.125452, 37.413610
			double latitude = 0;

			// 기본적으로 스마트폰의 GPS의 경도, 위도 정보의 위치 정보로 날씨를 가져온다.
			Position position = await _locationService.getGpsLocation();
			//print("GPS position longitude : " + position.longitude.toString() + "  latitude : " + position.latitude.toString());

			// 한국 위경도 범위 : 경도범위 124 – 132, 위도범위 33 – 43 
			if (position != null && position.longitude >= 124 && position.longitude <= 132 && position.latitude >= 33 && position.latitude <= 43) {
				longitude = position.longitude;
				latitude = position.latitude;
			} else {
				print("GPS not available or your area is not in Korea");
				if (_baseAddress == null || _baseAddress == "") {
					print("기본 주소가 없어 날씨정보를 가져올 수 없습니다.");
					throw FormatException('단지 주소가 올바르지 않아 날씨정보를 가져올 수 없습니다.'); // 주소가 없으면 날씨를 가져올 수 없음
				}

				//기본 주소로 경도, 위도 정보를 조회한다. 
				WGS84Xy wGS84Xy = await _locationService.getPositionCoord(_baseAddress);
				if (wGS84Xy == null) return null; // 경도,위도 조회 못하면 날씨 정보 가져올 수 없음
				longitude = wGS84Xy.x;
				latitude = wGS84Xy.y;
			}
			//print("longitude : " + longitude.toString() + "  latitude : " + latitude.toString());

			DateTime now = DateTime.now();
			now = now.add(new Duration(hours: -1)); // 한 시간 이전 시간 기준 
			String baseDate = DateFormat('yyyyMMdd').format(now);
			String baseTime = DateFormat('HH').format(now) + "00";

			apiAddr += "&serviceKey=" + _data_go_kr_auth_key;
			apiAddr += "&base_date=" + baseDate;
			apiAddr += "&base_time=" + baseTime;

			//기상청에서 사용하는 날씨정보의 좌표는 경도,위도 를 변환하여야 함
			WeatherMapXy nxy = _locationService.convertWeatherMapXy(longitude, latitude);
			apiAddr += "&nx=" + nxy.x.toString();
			apiAddr += "&ny=" + nxy.y.toString();

			//print("apiAddr : " + apiAddr);

			http.Response response = await http.get(Uri.parse(apiAddr));
			var result = json.decode(response.body);
			var items = result["response"]["body"]["items"]["item"];

			//print("items : " + json.encode(items));

			// 초단기 예보정보는 각 항목당시간별로 여러개 존재 (6시간-6개)하는데 가장 처음이 현재시간과 가까운 정보임.
			String skyStatus;
			double tempCurr;
			double rainfall;
			String rainType;
			for (Map < String, dynamic > item in items) {
				if (skyStatus == null && item["category"] == "SKY") {
					skyStatus = item["fcstValue"];
					continue;
				} else if (tempCurr == null && item["category"] == "T1H") {
					tempCurr = double.parse(item["fcstValue"]);
					continue;
				} else if (rainfall == null && item["category"] == "RN1") {
					rainfall = double.parse(item["fcstValue"]);
					continue;
				} else if (tempCurr == null && item["category"] == "PTY") {
					rainType = item["fcstValue"];
					continue;
				}

				//가져올 정보를 다 얻으면 더이상 loop 할 필요 없음
				if (skyStatus != null && tempCurr != null && rainfall != null && rainType != null) {
					break;
				}
			}

			// 하늘상태(SKY) 코드 : 맑음(1), 구름많음(3), 흐림(4)  * 구름조금(2) 삭제 (2019.06.4)
			// 강수형태(PTY) 코드 : 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4), 빗방울(5), 빗방울/눈날림(6), 눈날림(7) - 여기서 비/눈은 비와 눈이 섞여 오는 것을 의미 (진눈개비)
			// 강수 형태에 따라서 skyStatus 비, 눈 상태 추가 
			if (rainType == "1" || rainType == "5") {
				skyStatus = "11"; // 비
			} else if (rainType == "2" || rainType == "3" || rainType == "6" || rainType == "7") {
				skyStatus = "12"; // 눈
			}
			print("skyStatus : " + skyStatus + "  tempCurr : " + tempCurr.toString() + "  railfall : " + rainfall.toString() + "   rainType : " + rainType);

			//날씨정보의 기준이 된 경도, 위도 정보로 해당 지역의 주소를 가져옴 
			String address = await _locationService.getPositionAddress(longitude, latitude);
			print("address : " + address);

			// 대기오염 정보 조회
			AirPollution airPollution = await getAirPollution(longitude, latitude);
			print("pm10GradeName : " + airPollution.pm10GradeName + "  pm25GradeName : " + airPollution.pm25GradeName);

			Weather weather = Weather(
				tempCurr: tempCurr,
				skyStatus: skyStatus,
				rainfall: rainfall,
				rainType: rainType,
				address: address,
				weatherIcon: weatherIcons[skyStatus],
				pm10GradeName: airPollution.pm10GradeName,
				pm25GradeName: airPollution.pm25GradeName,
				pm10Value: airPollution.pm10Value,
				pm25Value: airPollution.pm25Value,
			);

			return weather;
		} catch (e) {
			print('Error: ${e.toString()}');
			//throw FormatException('날씨정보를 조회하지 못했습니다.');
			return null;
		}
	}


	// 미세먼지 정보 조회 (위도, 경도로 조회)
	Future < AirPollution > getAirPollution(double longitude, double latitude) async {
		String apiAddr = _airKorea_observatory_url; //api 호출을 위한 주소

		try {
			// 위도,경도 정보로 근접 관측소 정보를 조회한다.
			// 환경관리공단에서 사용하는 좌표는 TM 좌표라서 변환하여야 함
			TmMapXy tmMapXY = _locationService.convertTmXy(longitude, latitude);

			print("getAirPollution longitude : " + longitude.toString() + "  latitude : " + latitude.toString());
			apiAddr += "&serviceKey=" + _data_go_kr_auth_key;
			apiAddr += "&tmX=" + tmMapXY.x.toString();
			apiAddr += "&tmY=" + tmMapXY.y.toString();
			print("미세먼지 정보 조회 apiAddr : " + apiAddr);

			http.Response response = await http.get(Uri.parse(apiAddr));
			var result = json.decode(response.body);
      print("근접 관측소 정보 response.body  : " + response.body);
			var item = result["list"][0]; // 첫 번째 측정소 정보
			//print("item : " + json.encode(item));
			String stationName = item["stationName"];
			print("stationName : " + stationName);

			// 근접 측정소의 미세먼지 정보 조회
			apiAddr = _airKorea_url;
			apiAddr += "&serviceKey=" + _data_go_kr_auth_key;
			apiAddr += "&stationName=" + stationName;
			//print("apiAddr : " + apiAddr);
			response = await http.get(Uri.parse(apiAddr));
			result = json.decode(response.body);

			item = result["list"][0]; // 근접 측정소의 첫번째  정보
			//print("item : " + json.encode(item));

			AirPollution airPollution = AirPollution(
				pm10Value: item["pm10Value"] == "-" ? -1 : double.parse(item["pm10Value"]),
				pm25Value: item["pm25Value"] == "-" ? -1 : double.parse(item["pm25Value"]),
				pm10Grade: item["pm10Grade"],
				pm25Grade: item["pm25Grade"],
				pm10GradeName: getAirPollutionGradeName(item["pm10Grade"]),
				pm25GradeName: getAirPollutionGradeName(item["pm25Grade"]),
			);
			return airPollution;
		} catch (e) {
			print('Error: ${e.toString()}');
			//rethrow;

      AirPollution airPollution = AirPollution(
				pm10Value: -1,
				pm25Value: -1,
				pm10Grade: "-",
				pm25Grade: "-",
				pm10GradeName: "정보없음",
				pm25GradeName: "정보없음",
			);
      return airPollution;
		}
	}

	// 미세먼지/초미세먼지 상태이름 설정
	String getAirPollutionGradeName(String grade) {
		//Grade - 1 : 좋음, 2: 보통, 3: 나쁨, 4: 매우나쁨
		String gradeName = "";
		switch (grade) {
			case '1':
				gradeName = "좋음";
				break;
			case '2':
				gradeName = "보통";
				break;
			case '3':
				gradeName = "나쁨";
				break;
			case '4':
				gradeName = "매우나쁨";
				break;
		}
		return gradeName;
	}
}


class Weather {
	double tempCurr; //현재 온도
	String skyStatus; //하늘 상태
	double rainfall; //강수량
	String rainType; //강수 형태
	String address; //주소 (시/군/구 까지만 표시)
	String weatherIcon; //날씨 아이콘 이미지
	String pm10GradeName; //미세먼지 등급
	String pm25GradeName; //초미세먼지 등급
	double pm10Value; //미세먼지 값
	double pm25Value; //초미세먼지 값
	Weather({
		this.tempCurr,
		this.skyStatus,
		this.rainfall,
		this.rainType,
		this.address,
		this.weatherIcon,
		this.pm10GradeName,
		this.pm25GradeName,
		this.pm10Value,
		this.pm25Value,
	});

	Weather.fromJson(Map < String, dynamic > json) {
		tempCurr = json["tempCurr"]?.toDouble();
		skyStatus = json["skyStatus"]?.toString();
		rainfall = json["rainfall"]?.toDouble();
		rainType = json["rainType"]?.toString();
		address = json["address"]?.toString();
		weatherIcon = json["weatherIcon"]?.toString();
		pm10GradeName = json["pm10GradeName"]?.toString();
		pm25GradeName = json["pm25GradeName"]?.toString();
		pm10Value = json["pm10Value"]?.toDouble();
		pm25Value = json["pm25Value"]?.toDouble();
	}

	Map < String, dynamic > toJson() {
		final Map < String, dynamic > data = Map < String, dynamic > ();
		data["tempCurr"] = tempCurr;
		data["skyStatus"] = skyStatus;
		data["rainfall"] = rainfall;
		data["rainType"] = rainType;
		data["address"] = address;
		data["weatherIcon"] = weatherIcon;
		data["pm10GradeName"] = pm10GradeName;
		data["pm25GradeName"] = pm25GradeName;
		data["pm10Value"] = pm10Value;
		data["pm25Value"] = pm25Value;
		return data;
	}
}

class AirPollution {
	final double pm10Value; //미세 먼지 값
	final double pm25Value; //초미세 먼지 값
	final String pm10Grade; //미세먼지 등급
	final String pm25Grade; //초미세먼지 등급
	final String pm10GradeName; //미세먼지 등급
	final String pm25GradeName; //초미세먼지 등급
	AirPollution({
		this.pm10Value,
		this.pm25Value,
		this.pm10Grade,
		this.pm25Grade,
		this.pm10GradeName,
		this.pm25GradeName,
	});
}