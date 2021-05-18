import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:geodetic_converter/geodetic_converter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';


const _vworld_auth_key = 'C811E6A8-EEA3-32B7-B0BE-998391BC3D27';
const _vworld_api_url = 'http://api.vworld.kr/req/address?service=address&request=getAddress&version=2.0&crs=epsg:4326&format=json&type=PARCEL&zipcode=true&simple=true';
//point=126.978275264,37.566642192&key=서비스키
const _vworld_api_coord_url = 'http://api.vworld.kr/req/address?service=address&request=getcoord&version=2.0&crs=epsg:4326&format=json&type=ROAD&simple=true&refine=true';
//address=도로명주소&key=서비스키

/*
vworld_api response sample

{
    "response": {
        "service": {
            "name": "address",
            "version": "2.0",
            "operation": "getAddress",
            "time": "5(ms)"
        },
        "status": "OK",
        "result": [
            {
                "zipcode": "04524",
                "text": "서울특별시 중구 태평로1가 31",
                "structure": {
                    "level0": "대한민국",
                    "level1": "서울특별시",
                    "level2": "중구",
                    "level3": "",
                    "level4L": "태평로1가",
                    "level4LC": "1114010300",
                    "level4A": "명동",
                    "level4AC": "1114055000",
                    "level5": "31",
                    "detail": ""
                }
            }
        ]
    }
}

                "zipcode": "13496",
                "text": "경기도 성남시 분당구 야탑동 342-1",
                "structure": {
                    "level0": "대한민국",
                    "level1": "경기도",
                    "level2": "성남시 분당구",
                    "level3": "",
                    "level4L": "야탑동",
                    "level4LC": "4113510700",
                    "level4A": "야탑1동",
                    "level4AC": "4113562000",
                    "level5": "342-1",
                    "detail": ""
*/

class LocationService {

	// Future < Position > getGpsLocation() async {
	// 	try {
	// 		//LocationPermission permission = await checkPermission();
	// 		Position position = await Geolocator.getCurrentPosition();
	// 		return position;
	// 	} catch (e) {
	// 		print('Error: ${e.toString()}');
	// 		return null;
	// 	}
	// }

