import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/globals.dart';
import '../common/ui_common.dart';
import '../model/car_in_out_model.dart';
import '../service/facility_service.dart';
import '../common/style.dart';

class CarInOutScreen extends StatefulWidget {
	CarInOutScreen({
		Key key,
		this.title
	}): super(key: key);
	final String title;
	@override
	_CarInOutPage createState() => _CarInOutPage();
}

class _CarInOutPage extends State < CarInOutScreen > {
	final GlobalKey < ScaffoldState > _scaffoldKey = new GlobalKey < ScaffoldState > ();

	int _pageNum = 1;
	int _listCount = 15;
	int _totalCount = 100000000;
	dynamic _searchCondition;
	List < CarInOutModelParkingControlList > _items = [];
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
						'입출차 조회',
						style: TextFont.big_n,
					),
					backgroundColor: BgColor.white,
					actions: < Widget > [
						SizedBox(
							width: 40,
							height: 40,
							child: IconButton(
								icon: Image.asset(
									"assets/images/filter.png",
									fit: BoxFit.fitHeight,
								),
								tooltip: 'user',
								onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext newContext) {
                      return CarInOutFilterPop(callBack: _searchCallBack);
                    },
                  );
                },
							),
						)
					],
				),
				body: Container(
					padding: EdgeInsets.all(20),
						child: Column(
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
												return _buildDataWidget(context, _items[index], _doRemoveCarInOut);
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


	/// 검색 다이얼로그 창에서 검색한 결과 콜백 함수 
	_searchCallBack(dynamic searchCondition) {
		print("_searchCallBack :  searchCondition : ${json.encode(searchCondition)}");
		// setState(() {
			
		// });

		_pageNum = 1;
		_searchCondition = searchCondition;
		_items = [];
		_getPageData();
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
				_buildCarInOutInfo(context, data, callback)
			]
		);
	}


	/// 데이터 조회 (페이징 처리)
	_getPageData() async {
		if (!isPerformingRequest) {
			print("_getPageData  _pageNum : $_pageNum  _listCount : $_listCount  _totalCount : $_totalCount");

			setState(() => isPerformingRequest = true);

			final _facilityService = FacilityService();
			CarInOutModel dataModel = await _facilityService.getCarInOutList(context,  _pageNum, _listCount, _searchCondition);

			List<CarInOutModelParkingControlList> newEntries;
			if (dataModel == null || dataModel.parkingControlList == null){
				newEntries = [];
			}else{
				newEntries = dataModel.parkingControlList;
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
												'구분',
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
												'일시',
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
												'별칭',
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
	_doRemoveCarInOut(dynamic inOutModel) async {
		bool isSuccess = await _facilityService.removeCarInOut(context, inOutModel);
		if (isSuccess) {
			// _items 리스트에서 제거
			_items.removeWhere((data) => data.id == inOutModel.id);
			UICommon.showSnackBarMessage(_scaffoldKey.currentState, '삭제 하였습니다.');
			setState(() {}); // Data 다시 조회 처리
		} else {
			UICommon.showSnackBarMessage(_scaffoldKey.currentState, '실패 하였습니다.');
		}
	}

}

dynamic _columnWidths = {
	0: FixedColumnWidth(65),
	1: FlexColumnWidth(3),
	2: FlexColumnWidth(4),
	3: FlexColumnWidth(3),
	4: FixedColumnWidth(55),
};


DateFormat _displayDateTimeFommater = DateFormat("yyyy-MM-dd HH:mm");
FacilityService _facilityService = FacilityService();

dynamic _inOutTypeMap = {
	"AMA001": "입차",
	"AMA002": "출차",
	"AMA003": "방문입차",
	"AMA004": "방문출차",
};

/// 입출차 하나의 Row 표시 위젯 (TableRow)
TableRow _buildCarInOutInfo(context, CarInOutModelParkingControlList inOutModel, Function callback) {

	var inOutDateTime = _displayDateTimeFommater.format(DateTime.fromMillisecondsSinceEpoch(inOutModel.inoutCreDt));
	String inOutType = _inOutTypeMap[inOutModel.inoutType];

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
							inOutModel.carNo, // 차량번호
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
							inOutType, // 입출 구분
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
							inOutDateTime, // 입출 시간 
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
							inOutModel.carAlias == null? "" : inOutModel.carAlias, // 별칭
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
									callback(inOutModel); //_doRemoveInOutingCar
								}
							},
						)
					)
				)
			)
		]
	);
}


/// 검색 다이얼로그 
class CarInOutFilterPop extends StatefulWidget {
	final Function(dynamic) callBack;
	CarInOutFilterPop({
		Key key,
		this.callBack
	}): super(key: key);
	@override
	_CarInOutFilter createState() => _CarInOutFilter();
}

class _CarInOutFilter extends State < CarInOutFilterPop > {
	final _formKey = GlobalKey < FormState > ();
	RadioItems _inOutType = RadioItems.typeAll;

	DateTime _startDateTime;
	DateTime _endDateTime;
	String _startInOutDate = "";
	String _endInOutDate = "";
	DateFormat dateFommater = DateFormat(DATE_FORMAT);

