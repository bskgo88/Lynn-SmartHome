import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../common/ui_common.dart';
import '../model/notice_model.dart';
import '../service/community_service.dart';
import '../common/style.dart';
import 'package:getwidget/getwidget.dart';


List < Map < String, String > > noticeTypeList = [{
		"typeCode": "LYNN",
		"typeValue": "Lynn 공지"
	},
	{
		"typeCode": "HOMENET",
		"typeValue": "홈넷 공지"
	}
];

final GlobalKey < ScaffoldState > _scaffoldKey = new GlobalKey < ScaffoldState > ();

class CommunityNoticeScreen extends StatefulWidget {
	CommunityNoticeScreen({
		Key key,
	}): super(key: key);

	@override
	CommunityNoticeItem createState() => CommunityNoticeItem();
}

class CommunityNoticeItem extends State < CommunityNoticeScreen > {
	int _defaultIndex = 0;
	@override
	Widget build(BuildContext context) {
		// Scaffold is a layout for the major Material Components.
		return DefaultTabController(
			length: 2, // 탭 갯수
			initialIndex: _defaultIndex, // 기본적으로 보여지는 탭 인텍스
			child: Scaffold(
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
						'공지사항',
						style: TextFont.big_n,
					),
					elevation: 0,
					backgroundColor: BgColor.white,
					bottom: PreferredSize(
						preferredSize: const Size.fromHeight(kToolbarHeight),
							child: Container(
								padding: EdgeInsets.only(top: 10),
								color: BgColor.lgray,
								child: Align(
									alignment: Alignment.centerLeft,
									child: TabBar(
										labelPadding: EdgeInsets.all(0),
										isScrollable: true,
										indicatorWeight: 0,
										unselectedLabelColor: BgColor.black,
										labelColor: BgColor.black,
										indicator: BoxDecoration(
											image: DecorationImage(
												image: AssetImage("assets/images/tabbg.png"),
												fit: BoxFit.fitHeight,
											)
										),
										indicatorSize: TabBarIndicatorSize.tab,
										labelStyle: TextFont.big_n,
										unselectedLabelStyle: TextFont.semibig,
										onTap: (index) {
											//print("tab index : $index");
										},

										//  공지사항 탭
										tabs: _buildNoticeTypesTabs(context)

									),
								)
							)
					),
				),
				body: TabBarView(

					children: _buildNoticeTypesDetail(context)

				)
			)
		);
	}



	/// 공지사항 화면 표시
	List < Widget > _buildNoticeTypesDetail(BuildContext context) {
		return noticeTypeList.map((noticeType) {
			return NoticeListScreen(noticeTypeCode: noticeType["typeCode"]);
		}).toList();
	}
}


/// 공지사항 상단 탭 표시
List < Widget > _buildNoticeTypesTabs(BuildContext context) {
	return noticeTypeList.map((energyType) {
		return
		Tab(
			child: Container(
				width: 140,
				alignment: Alignment.center,
				child: Text(
					energyType["typeValue"],
				),
			),
		);
	}).toList();
}


/// 각 공지사항 목록 화면 
class NoticeListScreen extends StatefulWidget {
	final noticeTypeCode;
	NoticeListScreen({
		Key key,
		this.noticeTypeCode
	}): super(key: key);

	@override
	_NoticeListPage createState() => _NoticeListPage();
}

class _NoticeListPage extends State < NoticeListScreen > {
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
		return Container(
			padding: EdgeInsets.all(0),
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
									//return _buildDataWidget(context, _items[index], widget.noticeTypeCode);
									return Column(
										children: [
											NoticeDetailRowWidet(notice: _items[index], noticeTypeCode: widget.noticeTypeCode)
										]
									);
								}
							},
						),
					)
				],
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


/// 데이터 목록의 하나의 Row 표현 위젯 ( ListView Item Builder 에 사용)
class NoticeDetailRowWidet extends StatefulWidget {
	final NoticeModelNoticeList notice;
	final String noticeTypeCode;
	NoticeDetailRowWidet({
		Key key,
		this.notice,
		this.noticeTypeCode,
	}): super(key: key);

	@override
	_NoticeDetailRowState createState() => _NoticeDetailRowState();
}
class _NoticeDetailRowState extends State < NoticeDetailRowWidet > {
	DateFormat _displayDateTimeFommater = DateFormat("yyyy-MM-dd");
	String _bbsContents;
	final _comunityService = CommunityService();
	@override
	Widget build(BuildContext context) {
		if (widget.noticeTypeCode == "LYNN") {
			_bbsContents = widget.notice.bbsContent;
		}

		var noticeDateTime = _displayDateTimeFommater.format(DateTime.fromMillisecondsSinceEpoch(widget.notice.bbsCreDt));
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
						title: widget.notice.bbsTitle, // 제목
						titleChild: Container(
							padding: EdgeInsets.all(10),
							decoration: BoxDecoration(
								color: BgColor.white
							),
						),
						textStyle: TextFont.medium,
						contentChild: _bbsContents != null ? Text(_bbsContents, style: TextFont.normal, ) : _buildWaitaMomentIndicator(), // 내용
						collapsedIcon: Text(noticeDateTime, style: TextFont.normal_g, ),
						expandedIcon: Text(noticeDateTime, style: TextFont.normal_g, ),
						onToggleCollapsed: (isCollapse) async {
							if (isCollapse && widget.noticeTypeCode == "HOMENET" && _bbsContents == null) {
								NoticeModelNoticeList noticeData = await _comunityService.getNoticeDetail(context, widget.noticeTypeCode, widget.notice.bbsId);
								if (noticeData != null) {
									//print("onToggleCollapsed noticeData.bbsContent : ${noticeData.bbsContent}");
									_bbsContents = noticeData.bbsContent;
								} else {
									_bbsContents = "";
								}
								setState(() {});
							}
						}
					),
				],
			),
		);
	}
}


/// 테이블 데이터 가져오는 동안 표시 할 위젯 ( 로딩중)
Widget _buildWaitaMomentIndicator() {
	return new Padding(
		padding: const EdgeInsets.all(8.0),
			child: new Center(
				child: new Opacity(
					opacity: 1.0,
					child: new CircularProgressIndicator(),
				),
			),
	);
}