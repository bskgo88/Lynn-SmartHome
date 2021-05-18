
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../common/style.dart';
import '../model/user_home_model.dart';
import '../model/village_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/ui_common.dart';
import '../service/user_service.dart';
import '../service/home_service.dart';
import 'home.dart';
import '../common/validation.dart';

FormData _$FormDataFromJson(Map < String, dynamic > json) {
	return FormData(
		username: json['username'] as String,
		password: json['password'] as String,
		siteId: json['siteId'] as String,
		dong: json['dong'] as String,
		ho: json['ho'] as String,
	);
}

Map < String, dynamic > _$FormDataToJson(FormData instance) => < String, dynamic > {
	'username': instance.username,
	'password': instance.password,
	'siteId': instance.siteId,
	'dong': instance.dong,
	'ho': instance.ho,
};

@JsonSerializable()
class FormData {
	String username;
	String password;
	String siteId;
	String dong;
	String ho;

	FormData({
		this.username,
		this.password,
		this.siteId,
		this.dong,
		this.ho,
	});

	factory FormData.fromJson(Map < String, dynamic > json) => _$FormDataFromJson(json);
	Map < String, dynamic > toJson() => _$FormDataToJson(this);
}

class SignInHomenet extends StatefulWidget {
	@override
	_SignInHomenetState createState() => _SignInHomenetState();
}

class _SignInHomenetState extends State < SignInHomenet > {
	FormData formData = FormData();
	final GlobalKey < FormState > _formKey = GlobalKey < FormState > ();
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				iconTheme: IconThemeData(
					color: Colors.black, //change your color here
				),
				backgroundColor: BgColor.white,
				title: Text(
					'홈넷사 연동',
          style:TextFont.big_n
				),
			),
			bottomNavigationBar: Padding(
				padding: EdgeInsets.all(0),
				child: RaisedButton(
					padding: EdgeInsets.all(15),
					onPressed: () async {
						doHomenetLogin(context);
					},
					color: Color.fromARGB(255, 239, 144, 0),
					textColor: Color.fromARGB(255, 255, 255, 255),
					child: Text('계정확인'),
				),
			),
			body: Form(
				key: _formKey,
				child: Container(
          decoration: BoxDecoration(
            color: BgColor.white,
          ),
					constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: BgColor.white,
              ),
              padding: EdgeInsets.only(bottom: 50, right: 30, left: 30,top:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        '홈넷사 계정 연동을 위해 정보를 입력하세요.',
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
                      child: Text(
                        '계정 연결이 되어야 기기제어가 가능합니다.',
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
                        hintText: '단지에 등록된 홈넷사 아이디',
                        labelText: '아이디',
                        fillColor: BgColor.white,
                      ),
                      validator: Validation.checkEmpty,
                      onChanged: (value) {
                        formData.username = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: '비밀번호',
                        fillColor: BgColor.white,
                      ),
                      obscureText: true,
                      validator: Validation.validatePassword,
                      onChanged: (value) {
                        formData.password = value;
                      },
                    ),
                    GestureDetector(
                      child: InputDecorator(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: _villageName == null ? "단지" : _villageName,
                          fillColor: BgColor.white,
                          labelStyle: new TextStyle(
                            fontSize: 22,
                          )
                        ),
                        // validator: Validation.checkEmpty,
                        // onChanged: (value) {
                        // 	formData.siteId = value;
                        // },
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext newContext) {

                            // 단지 목록 다이얼로그 표시
                            return VillageListWidget(callback: selectVillageCallback);

                          },
                        );
                      },
                    ),
                    TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      hintText: '동 번호를 입력하세요.',
                      labelText: '동',
                      fillColor: BgColor.white,
                    ),
                    validator: Validation.checkEmpty,
                    onChanged: (value) {
                      formData.dong = value;
                    },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        hintText: '호 번호를 입력하세요.',
                        labelText: '호',
                        fillColor: BgColor.white,
                      ),
                      validator: Validation.checkEmpty,
                      onChanged: (value) {
                        formData.ho = value;
                      },
                    ),
                  ].expand(
                    (widget) => [
                      widget,
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
				),
			),
		);
	}

	doHomenetLogin(BuildContext context) async {
		if (!_formKey.currentState.validate()) {
			return;
		}

		//단지 아이디는 별도 체크 (단지 선택 했는지)
		if(formData.siteId == null){
			UICommon.alert(context, "단지를 선택 하세요.");
			return;
		}

		UICommon.showLoaderDialog(context);
		final _homeService = HomeService();
		User _user = User();
		_user.homeNetUserId = formData.username;
		_user.homeNetUserPassword = formData.password;
		_user.siteId = formData.siteId;
		_user.dong = formData.dong;
		_user.ho = formData.ho;
		final prefs = await SharedPreferences.getInstance();
		_user.userToken = prefs.getString('_user_token');  // 로그인시 설정한 사용자토큰 설정하여  syncHomeNet 호출
		String message;
		try {
			dynamic result = await _homeService.syncHomeNet(_user);
			UICommon.hideLoaderDialog(context);

			if (!(result is bool) && result != null && result["ho_no"] != null) {
				UserHomeModel userHomeModel = UserHomeModel.fromJson(result);
				// 결과에서 해당 사용자의 vendorToken 을 얻는다.
				String userEmail = prefs.getString('_user_email');
				int fIdx = userHomeModel.users.indexWhere((user) => user.email == userEmail); 
				String vendorToken = "";
				if(fIdx != -1){
					vendorToken = userHomeModel.users[fIdx].vendorToken;
				}
				print("doHomenetLogin  userEmail : $userEmail   vendorToken : $vendorToken");

				// vendorToken 이 있는 경우에만 홈넷과 연동된 상태임
				if(vendorToken != null && vendorToken != ""){
					prefs.setString('_vendor_token', vendorToken); // 홈넷 연동 상태 저장
					prefs.setString('_is_server_mode', "");  // 홈넷 연동시에는 모드를 운영모드로 설정한다.
					
					await Navigator.push(context, MaterialPageRoute(builder: (context) => Home()), ); //홈 화면으로 이동한다.
				}else{
					message = '사용자 정보를 찾을 수 없습니다.\n아이디와 비밀번호를 확인하세요.';
				}
			} else {
				message = '사용자 정보를 찾을 수 없습니다.\n아이디와 비밀번호를 확인하세요.';
			}
			print(message);
			UICommon.alert(context, message);
		} catch (e) {
			UICommon.hideLoaderDialog(context);
			message = e.toString();
			print(message);
			UICommon.alert(context, message);
		}
	}

	String _villageName;
	selectVillageCallback(dynamic villageInfo){
		//print("선택된 단지  villageId : ${villageInfo["villageId"]}   villageName : ${villageInfo["villageName"]}");
		_villageName = villageInfo["villageName"];
		formData.siteId = villageInfo["villageId"].toString();
		setState(() {});
	}
}





