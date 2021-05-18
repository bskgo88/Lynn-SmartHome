import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../common/globals.dart';
import '../model/user_home_model.dart';
import '../service/user_service.dart';



/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
class FcmService {
	static final FcmService _singleton = new FcmService._internal();
	static UserHomeModel _userHomeModel;
	static BuildContext _context;

	factory FcmService(BuildContext context, UserHomeModel userHomeModel) {
		_context = context;
		_userHomeModel = userHomeModel;
		return _singleton;
	}

	FcmService._internal() {
		initFcm();
	}

	initFcm() async {
		print("Firebase FcmService.initFcm called! - ${DateTime.now()}");
		await Firebase.initializeApp();
		//final FirebaseMessaging _fcm = FirebaseMessaging();

		// 사용자 토큰 저장  getAPNSToken
		FirebaseMessaging.instance.getToken().then((String token) {
			//assert(token != null);
			print("Firebase _fcm.getToken() token : $token");
      if(token != null){
        final userEmail = globalUser.email;
        int idx = _userHomeModel.users.indexWhere((user) => user.email == userEmail);
        if (idx != -1) {
          if (_userHomeModel.users[idx].fcmToken != token) {
            dynamic userInfo = {"fcm_token": token};
            final userService = UserService();
            // 사용자 FCM 토큰 서버 저장 처리 
            userService.doChangeUserInfo(userInfo).then((bool isSuccess){
              if(isSuccess){
                _userHomeModel.users[idx].fcmToken = token;
              }
            });
          }
        }
      }
		});

		// FCM 수신 설정

    // 앱이 실행중일 경우
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print("onMessage: $message");
      showDialog(
        context: _context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
          ),
          actions: < Widget > [
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    });

    // 앱이 백그라운드 실행중이거나 종료된 경우
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
	}

}

class FirebaseService{
	// token리스트에 해당하는 디바이스들로 FCM 전송
	void sendMultiFCM(List < String > tokenList, String title, String body) async {
		if (tokenList == null || tokenList.length == 0) return;
		//await Firebase.initializeApp();
		final HttpsCallable sendFCM = FirebaseFunctions.instance.httpsCallable('sendFCM');

  		// ignore: unused_local_variable
		final HttpsCallableResult result = await sendFCM.call( <String, dynamic > {
				"token": tokenList,
				"title": title,
				"body": body,
			},
		);
	}

	// token에 해당하는 디바이스로 커스텀 FCM 전송
	void sendFCM(String token, String title, String body) async {
		if (title.isEmpty || body.isEmpty) return;
		//await Firebase.initializeApp();
		final HttpsCallable sendFCM = FirebaseFunctions.instance.httpsCallable('sendFCM');

  		// ignore: unused_local_variable
		final HttpsCallableResult result = await sendFCM.call( <
			String, dynamic > {
				"token": token,
				"title": title,
				"body": body,
			},
		);
	}
}