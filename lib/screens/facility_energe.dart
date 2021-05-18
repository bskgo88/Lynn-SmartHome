import 'package:flutter/material.dart';
import '../common/ui_common.dart';
import '../model/ems_usage_model.dart';
import '../model/user_home_model.dart';
import '../service/facility_service.dart';
import '../common/style.dart';
import '../common/globals.dart';
import 'package:charts_flutter/flutter.dart'
as charts;
import 'package:getwidget/getwidget.dart';


//import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart';


List < Map < String, String > > energyTypeList = [{
		"typeCode": "ELEC",
		"typeValue": "전기"
	},
	{
		"typeCode": "GAS",
		"typeValue": "가스"
	},
	{
		"typeCode": "WATER",
		"typeValue": "수도"
	},
	{
		"typeCode": "HOTWATER",
		"typeValue": "온수"
	},
	{
		"typeCode": "HEATING",
    "typeValue": "난방"
	}
];

class FacilityEnergeScreen extends StatefulWidget {
	final UserHomeModel userHomeModel;
	FacilityEnergeScreen({
		Key key,
		this.userHomeModel
	}): super(key: key);

	@override
	FacilityEnergeScreenItem createState() => FacilityEnergeScreenItem();
}

class FacilityEnergeScreenItem extends State < FacilityEnergeScreen > {

	int _defaultIndex = 0;

	@override
	void initState() {
		super.initState();

		// 단지별 설정된 에너지 구분 (사용가능한 에너지 현황) 목록을 설정한다.
		List<UserHomeModelVillageEmstypes> emstypes = widget.userHomeModel.village.emstypes;
		if(emstypes != null && emstypes.length > 0){
			energyTypeList = [];
			for(var emstype in emstypes){
				Map < String, String > ems = {};
				ems["typeCode"] = emstype.ems.code; 
				ems["typeValue"] = emstype.ems.codeName; 

				//print("FacilityEnergeScreenItem ems typeCode : ${emstype.ems.code}   typeValue : ${emstype.ems.codeName} ");
				energyTypeList.add(ems);
			}
		}
	}

	@override
	Widget build(BuildContext context) {


		return DefaultTabController(
			length: energyTypeList.length, // 탭 갯수
			initialIndex: _defaultIndex, // 기본적으로 보여지는 탭 인텍스
			child: Scaffold(
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
						'에너지 현황',
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

										tabs: _buildEnergyTypesTabs(context) // 에너지 구분 탭 표시

									),
								)
							)
					),
				),

				body: TabBarView(

					//에너지 구군 별 에너지 현황 페이지 표시
					children: _buildEnergyTypesDetail(context)

				),
			)
		);
	}



	/// 에너지 현황 상세 - 이번달 사용량, 사용량 비교
	List < Widget > _buildEnergyTypesDetail(BuildContext context) {
		//print("_buildEnergyTypesDetail tab index : $index");
		return energyTypeList.map((energyType) {
			//print("energyType : $energyType");
			dynamic searchCondition = {
				"energyType": energyType["typeCode"]
			};
			final _facilityService = FacilityService();
			return FutureBuilder < EmsUsageModel > (
				future: _facilityService.getEnergyUsageList(context, searchCondition),
				builder: (context, snapShot) {
					if (snapShot.connectionState == ConnectionState.waiting) {
						return ShowLoading();
					} else {
						if (snapShot.data == null) {
							return UICommon.displayNoDataFound(context: context);
						}
						return EnergeDetailWidget(energyTypeCode: energyType["typeCode"], emsUsageModel: snapShot.data);
					}
				},
			);

		}).toList();
	}

}



