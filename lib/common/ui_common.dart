//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import '../common/style.dart';
//import 'package:loading/indicator/ball_pulse_indicator.dart';
import '../screens/widget/common_wait_indicator.dart';

class UICommon {

	static Map < String, String > deviceIcons = {
		"light": "assets/images/light",
		"gas": "assets/images/gas",
		"aircon": "assets/images/aircon",
		"heating": "assets/images/heating",
		"fan": "assets/images/fan",
		"switch": "assets/images/switch",
		"wallsocket": "assets/images/wallsocket",
		"LIGHTOFF": "assets/images/light",
		"ELEVATOR": "assets/images/elevator",
		"SECURITY": "assets/images/security",
	};

	static Map < String, String > deviceTypeNames = {
		"light": "조명",
		"gas": "가스",
		"aircon": "에어컨",
		"heating": "난방",
		"fan": "환기",
		"switch": "일괄스위치",
		"wallsocket": "대기전력",
		"LIGHTOFF": "일괄소등",
		"ELEVATOR": "엘리베이터호출",
		"SECURITY": "방범설정",
	};

	static Map < String, dynamic > deviceTypeCommands = {
		"light": [
			{
				"command": "power",
				"name": "전원",
				"values": [
					{
						"value": "on",
						"label": "켜기"
					},
					{
						"value": "off",
						"label": "끄기"
					}
				]
			}
		],
		"gas": [
			{
				"command": "power",
				"name": "밸브",
				"values": [
					{
						"value": "on",
						"label": "열림"
					},
					{
						"value": "off",
						"label": "닫힘"
					}
				]
			}
		],
		"aircon": [
			{
				"command": "power",
				"name": "전원",
				"values": [
					{
						"value": "on",
						"label": "켜짐"
					},
					{
						"value": "off",
						"label": "꺼짐"
					}
				]
			},
			{
				"command": "setTemperature",
				"name": "온도",
				"values": [
					{
						"value": "5",
						"label": "MIN"
					},
					{
						"value": "35",
						"label": "MAX"
					}
				]
			},
			{
				"command": "mode",
				"name": "모드",
				"values": [
          {
						"value": "auto",
						"label": "자동",
						"icon" : "auto"
					},
					{
						"value": "cool",
						"label": "냉방",
						"icon" : "cool"
					},
					{
						"value": "dehumidify",
						"label": "제습",
						"icon" : "dehumidify"
					},
					{
						"value": "airwash",
						"label": "송풍",
						"icon" : "airwash"
					}
				]
			},
			{
				"command": "wind",
				"name": "풍량",
				"values": [
					{
						"value": "light",
						"label": "약풍"
					},
					{
						"value": "mid",
						"label": "중풍"
					},
					{
						"value": "pow",
						"label": "강풍"
					},
					{
						"value": "auto",
						"label": "자동"
					}
				]
			}
		],
		"heating": [
			{
				"command": "power",
				"name": "전원",
				"values": [
					{
						"value": "on",
						"label": "켜기"
					},
					{
						"value": "off",
						"label": "끄기"
					}
				]
			},
			{
				"command": "setTemperature",
				"name": "온도",
				"values": [
					{
						"value": "5",
						"label": "MIN"
					},
					{
						"value": "35",
						"label": "MAX"
					}
				]
			},
			{
				"command": "mode",
				"name": "모드",
				"values": [
					{
						"value": "",
						"label": "미사용"
					},
					{
						"value": "in",
						"label": "일반",
						"icon" : "heating"
					},
					{
						"value": "out",
						"label": "외출",
						"icon" : "outmode"
					}
				]
			}
		],
		"fan": [
			{
				"command": "power",
				"name": "전원",
				"values": [
					{
						"value": "on",
						"label": "켜기"
					},
					{
						"value": "off",
						"label": "끄기"
					}
				]
			},
			{
				"command": "level",
				"name": "세기",
				"values": [
					{
						"value": "light",
						"label": "약"
					},
					{
						"value": "middel",
						"label": "중"
					},
					{
						"value": "strong",
						"label": "강"
					}
				]
			}
		],
		"switch": [
			{
				"command": "power",
				"name": "전원",
				"values": [
					{
						"value": "on",
						"label": "켜기"
					},
					{
						"value": "off",
						"label": "끄기"
					}
				]
			}
		],
		"wallsocket": [
			{
				"command": "power",
				"name": "전원",
				"values": [
					{
						"value": "on",
						"label": "켜기"
					},
					{
						"value": "off",
						"label": "끄기"
					}
				]
			},
			{
				"command": "sleep",
				"name": "취침",
				"values": [
					{
						"value": "on",
						"label": "켜기"
					},
					{
						"value": "off",
						"label": "끄기"
					}
				]
			}
		],
		"LIGHTOFF": [
			{
				"command": "power",
				"name": "소등",
				"values": [{
						"value": "on",
						"label": "켜기"
					},
					{
						"value": "off",
						"label": "끄기"
					}
				]
			}
		],
		"ELEVATOR": [
			{
				"command": "power",
				"name": "호출",
				"values": [
					{
						"value": "on",
						"label": "호출"
					},
					{
						"value": "off",
						"label": "취소"
					}
				]
			}
		],
		"SECURITY": [
			{
				"command": "power",
				"name": "방범",
				"values": [
					{
						"value": "on",
						"label": "설정"
					},
					{
						"value": "off",
						"label": "해지"
					}
				]
			}
		],
	};



