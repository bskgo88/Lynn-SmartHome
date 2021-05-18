import 'package:flutter/material.dart';
import '../common/globals.dart';
import '../common/ui_common.dart';
import '../model/user_home_model.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/style.dart';
import 'home.dart';


class AppInfoScreen extends StatefulWidget {
  final UserHomeModel userHomeModel;
  const AppInfoScreen({
    Key key,
    this.userHomeModel
  }): super(key: key);

  @override
  _AppInfoScreenState createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State < AppInfoScreen > {
  bool isServerMode = IS_SERVER_MODE;
  bool useVibration = USE_VIBRATION;
  dynamic getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    //print("@@@@@@@@ app info versionName : $versionName");
    final prefs = await SharedPreferences.getInstance();
    String vendorToken = prefs.getString('_vendor_token');
    //print("getAppInfo vendorToken : $vendorToken");
    return {
      "appName": appName,
      "versionName": versionName,
      "versionCode": versionCode,
      "vendorToken": vendorToken
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder < dynamic > (
      future: getAppInfo(),
      builder: (context, AsyncSnapshot < dynamic > snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {

          String vendorToken = snapshot.data["vendorToken"];
          bool isHomeNetUser = (vendorToken == null || vendorToken == "") ? false : true;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                '앱 정보',
                style: TextFont.big_n,
              ),
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: BgColor.white,
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(color: BgColor.lgray),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 15,
                        right: 15,
                        bottom: 10,
                      ),
                      child: Text(
                        '일반 정보',
                        style: TextFont.big,
                        textAlign: TextAlign.left,
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: BgColor.white,
                        border: Border(
                          bottom: BorderSide(width: 1, color: BgColor.rgray))),
                      width: double.infinity,
                      child: FlatButton(
                        //padding: EdgeInsets.all(0),
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 15,
                            bottom: 15,
                            right: 20,
                            left: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  "assets/images/info.png",
                                  fit: BoxFit.fitWidth,
                                ),
                                margin: EdgeInsets.only(
                                  right: 15,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data["appName"], // 앱이름 
                                        style: TextFont.semibig,
                                      ),
                                      margin: EdgeInsets.only(
                                        bottom: 2,
                                      )),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "버전 : ${snapshot.data["versionName"]}", // 버전
                                        style: TextFont.normal_g,
                                      ),
                                    ),
                                  ],
                                ))
                            ],
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: BgColor.white,
                        border: Border(
                          bottom: BorderSide(width: 1, color: BgColor.rgray))),
                      width: double.infinity,
                      child: FlatButton(
                        //padding: EdgeInsets.all(0),
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 15,
                            bottom: 15,
                            right: 20,
                            left: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  "assets/images/myuser.png",
                                  fit: BoxFit.fitWidth,
                                ),
                                margin: EdgeInsets.only(
                                  right: 15,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "사용자",
                                        style: TextFont.semibig,
                                      ),
                                      margin: EdgeInsets.only(
                                        bottom: 2,
                                      )),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${globalUser.name} (${globalUser.email})", // 이름 (아이디)
                                        style: TextFont.normal_g,
                                      ),
                                    ),
                                  ],
                                ))
                            ],
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: BgColor.white,
                        border: Border(
                          bottom: BorderSide(width: 1, color: BgColor.rgray))),
                      width: double.infinity,
                      child: FlatButton(
                        //padding: EdgeInsets.all(0),
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 15,
                            bottom: 15,
                            right: 20,
                            left: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  "assets/images/link.png", // set_homenet.png"assets/images/set_mode.png",
                                  fit: BoxFit.fitWidth,
                                ),
                                margin: EdgeInsets.only(
                                  right: 15,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '홈넷사 연동 정보',
                                        style: TextFont.semibig,
                                      ),
                                      margin: EdgeInsets.only(
                                        bottom: 2,
                                      )),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        isHomeNetUser ? '${widget.userHomeModel.village.villageName}  ${widget.userHomeModel.dongNo}-${widget.userHomeModel.hoNo}' : '홈넷 계정 연동이 필요합니다.',
                                        style: isHomeNetUser ? TextFont.normal_m : TextFont.normal_g,
                                      ),
                                    ),
                                  ],
                                ))
                            ],
                          ),
                        ),
                        onPressed: () {

                        },
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 15,
                        right: 15,
                        bottom: 10,
                      ),
                      child: Text(
                        '기타 설정',
                        style: TextFont.big,
                        textAlign: TextAlign.left,
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: BgColor.white,
                        border: Border(
                          bottom: BorderSide(width: 1, color: BgColor.rgray))),
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                          right: 20,
                          left: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                "assets/images/toggle.png",
                                fit: BoxFit.fitWidth,
                              ),
                              margin: EdgeInsets.only(
                                right: 15,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '모드선택',
                                      style: TextFont.semibig,
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: 2,
                                    )
                                  ),

                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            '데모(체험) 모드',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: const Color(0xff333333),
                                            ),
                                          )
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Switch(
                                            value: isServerMode,
                                            onChanged: (value) async {
                                              if (value && !isHomeNetUser) {
                                                UICommon.alert(context, "홈넷 계정과 연동이 필요합니다.");
                                                value = !value;
                                                return;
                                              }

                                              bool isConfirm = await UICommon.confirmDialog(context, "확인", "변경하시면 홈화면으로 이동합니다.", "취소", "확인");
                                              if (isConfirm) {
                                                isServerMode = value;
                                                final prefs = await SharedPreferences.getInstance();
                                                prefs.setString('_is_server_mode', value ? "Y" : "N");

                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

                                              } else {
                                                return;
                                              }
                                              // setState(() {
                                              // 	isServerMode = value;
                                              // 	print(isServerMode);
                                              // });
                                            },
                                            activeTrackColor: Colors.lightGreenAccent,
                                            activeColor: Colors.green,
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '운영(제어) 모드',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: const Color(0xff333333),
                                            ),
                                          )
                                        ),
                                      ]
                                    )

                                  )
                                ],
                              )
                            )
                          ]
                        ),
                      ),
                    ),

                    // 진동 사용 여부 설정
                    Container(
                      decoration: BoxDecoration(
                        color: BgColor.white,
                        border: Border(
                          bottom: BorderSide(width: 1, color: BgColor.rgray))),
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                          right: 20,
                          left: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 30,
                              height: 30,
                              child: Image.asset(
                                "assets/images/vibe.png",
                                fit: BoxFit.fitWidth,
                              ),
                              margin: EdgeInsets.only(
                                right: 15,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '진동 사용 여부',
                                      style: TextFont.semibig,
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: 2,
                                    )
                                  ),

                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("기기 제어시 진동 사용 여부를 설정하세요", style: TextFont.normal_g, ),
                                  ),


                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Text(
                                            '미사용',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: const Color(0xff333333),
                                            ),
                                          )
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Switch(
                                            value: useVibration,
                                            onChanged: (value) async {
                                              setState(() {
                                                useVibration = value;
                                                USE_VIBRATION = value;
                                              });
                                              final prefs = await SharedPreferences.getInstance();
                                              prefs.setString('_use_vibration', value ? "Y" : "N");
                                            },
                                            activeTrackColor: Colors.lightGreenAccent,
                                            activeColor: Colors.green,
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '사용',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: const Color(0xff333333),
                                            ),
                                          )
                                        ),
                                      ]
                                    )

                                  )
                                ],
                              )
                            )
                          ]
                        ),
                      ),
                    ),

                  ],
                ),
              )),
          );




        }
      }

    );


  }
}
