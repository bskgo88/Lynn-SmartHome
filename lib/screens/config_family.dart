import 'dart:async';
import 'dart:convert';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import '../common/ui_common.dart';
import '../common/validation.dart';
import '../model/user_home_model.dart';
import '../service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/style.dart';
import 'package:image_picker/image_picker.dart';

class ConfigFamilyScreen extends StatefulWidget {
	final UserHomeModel userHomeModel;

	const ConfigFamilyScreen({
		Key key,
		this.userHomeModel
	}): super(key: key);

	@override
	_ConfigFamilyScreenState createState() => _ConfigFamilyScreenState();
}

class _ConfigFamilyScreenState extends State < ConfigFamilyScreen > {

	@override
	Widget build(BuildContext context) {
		// Scaffold is a layout for the major Material Components.
		return Scaffold(
				appBar: AppBar(
					title: Text(
						'가족 구성원',
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
					padding: EdgeInsets.all(20),
					child: Column(

						// 구성원 목록 표시
						children: _buildMembers(context),

					)
				)
			)
		);
	}


	/// 구성원 목록 표시
	List < Widget > _buildMembers(BuildContext context) {
		List < UserHomeModelUsers > members = widget.userHomeModel.users;

		return members.map((member) {

			return FutureBuilder < dynamic > (
				future: getMemberInfo(),
				builder: (context, AsyncSnapshot < dynamic > snapshot) {
					if (snapshot.connectionState == ConnectionState.waiting) {
						return ShowLoading();
					} else {
						return FamilyMemberWidget(member: member, myEmail: snapshot.data["myEmail"], );
					}
				}
			);
		}).toList();
	}

	/// 사용자 정보 조회
	Future < dynamic > getMemberInfo() async {
		SharedPreferences _prefs = await SharedPreferences.getInstance();
		String myEmail = _prefs.getString("_user_email");
		//print("getMemberInfo myEmail : $myEmail");
		return {
			"myEmail": myEmail
		};
	}
}



class FamilyMemberWidget extends StatefulWidget {
	final UserHomeModelUsers member;
	final myEmail;

	const FamilyMemberWidget({
		Key key,
		this.member,
		this.myEmail
	}): super(key: key);
	@override
	_FamilyMemberWidgetState createState() => _FamilyMemberWidgetState();
}

class _FamilyMemberWidgetState extends State < FamilyMemberWidget > {
	final textEditingController = TextEditingController();
 	// ignore: unused_field
	PickedFile _image;

	@override
	void dispose() {
		// 사라질 때 제거
		textEditingController.dispose();
		super.dispose();
	}


	Future _getImage() async {
		final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 200, maxWidth: 200);
		var bytes;
		try{
			bytes = await pickedImage.readAsBytes();
		}catch(e){
			return;
		}
		String base64Encode = base64.encode(bytes);
		dynamic userInfo = {"picture": base64Encode};
		final userService = UserService();
		bool isSuccess = await userService.doChangeUserInfo(userInfo);
		if(isSuccess){
			widget.member.picture = base64Encode;
			setState(() {
				_image = pickedImage;
			});
		}
	}

	@override
	Widget build(BuildContext context) {

		UserHomeModelUsers member = widget.member;
		bool isMyInfo = widget.myEmail == member.email? true : false;

		MemoryImage userImage;
		if(widget.member.picture != null && widget.member.picture != ""){
			//print("Image picture : ${widget.member.picture}");
			try{
				userImage = MemoryImage(base64Decode(widget.member.picture));
			}catch(e){}
		}
		return Container( // 가족구성원
			margin: EdgeInsets.only(bottom: 15, ),
			padding: EdgeInsets.all(15),
			decoration: BoxDecoration(
				color: BgColor.white,
				borderRadius: Radii.radi15,
				boxShadow: [Shadows.fshadow],
			),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					InkWell(
						onTap: () {
							_getImage();
						},
						child: Container( // Face
							margin: EdgeInsets.only(right: 10),
							child : CircleAvatar (
								radius: 40.0,
								//backgroundColor: BgColor.white,
								backgroundImage: userImage == null? AssetImage("assets/images/picture.png") : userImage
							),
						),
					),
					Expanded(
						child: Column(
							children: [
								Container(
									margin: EdgeInsets.only(bottom: 5),
									width: double.infinity,
									child: Row(
										children: [
											Container(
												margin: EdgeInsets.only(right: 5),
												child: Text(
													'이름 :',
													style: TextFont.medium_m,
													textAlign: TextAlign.left,
												),
											),
											Expanded(
												child: Text(
													member.name, // 이름
													style: TextFont.semibig,
												)
											)
										],
									)
								),
								Container(
									margin: EdgeInsets.only(bottom: 5),
									width: double.infinity,
									child: Row(
										children: [
											Container(
												margin: EdgeInsets.only(right: 5),
												child: Text(
													'아이디 :',
													style: TextFont.medium_m,
													textAlign: TextAlign.left,
												),
											),
											Expanded(
												child: Text(
													member.email, // 이메일 (아이디)
													style: TextFont.medium
												)
											)
										],
									)
								),
								Container(
									margin: EdgeInsets.only(bottom: 5),
									width: double.infinity,
									child: Row(
										children: [
											Container(
												margin: EdgeInsets.only(right: 5),
												child: Text(
													'휴대폰 :',
													style: TextFont.medium_m,
													textAlign: TextAlign.left,
												),
											),
											Expanded(
												child: Text(
													member.mobile, // 휴대폰번호
													style: TextFont.medium
												)
											)
										],
									)
								),
								Container(
									margin: EdgeInsets.only(bottom: 5),
									width: double.infinity,
									child: Row(
										children: [
											Container(
												margin: EdgeInsets.only(right: 5),
												child: Text(
													'상태 :',
													style: TextFont.medium_m,
													textAlign: TextAlign.left,
												),
											),
											Expanded(
												child: Text(
													isMyInfo? '관리자' : '구성원',
													style: TextFont.medium
												)
											)
										],
									)
								),

								Visibility(
									//maintainSize: true, 
									//maintainAnimation: true,
									maintainState: true,
									visible: isMyInfo? true : false,
									child: Container(
										width: double.infinity,
										alignment: Alignment.centerRight,
										child: InkWell(
											child: Container(
												padding: EdgeInsets.only(top: 7, bottom: 7, left: 15, right: 15, ),
												decoration: BoxDecoration(
													color: BgColor.main
												),
												child: Text(
													'비밀번호변경',
													style: TextFont.medium_w,
												),
											),
											onTap: () async{
												bool isSuccess = await changePasswordDialog(context, widget.myEmail);
												print("isSuccess : $isSuccess");
												if(isSuccess == true){
													UICommon.showMessage(context, "비밀번호가 변경되었습니다.");
												}
											},
										)
									)
								)
							],
						),
					)
				],
			),
		);
	}
}



