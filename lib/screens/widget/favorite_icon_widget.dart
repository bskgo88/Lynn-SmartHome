import 'package:flutter/material.dart';
import '../../service/config_service.dart';
import '../../model/user_home_model.dart';

/// 하단 메뉴 영역
class FavoriteIconWidget extends StatefulWidget {
	final UserHomeDevices device;

	FavoriteIconWidget({
		Key key,
		@required this.device,
	}) : super(key: key);

	@override
	_FavoriteIconWidgetState createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State < FavoriteIconWidget > {

	Widget build(BuildContext context) {
		final _configService = ConfigService();
		UserHomeDevices device = widget.device;
		bool isButtonEnable = true;
		String isFavorite = device.isFavorite;
		return InkWell(
			onTap: () async {
				if (isButtonEnable) {
					isButtonEnable = false;
					await _configService.doFavorite(context, device.deviceId, device.id, (isFavorite == "yes" ? "no" : "yes"), true);
					isButtonEnable = true;
				}
			},
			onLongPress: () async {
				if (isButtonEnable) {
					isButtonEnable = false;
					await _configService.doFavorite(context, device.deviceId, device.id, (isFavorite == "yes" ? "no" : "yes"), true);
					isButtonEnable = true;
				}
			},
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            child: Image.asset(
              "assets/images/star" + (isFavorite == "yes" ? "_on" : "") + ".png",
              fit: BoxFit.fitHeight,
            )
          ),
          // Container(
          //   margin:EdgeInsets.only(top:1),
          //   alignment: Alignment.centerLeft,
          //   height: 20,
          //   child: Text(
          //     isFavorite == "yes" ? '해제하기' : '즐겨찾기',
          //     style:TextFont.vsmall,
          //   )
          // )
        ],
      ) 
		);
	}
}