import 'dart:convert';

import 'package:flutter/material.dart';
import '../common/ui_common.dart';
import '../model/delivery_model.dart';
import '../service/facility_service.dart';
import '../common/style.dart';

class DeliveryScreen extends StatefulWidget {
	DeliveryScreen({
		Key key,
		this.title
	}): super(key: key);
	final String title;
	@override
	_DeliveryPage createState() => _DeliveryPage();
}

class _DeliveryPage extends State < DeliveryScreen > {

	final GlobalKey < ScaffoldState > _scaffoldKey = new GlobalKey < ScaffoldState > ();

	int _pageNum = 1;
	int _listCount = 15;
	int _totalCount = 100000000;
	dynamic _searchCondition;
	List < DeliveryModelParcelList > _items = [];
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
						'택배 조회',
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
                      return DeliveryFilterPop(callBack: _searchCallBack);
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
												return _buildDataWidget(context, _items[index], _doRemoveDelivery);
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
				_buildDeliveryInfo(context, data, callback)
			]
		);
	}


	/// 데이터 조회 (페이징 처리)
	_getPageData() async {
		if (!isPerformingRequest) {
			print("_getPageData  _pageNum : $_pageNum  _listCount : $_listCount  _totalCount : $_totalCount");

			setState(() => isPerformingRequest = true);

			final _facilityService = FacilityService();
			DeliveryModel dataModel = await _facilityService.getDeliveryList(context,  _pageNum, _listCount, _searchCondition);

			List<DeliveryModelParcelList> newEntries;
			if (dataModel == null || dataModel.parcelList == null){
				newEntries = [];
			}else{
				newEntries = dataModel.parcelList;
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
										child: Container(
											child: Text(
												'택배함 No',
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
										child: Container(
											child: Text(
												'택배사',
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
										child: Container(
											child: Text(
												'확인',
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
	_doRemoveDelivery(dynamic parcelModel) async {
		bool isSuccess = await _facilityService.removeDelivery(context, parcelModel);
		if (isSuccess) {
			// _items 리스트에서 제거
			_items.removeWhere((data) => data.parcelGetId == parcelModel.parcelGetId);
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


//DateFormat _dateTimeFommater = DateFormat("yyyy-MM-dd HH:mm");
FacilityService _facilityService = FacilityService();

/// 택배 하나의 Row 표시 위젯 (TableRow)
TableRow _buildDeliveryInfo(context, DeliveryModelParcelList parcelModel, Function callback) {

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
							parcelModel.parcelStatus, // 구분 (택배도착/ 택배수령) 
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
							parcelModel.parcelBoxNo, // 택배함 번호
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
							parcelModel.parcelCompany, // 택배사
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
							parcelModel.confirmYn == "Y" ? "확인" : "미확인", // 확인여부
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
									callback(parcelModel); //_doRemoveVisitingCar
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
class DeliveryFilterPop extends StatefulWidget {
	final Function(dynamic) callBack;
	DeliveryFilterPop({
		Key key,
		this.callBack
	}): super(key: key);
	@override
	_DeliveryFilter createState() => _DeliveryFilter();
}

class _DeliveryFilter extends State < DeliveryFilterPop > {
	final _formKey = GlobalKey < FormState > ();
	RadioItems _arrivalStatus = RadioItems.arrivalAll;
	RadioItems _confirmStatus = RadioItems.confirmAll;

	Widget build(BuildContext context) {
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
																groupValue: _arrivalStatus,
																value: RadioItems.arrivalAll,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_arrivalStatus = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '도착',
																padding: EdgeInsets.all(0),
																groupValue: _arrivalStatus,
																value: RadioItems.arrivalArv,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_arrivalStatus = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '수령',
																padding: EdgeInsets.all(0),
																groupValue: _arrivalStatus,
																value: RadioItems.arrivalRcv,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_arrivalStatus = newValue;
																	});
																},
															)
														],
													),
												)
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
														'확인',
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
																groupValue: _confirmStatus,
																value: RadioItems.confirmAll,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_confirmStatus = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '미확인',
																padding: EdgeInsets.all(0),
																groupValue: _confirmStatus,
																value: RadioItems.confirmNo,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_confirmStatus = newValue;
																	});
																},
															),
															LabeledRadio(
																label: '확인',
																padding: EdgeInsets.all(0),
																groupValue: _confirmStatus,
																value: RadioItems.confirmYes,
																onChanged: (RadioItems newValue) {
																	setState(() {
																		_confirmStatus = newValue;
																	});
																},
															)
														],
													),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width/2-50,
              decoration: BoxDecoration(
                color: BgColor.lgray
              ),
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
              width: MediaQuery.of(context).size.width/2-50,
              decoration: BoxDecoration(
                color: BgColor.main
              ),
              child: FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text(
                  '검색',
                  style: TextFont.medium_w
                ),
                onPressed: () {
                  print("_arrivalStatus : $_arrivalStatus   _confirmStatus : $_confirmStatus");

                  Map < String, dynamic > seachValue = {};
                  if (_arrivalStatus == RadioItems.arrivalArv) {
                    seachValue["parcelStatus"] = "택배도착";
                  } else if (_arrivalStatus == RadioItems.arrivalRcv) {
                    seachValue["parcelStatus"] = "택배수령";
                  }

                  if (_confirmStatus == RadioItems.confirmNo) {
                    seachValue["isConfirm"] = true;
                  } else if (_arrivalStatus == RadioItems.arrivalRcv) {
                    seachValue["isConfirm"] = false;
                  }
                  widget.callBack(seachValue);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ]
        )
      ],
		);
	}
}


enum RadioItems {
	arrivalAll,
	arrivalArv,
	arrivalRcv,
	confirmAll,
	confirmYes,
	confirmNo
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