import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/ui_common.dart';
import '../model/notice_model.dart';
import '../service/community_service.dart';
import '../common/style.dart';
import 'package:getwidget/getwidget.dart';


class FaqScreen extends StatefulWidget {
	final noticeTypeCode;
	FaqScreen({
		Key key,
		this.noticeTypeCode
	}): super(key: key);

	@override
	_FaqPage createState() => _FaqPage();
}

class _FaqPage extends State < FaqScreen > {
	final GlobalKey < ScaffoldState > _scaffoldKey = new GlobalKey < ScaffoldState > ();

	int _pageNum = 1;
	int _listCount = 15;
	int _totalCount = 100000000;
 	// ignore: unused_field
	dynamic _searchCondition;
	List < NoticeModelNoticeList > _items = [];
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
						'FAQ',
						style: TextFont.big_n,
					),
					backgroundColor: BgColor.white,
				),
				body : 	Container(
					padding: EdgeInsets.all(20),
					child: Column(
						children: [
							Expanded(
								child: (_totalCount == 0) ? UICommon.displayNoDataFound(context: context) :
								ListView.builder(
									controller: _scrollController,
									itemCount: _items.length + 1,
									itemBuilder: (context, index) {
										if (index == _items.length) {
											return _buildProgressIndicator();
										} else {
											return _buildDataWidget(context, _items[index]);
										}
									},
								),
							)
						]
					),
				)
			)
		);
	}


	/// 검색 다이얼로그 창에서 검색한 결과 콜백 함수 
 	// ignore: unused_element
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
	Widget _buildDataWidget(BuildContext context, data) {
		return Column(
			children: [
				_buildFaqInfo(context, data)
			]
		);
	}


	/// 데이터 조회 (페이징 처리)
	_getPageData() async {
		if (!isPerformingRequest) {
			print("_getPageData  _pageNum : $_pageNum  _listCount : $_listCount  _totalCount : $_totalCount");

			setState(() => isPerformingRequest = true);

			final _comunityService = CommunityService();
			NoticeModel dataModel = await _comunityService.getNoticeList(context, widget.noticeTypeCode, _pageNum, _listCount);
			
			List < NoticeModelNoticeList > newEntries;
			if (dataModel == null || dataModel.noticeList == null) {
				newEntries = [];
			} else {
				newEntries = dataModel.noticeList;
				if (dataModel.totalCount != null) {
					_totalCount = dataModel.totalCount; // 전체 카운트 설정
				} else {
					_totalCount = dataModel.noticeList.length;
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

			print("_getPageData  _totalCount : $_totalCount");

			setState(() {
				_items.addAll(newEntries);
				isPerformingRequest = false;
			});
		}
	}
}


/// 하나의 Row 표시 위젯
Widget _buildFaqInfo(context, NoticeModelNoticeList notice) {
	DateFormat _displayDateTimeFommater = DateFormat("yyyy-MM-dd");
	//DateFormat _displayDateTimeFommater = DateFormat("yyyy-MM-dd HH:mm");

	var noticeDateTime = _displayDateTimeFommater.format(DateTime.fromMillisecondsSinceEpoch(notice.bbsCreDt));
	return Container(
		padding: EdgeInsets.all(0),
		decoration: BoxDecoration(
			border: BorderDirectional(
				bottom: BorderSide(
					color: Color.fromRGBO(112, 112, 112, 0.25),
					style: BorderStyle.solid),
			),
		),
		child: Column(
			children: < Widget > [
				GFAccordion(
					contentPadding: EdgeInsets.all(20),
					titlePadding: EdgeInsets.all(20),
					margin: EdgeInsets.all(0),
					title: notice.bbsTitle, // 제목
					titleChild: Container(
						padding: EdgeInsets.all(10),
						decoration: BoxDecoration(
							color: BgColor.white
						),
					),
					textStyle: TextFont.medium,
					contentChild: Text(notice.bbsContent, style: TextFont.normal, ), // 내용
					collapsedIcon: Text(noticeDateTime, style: TextFont.normal_g, ),
					expandedIcon: Text(noticeDateTime, style: TextFont.normal_g, ),
				),
			],
		),
	);
}