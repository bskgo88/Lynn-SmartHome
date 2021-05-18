import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import '../common/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../common/validation.dart';
import '../service/user_service.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State < SignUp > {
  final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();
  User _user = User();
  final userService = UserService();
  bool _autovalidate = false;
  bool _isDisplayPassword = true;

  var _focusNode = new FocusNode();
  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(_focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
						icon: Icon(
							Icons.arrow_back
						),
						tooltip: 'Back',
						onPressed: () {
							Navigator.of(context).pop();
						}
					),
					iconTheme: IconThemeData(
						color: Colors.black, //change your color here
					),
        //toolbarHeight: 70,
        title: Text('회원가입', style: TextFont.big_n,),
        backgroundColor: BgColor.white,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(color: BgColor.lgray),
            child: Form(
              autovalidate: _autovalidate,
              key: _formKey,
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(color: BgColor.lgray),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: BgColor.white,
                        boxShadow: [Shadows.fshadow],
                        borderRadius: Radii.radi20,
                      ),
                      margin: EdgeInsets.all(20),
                      padding:
                      EdgeInsets.only(bottom: 30, right: 20, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: < Widget > [
                          ...[
                            Container(
                              width: 101,
                              height: 60,
                              margin: EdgeInsets.only(top: 30),
                              child: Image.asset(
                                "assets/images/logo.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                '회원가입 하기',
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
                              margin: EdgeInsets.only(bottom: 30),
                              //padding: EdgeInsets.only(bottom:20),
                              child: Text(
                                '정확한 정보로 회원가입해주세요.\n휴대폰번호로 SMS인증을 진행합니다.',
                                style: TextStyle(
                                  fontFamily: 'NanumBarunGothic',
                                  fontSize: 12,
                                  color: const Color(0xff999999),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                hintText: '',
                                labelText: '이름',
                                fillColor: BgColor.white,
                              ),
                              validator: Validation.checkEmpty,
                              onSaved: (String value) {
                                _user.name = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'smarthome@wm.co.kr',
                                labelText: '이메일 (아이디)',
                                fillColor: BgColor.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: Validation.validateEmail,
                              onSaved: (String email) {
                                _user.email = email.trim();
                              },
                            ),

                            Container(
                              //height: 50,
                              decoration: _focusNode.hasFocus ? BoxDecoration(border: Border(bottom: BorderSide(width: 2.0, color: Colors.orange), ), ) : BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Color.fromARGB(255, 97, 97, 97)), ), ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      focusNode: _focusNode,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        hintText: '8자리 이상 입력',
                                        labelText: '비밀번호',
                                        fillColor: BgColor.white,
                                      ),
                                      obscureText: _isDisplayPassword,
                                      validator: (String value) {
                                        if (value.length < 8) {
                                          return '비밀번호는 8자 이상 입력하세요.';
                                        }
                                        _formKey.currentState.save();
                                        return null;
                                      },
                                      onSaved: (String password) {
                                        _user.password = password;
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 0, bottom: 0),
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: TextButton(
                                            //padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              setState(() {
                                                _isDisplayPassword = !_isDisplayPassword;
                                              });
                                            },
                                            child: Image.asset(
                                              (_isDisplayPassword) ?
                                              "assets/images/visibility_off.png" :
                                              "assets/images/visibility_on.png",
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ))
                                      ],
                                    ),
                                  ),
                                ],
                              )),

                            TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                hintText: '',
                                labelText: '비밀번호 확인',
                                fillColor: BgColor.white,
                              ),
                              obscureText: _isDisplayPassword,
                              validator: (String value) {
                                if (_user.password != null &&
                                  value != _user.password) {
                                  print(value);
                                  print(_user.password);
                                  return '비밀번호가 일치하지 않습니다.';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                hintText: '01012345678 ( - 없이 입력)',
                                labelText: '휴대폰 번호',
                                fillColor: BgColor.white,
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              validator: Validation.validatePhoneNumber,
                              onSaved: (String phoneNumber) {
                                _user.phoneNumber = phoneNumber.trim();
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                boxShadow: [Shadows.fshadow],
                              ),
                              child: RaisedButton(
                                color: BgColor.main,
                                child: Container(
                                  child: Text(
                                    '회원가입',
                                    textAlign: TextAlign.right,
                                    style: TextFont.medium_w,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    bool isConfirm = await confirmPopup(context);
                                    if (isConfirm) {
                                      doSignUp(context);
                                    }
                                  } else {
                                    setState(() {
                                      _autovalidate = true;
                                    });
                                  }
                                }),
                            )
                          ].expand(
                            (widget) => [
                              widget,
                              SizedBox(
                                height: 5,
                              )
                            ],
                          )
                        ]),
                    ),
                  )))),
          );
        },
      ),
    );
  }

  /**
   * 회원 가입 처리
   */
  void doSignUp(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      String message;
      bool signUpSuccess = false;
      try {
        _user = await userService.signUp(_user.email, _user.password, _user.name, _user.phoneNumber);
        signUpSuccess = true;

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('_user_phoneNumber', _user.phoneNumber); // 로그인 후 확인코드 화면 다시 보여주어야 하는 경우를 위함 
        //prefs.setString('_user_token', _user.userToken);

        //Navigator.pop(context);
        if (!_user.confirmed) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmationScreen(email: _user.email, phoneNumber: _user.phoneNumber)), );
        }else{
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Login(email: _user.email)), );
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login(email: _user.email)), (route) => false);
        }
        return;  // 바로 화면 이동
      }
      on CognitoClientException
      catch (e) {
        print(e.message);
        if (e.code == 'UsernameExistsException') {
          message = '이미 회원가입된 이메일 입니다.';
        } else if (e.code == 'InvalidParameterException' ||
          e.code == 'ResourceNotFoundException') {
          message = e.message + '_after sign up';
        } else {
          print(e.message);
          message = '처리중 에러가 발생했습니다.';
        }
      } catch (e) {
        print(e.toString());
        message = '알 수 없는 에러가 발생했습니다.';
      }

      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: '확인',
          onPressed: () {
            if (signUpSuccess) {
              Navigator.pop(context);
              if (!_user.confirmed) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationScreen(
                      email: _user.email, phoneNumber: _user.phoneNumber)),
                );
              }
            }
          },
        ),
        duration: Duration(seconds: 30),
      );

      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  Future < bool > confirmPopup(BuildContext context) {
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
            decoration: BoxDecoration(color: BgColor.main),
            child: Text(
              '확인',
              style: TextFont.medium_w,
            ),
          ),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(_user.phoneNumber + '로 확인코드가 발송됩니다.',
                style: TextFont.medium),
            ),
          ),
          actions: < Widget > [
            Row(children: [
              Container(
                decoration: BoxDecoration(color: BgColor.lgray),
                width: MediaQuery.of(context).size.width / 2 - 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('번호수정', style: TextFont.medium),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: BgColor.main),
                width: MediaQuery.of(context).size.width / 2 - 50,
                child: TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('확인', style: TextFont.medium_w),
                ),
              ),
            ]),
          ],
        );
      });
  }
}

