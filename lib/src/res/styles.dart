import 'package:flutter/material.dart';

import 'dimens.dart';

const _tiny = TextStyle(fontSize: kTextTiny);
const _small = TextStyle(fontSize: kTextSmall);
const _normal = TextStyle();
const _normalThin = TextStyle(fontWeight: FontWeight.w300);
const _normalBold = TextStyle(fontWeight: FontWeight.bold);
const _big = TextStyle(fontSize: kTextBig);
const _normalStruct = StrutStyle(height: 1.3);

TextStyle textSmall = _small;

TextStyle textNormal = _normal;

TextStyle textNormalThin = _normalThin;

TextStyle textBlackThin = _normalThin.copyWith(color: Colors.black);

TextStyle textBlack = _normal.copyWith(color: Colors.black);

TextStyle textBlackBold = _normalBold.copyWith(color: Colors.black);

StrutStyle structNormal = _normalStruct;

TextStyle textGrey = _normal.copyWith(color: Colors.grey);

TextStyle textWhite = _normal.copyWith(color: Colors.white);

TextStyle textWhiteSmall = _small.copyWith(color: Colors.white);

TextStyle textWhiteTiny = _tiny.copyWith(color: Colors.white);

TextStyle textTiny = _tiny;

TextStyle textWhiteBig = _big.copyWith(color: Colors.white);

TextStyle textBig = _big;

TextStyle textWhiteBigBold = _big.copyWith(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

TextStyle textWhiteSpacing =
    _normal.copyWith(color: Colors.white, letterSpacing: 1);

TextStyle textUnderline =
    _normal.copyWith(decoration: TextDecoration.underline);