	Widget build(BuildContext context) {

		if (_startDateTime == null) {
			_endDateTime = DateTime.now();
			_startDateTime = _endDateTime.add(Duration(days: -7)); //검색 시작 일시는 기본적으로 시작일시 7일전 부터로 설정
		}

		if (_startDateTime != null) {
			_startInOutDate = dateFommater.format(_startDateTime);
		}
		if (_endDateTime != null) {
			_endInOutDate = dateFommater.format(_endDateTime);
		}
		if (_startDateTime != null && _endDateTime != null && _endDateTime.difference(_startDateTime).inMinutes < 0) {
			_startDateTime = _endDateTime.add(Duration(days: -1));
		}

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
					'검색 필터',
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
										margin: EdgeInsets.only(bottom: 10, ),
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
														'구분',
														style: TextFont.medium,
													)
												),
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.center,
														mainAxisAlignment: MainAxisAlignment.start,
														children: < Widget > [
															LabeledRadio(
																label: '전체',
																padding: EdgeInsets.all(0),
																groupValue: _inOutType,
																value: RadioItems.typeAll,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_inOutType = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '입차',
																padding: EdgeInsets.all(0),
																groupValue: _inOutType,
																value: RadioItems.typeIn,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_inOutType = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '출차',
																padding: EdgeInsets.all(0),
																groupValue: _inOutType,
																value: RadioItems.typeOut,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_inOutType = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '방문입차',
																padding: EdgeInsets.all(0),
																groupValue: _inOutType,
																value: RadioItems.typeVisitIn,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_inOutType = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '방문출차',
																padding: EdgeInsets.all(0),
																groupValue: _inOutType,
																value: RadioItems.typeVisitOut,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_inOutType = newValue;
																	});
																},
															)
														],
													),
												),
											]
										),
									),


									Container(
										margin: EdgeInsets.only(bottom: 10, ),
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
														'시작일',
														style: TextFont.medium,
													)
												),
												Expanded(
                          child : Container (
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
                                      firstDate: DateTime(DateTime.now().year - 5), // 시작일
                                      lastDate: DateTime(DateTime.now().year + 5), // 마지막일
                                      builder: (BuildContext context, Widget child) {
                                        return Theme(
                                          data: ThemeData.dark(), // 다크테마
                                          child: child,
                                        );
                                      },
                                    );
                                    selectedDate.then((dateTime) {
                                      setState(() {
                                        _startDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, _startDateTime.hour, _startDateTime.minute);
                                        _startInOutDate = dateFommater.format(_startDateTime);
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 16),
                                    child: Text(
                                      _startInOutDate,
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
														'종료일',
														style: TextFont.medium,
													)
												),
                        Expanded(
                          child: Container(
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
                                      initialDate: _endDateTime,
                                      firstDate: _startDateTime, // 시작일
                                      lastDate: DateTime.now(), // 마지막일
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
                                        _endInOutDate = dateFommater.format(_endDateTime);
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15, bottom: 16),
                                    child: Text(
                                      _endInOutDate,
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
								child: Text(
									'검색',
									style: TextFont.medium_w
								),
								onPressed: () {
									print("_inOutType : $_inOutType");

									Map < String, dynamic > seachValue = {};
									if (_inOutType == RadioItems.typeIn) {
										seachValue["inoutType"] = "AMA001";
									} else if (_inOutType == RadioItems.typeOut) {
										seachValue["inoutType"] = "AMA001";
									} else if (_inOutType == RadioItems.typeVisitIn) {
										seachValue["inoutType"] = "AMA003";
									} else if (_inOutType == RadioItems.typeVisitOut) {
										seachValue["inoutType"] = "AMA004";
									}
									if (_startInOutDate != null && _startInOutDate != "") {
										seachValue["inoutCreDtFrom"] = _startInOutDate;
									}
									if (_endInOutDate != null && _endInOutDate != "") {
										seachValue["inoutCreDtTo"] = _endInOutDate;
									}
									widget.callBack(seachValue);
									Navigator.of(context).pop();
								},
							),
						),
					]
				),
			],
		);
	}
}


enum RadioItems {
	typeAll,
	typeIn,
	typeOut,
	typeVisitIn,
	typeVisitOut
}

class LabeledRadio extends StatelessWidget {
	final String label;
	final EdgeInsets padding;
	final RadioItems groupValue;
	final RadioItems value;
	final Function onChanged;

	const LabeledRadio({
		this.label,
		this.padding,
		this.groupValue,
		this.value,
		this.onChanged
	});

	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: () {
				if (value != groupValue) {
					onChanged(value);
				}
			},
			child: Padding(
				padding: padding,
				child: SizedBox(
					width: 185,
					height: 30,
					child: Row(
						children: < Widget > [
							SizedBox(
								width: 20,
								height: 30,
								child: Radio < RadioItems > (
									groupValue: groupValue,
									value: value,
									onChanged: (RadioItems newValue) {
										onChanged(newValue);
									},
								),
							),
							Container(
								margin: EdgeInsets.only(left: 5),
								child: Text(label, style: TextFont.medium),
							)
						],
					),
				)
			),
		);
	}
}