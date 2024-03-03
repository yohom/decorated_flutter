import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';

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
    required SearchKeywordCallback<T> by,
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

extension SelectableListStreamX on Stream<List<Selectable>> {
  /// 把[Selectable]的列表流转换为对应的选中数量流
  Stream<int> selectedCount() {
    return map((event) => event.whereOrEmpty((it) => it.isSelected).length);
  }
}

extension StringStream on Stream<String> {
  static LoadingBuilder? loadingWidgetBuilder;
  static Color? backgroundColor;
  static bool loadingCancelable = false;
  static String defaultLoadingText = '加载中...';

  Future<void> loading({
    bool? cancelable,
    String? initText,
    Color? backgroundColor,
  }) async {
    final context = gNavigatorKey.currentContext;
    if (context == null) {
      throw '请在MaterialApp/CupertinoApp中设置navigatorKey为gNavigatorKey';
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    final theme = Theme.of(context);

    // 是被future pop的还是按返回键pop的
    bool popByStream = true;

    final subject = BehaviorSubject<String>();

    // 显示loading
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return Theme(
          data: theme,
          child: WillPopScope(
            onWillPop: () async => cancelable ?? loadingCancelable,
            child: StreamBuilder<String>(
              stream: subject.stream,
              builder: (_, snapshot) {
                return ModalLoading(snapshot.data ?? '加载中...');
              },
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 150),
      barrierDismissible: cancelable ?? loadingCancelable,
      barrierLabel: 'Dismiss',
      barrierColor:
          backgroundColor ?? FutureX.backgroundColor ?? Colors.black54,
    ).whenComplete(() {
      // 1. 如果是返回键pop的, 那么设置成true, 这样future完成时就不会pop了
      // 2. 如果是future完成导致的pop, 那么这一行是没用任何作用的
      popByStream = false;
    });

    try {
      await for (final item in this) {
        subject.add(item);
      }
    } catch (error, stacktrace) {
      subject.addError(error, stacktrace);
    } finally {
      // 结束关闭流
      subject.close();
    }

    return subject.listen(doNothing1).asFuture().whenComplete(() {
      if (popByStream && navigator.canPop()) {
        navigator.pop();
      }
    });
  }
}
