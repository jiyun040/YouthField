import 'package:flutter/material.dart';
import 'package:youthfield/constants/color.dart';

class YouthFieldTextStyle {
  /// title
  static const TextStyle title1 = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle title4 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  /// body
  static const TextStyle body1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body4 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  /// etc
  static const TextStyle placeholder = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle textCount = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle smallButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}

const TextStyle defaultTextStyle = TextStyle(
  color: YouthFieldColor.black800,
  fontFamily: 'LINESeedKR',
);