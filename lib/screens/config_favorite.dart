
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_home_bloc.dart';
import '../common/ui_common.dart';
import '../model/user_home_model.dart';
import '../service/config_service.dart';
import '../common/style.dart';


List < String > selectedDevices = [];
class ConfigFavorite extends StatefulWidget {
	final UserHomeModel userHomeModel;
	final prevPage;

	ConfigFavorite({
		Key key,
		@required this.userHomeModel,
		this.prevPage
	}): super(key: key);

	@override
	_ConfigFavoriteState createState() => _ConfigFavoriteState();
}

class _ConfigFavoriteState extends State < ConfigFavorite > {
	GlobalKey < ScaffoldState > _scaffoldKey = new GlobalKey < ScaffoldState > ();
	void initState() {
		//print("_ConfigFavoriteState initState");
		//selectedDevices = [];
		super.initState();
	}

	ConfigService _configService = ConfigService();

	@override
	Widget build(BuildContext context) {

		UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);
		bool isButtonEnable = true;
		selectedDevices = [];
		// Scaffold is a layout for the major Material Components.
		return Scaffold(
			key: _scaffoldKey,
			appBar: AppBar(
				title: Text(
					'즐겨찾기 관리',
					style: TextFont.big_n,
				),
				iconTheme: IconThemeData(
					color: Colors.black, //change your color here
				),
				leading: IconButton(
					icon: Icon(
						Icons.arrow_back
					),
					tooltip: 'Navigation menu',
					onPressed: () {
						if(widget.prevPage != null){
							Navigator.pushNamed(context, widget.prevPage);
							//Navigator.pushReplacementNamed(context, widget.prevPage);
						}else{
							Navigator.of(context).pop();
						}
					}
				),
				backgroundColor: BgColor.white,
			),
			body: Container(
				constraints: BoxConstraints.expand(),
				decoration: BoxDecoration(color: BgColor.lgray),
				child: SingleChildScrollView(
					padding: EdgeInsets.all(20),
					child: Column(
						children: < Widget > [
							Column(
								mainAxisAlignment: MainAxisAlignment.start,
								// 즐겨찾기 기기 목록 위젯 
								children: _buildFavoriteListDevices(context) 

							),
							Container( // 버튼영역
								width: double.infinity,
								height: 50,
								margin: EdgeInsets.only(top: 13),
								decoration: BoxDecoration(
									color: BgColor.main,
									boxShadow: [Shadows.fshadow],
									borderRadius: Radii.radi10,
								),
								child: FlatButton(
									onPressed: () async {

										// 선택된 기기 저장 처리
										if (isButtonEnable) {
											if (selectedDevices.length == 0) {
												UICommon.alert(context, "선택한 기기가 없습니다.");
												return;
											}
											isButtonEnable = false;
											
											for (var device in widget.userHomeModel.homedevices) {
												// ignore: avoid_init_to_null
												String isFavorite = null;
												// 즐겨찾기 새로 추가된 기기목록에 있는지 체크
												int nIdx = selectedDevices.indexWhere((deviceId) => deviceId == device.deviceId);
												// 기존 즐겨 찾기 목록에 있는지 체크
												//int oIdx = widget.userHomeModel.favoriteDevices.indexWhere((favoriteDevice) => favoriteDevice.deviceId == device.deviceId);
												bool oldExists = device.isFavorite == "yes"? true : false;
												
												if(nIdx >= 0 && !oldExists){  // 신규로 즐겨찾기 추가된 기기
													isFavorite = "yes";
												}else if(nIdx < 0 && oldExists){  // 즐겨찾기 삭제한 기기
													isFavorite = "no";
												}
												if(isFavorite != null){  // 기존과 다른 상태만 처리한다.
													//print("New Favorite Config  deviceId : ${device.deviceId}  isFavorite : $isFavorite");
													_configService.doFavorite(context, device.deviceId, device.id, isFavorite, false).then((value) {
														// 화면 state 변경 처리
														userHomeBloc.add(StatusChangedEvent(deviceId: device.deviceId, statusName:  "isFavorite", statusValue: isFavorite ));
													});
												}
											}
											UICommon.showSnackBarMessage(_scaffoldKey.currentState, '저장되었습니다');
											isButtonEnable = true;
										}

									},
									child: Text(
										'즐겨찾기 저장',
										style: TextFont.semibig_w,
									)
								)
							),
						],
					),
				)
			),
		);
	}

	/// 즐겨찾기 설정 팝업 다이얼로그에 들어가는 기기 목록 위젯
	List < Widget > _buildFavoriteListDevices(BuildContext context) {
		final homedevices = widget.userHomeModel.homedevices;

		UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

		List < Widget > devicesWidget = [];
		bool isFavorite;
		for (var device in homedevices) {
			// 일괄소등과 엘리베이터호출은 즐겨찾기 추가 화면 목록에서 제외 처리
			if (device.devicemodel.modeltype.code == "LIGHTOFF" || device.devicemodel.modeltype.code == "ELEVATOR") {
				continue;
			}
			if (device.isFavorite == "yes") {
				isFavorite = true;
			}else{
				isFavorite = false;
			}
			//print("_buildFavoriteListDevices  deviceId : ${device.deviceId}  isFavorite : $isFavorite");
			devicesWidget.add(FavoriteListDeviceWidget(device: device, isFavorite: isFavorite, userHomeBloc: userHomeBloc));
		}
		return devicesWidget;
	}
}


