import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import '../common/style.dart';
//import '../common/ui_common.dart';
import '../common/validation.dart';
import '../service/user_service.dart';
import 'login.dart';


class ForgotPw extends StatefulWidget {
	@override
	_ForgotPwScreenState createState() => _ForgotPwScreenState();
}

class _ForgotPwScreenState extends State < ForgotPw > {
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();
	User _user = User();
	final userService = UserService();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text('비밀번호 찾기'),
        backgroundColor: BgColor.white,
      ),
			body: Builder(
				builder: (BuildContext context) {
					return Container(
            decoration: BoxDecoration(color: BgColor.lgray),
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
                      padding:EdgeInsets.only(bottom:30, right:20, left:20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                '비밀번호 찾기',
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
                              child: Text(
                                '가입한 이메일 주소를 입력하시면 가입시 등록한 휴대폰 번호로 인증코드를 받을 수 있습니다.\n문자 수신이 안되시는 경우 이메일을 확인해 주세요.',
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
                                hintText: 'example@wm.co.kr',
                                labelText: '가입한 이메일 주소',
                                fillColor: BgColor.white,
                              ),
												      keyboardType: TextInputType.emailAddress,
                              validator: Validation.validateEmail,
                              onSaved: (String email) {
                                _user.email = email;
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(top:20),
                              width:double.infinity,
                              height:50,
                              decoration: BoxDecoration(
                                boxShadow: [Shadows.fshadow],
                              ),
                              child: RaisedButton(
																color: BgColor.main,
																child: Container(
                                  child: Text(
                                    '확인코드 보내기',
                                    textAlign: TextAlign.right,
                                    style: TextFont.medium_w,
                                  ),
																),
                                onPressed: () {
                                  doForgotPw(context);
                                },
                              ),
                            )
                          ].expand(
                            (widget) => [
                              widget,
                              SizedBox(
                                height: 5,
                              )
                            ],
                          )
                        ]
                      )
										),
									),
                ),
							),
						),
					);
				},
			),
		);
	}


	void doForgotPw(BuildContext context) async {
		if (_formKey.currentState.validate()) {
			_formKey.currentState.save();

			String message;
			bool forgotPwSuccess = false;
			try {
				await userService.forgorPassword(_user.email);
				forgotPwSuccess = true;
				//message = '전송하였습니다. 비밀번호 변경 화면으로 이동합니다.';
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangPasswordScreen(email: _user.email)),);
			}
			on CognitoClientException
			catch (e) {
				print(e.message);
				print(e.code);
				if (e.code == 'UserNotFoundException') {
					message = _user.email + ' 로 가입된 사용자가 없습니다.';
				} else {
					print(e.message);
					message = '처리중 에러가 발생했습니다.';
				}
			} catch (e) {
				print(e.toString());
				message = '알 수 없는 에러가 발생했습니다.';
			}
      if (!forgotPwSuccess) {
        final snackBar = SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
		}
	}
}

class ChangPasswordScreen extends StatefulWidget {
	ChangPasswordScreen({
		Key key,
		this.email
	}): super(key: key);

	final String email;
	@override
	_ChangPasswordScreenState createState() => _ChangPasswordScreenState();
}

class _ChangPasswordScreenState extends State < ChangPasswordScreen > {
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();
	String email;
	String confirmationCode;
	User _user = User();
	final _userService = UserService();

	@override
	Widget build(BuildContext context) {
		final Size screenSize = MediaQuery.of(context).size;
		return Scaffold(
			appBar: AppBar(
				title: Text('비밀번호 변경'),
			),
			body: Builder(
				builder: (BuildContext context) => Container(
					child: Form(
						key: _formKey,
						child: ListView(
							children: < Widget > [
								ListTile(
									leading: const Icon(Icons.lock),
										title: TextFormField(
											decoration: InputDecoration(labelText: 'SMS로 받은 확인코드입력'),
											onSaved: (String code) {
												email = widget.email;
												confirmationCode = code;
											},
										),
								),
								ListTile(
										leading: const Icon(Icons.lock_outline),
											title: MyTextFormField(
												hintText: '변경할 비밀번호',
												obscureText: true,
												validator: (String value) {
													if (value.length < 8) {
														return '비밀번호는 8자 이상으로 입력하세요.';
													}
													_formKey.currentState.save();
													return null;
												},
												onSaved: (String password) {
													_user.password = password;
												},
											),
									),
									ListTile(
										leading: const Icon(Icons.lock_outline),
											title: MyTextFormField(
												hintText: '비밀번호 재입력',
												obscureText: true,
												validator: (String value) {
													if (_user.password != null && value != _user.password) {
														print(value);
														print(_user.password);
														return '비밀번호가 일치하지 않습니다.';
													}
													return null;
												},
											),
									),
								Container(
									padding: EdgeInsets.all(20.0),
									width: screenSize.width,
									child: RaisedButton(
										child: Text(
											'비밀번호 변경',
											style: TextStyle(color: Colors.white),
										),
										onPressed: () {
												doChagePassword(context);
										},
										color: BgColor.main,
									),
									margin: EdgeInsets.only(
										top: 10.0,
									),
								),
								
							],
						),
					),
				)),
		);
	}

	doChagePassword(BuildContext context) async {

		if (!_formKey.currentState.validate()) {
			return;
		}

		_formKey.currentState.save();
		bool passwordConfirmed = false;
		String message;
		try {
			passwordConfirmed = await _userService.confirmPassword(email, confirmationCode, _user.password);
			message = '비밀번호가 변경되었습니다.';
		}
		on CognitoClientException
		catch (e) {
			print(e.message);
			print(e.code);
			if (e.code == 'CodeMismatchException') {
				message = '확인코드가 올바르지 않습니다.';
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
				onPressed: () {
					if (passwordConfirmed) {
						Navigator.pop(context);
						//Navigator.push(context,MaterialPageRoute(builder: (context) => Login(email: _user.email)),);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login(email: _user.email)), (route) => false);
					}
				},
			),
			duration: Duration(seconds: 30),
		);

		Scaffold.of(context).showSnackBar(snackBar);
	}
}

class MyTextFormField extends StatelessWidget {
	final String hintText;
	final String labelText;
	final Function validator;
	final Function onSaved;
	final bool obscureText;
	final TextInputType keyboardType;

	MyTextFormField({
		this.hintText,
		this.labelText,
		this.validator,
		this.onSaved,
		this.obscureText = false,
		this.keyboardType,
	});

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.all(8.0),
			child: TextFormField(
				decoration: InputDecoration(
					hintText: hintText,
					labelText: labelText,
					contentPadding: EdgeInsets.all(15.0),
					border: InputBorder.none,
					filled: true,
					fillColor: Colors.grey[200],
				),
				obscureText: obscureText,
				validator: validator,
				onSaved: onSaved,
				keyboardType: keyboardType,
			),
		);
	}
}