class ConfirmationScreen extends StatefulWidget {
  ConfirmationScreen({
    Key key,
    this.email,
    this.phoneNumber
  }): super(key: key);

  final String email;
  final String phoneNumber;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State < ConfirmationScreen > {
  final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();
  String confirmationCode;
  User _user = User();
  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    //final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Text('회원가입 - 확인코드 확인', style: TextStyle(color: BgColor.black), ),
        backgroundColor: BgColor.white,
        iconTheme: IconThemeData(
					color: Colors.black,
				),
      ),
      body: Builder(
        builder: (BuildContext context) => Container(
          child: Form(
            key: _formKey,
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(color: BgColor.lgray),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: BgColor.white,
                      boxShadow: [Shadows.fshadow],
                      borderRadius: Radii.radi20,
                    ),
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.only(
                      top: 30, bottom: 30, right: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: < Widget > [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              '회원가입이 되었습니다.\n서비스 이용을 위해서는 인증코드를 확인 하셔야합니다.\n인증코드 SMS 수신이 안되는 경우 스팸함을 확인하시거나 이메일로 인증코드를 받으세요.',
                              style: TextStyle(
                                fontFamily: 'NanumBarunGothic',
                                fontSize: 12,
                                color: const Color(0xff999999),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              enabled: false,
                              fillColor: BgColor.white,
                            ),
                            initialValue: widget.email,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String email) {
                              //debugPrint('email : ' + email);
                              _user.email = email;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              enabled: false,
                              fillColor: BgColor.white,
                            ),
                            initialValue: widget.phoneNumber,
                            keyboardType:
                            TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                            onSaved: (String phoneNumber) {
                              //debugPrint('phoneNumber : ' + phoneNumber);
                              _user.phoneNumber = phoneNumber;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              hintText: '',
                              labelText: '인증코드 입력',
                              fillColor: BgColor.white,
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                            onSaved: (String code) {
                              confirmationCode = code;
                            },
                          ),
                          Container(
                            height: 10,
                            decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
                            margin: EdgeInsets.only(bottom: 5)
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                child: Text(
                                  '인증코드 다시 받기',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                onPressed: () {
                                  doResendConfirmation(context);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  '이메일로 코드 받기',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                ),
                                onPressed: () {
                                  doResendConfirmationEmail(context);
                                },
                              ),
                            ]
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: [Shadows.fshadow],
                            ),
                            child: RaisedButton(
                              color: BgColor.main,
                              child: Container(
                                child: Text(
                                  '인증코드 확인',
                                  textAlign: TextAlign.right,
                                  style: TextFont.big_w,
                                ),
                              ),
                              onPressed: () {
                                doSignUpConfirm(context);
                              },
                            ),
                          ),
                      ]),
                  ),
                ),
              ),
            ),
          ),
        )),
    );
  }

  doSignUpConfirm(BuildContext context) async {
    _formKey.currentState.save();
    bool accountConfirmed = false;
    String message;
    try {
      accountConfirmed = await _userService.confirmAccount(_user.email, confirmationCode);
      print("doSignUpConfirm  accountConfirmed : $accountConfirmed");
      if(accountConfirmed){
        bool isConfirm = await signupSuccessPopup(context);  //회원가입완료 안내 Dialog
        if (isConfirm) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login(email: _user.email)), (route) => false);
        }
      }
      return;
    }
    on CognitoClientException
    catch (e) {
      if (e.code == 'CodeMismatchException') {
        message = '확인코드가 올바르지 않습니다.';
      } else if (e.code == 'InvalidParameterException' ||
        e.code == 'NotAuthorizedException' ||
        e.code == 'UserNotFoundException' ||
        e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        print(e.message);
        message = '처리중 에러가 발생했습니다.';
      }
    } catch (e) {
      print(e.toString());
      message = '알 수 없는 에러가 발생했습니다.';
    }

    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
      duration: Duration(seconds: 5),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //인증코드 다기 받기 처리
  doResendConfirmation(BuildContext context) async {
    _formKey.currentState.save();
    String message;
    try {
      await _userService.resendConfirmationCode(_user.email);
      message = '${_user.phoneNumber}로 인증코드를 다시 전송했습니다.';
    }
    on CognitoClientException
    catch (e) {
      if (e.code == 'LimitExceededException' ||
        e.code == 'InvalidParameterException' ||
        e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        print(e.message);
        message = '처리중 에러가 발생했습니다.';
      }
    } catch (e) {
      print(e.toString());
      message = '알 수 없는 에러가 발생했습니다.';
    }

    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
      duration: Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  // 이메일로 인증코드 받기 처리
  doResendConfirmationEmail(BuildContext context) async {
     _formKey.currentState.save();
    String message;
    try {
      Map < String, String > headers = {
        "Content-type": "application/json",
        "Authorization": "1234567890"  // 이 값은 어떻게 넘겨야하지?
      };
      Map < String, String > body = {
        "username": _user.email
      };

      String url = "https://lynnlife-api.bareunsem.net/api/emailConfirm"; //추후 정확한 주소 확인

      final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
      print("response.statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {

        //Cognito 전화번호 지우는 것까지만 되고 이메일 수신이 안되어 아래 추가
        try {
          await _userService.resendConfirmationCode(_user.email);
          message = '${_user.email}로 인증코드를 전송했습니다.';
        }
        catch (err) {
          message = '인증코드 전송에 실패하였습니다.';
        }

        //message = '${_user.email}로 인증코드를 전송했습니다.';
      } else {
        message = '인증코드 전송에 실패하였습니다.';
      }
    }
    catch (e) {
      print("doResendConfirmationEmail Error : $e");
      message = '처리중 에러가 발생했습니다.';
    }

    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
      duration: Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

}




Future < bool > signupSuccessPopup(BuildContext context) {
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
            decoration: BoxDecoration(color: BgColor.main),
            child: Text(
              '안내',
              style: TextFont.medium_w,
            ),
          ),
          content: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text('인증코드가 확인되었습니다.\n이메일과 비밀번호로 로그인해 주세요.',
                style: TextFont.medium),
            ),
          ),
          actions: < Widget > [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: MediaQuery.of(context).size.width - 150,
                decoration: BoxDecoration(
                  color: BgColor.main
                ),
                child: TextButton(
                  child: Text(
                    '확인',
                    style: TextFont.medium
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
					  ),
          ],
        );
      });
  }