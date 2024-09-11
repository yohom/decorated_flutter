// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:ui';

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

final SPACE_STATUS_BAR = SizedBox(height: window.padding.top);

const SPACE_ZERO = SizedBox.shrink();
const SLIVER_SPACE_ZERO = SliverToBoxAdapter(child: SizedBox.shrink());

const SPACE_1 = SizedBox(width: 1, height: 1);
const SPACE_1_HORIZONTAL = SizedBox(width: 1, height: 0);
const SPACE_1_VERTICAL = SizedBox(width: 0, height: 1);

const SLIVER_SPACE_1 = SliverToBoxAdapter(
  child: SizedBox(width: 1, height: 1),
);
const SLIVER_SPACE_1_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 1, height: 0),
);
const SLIVER_SPACE_1_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 1),
);

const SPACE_2 = SizedBox(width: 2, height: 2);
const SPACE_2_HORIZONTAL = SizedBox(width: 2, height: 0);
const SPACE_2_VERTICAL = SizedBox(width: 0, height: 2);

const SLIVER_SPACE_2 = SliverToBoxAdapter(
  child: SizedBox(width: 2, height: 2),
);
const SLIVER_SPACE_2_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 2, height: 0),
);
const SLIVER_SPACE_2_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 2),
);

const SPACE_4 = SizedBox(width: 4, height: 4);
const SPACE_4_HORIZONTAL = SizedBox(width: 4, height: 0);
const SPACE_4_VERTICAL = SizedBox(width: 0, height: 4);

const SLIVER_SPACE_4 = SliverToBoxAdapter(
  child: SizedBox(width: 4, height: 4),
);
const SLIVER_SPACE_4_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 4, height: 0),
);
const SLIVER_SPACE_4_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 4),
);

const SPACE_6 = SizedBox(width: 6, height: 6);
const SPACE_6_HORIZONTAL = SizedBox(width: 6, height: 0);
const SPACE_6_VERTICAL = SizedBox(width: 0, height: 6);

const SLIVER_SPACE_6 = SliverToBoxAdapter(
  child: SizedBox(width: 6, height: 6),
);
const SLIVER_SPACE_6_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 6, height: 0),
);
const SLIVER_SPACE_6_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 6),
);

const SPACE_8 = SizedBox(width: 8, height: 8);
const SPACE_8_HORIZONTAL = SizedBox(width: 8, height: 0);
const SPACE_8_VERTICAL = SizedBox(width: 0, height: 8);

const SLIVER_SPACE_8 = SliverToBoxAdapter(
  child: SizedBox(width: 8, height: 8),
);
const SLIVER_SPACE_8_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 8, height: 0),
);
const SLIVER_SPACE_8_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 8),
);

const SPACE_12 = SizedBox(width: 12, height: 12);
const SPACE_12_HORIZONTAL = SizedBox(width: 12, height: 0);
const SPACE_12_VERTICAL = SizedBox(width: 0, height: 12);

const SLIVER_SPACE_12 = SliverToBoxAdapter(
  child: SizedBox(width: 12, height: 12),
);
const SLIVER_SPACE_12_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 12, height: 0),
);
const SLIVER_SPACE_12_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 12),
);

const SPACE_16 = SizedBox(width: 16, height: 16);
const SPACE_16_HORIZONTAL = SizedBox(width: 16, height: 0);
const SPACE_16_VERTICAL = SizedBox(width: 0, height: 16);

const SLIVER_SPACE_16 = SliverToBoxAdapter(
  child: SizedBox(width: 16, height: 16),
);
const SLIVER_SPACE_16_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 16, height: 0),
);
const SLIVER_SPACE_16_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 16),
);

const SPACE_24 = SizedBox(width: 24, height: 24);
const SPACE_24_HORIZONTAL = SizedBox(width: 24, height: 0);
const SPACE_24_VERTICAL = SizedBox(width: 0, height: 24);

const SLIVER_SPACE_24 = SliverToBoxAdapter(
  child: SizedBox(width: 24, height: 24),
);
const SLIVER_SPACE_24_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 24, height: 0),
);
const SLIVER_SPACE_24_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 24),
);

const SPACE_32 = SizedBox(width: 32, height: 32);
const SPACE_32_HORIZONTAL = SizedBox(width: 32, height: 0);
const SPACE_32_VERTICAL = SizedBox(width: 0, height: 32);

const SLIVER_SPACE_32 = SliverToBoxAdapter(
  child: SizedBox(width: 32, height: 32),
);
const SLIVER_SPACE_32_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 32, height: 0),
);
const SLIVER_SPACE_32_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 32),
);

const SPACE_40 = SizedBox(width: 40, height: 40);
const SPACE_40_HORIZONTAL = SizedBox(width: 40, height: 0);
const SPACE_40_VERTICAL = SizedBox(width: 0, height: 40);

const SLIVER_SPACE_40 = SliverToBoxAdapter(
  child: SizedBox(width: 40, height: 40),
);
const SLIVER_SPACE_40_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 40, height: 0),
);
const SLIVER_SPACE_40_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 40),
);

const SPACE_48 = SizedBox(width: 48, height: 48);
const SPACE_48_HORIZONTAL = SizedBox(width: 48, height: 0);
const SPACE_48_VERTICAL = SizedBox(width: 0, height: 48);

const SLIVER_SPACE_48 = SliverToBoxAdapter(
  child: SizedBox(width: 48, height: 48),
);
const SLIVER_SPACE_48_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 48, height: 0),
);
const SLIVER_SPACE_48_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 48),
);

const SPACE_56 = SizedBox(width: 56, height: 56);
const SPACE_56_HORIZONTAL = SizedBox(width: 56, height: 0);
const SPACE_56_VERTICAL = SizedBox(width: 0, height: 56);

const SLIVER_SPACE_56 = SliverToBoxAdapter(
  child: SizedBox(width: 56, height: 56),
);
const SLIVER_SPACE_56_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 56, height: 0),
);
const SLIVER_SPACE_56_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 56),
);

const SPACE_64 = SizedBox(width: 64, height: 64);
const SPACE_64_HORIZONTAL = SizedBox(width: 64, height: 0);
const SPACE_64_VERTICAL = SizedBox(width: 0, height: 64);

const SLIVER_SPACE_64 = SliverToBoxAdapter(
  child: SizedBox(width: 64, height: 64),
);
const SLIVER_SPACE_64_HORIZONTAL = SliverToBoxAdapter(
  child: SizedBox(width: 64, height: 0),
);
const SLIVER_SPACE_64_VERTICAL = SliverToBoxAdapter(
  child: SizedBox(width: 0, height: 64),
);

const kDivider0 = Divider(height: 0);
const kDivider1 = Divider(height: 1);
const kDivider2 = Divider(height: 2);
const kDivider4 = Divider(height: 4);
const kDivider8 = Divider();
const kDivider12 = Divider(height: 12);
const kDivider16 = Divider(height: 16);
const kDivider24 = Divider(height: 24);
const kDivider48 = Divider(height: 48);
const kDivider64 = Divider(height: 64);
//endregion

const borderSide = BorderSide(color: Colors.grey, width: 0.3);
const topBottomBorder = Border(top: borderSide, bottom: borderSide);
const leftRightBorder = Border(left: borderSide, right: borderSide);
