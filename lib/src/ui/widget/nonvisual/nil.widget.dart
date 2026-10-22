// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

// 这里使用SizedBox.shrink代替了
const NIL = SizedBox.shrink();
const SLIVER_NIL = SliverToBoxAdapter(child: SizedBox.shrink());
const PREFERRED_NIL = PreferredSize(preferredSize: Size.zero, child: NIL);
const HORIZONTAL_NIL = SizedBox(width: double.infinity, height: 0.0);
const VERTICAL_NIL = SizedBox(width: 0.0, height: double.infinity);