Future < bool > changePasswordDialog(BuildContext context, String email) async {
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();
	String _currPassword;
	String _newPassword;
	final _userService = UserService();
	return showDialog < bool > (
		context: context, builder: (context) {

		Future < bool > doChangePassword(BuildContext context) async {
			if (!_formKey.currentState.validate()) {
				return null;
			}

			_formKey.currentState.save();
			bool passwordChanged = false;
			String message;
			try {

				print("changePasswordDialog  email: $email _currPassword : $_currPassword   _newPassword : $_newPassword");
				passwordChanged = await _userService.changePassword(email, _currPassword, _newPassword);
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

			print(message);
			return passwordChanged;
		}

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
						'비밀번호변경',
						style: TextFont.medium_w,
					),
				),
				content: SingleChildScrollView(
					padding: EdgeInsets.all(15),
					child: Column(
						children: [
							Form(
								key: _formKey,
								child: Column(
									children: [
										TextFormField(
											decoration: InputDecoration(
												filled: true,
												hintText: '기존 비밀번호를 입력 해 주세요.',
												labelText: '기존 비밀번호',
												fillColor: BgColor.white,
											),
											obscureText: true,
											onChanged: (value) {},
											validator: Validation.checkEmpty,
											onSaved: (String password) {
												_currPassword = password;
											},
										),
										TextFormField(
											decoration: InputDecoration(
												filled: true,
												hintText: '변경하실 비밀번호를 입력 해 주세요.',
												labelText: '새 비밀번호',
												fillColor: BgColor.white,
											),
											obscureText: true,
											onChanged: (value) {},
											validator: (String value) {
												if (value.length < 8) {
													return '비밀번호는 8자 이상으로 입력하세요.';
												}
												_formKey.currentState.save();
												return null;
											},
											onSaved: (String password) {
												_newPassword = password;
											},
										),
										TextFormField(
											decoration: InputDecoration(
												filled: true,
												hintText: '변경하실 비밀번호를 한번더 입력 해 주세요.',
												labelText: '새 비밀번호 확인',
												fillColor: BgColor.white,
											),
											obscureText: true,
											onChanged: (value) {},
											validator: (String value) {
													if (_newPassword != null && value != _newPassword) {
														return '비밀번호가 일치하지 않습니다.';
													}
													return null;
												},
										),
									],
								)

							),
						]
					),
				),
				actions: < Widget > [
					SizedBox(
						width: MediaQuery.of(context).size.width,
						child: Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Container(
									width: MediaQuery.of(context).size.width / 2 - 50,
									decoration: BoxDecoration(
										color: BgColor.lgray
									),
									child: FlatButton(
										child: Text(
											'취소',
											style: TextFont.medium
										),
										onPressed: () {
											Navigator.of(context).pop();
										},
									),
								),
								Container(
									width: MediaQuery.of(context).size.width / 2 - 50,
									decoration: BoxDecoration(
										color: BgColor.main
									),
									child: FlatButton(
										child: Text(
											'수정',
											style: TextFont.medium_w
										),
										onPressed: () async{
											bool isSuccess = await doChangePassword(context);
											print("Dialog isSuccess : $isSuccess");
											if(isSuccess){
												Navigator.of(context).pop(true);
											}else if(isSuccess != null && !isSuccess){
												UICommon.alert(context, "실패 하였습니다.\n기존 비밀번호를 확인하세요.");
											}
										}
									),
								),
							]
						)
					),
				],
			);
		}
	);
	
}

