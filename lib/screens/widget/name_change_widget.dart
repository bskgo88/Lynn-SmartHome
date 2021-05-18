import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user_home_bloc.dart';
import '../../common/validation.dart';
import '../../service/config_service.dart';
import '../../common/style.dart';


// ignore: non_constant_identifier_names
Future < bool > DeviceNameChangeDialog(BuildContext context, String deviceId, String oldDeviceName, dynamic locationId) async {
	final _configService = ConfigService();
	String deviceName;
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();

	UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

	return showDialog < bool > (
		context: context,
		builder: (context) {
			return AlertDialog(
				title: Text('기기 이름 변경'),
				content: SingleChildScrollView(
					child: Column(
						children: [
							Form(
								key: _formKey,
								child:
								TextFormField(
									decoration: InputDecoration(
										filled: true,
										//labelText: '등록하실 공간명을 입력하세요',
										fillColor: BgColor.white,
									),
									initialValue: oldDeviceName,
									validator: Validation.checkEmpty,
									onSaved: (String newDeviceName) {
										deviceName = newDeviceName;
									},
								),
							),
						]
					),
				),
				actions: < Widget > [
					FlatButton(
						child: Text('취소'),
						onPressed: () {
							Navigator.pop(context);
						},
					),
					FlatButton(
						child: Text('수정'),
						onPressed: () async {
							if (_formKey.currentState.validate()) {
								_formKey.currentState.save();
								dynamic success = await _configService.doChangeDeviceInfo(context, deviceId, deviceName, locationId);
								if (success) {
									userHomeBloc.add(StatusChangedEvent(deviceId: deviceId, statusName: "deviceName", statusValue: deviceName));
									Navigator.of(context).pop(true);
								} else {
									Navigator.of(context).pop(false);
								}
							}
						},
					)
				],
			);
		},
	);
}


// ignore: non_constant_identifier_names
Future < bool > LocationNameChangeDialog(BuildContext context, dynamic locationId, String oldLocationName) async {
	final _configService = ConfigService();
	String locationName;
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();

	UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

	return showDialog < bool > (
		context: context,
		builder: (context) {
			return AlertDialog(
				title: Text('공간 이름 변경'),
				content: SingleChildScrollView(
					child: Column(
						children: [
							Form(
								key: _formKey,
								child:
								TextFormField(
									decoration: InputDecoration(
										filled: true,
										fillColor: BgColor.white,
									),
									initialValue: oldLocationName,
									validator: Validation.checkEmpty,
									onSaved: (String newLocationName) {
										locationName = newLocationName;
									},
								),
							),
						]
					),
				),
				actions: < Widget > [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: BgColor.lgray
                ),
                width: 145,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    '취소',
                    style: TextFont.medium
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: BgColor.main
                ),
                width: 145,
                child: FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      dynamic success = await _configService.doChangeLocation(context, locationId, locationName);
                      if (success) {
                        userHomeBloc.add(HomeLocationsChangedEvent(changeMode: "MODIFY", locationId: locationId, locationName: locationName));
                        Navigator.of(context).pop(true);
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    }
                  },
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    '수정',
                    style: TextFont.medium_w
                  ),
                ),
              ),
            ]
          ),
				],
			);
		},
	);
}


// ignore: non_constant_identifier_names
Future < bool > RoutineNameChangeDialog(BuildContext context, dynamic routineId, String oldRoutineName) async {
	final _configService = ConfigService();
	String routineName;
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();

	UserHomeBloc userHomeBloc = BlocProvider.of < UserHomeBloc > (context);

	return showDialog < bool > (
		context: context,
		builder: (context) {
			return AlertDialog(
				title: Text('루틴 이름 변경'),
				content: SingleChildScrollView(
					child: Column(
						children: [
							Form(
								key: _formKey,
								child:
								TextFormField(
									decoration: InputDecoration(
										filled: true,
										fillColor: BgColor.white,
									),
									initialValue: oldRoutineName,
									validator: Validation.checkEmpty,
									onSaved: (String newRoutineName) {
										routineName = newRoutineName;
									},
								),
							),
						]
					),
				),
				actions: < Widget > [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: BgColor.lgray
                ),
                width: 145,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    '취소',
                    style: TextFont.medium
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: BgColor.main
                ),
                width: 145,
                child: FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      dynamic success = await _configService.doChangeRoutine(context, routineId, routineName);
                      if (success) {
                        userHomeBloc.add(HomeRoutineChangedEvent(changeMode: "MODIFY", routineId: routineId, routineName: routineName));
                        Navigator.of(context).pop(true);
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    }
                  },
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    '수정',
                    style: TextFont.medium_w
                  ),
                ),
              ),
            ]
          ),
				],
			);
		},
	);
}