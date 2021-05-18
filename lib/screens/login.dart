import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/ui_common.dart';
import '../common/validation.dart';
import '../service/user_service.dart';
import 'sign_up.dart';
import 'forgot_pw.dart';
import 'sign_agreement.dart';

class Login extends StatefulWidget {
  Login({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  User _user = User();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isDisplayPassword = true;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(0),
        child: RaisedButton(
          padding: EdgeInsets.all(20),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            await doLogin(context);
            setState(() {
              isLoading = false;
            });
          },
          color: Color.fromARGB(255, 239, 144, 0),
          textColor: Color.fromARGB(255, 255, 255, 255),
          child: isLoading
              ? SizedBox(
                  width: 22, height: 22, child: CircularProgressIndicator())
              : Text("로그인"),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height - 38,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 101,
                      height: 60,
                      margin: EdgeInsets.only(top: 80, left: 40),
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 68, left: 40),
                      child: Text(
                        '안녕하세요\n우미건설 Smart Lynn 서비스입니다.',
                        style: TextStyle(
                          fontFamily: 'NanumBarunGothic',
                          fontSize: 16,
                          color: const Color(0xff333333),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 40),
                      child: Text(
                        '사용을 위해 로그인 해주세요.',
                        style: TextStyle(
                          fontFamily: 'NanumBarunGothic',
                          fontSize: 12,
                          color: const Color(0xff999999),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 50,
                  left: 40,
                  child: Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                  height: 50,
                                  child: TextFormField(
                                    initialValue: widget.email,
                                    decoration: InputDecoration(
                                        hintText: "이메일 주소를 입력하세요.",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 204, 204, 204)),
                                        contentPadding: EdgeInsets.all(0),
                                        border: InputBorder.none),
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 75, 75, 75),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    autocorrect: false,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: Validation.validateEmail,
                                    onSaved: (String email) {
                                      //print('email : ' + email);
                                      _user.email = email.trim();
                                    },
                                  )),
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 227, 227, 227)),
                              ),
                              Container(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "비밀번호를 입력하세요.",
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 204, 204)),
                                            contentPadding: EdgeInsets.all(0),
                                            border: InputBorder.none),
                                        obscureText: _isDisplayPassword,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        autocorrect: false,
                                        validator: Validation.validatePassword,
                                        onSaved: (String password) {
                                          //print('password : ' + password);
                                          _user.password = password;
                                        },
                                      )),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: FlatButton(
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: () {
                                                    setState(() {
                                                      _isDisplayPassword =
                                                          !_isDisplayPassword;
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    (_isDisplayPassword)
                                                        ? "assets/images/visibility_off.png"
                                                        : "assets/images/visibility_on.png",
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 227, 227, 227)),
                              ),
                              Container(
                                  height: 50,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            '회원가입',
                                            style: TextStyle(
                                              fontFamily: 'NanumBarunGothic',
                                              fontSize: 14,
                                              color: const Color(0xff999999),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AgreementScreen()));
                                          },
                                        ),
                                        Container(
                                          child: Text(
                                            '·',
                                            style: TextStyle(
                                              fontFamily: 'NanumBarunGothic',
                                              fontSize: 14,
                                              color: const Color(0xff999999),
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          child: Text(
                                            '비밀번호 찾기',
                                            style: TextStyle(
                                              fontFamily: 'NanumBarunGothic',
                                              fontSize: 14,
                                              color: const Color(0xff999999),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPw()));
                                          },
                                        ),
                                      ])),
                            ],
                          )))),
            ],
          ),
        )),
      ),
    );
  }

  doLogin(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    final _userAccount = UserService();
    String message;
    try {
      _user = await _userAccount.login(_user.email, _user.password);
      //print("doLogin _user.confirmed : ${_user.confirmed}");
      if (_user.confirmed) {
        //사용자 정보 조회 (홈넷사 계정 연동되어 있는지 체크)
        _user = await _userAccount.getUserInfo(_user);

        /// 기본정보 저장소에 저장
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('_user_name', _user.name); // 사용자명 설정 (로그인 후 화면에 보여주기 위함)
        prefs.setString('_user_token', _user.userToken); //이 후에 자동 로그인 될 수 있도록 설정
        prefs.setString('_user_email', _user.email); // 로그인 후 사용자 본인 확인
        prefs.setString('_vendor_token', _user.vendorToken); // 홈넷 연동 되었는지 확인하기 위하여 설정
        //print("doLogin _user._vendor_token : ${_user.vendorToken}");

        // 홈(메인) 화면으로 이동
        //Navigator.pushReplacementNamed(context, '/home'); //pushReplacementNamed 사용하여야 백버튼으로 다시 로그인 화면으로 이동하지 않음
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

      } else {
        message = '아직 승인상태가 아닙니다.\n 이메일 확인 화면으로 이동합니다.';
        print(message);
        final prefs = await SharedPreferences.getInstance();
        String phoneNumber = prefs.getString('_user_phoneNumber');
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmationScreen(email: _user.email, phoneNumber: phoneNumber,)));
      }
    } on CognitoClientException catch (e) {
      print(e.message);
      if (e.code == 'UserNotFoundException') {
        message = '존재하지 않는 아이디 입니다.';
      } else if (e.code == 'NotAuthorizedException') {
        message = '비밀번호를 확인해 주세요.';
      } else if (e.code == 'InvalidParameterException' ||
          e.code == 'ResourceNotFoundException') {
        message = '잘못된 요청입니다.';
      } else {
        message = '처리중 에러가 발생했습니다.';
      }
      print(message);
      UICommon.alert(context, message);
    } catch (e) {
      print(e.toString());
      message = '처리중 에러가 발생했습니다.';
      UICommon.alert(context, message);
    }
  }
}
