// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

// 这里使用SizedBox.shrink代替了
const NIL = SizedBox.shrink();
const SLIVER_NIL = SliverToBoxAdapter(child: SizedBox.shrink());
