import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../common/globals.dart';
import '../model/status_event_model.dart';
import '../service/device_service.dart';

const WEBSOCKET_URL = 'wss://0b6kf9xhc2.execute-api.ap-northeast-2.amazonaws.com/dev';


class WebsocketService {
	static final WebsocketService _singleton = new WebsocketService._internal();
	StreamController < String > streamController = new StreamController.broadcast(sync: true);
	WebSocket channel;
	static String initHomeId;

	factory WebsocketService(String homeId) {
		initHomeId = homeId;
		return _singleton;
	}

	WebsocketService._internal() {
		initWebSocketConnection();
	}

	initWebSocketConnection() async {
		print("conecting Websocket..");
		this.channel = await connectWebSocket();
		print("Websocket connection connection initializied - ${DateTime.now()}");

		//웹소켓 초기 메세지 보내기
		Map < String, dynamic > initMessage = {
			"action": "setHome",
			"data": initHomeId
		};
		print("Websocket send init message : ${json.encode(initMessage)} - ${DateTime.now()}");
		channel.add(json.encode(initMessage));

		this.channel.done.then((dynamic _) => _onDisconnected());
		broadcastNotifications();
	}

	broadcastNotifications() {
		this.channel.listen((streamData) {
			streamController.add(streamData);
		}, onDone: () {
			print("Websocket conecting aborted- ${DateTime.now()}");
			// 웹소켓이 끊어졌을 경우 재연결 함.
			//initWebSocketConnection();
		}, onError: (e) {
			print('Websocket Server error: ${DateTime.now()} $e');
			// 웹소켓이 에러발생시 재연결 함.
			//initWebSocketConnection();
		});
	}

	connectWebSocket() async {
		try {
			return await WebSocket.connect(WEBSOCKET_URL);
		} catch (e) {
			print("Websocket Error! can not connect WS connectWebSocket " + e.toString());
			await Future.delayed(Duration(milliseconds: 10000));
			return await connectWebSocket();
		}
	}

	void _onDisconnected() {
		// 웹소켓이 끊어졌을 경우 재연결 함.
		initWebSocketConnection();
	}
}




class WebSocketListener{

  // ignore: close_sinks
  static StreamController < String > _streamController;
	static void listen(BuildContext context, String homeId){

		// 웹소켓 연결 및 Listen
		if (IS_SERVER_MODE) {
			try {
				if (_streamController == null) {
					print("WebSocketListener  listen _streamController is null - ${DateTime.now()}");
					_streamController = WebsocketService(homeId).streamController;
				}
				_streamController.stream.listen((message) {
					try {
						//print("setWebSocketChannel receive message : $message");
						final statusEventModel = StatusEventModel.fromJson(json.decode(message));
						for (var event in statusEventModel.eventList) {
							print("WebSocketChannel receive message device_id : ${statusEventModel.deviceId} command : ${event.command}  value : ${event.value}");
							DeviceService().setDeviceChangedStatus(context, statusEventModel.deviceId, event.command, event.value);
						}
					} catch (e) {
						// fromJson parsing 이 안되는 문자열 수신되는 경우가 있음 - 무시하고  skip
					}
				});
			} catch (e) {
				print("WebSocketListener  listen Initialize Error : $e");
			}
		}
	}
}