import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/style.dart';

class NewIntro extends StatefulWidget {
  NewIntro({Key key, this.email}) : super(key: key);
  final String email;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<NewIntro> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Color.fromARGB(255, 243, 243, 243)),
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/intro_title.svg'
                    ),
                    margin: EdgeInsets.only(
                      bottom: 36,
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/images/intro_illust.svg'
                    ),
                    margin: EdgeInsets.only(
                      bottom: 12,
                    ),
                  ),
                  Container(
                    width: 280,
                    height: 45,
                    margin: EdgeInsets.only(
                      bottom: 97,
                    ),
                    decoration: BoxDecoration(
                      color: BgColor.newmain,
                      borderRadius: Radii.radi30
                    ),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: Text(
                        '시작하기',
                        textAlign: TextAlign.center,
                        style: TextFont.introText_w
                      ),
                    ),
                  ),
                  Container(
                    width: 280,
                    height: 45,
                    margin: EdgeInsets.only(
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      color: BgColor.white,
                      borderRadius: Radii.radi30
                    ),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left:20,),
                            child: SvgPicture.asset(
                              'assets/images/intro_icon1.svg'
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '임차모집 대기신청',
                              textAlign: TextAlign.center,
                              style: TextFont.introText
                            ),
                          ),
                          Container(
                            width:36,
                          ),
                        ],
                      )
                    ),
                  ),
                  Container(
                    width: 280,
                    height: 45,
                    margin: EdgeInsets.only(
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      color: BgColor.white,
                      borderRadius: Radii.radi30
                    ),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left:20,),
                            child: SvgPicture.asset(
                              'assets/images/intro_icon2.svg'
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '사전점검 방문예약',
                              textAlign: TextAlign.center,
                              style: TextFont.introText
                            ),
                          ),
                          Container(
                            width:36,
                          ),
                        ],
                      )
                    ),
                  )
                ],
              )
            ),
            Expanded(
              child: Container(),
            )
          ]
        ),
      ),
    );
  }
}