	static showLoaderDialog(BuildContext context) {
		//showDialog(context: context, builder: (BuildContext context) => ShowLoading());

		Navigator.push(context, MaterialPageRoute(builder: (context) => ShowLoading()));
	}

	static showLoaderSmallDialog(BuildContext context) {
		AlertDialog alert = AlertDialog(
			content: new Row(
				children: [
					CircularProgressIndicator(),
					Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
				],
			),
		);
		showDialog(
			barrierDismissible: false,
			context: context,
			builder: (BuildContext context) {
				return alert;
			},
		);
	}

	static hideLoaderDialog(BuildContext context) {
		Navigator.pop(context);
	}

	static alert(BuildContext context, String message) {
		if (message != null) {
			showDialog(context: context, builder: (BuildContext context) => BaseAlertDialog(message));
			//Navigator.push(context, MaterialPageRoute(builder: (context) => BaseAlertDialog(message)));
		}
	}


	static showMessage(BuildContext context, String message) {
		final snackBar = SnackBar(
			content: Text(message),
			action: SnackBarAction(
				label: '확인',
				onPressed: () {},
			),
			duration: Duration(seconds: 2),
		);
		Scaffold.of(context).showSnackBar(snackBar);
	}

	static showSnackBarMessage(scaffoldState, String message) {
		final snackBar = SnackBar(
			content: Text(message),
			action: SnackBarAction(
				label: '확인',
				onPressed: () {},
			),
			duration: Duration(seconds: 2),
		);
		scaffoldState.showSnackBar(snackBar);
	}


	// static showFlushBar(BuildContext context, String message) {
	// 	Flushbar(
	// 	title:  "알림",
	// 	message:  message,
	// 	duration:  Duration(seconds: 3),              
	// 	)..show(context);
	// }



	static Future < bool > confirmDialog(BuildContext context, String title, String message, String cancelLabel, String confirmLabel) {
		return showDialog < bool > (
			context: context,
			builder: (context) {
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
							title,
							style: TextFont.medium_w,
						),
					),

					content: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: < Widget > [
                Container(
                  width:260,
                  child: Text(
                    message,
                    style: TextFont.semibig,
                    textAlign: TextAlign.center,
                  ),
                )
              ]
            )
          ),

					actions: < Widget > [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/2-50,
                    decoration: BoxDecoration(
                      color: BgColor.lgray
                    ),
                    child: FlatButton(
                      onPressed: () {
											  Navigator.of(context).pop(false);
                      },
                      child: Text(
                        cancelLabel == "" ? "취소" : cancelLabel,
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
                      child: Text(
                        confirmLabel == "" ? "확인" : confirmLabel,
                        style: TextFont.medium_w
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ]
              )
            ),
					],
				);
			},
		);
	}

	static Widget displayNoDataFound({context, message}) {
		return Container(
			width: double.infinity,
      decoration: BoxDecoration(
        color:BgColor.white
      ),
			constraints: BoxConstraints(minHeight: 30),
			padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom:30,),
			child: Text(
				message == null? "조회된 데이타가 없습니다." : message,
				style: TextFont.semibig,
				textAlign: TextAlign.center,
			)
		);
	}
}

class BaseAlertDialog extends StatelessWidget {
	final String message;
	BaseAlertDialog(this.message);
	@override
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
          '확인메세지',
          style: TextFont.medium_w,
        ),
      ),

      content: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: < Widget > [
            Container(
              width:260,
              child: Text(
                message,
                style: TextFont.semibig,
                textAlign: TextAlign.center,
              ),
            )
          ]
        )
      ),

			actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
              color: BgColor.main
            ),
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              onPressed: () {
              Navigator.of(context).pop();
              },
              child: Text(
                '확인',
                style: TextFont.medium_w
              ),
            ),
          ),
        ),
			],
		);
	}
}


class ShowLoading extends StatefulWidget {
	@override
	_ShowLoading createState() => _ShowLoading();
}
class _ShowLoading extends State < ShowLoading > {

	@override
	void dispose() {
		super.dispose();
		//AnimationController.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			color: Colors.white,
			child: Center(
				child: Loading(indicator: CommonWaitIndicator(), size: 70.0, color: Colors.orange),
			),
		);

		// return new Scaffold(
		// 	body: Center(
		// 		child: Loading(indicator: BallPulseIndicator(), size: 70.0, color: Colors.orange),
		// 	)
		// );
	}
}
