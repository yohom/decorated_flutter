import 'package:flutter/material.dart';

//region space
@Deprecated('使用kSpace0代替')
const kSpaceZero = 0.0;
@Deprecated('使用kSpace1代替')
const kSpaceTiny = 1.0;
@Deprecated('使用kSpace2代替')
const kSpaceLittle = 2.0;
@Deprecated('使用kSpace4代替')
const kSpaceSmall = 4.0;
@Deprecated('使用kSpace8代替')
const kSpaceNormal = 8.0;
@Deprecated('使用kSpace12代替')
const kSpaceLittleBig = 12.0;
@Deprecated('使用kSpace16代替')
const kSpaceBig = 16.0;
@Deprecated('使用kSpace24代替')
const kSpaceLarge = 24.0;
@Deprecated('使用kSpace32代替')
const kSpaceHuge = 32.0;
@Deprecated('使用kSpace48代替')
const kSpaceGreat = 48.0;
@Deprecated('使用kSpace64代替')
const kSpaceGiant = 64.0;

const kSpace0 = 0.0;
const kSpace1 = 1.0;
const kSpace2 = 2.0;
const kSpace4 = 4.0;
const kSpace6 = 6.0;
const kSpace8 = 8.0;
const kSpace12 = 12.0;
const kSpace16 = 16.0;
const kSpace24 = 24.0;
const kSpace32 = 32.0;
const kSpace48 = 48.0;
const kSpace56 = 56.0;
const kSpace64 = 64.0;

const SPACE_ZERO = SizedBox.shrink();

@deprecated
const SPACE_TINY = SizedBox(width: kSpaceTiny, height: kSpaceTiny);
@deprecated
const SPACE_TINY_HORIZONTAL = SizedBox(width: kSpaceTiny, height: kSpaceZero);
@deprecated
const SPACE_TINY_VERTICAL = SizedBox(width: kSpaceZero, height: kSpaceTiny);

const SPACE_1 = SizedBox(width: kSpace1, height: kSpace1);
const SPACE_1_HORIZONTAL = SizedBox(width: kSpace1, height: kSpace0);
const SPACE_1_VERTICAL = SizedBox(width: kSpace0, height: kSpace1);

@deprecated
const SPACE_LITTLE = SizedBox(width: kSpaceLittle, height: kSpaceLittle);
@deprecated
const SPACE_LITTLE_HORIZONTAL = SizedBox(width: kSpaceLittle, height: kSpace0);
@deprecated
const SPACE_LITTLE_VERTICAL = SizedBox(width: kSpace0, height: kSpaceLittle);

const SPACE_2 = SizedBox(width: kSpace2, height: kSpace2);
const SPACE_2_HORIZONTAL = SizedBox(width: kSpace2, height: kSpace0);
const SPACE_2_VERTICAL = SizedBox(width: kSpace0, height: kSpace2);

@deprecated
const SPACE_SMALL = SizedBox(width: kSpace4, height: kSpace4);
@deprecated
const SPACE_SMALL_HORIZONTAL = SizedBox(width: kSpace4, height: kSpace0);
@deprecated
const SPACE_SMALL_VERTICAL = SizedBox(width: kSpace0, height: kSpace4);

const SPACE_4 = SizedBox(width: kSpace4, height: kSpace4);
const SPACE_4_HORIZONTAL = SizedBox(width: kSpace4, height: kSpace0);
const SPACE_4_VERTICAL = SizedBox(width: kSpace0, height: kSpace4);

@deprecated
const SPACE_NORMAL = SizedBox(width: kSpaceNormal, height: kSpaceNormal);
@deprecated
const SPACE_NORMAL_HORIZONTAL = SizedBox(width: kSpaceNormal, height: kSpace0);
@deprecated
const SPACE_NORMAL_VERTICAL = SizedBox(width: kSpace0, height: kSpaceNormal);

const SPACE_8 = SizedBox(width: kSpace8, height: kSpace8);
const SPACE_8_HORIZONTAL = SizedBox(width: kSpace8, height: kSpace0);
const SPACE_8_VERTICAL = SizedBox(width: kSpace0, height: kSpace8);

@deprecated
const SPACE_LITTLE_BIG = SizedBox(width: kSpace12, height: kSpace12);
@deprecated
const SPACE_LITTLE_BIG_HORIZONTAL = SizedBox(width: kSpace12, height: kSpace0);
@deprecated
const SPACE_LITTLE_BIG_VERTICAL = SizedBox(width: kSpace0, height: kSpace12);

