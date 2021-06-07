import 'package:flutter/material.dart';

//region space
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
const kSpace40 = 40.0;
const kSpace48 = 48.0;
const kSpace56 = 56.0;
const kSpace64 = 64.0;

const SPACE_ZERO = SizedBox.shrink();
const SLIVER_SPACE_ZERO = SliverToBoxAdapter(child: SizedBox.shrink());

const SPACE_1 = SizedBox(width: kSpace1, height: kSpace1);
const SPACE_1_HORIZONTAL = SizedBox(width: kSpace1, height: kSpace0);
const SPACE_1_VERTICAL = SizedBox(width: kSpace0, height: kSpace1);

const SLIVER_SPACE_1 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace1, height: kSpace1),
);
const SLIVER_SPACE_1_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace1, height: kSpace0),
);
const SLIVER_SPACE_1_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace1),
);

const SPACE_2 = SizedBox(width: kSpace2, height: kSpace2);
const SPACE_2_HORIZONTAL = SizedBox(width: kSpace2, height: kSpace0);
const SPACE_2_VERTICAL = SizedBox(width: kSpace0, height: kSpace2);

const SLIVER_SPACE_2 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace2, height: kSpace2),
);
const SLIVER_SPACE_2_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace2, height: kSpace0),
);
const SLIVER_SPACE_2_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace2),
);

const SPACE_4 = SizedBox(width: kSpace4, height: kSpace4);
const SPACE_4_HORIZONTAL = SizedBox(width: kSpace4, height: kSpace0);
const SPACE_4_VERTICAL = SizedBox(width: kSpace0, height: kSpace4);

const SLIVER_SPACE_4 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace4, height: kSpace4),
);
const SLIVER_SPACE_4_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace4, height: kSpace0),
);
const SLIVER_SPACE_4_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace4),
);

const SPACE_6 = SizedBox(width: kSpace6, height: kSpace6);
const SPACE_6_HORIZONTAL = SizedBox(width: kSpace6, height: kSpace0);
const SPACE_6_VERTICAL = SizedBox(width: kSpace0, height: kSpace6);

const SLIVER_SPACE_6 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace6, height: kSpace6),
);
const SLIVER_SPACE_6_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace6, height: kSpace0),
);
const SLIVER_SPACE_6_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace6),
);

const SPACE_8 = SizedBox(width: kSpace8, height: kSpace8);
const SPACE_8_HORIZONTAL = SizedBox(width: kSpace8, height: kSpace0);
const SPACE_8_VERTICAL = SizedBox(width: kSpace0, height: kSpace8);

const SLIVER_SPACE_8 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace8, height: kSpace8),
);
const SLIVER_SPACE_8_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace8, height: kSpace0),
);
const SLIVER_SPACE_8_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace8),
);

const SPACE_12 = SizedBox(width: kSpace12, height: kSpace12);
const SPACE_12_HORIZONTAL = SizedBox(width: kSpace12, height: kSpace0);
const SPACE_12_VERTICAL = SizedBox(width: kSpace0, height: kSpace12);

const SLIVER_SPACE_12 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace12, height: kSpace12),
);
const SLIVER_SPACE_12_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace12, height: kSpace0),
);
const SLIVER_SPACE_12_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace12),
);

const SPACE_16 = SizedBox(width: kSpace16, height: kSpace16);
const SPACE_16_HORIZONTAL = SizedBox(width: kSpace16, height: kSpace0);
const SPACE_16_VERTICAL = SizedBox(width: kSpace0, height: kSpace16);

const SLIVER_SPACE_16 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace16, height: kSpace16),
);
const SLIVER_SPACE_16_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace16, height: kSpace0),
);
const SLIVER_SPACE_16_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace16),
);

const SPACE_24 = SizedBox(width: kSpace24, height: kSpace24);
const SPACE_24_HORIZONTAL = SizedBox(width: kSpace24, height: kSpace0);
const SPACE_24_VERTICAL = SizedBox(width: kSpace0, height: kSpace24);

const SLIVER_SPACE_24 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace24, height: kSpace24),
);
const SLIVER_SPACE_24_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace24, height: kSpace0),
);
const SLIVER_SPACE_24_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace24),
);

const SPACE_32 = SizedBox(width: kSpace32, height: kSpace32);
const SPACE_32_HORIZONTAL = SizedBox(width: kSpace32, height: kSpace0);
const SPACE_32_VERTICAL = SizedBox(width: kSpace0, height: kSpace32);

const SLIVER_SPACE_32 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace32, height: kSpace32),
);
const SLIVER_SPACE_32_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace32, height: kSpace0),
);
const SLIVER_SPACE_32_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace32),
);

const SPACE_40 = SizedBox(width: kSpace40, height: kSpace40);
const SPACE_40_HORIZONTAL = SizedBox(width: kSpace40, height: kSpace0);
const SPACE_40_VERTICAL = SizedBox(width: kSpace0, height: kSpace40);

const SLIVER_SPACE_40 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace40, height: kSpace40),
);
const SLIVER_SPACE_40_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace40, height: kSpace0),
);
const SLIVER_SPACE_40_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace40),
);

const SPACE_48 = SizedBox(width: kSpace48, height: kSpace48);
const SPACE_48_HORIZONTAL = SizedBox(width: kSpace48, height: kSpace0);
const SPACE_48_VERTICAL = SizedBox(width: kSpace0, height: kSpace48);

const SLIVER_SPACE_48 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace48, height: kSpace48),
);
const SLIVER_SPACE_48_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace48, height: kSpace0),
);
const SLIVER_SPACE_48_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace48),
);

const SPACE_56 = SizedBox(width: kSpace56, height: kSpace56);
const SPACE_56_HORIZONTAL = SizedBox(width: kSpace56, height: kSpace0);
const SPACE_56_VERTICAL = SizedBox(width: kSpace0, height: kSpace56);

const SLIVER_SPACE_56 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace56, height: kSpace56),
);
const SLIVER_SPACE_56_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace56, height: kSpace0),
);
const SLIVER_SPACE_56_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace56),
);

const SPACE_64 = SizedBox(width: kSpace64, height: kSpace64);
const SPACE_64_HORIZONTAL = SizedBox(width: kSpace64, height: kSpace0);
const SPACE_64_VERTICAL = SizedBox(width: kSpace0, height: kSpace64);

const SLIVER_SPACE_64 = SliverToBoxAdapter(
  child: SizedBox(width: kSpace64, height: kSpace64),
);
const SLIVER_SPACE_64_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace64, height: kSpace0),
);
const SLIVER_SPACE_64_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: kSpace0, height: kSpace64),
);

const kDivider0 = Divider(height: kSpace0);
const kDivider1 = Divider(height: kSpace1);
const kDivider2 = Divider(height: kSpace2);
const kDivider4 = Divider(height: kSpace4);
const kDivider8 = Divider();
const kDivider12 = Divider(height: kSpace12);
const kDivider16 = Divider(height: kSpace16);
const kDivider24 = Divider(height: kSpace24);
const kDivider48 = Divider(height: kSpace48);
const kDivider64 = Divider(height: kSpace64);
//endregion

const borderSide = BorderSide(color: Colors.grey, width: 0.3);
const topBottomBorder = Border(top: borderSide, bottom: borderSide);
const leftRightBorder = Border(left: borderSide, right: borderSide);