/// 즐겨찾기 추가에 들어가는 기기 위젯 
class FavoriteListDeviceWidget extends StatefulWidget {
	final UserHomeDevices device;
	final isFavorite;
	final userHomeBloc;
	FavoriteListDeviceWidget({
		Key key,
		@required this.device,
		@required this.isFavorite,
		this.userHomeBloc
	}): super(key: key);

	@override
	_FavoriteListDeviceWidgetState createState() => _FavoriteListDeviceWidgetState();
}
class _FavoriteListDeviceWidgetState extends State < FavoriteListDeviceWidget > {
	bool isSuccess = false;
	bool isButtonEnable = true;
	bool isSelected;
	Widget build(BuildContext context) {

		UserHomeDevices device = widget.device;
		String deviceTypeCode = device.devicemodel.modeltype.code;
		if(isSelected == null) {
			isSelected = widget.isFavorite;
			if(isSelected){
				int nIdx = selectedDevices.indexWhere((deviceId) => deviceId == device.deviceId);
				if(nIdx < 0){
					selectedDevices.add(device.deviceId);
				}
			}
		}
		return Material(
			color: Colors.transparent,
			child:

			Container(
				margin: EdgeInsets.only(bottom: 7),
				decoration: BoxDecoration(
					boxShadow: [Shadows.fshadow],
					borderRadius: Radii.radi10,
					color: BgColor.white,
				),
				child: Row(
					children: [
						Expanded(
							child: FlatButton(
								//padding: EdgeInsets.all(13),
								onPressed: () async {
								},
								child: Row(
									crossAxisAlignment: CrossAxisAlignment.center,
									mainAxisAlignment: MainAxisAlignment.start,
									children: [
										Container(
											width: 24,
											height: 24,
											margin: EdgeInsets.only(right: 10),
											child: Image.asset(
												UICommon.deviceIcons[deviceTypeCode] + ".png", // 기기 이미지
												fit: BoxFit.fitWidth,
											),
										),
										Expanded(
											child: Text(
												device.deviceName, // 기기 명 
												style: TextFont.normal,
												textAlign: TextAlign.left,
											)
										)
									],
								),
							)
						),
						Container(
							padding: EdgeInsets.only(right: 10),
							child: SizedBox(
								width: 24,
								height: 24,
								child: Checkbox(
									value: isSelected,
									onChanged: (flag) {
										if(flag){
											selectedDevices.add(device.deviceId);
										}else{
											selectedDevices.removeWhere((deviceId) => deviceId == device.deviceId);
										}
										setState(() {
											isSelected = flag;
										});
									}
								),
							),
						)

					],
				)
			)

		);
	}
}