const SPACE_12 = SizedBox(width: kSpace12, height: kSpace12);
const SPACE_12_HORIZONTAL = SizedBox(width: kSpace12, height: kSpace0);
const SPACE_12_VERTICAL = SizedBox(width: kSpace0, height: kSpace12);

@deprecated
const SPACE_BIG = SizedBox(width: kSpace16, height: kSpace16);
@deprecated
const SPACE_BIG_HORIZONTAL = SizedBox(width: kSpace16, height: kSpace0);
@deprecated
const SPACE_BIG_VERTICAL = SizedBox(width: kSpace0, height: kSpace16);

const SPACE_16 = SizedBox(width: kSpace16, height: kSpace16);
const SPACE_16_HORIZONTAL = SizedBox(width: kSpace16, height: kSpace0);
const SPACE_16_VERTICAL = SizedBox(width: kSpace0, height: kSpace16);

@deprecated
const SPACE_LARGE = SizedBox(width: kSpace24, height: kSpace24);
@deprecated
const SPACE_LARGE_HORIZONTAL = SizedBox(width: kSpace24, height: kSpace0);
@deprecated
const SPACE_LARGE_VERTICAL = SizedBox(width: kSpace0, height: kSpace24);

const SPACE_24 = SizedBox(width: kSpace24, height: kSpace24);
const SPACE_24_HORIZONTAL = SizedBox(width: kSpace24, height: kSpace0);
const SPACE_24_VERTICAL = SizedBox(width: kSpace0, height: kSpace24);

@deprecated
const SPACE_HUGE = SizedBox(width: kSpace32, height: kSpace32);
@deprecated
const SPACE_HUGE_HORIZONTAL = SizedBox(width: kSpace32, height: kSpace0);
@deprecated
const SPACE_HUGE_VERTICAL = SizedBox(width: kSpace0, height: kSpace32);

const SPACE_32 = SizedBox(width: kSpace32, height: kSpace32);
const SPACE_32_HORIZONTAL = SizedBox(width: kSpace32, height: kSpace0);
const SPACE_32_VERTICAL = SizedBox(width: kSpace0, height: kSpace32);

@deprecated
const SPACE_GREAT = SizedBox(width: kSpaceGreat, height: kSpaceGreat);
@deprecated
const SPACE_GREAT_HORIZONTAL = SizedBox(width: kSpaceGreat, height: kSpace0);
@deprecated
const SPACE_GREAT_VERTICAL = SizedBox(width: kSpace0, height: kSpaceGreat);

const SPACE_48 = SizedBox(width: kSpace48, height: kSpace48);
const SPACE_48_HORIZONTAL = SizedBox(width: kSpace48, height: kSpace0);
const SPACE_48_VERTICAL = SizedBox(width: kSpace0, height: kSpace48);

@deprecated
const SPACE_GIANT = SizedBox(width: kSpace64, height: kSpace64);
@deprecated
const SPACE_GIANT_HORIZONTAL = SizedBox(width: kSpace64, height: kSpace0);
@deprecated
const SPACE_GIANT_VERTICAL = SizedBox(width: kSpace0, height: kSpace64);

const SPACE_64 = SizedBox(width: kSpace64, height: kSpace64);
const SPACE_64_HORIZONTAL = SizedBox(width: kSpace64, height: kSpace0);
const SPACE_64_VERTICAL = SizedBox(width: kSpace0, height: kSpace64);

const kDividerZero = Divider(height: kSpaceZero);
const kDividerTiny = Divider(height: kSpaceTiny);
const kDividerLittle = Divider(height: kSpaceLittle);
const kDividerSmall = Divider(height: kSpaceSmall);
const kDividerNormal = Divider();
const kDividerLittleBig = Divider(height: kSpaceLittleBig);
const kDividerBig = Divider(height: kSpaceBig);
const kDividerLarge = Divider(height: kSpaceLarge);
const kDividerHuge = Divider(height: kSpaceHuge);
const kDividerGreat = Divider(height: kSpaceGreat);
const kDividerGiant = Divider(height: kSpaceGiant);
//endregion

const borderSide = BorderSide(color: Colors.grey, width: 0.3);
const topBottomBorder = Border(top: borderSide, bottom: borderSide);
const leftRightBorder = Border(left: borderSide, right: borderSide);
