import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/globals.dart';
import '../common/ui_common.dart';
import '../common/validation.dart';
import '../model/visiting_car_model.dart';
import '../service/facility_service.dart';
import '../common/style.dart';


class VisitingCarScreen extends StatefulWidget {
	VisitingCarScreen({
		Key key,
		this.title
	}): super(key: key);
	final String title;
	@override
	_VisitingCarPage createState() => _VisitingCarPage();
}

class _VisitingCarPage extends State < VisitingCarScreen > {
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

	int _pageNum = 1;
	int _listCount = 15;
	int _totalCount = 100000000;
	List < VisitingCarModelVisitCarList > _items = [];
	bool isPerformingRequest = false;
	ScrollController _scrollController = ScrollController();

	@override
	void initState() {
		super.initState();

		// 최초 로드시에도 데이터 불러온다.
		_getPageData();

		_scrollController.addListener(() {
			//if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
			if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
				_getPageData();
			}
		});
	}

	@override
	void dispose() {
		_scrollController.dispose();
		super.dispose();
	}


	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			home: Scaffold(
				key: _scaffoldKey,
				bottomNavigationBar: Padding(
					padding: EdgeInsets.all(0),
					child: RaisedButton(
						padding: EdgeInsets.all(15),
						onPressed: () {
							showDialog(
								context: context,
								builder: (BuildContext newContext) {
									return VisitingCarPop();
								},
							);
						},
						color: Color.fromARGB(255, 239, 144, 0),
						textColor: Color.fromARGB(255, 255, 255, 255),
						child: Text('방문차량 등록'),
					),
				),
				appBar: AppBar(
					leading: IconButton(
						icon: Icon(
							Icons.arrow_back
						),
						tooltip: 'Navigation menu',
						onPressed: () {
							Navigator.of(context).pop();
						}
					),
					iconTheme: IconThemeData(
						color: Colors.black, //change your color here
					),
					title: Text(
						'방문차량',
						style: TextFont.big_n,
					),
					backgroundColor: BgColor.white,
				),
				body: 
					Container(
					padding: EdgeInsets.all(20),
						child: 
						Column(
							children: [
								
								// 테이블 헤더
								_buildTableHeader(context),

								Expanded (
									child : (_totalCount == 0)? UICommon.displayNoDataFound(context: context) : 
										ListView.builder(
										controller: _scrollController,
										itemCount: _items.length + 1,
										itemBuilder: (context, index) {
											if (index == _items.length) {
												return _buildProgressIndicator();
											} else {
												return _buildDataWidget(context, _items[index], _doRemoveVisitingCar);
											}
										},
									),
								)
							],
						)
				)
			)
		);
	}

	/// 테이블 데이터 가져오는 동안 표시 할 위젯 ( 로딩중)
	Widget _buildProgressIndicator() {
		return new Padding(
			padding: const EdgeInsets.all(8.0),
				child: new Center(
					child: new Opacity(
						opacity: isPerformingRequest ? 1.0 : 0.0,
						child: new CircularProgressIndicator(),
					),
				),
		);
	}


	/// 데이터 목록의 하나의 Row 표현 위젯 ( ListView Item Builder 에 사용)
	Widget _buildDataWidget(BuildContext context, data, callback) {
		return Table(
			border: TableBorder.all(color: BgColor.rgray, width: 1),
			columnWidths: _columnWidths,
			children: [
				_buildVisitingCarInfo(context, data, callback)
			]
		);
	}


	/// 데이터 조회 (페이징 처리)
	_getPageData() async {
		if (!isPerformingRequest) {
			print("_getPageData  _pageNum : $_pageNum  _listCount : $_listCount  _totalCount : $_totalCount");

			setState(() => isPerformingRequest = true);

			final _facilityService = FacilityService();
			VisitingCarModel dataModel = await _facilityService.getVisitingCarList(context, _pageNum, _listCount);

			List<VisitingCarModelVisitCarList> newEntries;
			if (dataModel == null || dataModel.visitCarList == null){
				newEntries = [];
			}else{
				newEntries = dataModel.visitCarList;
				if(dataModel.totalCount != null){
					_totalCount = dataModel.totalCount;  // 전체 카운트 설정
				}
			}

			if (newEntries.isEmpty) {
				if (_pageNum == 1) {
					_totalCount = 0;
				} else {
					double edge = 50.0;
					double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
					if (offsetFromBottom < edge) {
						_scrollController.animateTo(
							_scrollController.offset - (edge - offsetFromBottom),
							duration: new Duration(milliseconds: 500),
							curve: Curves.easeOut);
					}
					UICommon.showSnackBarMessage(_scaffoldKey.currentState, '더 이상 데이타가 없습니다.');
				}
			} else {
				_pageNum++; //페이지 번호 증가시킴
			}

			setState(() {
				_items.addAll(newEntries);
				isPerformingRequest = false;
			});
		}
	}


	/// 화면 데이터 테이블 헤더 정보
	Widget _buildTableHeader(BuildContext context) {
		return Table(
			border: TableBorder.all(color: BgColor.rgray, width: 1),
			columnWidths: _columnWidths,
			children: < TableRow > [
				TableRow(
					decoration: BoxDecoration(
						color: BgColor.lgray
					),
					children: < Widget > [
						TableCell(
							verticalAlignment: TableCellVerticalAlignment.middle,
							child: Container(
								padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
								alignment: Alignment.center,
								child: Container(
									child: Text(
										'차번',
										style: TextFont.medium,
										textAlign: TextAlign.center,
									),
								)
							)
						),
						TableCell(
							verticalAlignment: TableCellVerticalAlignment.middle,
							child: Container(
								padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
								alignment: Alignment.center,
								child: Container(
									child: Text(
										'방문일시',
										style: TextFont.medium,
										textAlign: TextAlign.center,
									),
								)
							)
						),
						TableCell(
							verticalAlignment: TableCellVerticalAlignment.middle,
							child: Container(
								padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
								alignment: Alignment.center,
								child: Container(
									child: Text(
										'종료일시',
										style: TextFont.medium,
										textAlign: TextAlign.center,
									),
								)
							)
						),
						TableCell(
							verticalAlignment: TableCellVerticalAlignment.middle,
							child: Container(
								padding: EdgeInsets.only(top: 15, bottom: 15, left: 5, right: 5),
								alignment: Alignment.center,
								child: Container(
									child: Text(
										'삭제',
										style: TextFont.medium,
										textAlign: TextAlign.center,
									),
								)
							)
						),
					]
				),
			]
		);
	}


	// 선택된 차량의 정보를 가지고 오기 위한 콜백 함수
	_doRemoveVisitingCar(dynamic carModel) async {
		bool isSuccess = await _facilityService.removeVisitingCar(context, carModel);
		if (isSuccess) {
			// _items 리스트에서 제거
			_items.removeWhere((data) => data.id == carModel.id);
			UICommon.showSnackBarMessage(_scaffoldKey.currentState, '삭제 하였습니다.');
			setState(() {}); // Data 다시 조회 처리
		} else {
			UICommon.showSnackBarMessage(_scaffoldKey.currentState, '실패 하였습니다.');
		}
	}

}




