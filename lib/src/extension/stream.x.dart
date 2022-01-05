import 'dart:async';

import 'package:decorated_flutter/src/utils/utils.export.dart';
import 'package:rxdart/rxdart.dart';

extension ListStreamX<T> on Stream<List<T>> {
  /// 在一个列表Stream中, 找出目标项, 并转换为该项的Stream
  ///
  /// 如果提供了对比函数[equal], 那么以对比函数为准, 否则直接使用[==]对比.
  /// 使用场景:
  ///   一个列表页, 点击进入详情页, 带入列表页的单项数据并同时请求详情页的信息. 如果对详情页
  ///   的操作会触发单项数据的改变, 那么就可以使用这个方法去动态改变单项数据的值, 并发射, 实现
  ///   数据的联动更新.
  Stream<T> select(T t, {bool Function(T t1, T t2)? equal}) {
    if (equal != null) {
      return map((list) => list.firstWhere((e) => equal(e, t)));
    } else {
      return map((list) => list.firstWhere((e) => e == t));
    }
  }

  /// 根据搜索关键字[keyword]流来过滤原始流[this]
  Stream<List<T>> search(
    Stream<String> keyword, {
    required SearchCallback<T> by,
  }) {
    return Rx.combineLatest2<List<T>?, String, List<T>>(
      this,
      keyword,
      (source, keyword) {
        return source?.where((it) => by(it, keyword)).toList() ?? [];
      },
    );
  }
}

extension StreamSubscriptionX<T> on StreamSubscription<T> {}