	Future < Position > getGpsLocation() async {
		bool serviceEnabled;
		LocationPermission permission;

		serviceEnabled = await Geolocator.isLocationServiceEnabled();
		if (!serviceEnabled) {
			// return Future.error('위치 서비스가 비활성화 되어 있습니다.');
			return null;
		}

		permission = await Geolocator.checkPermission();
		if (permission == LocationPermission.deniedForever) {
			// return Future.error('위치서비스에 대한 권한이 거부되어 있습니다.');
			return null;
		}

		if (permission == LocationPermission.denied) {
			permission = await Geolocator.requestPermission();
			if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
				//return Future.error('위치서비스에 대한 권하니아 거부되었습니다. (actual value: $permission).');
				return null;
			}
		}
		return await Geolocator.getCurrentPosition();
	}

	// Future < Position > updateLocation() async {
	// 	try {
	// 		Position newPosition = await Geolocator.getCurrentPosition().timeout(new Duration(seconds: 5));
	// 		return newPosition;
	// 		// setState(() {
	// 		// 	_position = newPosition;
	// 		// });
	// 	} catch (e) {
	// 		print('Error: ${e.toString()}');
	// 		return null;
	// 	}
	// }

	// 경도, 위도 정보로 해당 주소를 조회함 
	Future< String > getPositionAddress(double longitude, double latitude) async{
		String apiAddr = _vworld_api_url;
		try{
			String point = longitude.toString() + "," + latitude.toString();
			apiAddr += "&key=" + _vworld_auth_key;
			apiAddr += "&point=" + point;
			//print("apiAddr : " + apiAddr);
			http.Response response = await http.get(Uri.parse(apiAddr));
			var result = json.decode(response.body); 
			var item = result["response"]["result"][0];
			//print("items : " + json.encode(item));
			String address = item["structure"]["level2"].split(" ")[0] + " " + item["structure"]["level4L"];
			//print("getPositionAddress address : " + address);
			return address;
		}catch(e){
			print(e);
			rethrow;
		}
	}

	// 주소로 경도, 위도를 조회
	Future< WGS84Xy > getPositionCoord(String address) async{
		String apiAddr = _vworld_api_coord_url;
		try{
			address = Uri.encodeComponent(address); // 한글이므로 URI인코딩 필요
			apiAddr += "&key=" + _vworld_auth_key;
			apiAddr += "&address=" + address;
			//print("getPositionCoord apiAddr : " + apiAddr);
			http.Response response = await http.get(Uri.parse(apiAddr));
			var result = json.decode(response.body); 
			var item = result["response"]["result"];
			//print("item : " + json.encode(item));
			return WGS84Xy(
				double.parse(item["point"]["x"]),
				double.parse(item["point"]["y"]),
			);
		}catch(e){
			print(e);
			rethrow;
		}
	}

	// 기상청에서 사용하는 좌표로 변환한다.
	WeatherMapXy convertWeatherMapXy(double longitude, double latitude) {
		//int NX = 149; /* X 축 격자점 수 */
		//int NY = 253; /* Y 축 격자점 수 */
		double pi, degrad; //, RADDEG;
		double re, olon, olat, sn, sf, ro;
		double slat1, slat2, ra, theta;  //alon, alat, xn, yn, 
		LamcParameter map = LamcParameter();
		map.re = 6371.00877; // 지도반경
		map.grid = 5.0; // 격자간격 (km)
		map.slat1 = 30.0; // 표준위도 1
		map.slat2 = 60.0; // 표준위도 2
		map.olon = 126.0; // 기준점 경도
		map.olat = 38.0; // 기준점 위도
		map.xo = 210 / map.grid; // 기준점 X 좌표
		map.yo = 675 / map.grid; // 기준점 Y 좌표
		map.first = 0;
		if ((map).first == 0) {
			// pi = asin(1.0) * 2.0;
			pi = 3.1415926535897931;
			degrad = pi / 180.0;
			//RADDEG = 180.0 / pi;
			re = map.re / map.grid;
			slat1 = map.slat1 * degrad;
			slat2 = map.slat2 * degrad;
			olon = map.olon * degrad;
			olat = map.olat * degrad;
			sn = tan(pi * 0.25 + slat2 * 0.5) / tan(pi * 0.25 + slat1 * 0.5);
			sn = log(cos(slat1) / cos(slat2)) / log(sn);
			sf = tan(pi * 0.25 + slat1 * 0.5);
			sf = pow(sf, sn) * cos(slat1) / sn;
			ro = tan(pi * 0.25 + olat * 0.5);
			ro = re * sf / pow(ro, sn);
			map.first = 1;
		}
		ra = tan(pi * 0.25 + latitude * degrad * 0.5);
		ra = re * sf / pow(ra, sn);
		theta = longitude * degrad - olon;
		if (theta > pi) theta -= 2.0 * pi;
		if (theta < -pi) theta += 2.0 * pi;
		theta *= sn;

		double x = (ra * sin(theta)) + map.xo;
		double y = (ro - ra * cos(theta)) + map.yo;
		x = x + 1.5;
		y = y + 1.5;
		return WeatherMapXy(x.toInt(), y.toInt());
	}

	//환경공단에서 사용하는 TM 좌표로 변환한다.
	TmMapXy convertTmXy(double longitude, double latitude) {
		final geodeticConverter = GeodeticConverter();

		//해당 패키지의 만든이가 x좌표, y좌표를 바꾸어 구현하여  latitude, longitude 를 바꾸어 호출함
		double x = geodeticConverter.wgs84ToTM(x: latitude, y: longitude).x;  
		double y = geodeticConverter.wgs84ToTM(x: latitude, y: longitude).y;
		//print("convertTmXy x : " + x.toString() + "  y : " + y.toString());
		return TmMapXy(x, y);
	}
}

class WeatherMapXy {
	int x;
	int y;
	WeatherMapXy(this.x, this.y);
}

class WGS84Xy {
	double x;
	double y;
	WGS84Xy(this.x, this.y);
}

class TmMapXy {
	double x;
	double y;
	TmMapXy(this.x, this.y);
}

class LamcParameter {
	double re; /* 사용할 지구반경 [ km ]      */
	double grid; /* 격자간격        [ km ]      */
	double slat1; /* 표준위도        [degree]    */
	double slat2; /* 표준위도        [degree]    */
	double olon; /* 기준점의 경도   [degree]    */
	double olat; /* 기준점의 위도   [degree]    */
	double xo; /* 기준점의 X 좌표  [격자거리]  */
	double yo; /* 기준점의 Y 좌표  [격자거리]  */
	int first; /* 시작여부 (0 = 시작)         */
}