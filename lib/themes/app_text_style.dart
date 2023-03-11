import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_font.dart';

class AppTextStyle {
  static const h1 = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  static const h2 = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  static const h3 = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: AppFont.avenir,
    fontSize: 22,
  );
  static const largeTitle = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );
  static const body20 = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 20,
  );
  static const body15 = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 15,
  );
  static const body17 = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 17,
  );
  static const caption11 = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 11,
  );
  static const caption13 = TextStyle(
    fontFamily: AppFont.avenir,
    fontSize: 13,
  );
  static const appName = TextStyle(
    fontFamily: AppFont.silkscreen,
    fontSize: 50,
    color: AppTextColor.pink,
    fontStyle: FontStyle.italic,
  );
}