dynamic _columnWidths = {
	0: FixedColumnWidth(80),
	1: FlexColumnWidth(),
	2: FlexColumnWidth(),
	3: FixedColumnWidth(60),
};



DateFormat _displayDateTimeFommater = DateFormat("yyyy-MM-dd HH:mm");
FacilityService _facilityService = FacilityService();

/// 방문차량 하나의 Row 표시 위젯 (TableRow)
TableRow _buildVisitingCarInfo(context, VisitingCarModelVisitCarList carModel, Function callback) {
	//print("_visitingCarListView visitingCars.length : ${visitingCars.length}");
	var startVisitDateTime = _displayDateTimeFommater.format(DateTime.fromMillisecondsSinceEpoch(carModel.dateTime));
	var endVisitDateTime = _displayDateTimeFommater.format(DateTime.fromMillisecondsSinceEpoch(carModel.dateTime));

	return TableRow(
		decoration: BoxDecoration(
			color: BgColor.white
		),
		children: < Widget > [
			TableCell(
				verticalAlignment: TableCellVerticalAlignment.middle,
				child: Container(
					padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5, ),
					alignment: Alignment.center,
					child: Container(
						child: Text(
							carModel.carNo, // 차량번호 
							style: TextFont.normal,
							textAlign: TextAlign.center,
						),
					)
				)
			),
			TableCell(
				verticalAlignment: TableCellVerticalAlignment.middle,
				child: Container(
					padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5, ),
					alignment: Alignment.center,
					child: Container(
						child: Text(
							startVisitDateTime, // 방문일시
							style: TextFont.normal,
							textAlign: TextAlign.center,
						),
					)
				)
			),
			TableCell(
				verticalAlignment: TableCellVerticalAlignment.middle,
				child: Container(
					padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5, ),
					alignment: Alignment.center,
					child: Container(
						child: Text(
							endVisitDateTime, //방문종료일시
							style: TextFont.normal,
							textAlign: TextAlign.center,
						),
					)
				)
			),
			TableCell(
				verticalAlignment: TableCellVerticalAlignment.middle,
				child: Container(
					padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5, ),
					alignment: Alignment.center,
					child: Container(
						child: InkWell(
							child: Container(
								width: 24,
								height: 24,
								padding: EdgeInsets.all(8),
								decoration: BoxDecoration(
									color: BgColor.white,
									borderRadius: Radii.radi20,
									boxShadow: [Shadows.fshadow],
								),
								child: Image.asset(
									"assets/images/close.png",
									fit: BoxFit.fitWidth,
								),
							),
							onTap: () async {

								bool isConfirm = await UICommon.confirmDialog(context, "삭제 확인", "해당 건을 삭제 하시겠습니니까?", "취소", "삭제");
								print("isConfirm : $isConfirm");
								if (isConfirm != null && isConfirm) {
									callback(carModel); //_doRemoveVisitingCar
								}
							},
						)
					)
				)
			),
		]
	);
}