/// 단지 목록 위젯
/// 기기 추가 다이얼로그 창 화면 
class VillageListWidget extends StatefulWidget {
	final Function(dynamic) callback;
	VillageListWidget({
		this.callback
	});
	@override
	_VillageListWidgetState createState() => _VillageListWidgetState();
}

class _VillageListWidgetState extends State < VillageListWidget > {

	String _searchValue;
	Widget build(BuildContext context) {

		if(_searchValue == null) _searchValue = "";

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
					'단지 선택',
					style: TextFont.big_w,
				),
			),
			content: Container(
				width: double.maxFinite,
				child: Column(
				mainAxisSize: MainAxisSize.min,
				children: < Widget > [

					Container(
						child: Row(
							children: [
								Expanded(
									child: Container(
										padding:EdgeInsets.only(left:20),

										child: TextFormField(
											decoration: InputDecoration(
												filled: true,
												hintText: '시/군/구 명',
												fillColor: BgColor.white,
											),
											validator: Validation.checkEmpty,
											onChanged: (value) {
												_searchValue = value;
											},
										),


									)
								),
								Container(
									child: InkWell(
										child: Container(
											width: 80,
											height: 36,
											padding: EdgeInsets.all(5),
											child: Image.asset(
												"assets/images/search.png",
												fit: BoxFit.fitHeight,
											),
										),
										onTap: () {

											//검색 아아콘 탭 
											setState(() {});
										}
									)
								)
							],
						),
					),
					Expanded(
						child: _buildVillageList(context, _searchValue, widget.callback)
					)
				]
				), ),
			actions: < Widget > [
        Container(
          decoration: BoxDecoration(
            color: BgColor.main
          ),
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: Text(
              '닫기',
							style: TextFont.medium_w
            ),
          ),
        )
			],
		);
	}


	/// 단지선택 팝업 다이얼로그에 들어가는 단지 목록 위젯
	Widget _buildVillageList(BuildContext context, String searchValue, Function callback) {
		final _userService = HomeService();
		return FutureBuilder < List < VillageModel >> (
			future: _userService.getVillages(searchValue),
			builder: (context, villageSnap) {
				if (villageSnap.connectionState == ConnectionState.waiting) {
					return ShowLoading();
				} else {
					List < VillageModel > villages = villageSnap.data;
					return _villageListView(villages, callback);
				}
			},
		);
	}


}

Widget _villageListView(List < VillageModel > villages, Function callback) {
	// print("_villageListView villages.length : ${villages.length}");
	return ListView.builder(
		shrinkWrap: true, //MUST TO ADDED
		physics: NeverScrollableScrollPhysics(), //MUST TO ADDED
		itemCount: villages.length,
		itemBuilder: (context, index) {
			return 
				InkWell(
				onTap: () {
					//print("_villageListView selected  villageId : ${villages[index].id} , villageName: ${villages[index].villageName}");
					var selectVillage = {"villageId" : villages[index].siteId, "villageName": villages[index].villageName};
					callback(selectVillage);
					Navigator.of(context).pop();
				},
				child: _villageTile(villages[index].villageName, villages[index].address, Icons.location_city)
			);
		}
	);
}

Widget _villageTile(String villageName, String address, IconData icon) {
	return ListTile(
		title: Text(villageName,
			style: TextStyle(
				fontWeight: FontWeight.w500,
				fontSize: 16,
			)),
		subtitle: Text(address),
		leading: Icon(
			icon,
			color: Colors.blue[500],
		),
	);
}
