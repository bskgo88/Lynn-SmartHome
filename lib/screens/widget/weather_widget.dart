import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/weather_service.dart';
import '../../common/style.dart';


//날씨 영역 위젯
class WeatherWidget extends StatelessWidget {
	final String villageAddress; //단지 주소 (동/읍/면 까지만 필요)
	WeatherWidget(this.villageAddress) {
		print("########################   WeatherWidget villageAddress : " + villageAddress);
	}

	Widget build(BuildContext context) {
		String baseAddress = villageAddress;
		WeatherService _weatherService = new WeatherService();
		_weatherService.setBaseAddress(baseAddress);

		return FutureBuilder < dynamic > (
			//future: _weatherService.getWeather(),
			future: _weatherService.fetchWeather(),  //      AsyncMemoizer 사용
			builder: (context, AsyncSnapshot < dynamic > weather) {
				// 처리중인 경우
				if (weather.connectionState == ConnectionState.waiting) {
					return Container(
						// color: BgColor.white,
						margin: EdgeInsets.only(top: 10),
						padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 18),
						color: BgColor.white,
						width: double.infinity,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							mainAxisAlignment: MainAxisAlignment.center,
							children: < Widget > [
								SizedBox(
									child: CircularProgressIndicator(),
									height: 30.0,
									width: 30.0,
								)
							]
						)
					);
				}
				// 데이타가져오는데 에러가 있는 경우 (날씨정보를 못가져오는 경우)
				else if (weather == null || !weather.hasData) {
					return Container(
						// color: BgColor.white,
						margin: EdgeInsets.only(top: 10),
						padding: EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 18),
						child: Text(
							'날씨정보를 가져오지 못했습니다.',
							style: TextFont.normal
						)
					);
				} 
				// 정상적으로 가져온 경우
				else {
					return Container(
						color: BgColor.white,
						margin: EdgeInsets.only(top: 10),
						padding: EdgeInsets.only(
							top: 15, right: 15, left: 15, bottom: 18),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: < Widget > [
								Row(
									mainAxisAlignment: MainAxisAlignment.start,
									children: [
										Align(alignment: Alignment.centerLeft),
										Container(
											height: 32,
											child: Image.asset(weather.data.weatherIcon, fit: BoxFit.fitHeight, ),
										),
										Container(
											padding: EdgeInsets.only(left: 10),
											child: Text(weather.data.tempCurr.toString() + 'c', style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 26, color: const Color(0xff02A0F7), height: 1.5, ), textAlign: TextAlign.right, ),
										),
										Container(
											padding: EdgeInsets.only(left: 7, top: 7),
											child: Text(weather.data.address,
												style: TextStyle(
													fontFamily: 'NanumBarunGothic',
													fontWeight: FontWeight.w400,
													fontSize: 12,
													color: const Color(0xff666666),
														height: 1.5,
												),
												textAlign: TextAlign.left,
											),
										),
										Expanded(
											child: Text(''),
										),
										Container(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.end,
												children: [
													Container(
														child: Text(
															//'미세먼지 : ' + weather.data.pm10GradeName+'(' + weather.data.pm10Value.toString() + ')',
															'미세먼지 : ${weather.data.pm10GradeName}(${weather.data.pm10Value == -1? "-" : weather.data.pm10Value.toInt().toString()})',
															style: TextStyle(
																fontFamily: 'NanumBarunGothic',
																fontWeight: FontWeight.w400,
																fontSize: 12,
																color: const Color(0xff333333),
																	height: 1.5,
															),
															textAlign: TextAlign.right,
														),
													),
													Container(
														child: Text(
															'초미세먼지 : ${weather.data.pm25GradeName}(${weather.data.pm25Value == -1? "-" : weather.data.pm25Value.toInt().toString()})',
															style: TextStyle(
																fontFamily: 'NanumBarunGothic',
																fontWeight: FontWeight.w400,
																fontSize: 12,
																color: const Color(0xff333333),
																	height: 1.5,
															),
															textAlign: TextAlign.right,
														),
													),
												],
											),
										),
									],
								),
							]),
					);
				}
			}
		);
	}
}