//등록화면
class VisitingCarPop extends StatefulWidget {
	VisitingCarPop({
		Key key
	}): super(key: key);
	@override
	_VisitingCarPopup createState() => _VisitingCarPopup();
}

class _VisitingCarPopup extends State < VisitingCarPop > {
	final _formKey = GlobalKey < FormState > ();
	DateTime _startDateTime;
	DateTime _endDateTime;
	String _startVisitDate;
	String _startVisitTime;
	String _endVisitDate;
	String _endVisitTime;
	DateFormat dateFommater = DateFormat(DATE_FORMAT);
	DateFormat timeFommater = DateFormat(TIME_FORMAT);
	DateFormat dateTimeFommater = DateFormat(DATE_TIME_FORMAT);

	VisitingCarModelVisitCarList visitingCarModel = VisitingCarModelVisitCarList();
	final _facilityService = FacilityService();
	Widget build(BuildContext context) {

		if (_startDateTime == null) {
			_startDateTime = DateTime.now();
			_endDateTime = _startDateTime.add(Duration(hours: 8)); //종료일시는 기본적으로 시작일시  8시간 후로 설정
		}

		if (_endDateTime.difference(_startDateTime).inMinutes < 0) {
			_endDateTime = _startDateTime.add(Duration(hours: 8));
		}
		_startVisitDate = dateFommater.format(_startDateTime);
		_startVisitTime = timeFommater.format(_startDateTime);
		_endVisitDate = dateFommater.format(_endDateTime);
		_endVisitTime = timeFommater.format(_endDateTime);

		return AlertDialog(
			titlePadding: EdgeInsets.all(0),
			actionsPadding: EdgeInsets.all(0),
			contentPadding: EdgeInsets.all(0),
			title: Container(
				padding: EdgeInsets.all(15),
				width: double.infinity,
				decoration: BoxDecoration(
					color: BgColor.main
				),
				child: Text(
					'방문차량 등록',
					style: TextFont.medium_w,
				),
			),
			content: SingleChildScrollView(
				padding: EdgeInsets.all(15),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: < Widget > [
						Form(
							key: _formKey,
							child: Column(
								children: < Widget > [
									Container(
                    width: MediaQuery.of(context).size.width,
										child: Row(
											crossAxisAlignment: CrossAxisAlignment.start,
											mainAxisAlignment: MainAxisAlignment.start,
											children: [
												Container(
													width: 80,
													padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
													margin: EdgeInsets.only(right: 15, ),
													decoration: BoxDecoration(
														color: BgColor.lgray
													),
													child: Text(
														'차량번호',
														style: TextFont.medium,
													)
												),
												Expanded(
                          child:Container(
                            margin: EdgeInsets.only(bottom: 10,),
                            decoration: BoxDecoration(
                              color: BgColor.white,
                              border: Border(bottom: BorderSide(width: 1, color: BgColor.black))
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: '차량번호를 입력하세요',
                                  hintStyle: TextFont.medium_g,
                                ),
                                validator: Validation.checkEmpty,
                                onChanged: (value) {
                                  visitingCarModel.carNo = value;
                                },
                            ),
                          )
                        )
											]
										),
									),
									Container(
                    width: MediaQuery.of(context).size.width,
										child: Row(
											crossAxisAlignment: CrossAxisAlignment.start,
											mainAxisAlignment: MainAxisAlignment.start,
											children: [
												Container(
													width: 80,
													padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
													margin: EdgeInsets.only(right: 15, ),
													decoration: BoxDecoration(
														color: BgColor.lgray
													),
													child: Text(
														'방문일시',
														style: TextFont.medium,
													)
												),
												Expanded(
                          child : Container(
                            margin: EdgeInsets.only(bottom: 10, ),
                              decoration: BoxDecoration(
                                color: BgColor.white,
                                border: Border(bottom: BorderSide(width: 1, color: BgColor.black))
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Future < DateTime > selectedDate = showDatePicker(
                                        context: context,
                                        locale: Locale('ko', 'KO'),
                                        initialDate: _startDateTime, // 초기값 
                                        firstDate: DateTime(DateTime.now().year - 1), // 시작일
                                        lastDate: DateTime(DateTime.now().year + 1), // 마지막일
                                        builder: (BuildContext context, Widget child) {
                                          return Theme(
                                            data: ThemeData.dark(), // 다크테마
                                            child: child,
                                          );
                                        },
                                      );
                                      selectedDate.then((dateTime) {
                                        setState(() {
                                          _startDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, _startDateTime.hour, _startDateTime.minute); // 기존 시간 유지하고 날짜만 변경
                                          _startVisitDate = dateFommater.format(_startDateTime);
                                        });
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top: 15, bottom: 16),
                                      width: MediaQuery.of(context).size.width/2-95,
                                      child: Text(
                                        _startVisitDate,
                                        style: TextFont.medium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Future < TimeOfDay > selectedTime = showTimePicker(
                                        cancelText: '취소',
                                        confirmText: '확인',
                                        helpText: '시간 선택',
                                        initialTime: TimeOfDay.fromDateTime(_startDateTime),
                                        context: context,
                                        builder: (BuildContext context, Widget child) {
                                          return Theme(
                                            data: ThemeData.dark(), // 다크테마
                                            child: child,
                                          );
                                        },
                                      );
                                      selectedTime.then((timeOfDay) {
                                        setState(() {
                                          _startDateTime = DateTime(_startDateTime.year, _startDateTime.month, _startDateTime.day, timeOfDay.hour, timeOfDay.minute); // 기존 날짜 유지하고 시간만 변경
                                          _startVisitTime = timeFommater.format(_startDateTime);
                                        });
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top: 15, bottom: 16),
                                      width: MediaQuery.of(context).size.width/2-110,
                                      child: Text(
                                        _startVisitTime,
                                        style: TextFont.medium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          )
                        )
											]
										),
									),
									Container(
                    width: MediaQuery.of(context).size.width,
										child: Row(
											crossAxisAlignment: CrossAxisAlignment.start,
											mainAxisAlignment: MainAxisAlignment.start,
											children: [
												Container(
													width: 80,
													padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
													margin: EdgeInsets.only(right: 15, ),
													decoration: BoxDecoration(
														color: BgColor.lgray
													),
													child: Text(
														'방문종료',
														style: TextFont.medium,
													)
												),
												Expanded(
                          child : Container(
                            margin: EdgeInsets.only(bottom: 10, ),
                            decoration: BoxDecoration(
                              color: BgColor.white,
                              border: Border(bottom: BorderSide(width: 1, color: BgColor.black))
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Future < DateTime > selectedDate = showDatePicker(
                                      context: context,
                                      locale: Locale('ko', 'KO'),
                                      initialDate: _endDateTime, // 초기값 
                                      firstDate: _startDateTime, // 시작일 - 방문시작일보다 같거나 커야 함.
                                      lastDate: DateTime(DateTime.now().year + 1), // 마지막일
                                      builder: (BuildContext context, Widget child) {
                                        return Theme(
                                          data: ThemeData.dark(), // 다크테마
                                          child: child,
                                        );
                                      },
                                    );
                                    selectedDate.then((dateTime) {
                                      setState(() {
                                        _endDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, _endDateTime.hour, _endDateTime.minute); // 기존 시간 유지하고 날짜만 변경
                                        _endVisitDate = dateFommater.format(_endDateTime);
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 16),
                                    width: MediaQuery.of(context).size.width/2-95,
                                    child: Text(
                                      _endVisitDate,
                                      style: TextFont.medium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Future < TimeOfDay > selectedTime = showTimePicker(
                                      cancelText: '취소',
                                      confirmText: '확인',
                                      helpText: '시간 선택',
                                      initialTime: TimeOfDay.fromDateTime(_endDateTime),
                                      context: context,
                                      builder: (BuildContext context, Widget child) {
                                        return Theme(
                                          data: ThemeData.dark(), // 다크테마
                                          child: child,
                                        );
                                      },
                                    );
                                    selectedTime.then((timeOfDay) {
                                      setState(() {
                                        _endDateTime = DateTime(_endDateTime.year, _endDateTime.month, _endDateTime.day, timeOfDay.hour, timeOfDay.minute); // 기존 날짜 유지하고 시간만 변경
                                        _endVisitTime = timeFommater.format(_endDateTime);
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 16),
                                    width: MediaQuery.of(context).size.width/2-110,
                                    child: Text(
                                      _endVisitTime,
                                      style: TextFont.medium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          )
												)
											]
										),
									)
								]
							)
						),
					]
				)
			),
			actions: < Widget > [
				Row(
					children: [
						Container(
							decoration: BoxDecoration(
								color: BgColor.lgray
							),
              width: MediaQuery.of(context).size.width/2-50,
							child: FlatButton(
								onPressed: () {
									Navigator.of(context).pop();
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
              width: MediaQuery.of(context).size.width/2-50,
							child: FlatButton(
								onPressed: () async {
									bool isSuccess = await doAddVisitingCar(context);
									if (isSuccess != null) {
										Navigator.of(context).pop();
									} else { // validation 실패

									}
								},
								textColor: Theme.of(context).primaryColor,
								child: Text(
									'등록',
									style: TextFont.medium_w
								),
							),
						),
					]
				),
			],
		);
	}

	/// 방문차량 등록 처리
	Future < bool > doAddVisitingCar(context) async {
		if (!_formKey.currentState.validate()) {
			return null;
		}
		String _startDateTime = _startVisitDate + " " + _startVisitTime;
		String _endDateTime = _endVisitDate + " " + _endVisitTime;
		print("doAddVisitingCar _startDateTime : $_startDateTime  _endDateTime : $_endDateTime");
		int startTimeStamp = dateTimeFommater.parse(_startDateTime).millisecondsSinceEpoch;
		int endTimeStamp = dateTimeFommater.parse(_endDateTime).millisecondsSinceEpoch;
		print("doAddVisitingCar startTimeStamp : $startTimeStamp  endTimeStamp : $endTimeStamp");
		visitingCarModel.dateTime = startTimeStamp;
		visitingCarModel.dateTimeEnd = endTimeStamp;
		return await _facilityService.addVisitingCar(context, visitingCarModel);
	}
}
