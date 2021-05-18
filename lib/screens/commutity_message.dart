import 'package:flutter/material.dart';
import '../common/globals.dart';
import '../model/user_home_model.dart';
import '../service/fcm_service.dart';

class FamilyMessageScreen extends StatefulWidget {
	final UserHomeModel userHomeModel;
	FamilyMessageScreen({
		Key key,
		this.userHomeModel
	}): super(key: key);
	@override
	_FamilyMessageState createState() => _FamilyMessageState();
}

class _FamilyMessageState extends State < FamilyMessageScreen > {

	final GlobalKey < ScaffoldState > _scaffoldKey = new GlobalKey < ScaffoldState > ();
	final TextStyle tsTitle = TextStyle(color: Colors.grey, fontSize: 13);
	final TextStyle tsContent = TextStyle(color: Colors.blueGrey, fontSize: 15);
	TextEditingController _titleCon = TextEditingController();
	TextEditingController _bodyCon = TextEditingController();
	Map < String,
	bool > _map = Map();

	FirebaseService _firebaseService = FirebaseService();

	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {

		return Scaffold(
			key: _scaffoldKey,
			appBar: AppBar(title: Text("가족메세지")),
			body: Column(
				children: < Widget > [
					Expanded(
						child: ListView(
							children:
							widget.userHomeModel.users.map((UserHomeModelUsers user) {
								if (!_map.containsKey(user.fcmToken)) {
									_map[user.fcmToken] = false;
								}

								return Card(
									elevation: 2,
									child: Container(
										padding: const EdgeInsets.all(10),
											child: Row(
												children: < Widget > [
													Checkbox(
														value: _map[user.fcmToken],
														onChanged: (flag) {
															if (user.fcmToken == null || user.fcmToken == "") {
																flag = false;
															}
															setState(() {
																//print(flag);
																_map[user.fcmToken] = flag;
															});
														},
													),

													Expanded(
														child: Column(
															children: < Widget > [
																Row(
																	children: < Widget > [
																		Expanded(
																			child: Text(user.name,
																				style: tsContent
																			)
																		)
																	],
																),

															],
														),
													),

													IconButton(
														icon: Icon(Icons.message),
														tooltip: "메세지 보내기",
														onPressed: () {
															List < String > tokenList = List < String > ();
															tokenList.add(user.fcmToken);
															showMessageEditor(tokenList);
														},
													),


												],
											),
									),
								);
							}).toList(),
						),
					),

					Container(
						child: RaisedButton(
							child: Text("선택된 사용자 메세지 전송"),
							onPressed: () {
								List < String > tokenList = List < String > ();
								_map.forEach((String key, bool value) {
									if (value) {
										tokenList.add(key);
									}
								});
								showMessageEditor(tokenList);
							}
						),
					)

				],
			),
		);
	}



	void showMessageEditor(List < String > tokenList) {
		showDialog(
			context: context,
			barrierDismissible: false,
			builder: (context) {
				return AlertDialog(
					title: Text("메세지 전송"),
					content: Container(
						child: Column(
							children: < Widget > [
								TextField(
									maxLines: 5,
									decoration: InputDecoration(labelText: "내용"),
									controller: _bodyCon,
								)
							],
						),
					),
					actions: < Widget > [
						FlatButton(
							child: Text("취소"),
							onPressed: () {
								_titleCon.clear();
								_bodyCon.clear();
								Navigator.pop(context);
							},
						),
						FlatButton(
							child: Text("전송"),
							onPressed: () {
								if (_bodyCon.text.isNotEmpty) {
									String title = "${globalUser.name}님이 보낸 메시지";
									_firebaseService.sendMultiFCM(tokenList, title, _bodyCon.text);
								}
								Navigator.pop(context);
							},
						)
					],
				);
			},
		);
	}

}