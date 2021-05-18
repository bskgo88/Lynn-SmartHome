import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

class Radii {
  static const BorderRadiusGeometry radi5 = BorderRadius.all(Radius.circular(5));
  static const BorderRadiusGeometry radi10 = BorderRadius.all(Radius.circular(10));
  static const BorderRadiusGeometry radi15 = BorderRadius.all(Radius.circular(15));
  static const BorderRadiusGeometry radi20 = BorderRadius.all(Radius.circular(20));
  static const BorderRadiusGeometry radi25 = BorderRadius.all(Radius.circular(25));
  static const BorderRadiusGeometry radi30 = BorderRadius.all(Radius.circular(30));
  static const BorderRadiusGeometry radi35 = BorderRadius.all(Radius.circular(35));
  static const BorderRadiusGeometry radi40 = BorderRadius.all(Radius.circular(40));
  static const BorderRadiusGeometry radi45 = BorderRadius.all(Radius.circular(45));
  static const BorderRadiusGeometry radi50 = BorderRadius.all(Radius.circular(50));
  static const BorderRadiusGeometry radi55 = BorderRadius.all(Radius.circular(55));
  static const BorderRadiusGeometry radi60 = BorderRadius.all(Radius.circular(60));
  static const BorderRadiusGeometry radi65 = BorderRadius.all(Radius.circular(65));
  static const BorderRadiusGeometry radi70 = BorderRadius.all(Radius.circular(70));
}

class Shadows {
  static const BoxShadow fshadow = BoxShadow(
    color: Color.fromARGB(38, 0, 0, 0),
    offset: Offset(3, 3),
    blurRadius: 15,
  );
  static const BoxShadow sshadow = BoxShadow(
    color: Color.fromARGB(38, 0, 0, 0),
    offset: Offset(2, 2),
    blurRadius: 8,
  );
  static const BoxShadow inShadow = BoxShadow(
    color: Color.fromARGB(38, 0, 0, 0),
    offset: Offset(0, 0),
    blurRadius: 0.0,
  );
  static const BoxShadow none = BoxShadow(
    color: Color.fromARGB(0, 0, 0, 0),
    offset: Offset(0, 0),
    blurRadius: 0.0,
  );
}

class OnItem {
  static const LinearGradient onset = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 230, 230, 230),
      Color.fromARGB(255, 245, 245, 245),
      Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 245, 245, 245),
      Color.fromARGB(255, 230, 230, 230),
    ],
    stops: [
      0,
      0.15,
      0.5,
      0.85,
      1
    ]
  );
  static const LinearGradient onsetDeep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 230, 230, 230),
      Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 230, 230, 230),
      Color.fromARGB(255, 0, 0, 0),
    ],
    stops: [
      0,
      0.15,
      0.5,
      0.85,
      1
    ]
  );
  static const LinearGradient offset = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
        Color.fromARGB(255, 255, 255, 255),
      ],
      stops: [
        0,
        0.15,
        0.5,
        0.85,
        1
      ]);
  static const LinearGradient full = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromARGB(255, 220, 220, 220),
        Color.fromARGB(255, 255, 255, 255),
      ],
      stops: [
        0,
        1
      ]);
}

class BgColor {
  static const Color gray = Color.fromARGB(255, 153, 153, 153);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color black45 = Color.fromARGB(255, 45, 45, 45);
  static const Color lgray = Color.fromARGB(255, 245, 245, 245);
  static const Color rgray = Color.fromARGB(255, 225, 225, 225);
  static const Color main = Color.fromARGB(255, 239, 144, 0);
  static const Color none = Color.fromARGB(0, 0, 0, 0);
  static const Color shadow = Color.fromARGB(38, 0, 0, 0);
  static const Color transWhite = Color.fromARGB(150, 255, 255, 255);
  static const Color transBlack = Color.fromARGB(150, 0, 0, 0);
  static const Color transgray = Color.fromARGB(150, 225, 225, 225);
  static const Color newmain = Color.fromARGB(255, 243, 102, 40);
}

class TextFont {
  static const TextStyle nanumb = TextStyle(fontFamily: 'NanumBarunGothic');
  static const TextStyle vsmall = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 8,
    color: const Color(0xff666666)
  );
  static const TextStyle small = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: const Color(0xff999999)
  );
  static const TextStyle small_n = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: const Color(0xff333333)
  );
  static const TextStyle small_m = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: const Color(0xffef9000)
  );
  static const TextStyle normal = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: const Color(0xff333333)
  );
  static const TextStyle normal_w = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: const Color(0xffffffff)
  );
  static const TextStyle normal_m = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: const Color(0xffef9000)
  );
  static const TextStyle normal_g = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: const Color(0xff999999)
  );
  static const TextStyle medium = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: const Color(0xff333333)
  );
  static const TextStyle medium_w = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: const Color(0xffffffff)
  );
  static const TextStyle medium_g = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: const Color(0xffcccccc)
  );
  static const TextStyle medium_99 = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: const Color(0xff999999)
  );
  static const TextStyle medium_66 = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: const Color(0xff666666)
  );
  static const TextStyle medium_m = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: const Color(0xffef9000)
  );
  static const TextStyle semibig = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: const Color(0xff333333)
  );
  static const TextStyle semibig_w = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: const Color(0xffffffff)
  );
  static const TextStyle big_n = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: const Color(0xff333333)
  );
  static const TextStyle big_wn = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: const Color(0xffffffff)
  );
  static const TextStyle big = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: const Color(0xff333333)
  );
  static const TextStyle big_w = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: const Color(0xffffffff)
  );
  
  static const TextStyle big_lb = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: const Color(0xff5790f3)
  );
  
  static const TextStyle big_sb = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: const Color(0xffb5d0ff)
  );
  static const TextStyle item = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 10,
    color: const Color(0xff333333)
  );
  static const TextStyle item_on = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 10,
    color: const Color(0xffef9000)
  );
  static const TextStyle item2 = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: const Color(0xff333333)
  );

  static const TextStyle great = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: const Color(0xff333333)
  );
  static const TextStyle great_w = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: const Color(0xffffffff)
  );

  static const TextStyle introText = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: const Color(0xff3C3C3C)
  );
  
  static const TextStyle introText_w = TextStyle(
    fontFamily: 'NanumBarunGothic',
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: const Color(0xffffffff)
  );
}