/// 에너지 현황 상단 탭 표시
List < Widget > _buildEnergyTypesTabs(BuildContext context) {
	return energyTypeList.map((energyType) {
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





/// 에너지 현황 상세 페이지 
class EnergeDetailWidget extends StatefulWidget {
	final energyTypeCode;
	final EmsUsageModel emsUsageModel;
	EnergeDetailWidget({
		Key key,
		this.energyTypeCode,
		this.emsUsageModel
	}): super(key: key);
	@override
	EnergeDetailWidgetState createState() => EnergeDetailWidgetState();
}

class EnergeDetailWidgetState extends State < EnergeDetailWidget > {

	String _period = "YEAR";

	@override
	Widget build(BuildContext context) {

		return Container(
			constraints: BoxConstraints.expand(),
			decoration: BoxDecoration(color: BgColor.lgray),
			child: SingleChildScrollView(
				child: Column(
					children: [
						Container(
							padding: EdgeInsets.all(15),
							width: double.infinity,
							decoration: BoxDecoration(
								color: BgColor.white
							),
							child: Column(
								children: [
									Container(
										width: double.infinity,
										child: Text(
											'이번 달 사용량',
											style: TextFont.big,
										),
										margin: EdgeInsets.only(bottom: 10, ),
									),
									Container(
										width: double.infinity,
										decoration: BoxDecoration(
											border: Border.all(width: 1, color: BgColor.lgray)
										),
										padding: EdgeInsets.all(10),
										child: Row(
											crossAxisAlignment: CrossAxisAlignment.center,
											mainAxisAlignment: MainAxisAlignment.start,
											children: [
												Container(
													child: Text(
														"${widget.emsUsageModel.thisMonthUsage}", // 이번달 사용량
														style: TextFont.big,
													),
													margin: EdgeInsets.only(right: 5, )
												),
												Container(
													child: Text(
														widget.energyTypeCode == "ELEC"? "Kwh" : "㎥",
														style: TextFont.normal,
													),
												)
											],
										),
									)
								],
							),
						),

						Container(
							margin: EdgeInsets.only(top: 10, ),
							padding: EdgeInsets.all(15),
							width: double.infinity,
							decoration: BoxDecoration(
								color: BgColor.white
							),
							child: Column(
								children: [
									Container(
										width: double.infinity,
										child: Text(
											"사용량 비교 ("+ (widget.energyTypeCode == "ELEC"? "Kwh" : "㎥") + ")",
											style: TextFont.big,
										),
										margin: EdgeInsets.only(bottom: 10, ),
									),
									Container(
										width: double.infinity,
										padding: EdgeInsets.all(10),
										decoration: BoxDecoration(
											border: Border.all(width: 1, color: BgColor.lgray)
										),
										child: Row(
											children: [
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.center,
														mainAxisAlignment: MainAxisAlignment.center,
														children: [
															Container(
																child: Text(
																	'전월',
																	style: TextFont.big_n,
																),
															),
															Container(
																child: Text(
																	"${widget.emsUsageModel.lastMonthUsage}", // 전월 사용량
																	style: TextFont.big_lb,
																),
															)
														],
													),
												),
												Container(
													child: Container(
														width: 1,
														height: 35,
														decoration: BoxDecoration(
															color: BgColor.rgray,
														),
													)
												),
												Expanded(
													child: Column(
														crossAxisAlignment: CrossAxisAlignment.center,
														mainAxisAlignment: MainAxisAlignment.center,
														children: [
															Container(
																child: Text(
																	'전년 동월',
																	style: TextFont.big_n,
																),
															),
															Container(
																child: Text(
																	"${widget.emsUsageModel.lastYearUsage}", // 전년 동월 사용량
																	style: TextFont.big_sb,
																),
															)
														],
													),
												)
											],
										)
									),
								],
							),
						),

						// 에너지 그래프 표시 
						_buildEnergeReportWidget(context, widget.energyTypeCode, _period)


					],
				)
			)
		);

	}



	/// 에너지 그래프  및 상세 테이블 표시 
	Widget _buildEnergeReportWidget(BuildContext context, energyTypeCode, period) {
		//print("_setGraphData  energyType : $energyTypeCode  period : $period");
		dynamic searchCondition = {
			"energyTypeCode": energyTypeCode,
			"period": period
		};
		final _facilityService = FacilityService();
		return FutureBuilder < EmsUsageReportModel > (
			future: _facilityService.getEnergyUsageReportList(context, searchCondition),
			builder: (context, snapShot) {
				if (snapShot.connectionState == ConnectionState.waiting) {
					return ShowLoading();
				} else {
					if (snapShot.data == null) {
						return UICommon.displayNoDataFound(context: context);
					}
					//print("_setGraphData  energyType : $energyTypeCode  period : $period  snapShot.data.usages.length : ${snapShot.data.usages.length}");
					return EnergeReportWidget(energyTypeCode: energyTypeCode, period: period, emsUsageReportModel: snapShot.data, callBack: doChangePeriod);
				}
			},
		);
	}


	doChangePeriod(String period) {
		setState(() {
			_period = period;
		});
	}
}



/// 에너지 현황 그래프 페이지 - 그래프 및 상세 표 
class EnergeReportWidget extends StatefulWidget {
	final energyTypeCode;
	final period;
	final EmsUsageReportModel emsUsageReportModel;
	final Function(String) callBack;
	EnergeReportWidget({
		Key key,
		this.energyTypeCode,
		this.period,
		this.emsUsageReportModel,
		this.callBack,
	}): super(key: key);

	@override
	EnergeReportWidgetState createState() => EnergeReportWidgetState.setGraphData(energyTypeCode, period, emsUsageReportModel);
}

class EnergeReportWidgetState extends State < EnergeReportWidget > {
	final List < charts.Series > seriesList;
	//final List < charts.Series < GraphData,int >> seriesList;
	final bool animate;

	EnergeReportWidgetState(this.seriesList, {this.animate});

	/// Creates a [BarChart] with sample data and no transition.
	factory EnergeReportWidgetState.setGraphData(energyTypeCode, period, emsUsageReportModel) {
		return new EnergeReportWidgetState(
			_setGraphData(energyTypeCode, period, emsUsageReportModel),
			// Disable animations for image tests.
			animate: true,
		);
	}

	int _selectedIndex = 0;

	@override
	Widget build(BuildContext context) {

		int _viewPortNum = 12;
		String _viewPortIndex = "1";
    int _fontSize = 14;
		if(widget.emsUsageReportModel != null && widget.emsUsageReportModel.usages.length > 0){
			_viewPortNum = widget.emsUsageReportModel.usages.length;
			// if(_viewPortNum > 12) _viewPortNum = 12;
			// if(widget.emsUsageReportModel.usages.length > 6){
			// 	_viewPortIndex = (widget.emsUsageReportModel.usages.length -1).toString();
			// }
      if(_viewPortNum > 24) _fontSize = 8;
      else if(_viewPortNum > 20) _fontSize = 9;
      else if(_viewPortNum > 16) _fontSize = 10;
      else if(_viewPortNum > 12) _fontSize = 12;
		}

		if(widget.period == "YEAR") _selectedIndex = 0;
		else _selectedIndex = 1;

		List < bool > _selections = List.generate(2, (_) => false);
		_selections[_selectedIndex] = true;

    var now = new DateTime.now();
    String stdYear = "${now.year}년";
    String stdMonth =  "${now.month}월";
    if(!IS_SERVER_MODE){
      stdYear = "${now.year-1}년";
      stdMonth = "12월";
    }
		return Container(

			child: Column(
				children: [

					Container(
						margin: EdgeInsets.only(top: 10, ),
						width: double.infinity,
						decoration: BoxDecoration(
							color: BgColor.white
						),
						padding: EdgeInsets.all(15),
						child: Column(
							children: [
								Container(
									width: double.infinity,
									margin: EdgeInsets.only(bottom: 15, ),
									child: ToggleButtons(
										fillColor: BgColor.lgray,
										borderColor: BgColor.lgray,
										selectedBorderColor: BgColor.lgray,
										selectedColor: BgColor.main,
										color: BgColor.black45,
										textStyle: TextFont.semibig,
										borderRadius: Radii.radi10,

										children: < Widget > [
											Container(
												alignment: Alignment.center,
												width: 90,
												child: Text('$stdYear'),
											),
											Container(
												alignment: Alignment.center,
												width: 90,
												child: Text('$stdMonth'),
											),
										],
										onPressed: (int index) async {
											setState(() {
												String period = index == 0 ? "YEAR" : "MONTH";
												_selections[index] = true;
												_selectedIndex = index;
												widget.callBack(period);
											});
										},
										isSelected: _selections,
									),
								),
								Container(
									width: double.infinity,
									child: Row(
										children: [
											Container(
												child: Text(
													widget.energyTypeCode == "ELEC"? "Kwh" : "㎥",
													style: TextFont.normal,
												),
											),
											Expanded(
												child: Container(
                          margin: EdgeInsets.only(right: 20, ),
                          child:Text(
                            '검침일에 준하여 사용량 그래프를 표시합니다.',
                            style: TextFont.small,
                            textAlign: TextAlign.right,
                          )
                        )
											)
										],
									),
								),
								Container(
									height: 200,
									width: double.infinity,
									child: new charts.BarChart( // Bar Chart  //child: new charts.LineChart( // Line Chart
										seriesList,
										animate: animate,
										animationDuration: Duration(milliseconds: 500,),
										//defaultRenderer: new charts.LineRendererConfig(includePoints: true), // Line Chart
										behaviors: [
											new charts.SlidingViewport(),
											new charts.PanAndZoomBehavior(),
											new charts.ChartTitle(
												(_selectedIndex == 0? '월' : "일"), 
												titleStyleSpec : charts.TextStyleSpec(fontSize: 14),
												behaviorPosition: charts.BehaviorPosition.bottom, 
												titleOutsideJustification: charts.OutsideJustification.middleDrawArea
											),
										],

										domainAxis: new charts.OrdinalAxisSpec(  //domainAxis: new charts.NumericAxisSpec( // Line Chart 사용시

                      renderSpec: new charts.SmallTickRendererSpec(
                        minimumPaddingBetweenLabelsPx: 0,
                        labelStyle: new charts.TextStyleSpec(
                          fontSize: _fontSize,  // 보여주는 갯수에 따라 폰트크기 다르게 함.
                          color: charts.MaterialPalette.black
                        ),
                        lineStyle: new charts.LineStyleSpec(
                          color: charts.MaterialPalette.black
                        )
                      ),

											viewport: new charts.OrdinalViewport(_viewPortIndex, _viewPortNum), // Bar Chart
											//viewport: new charts.NumericExtents(1, 31), // Line Chart
											//tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 12), // Line Chart
											//tickFormatterSpec: charts.BasicNumericTickFormatterSpec(_formaterDay,),  // 라인차트에서 xAxis 스트링 변환 필요 시 
										),
									)
								)
							],
						)
					),

					Container(
						margin: EdgeInsets.only(top: 10, ),
						padding: EdgeInsets.only(bottom: 20),
						decoration: BoxDecoration(
							color: BgColor.white,
							border: BorderDirectional(
								bottom: BorderSide(
									color: Color.fromRGBO(112, 112, 112, 0.25),
									style: BorderStyle.solid),
							),
						),
						child: Column(

							children: < Widget > [
								GFAccordion(
									margin: EdgeInsets.all(0),
									contentPadding: EdgeInsets.all(15),
									titlePadding: EdgeInsets.all(15),
									expandedTitleBackgroundColor: BgColor.white,
									titleChild: Text(
										'상세보기',
										style: TextFont.big,
									),
									textStyle: TextFont.medium,
									collapsedIcon: Icon(Icons.add),
									expandedIcon: Icon(Icons.minimize),
									contentChild: Container(
										child: Column(
											children: [
												// 테이블 헤더 표시 
												Table(
													border: TableBorder.all(color: BgColor.rgray, width: 1),
													children: < TableRow > [
														TableRow(
															children: < Widget > [
																TableCell(
																	verticalAlignment: TableCellVerticalAlignment.middle,
																	child: Container(
																		decoration: BoxDecoration(
																			color: BgColor.lgray
																		),
																		width: double.infinity,
																		padding: EdgeInsets.all(15),
																		alignment: Alignment.center,
																		child: Container(
																			child: Text(
																				'구분',
																				style: TextFont.medium
																			),
																		)
																	)
																),
																TableCell(
																	verticalAlignment: TableCellVerticalAlignment.middle,
																	child: Container(
																		decoration: BoxDecoration(
																			color: BgColor.lgray
																		),
																		width: double.infinity,
																		padding: EdgeInsets.all(15),
																		alignment: Alignment.center,
																		child: Container(
																			child: Text(
																				'사용량',
																				style: TextFont.medium
																			),
																		)
																	)
																)
															]
														),
													]
												),

												// 테이블 데이타 표시
												Table(
													border: TableBorder.all(color: BgColor.rgray, width: 1),
													children: getGraphDataTable(widget.energyTypeCode, widget.period, widget.emsUsageReportModel)
												)

											]
										)
									),
								),
							],
						),
					),
				],
			)
		);
	}


	/// 그래프 표시 
	static List < charts.Series < GraphData, String >> _setGraphData(String energyTypeCode, String period, EmsUsageReportModel emsUsageReportModel) {
		//print("_setGraphData  energyType : $energyTypeCode  period : $period  emsUsageReportModel : ${emsUsageReportModel.usages}");
		final List < GraphData > data = [];

		if (emsUsageReportModel.usages != null) {
      //int divisor = (emsUsageReportModel.usages.length / 10).round();
			//print("_setGraphData  divisor : $divisor  emsUsageReportModel.usages.length : ${emsUsageReportModel.usages.length}");
			int seq = 1;
			String xLabelType = (period == "YEAR" ? "월" : "일");
			for (var usage in emsUsageReportModel.usages) {
        data.add(GraphData(seq.toString(), usage)); //data.add(GraphData(seq, usage));  // Line Chart 사용시
				seq++;
			}
		}

		return [
			new charts.Series < GraphData, String > (
				id: 'Energy',
				domainFn: (GraphData data, _)  =>data.label,
				measureFn: (GraphData data, _) => data.value,
				data: data,
				labelAccessorFn: (GraphData data, _) => data.value.toString(),
				colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
			)
		];
	}

	// 그래프 하단 상세보기 데이타 표시 
	List < TableRow > getGraphDataTable(String energyTypeCode, String period, EmsUsageReportModel emsUsageReportModel) {
		final List < TableRow > data = [];
		if (emsUsageReportModel.usages != null) {
			int seq = 1;
			String periodLabel = period == "YEAR" ? "월" : "일";
			for (var usage in emsUsageReportModel.usages) {
				data.add(

					TableRow(
						children: < Widget > [
							TableCell(
								verticalAlignment: TableCellVerticalAlignment.middle,
								child: Container(
									width: double.infinity,
									padding: EdgeInsets.all(15),
									alignment: Alignment.center,
									child: Container(
										child: Text(
											"$seq $periodLabel", //  월 또는 일 
											style: TextFont.medium
										),
									)
								)
							),
							TableCell(
								verticalAlignment: TableCellVerticalAlignment.middle,
								child: Container(
									width: double.infinity,
									padding: EdgeInsets.all(15),
									alignment: Alignment.center,
									child: Container(
										child: Text(
											"$usage ", // 사용량
											style: TextFont.medium
										),
									)
								)
							)
						]
					)


				);
				seq++;
			}
		}
		return data;
	}

}


/// Each Graph Bar
class GraphData {
	final String label;
	final double value;
	GraphData(this.label, this.value);
}

// 라인차트 사용 시 X축 라벨 스트링 표현 시
// String _formaterDay(num day) {
//     int value = day.toInt();
//     return '$value 일';
// }

