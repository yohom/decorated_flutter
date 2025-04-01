import 'dart:math';

import 'package:decorated_flutter/src/mixin/mixin.export.dart';
import 'package:decorated_flutter/src/utils/utils.export.dart';

extension IterableX<T> on Iterable<T> {
  /// 寻找元素, 找不到就返回null, 如果多余一个就返回第一个
  T? find(bool Function(T it) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }

  /// 最后一个索引
  int get lastIndex {
    return length - 1;
  }

  T? operator [](int index) {
    return (index >= 0 && index < length) ? elementAt(index) : null;
  }

  Iterable<T> operator +(T other) => followedBy([other]);

  Iterable<T> operator -(T other) => where((element) => element != other);

  Map<S, List<T>> groupBy<S>(S Function(T) key) {
    var map = <S, List<T>>{};
    for (var element in this) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  int countWhere(bool Function(T element) test) {
    try {
      return where(test).length;
    } catch (_) {
      return 0;
    }
  }

  T? lastWhereOrNull(bool Function(T element) test) {
    try {
      return lastWhere(test);
    } catch (_) {
      return null;
    }
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  T? getOrNull(int? index) {
    if (index == null) return null;
    try {
      final result = this[index];
      return result;
    } catch (e) {
      return null;
    }
  }

  Iterable<T> whereOrEmpty(bool Function(T element) test) {
    try {
      return where(test);
    } catch (e) {
      return [];
    }
  }

  Iterable<(T?, T, T?)> get tripled {
    return [
      for (int i = 0; i < length; i++) (this[i - 1], elementAt(i), this[i + 1])
    ];
  }

  @Deprecated('命名统一, 使用pairedWithPrev代替')
  Iterable<(T?, T)> get doubledWithPrev {
    return [for (int i = 0; i < length; i++) (this[i - 1], elementAt(i))];
  }

  @Deprecated('命名统一, 使用pairedWithNext代替')
  Iterable<(T, T?)> get doubledWithNext {
    return [for (int i = 0; i < length; i++) (elementAt(i), this[i + 1])];
  }

  /// 每个元素与其前一个元素组成一对
  Iterable<(T?, T)> get pairedWithPrev {
    return [for (int i = 0; i < length; i++) (this[i - 1], elementAt(i))];
  }

  /// 每个元素与其后一个元素组成一对
  Iterable<(T, T?)> get pairedWithNext {
    return [for (int i = 0; i < length; i++) (elementAt(i), this[i + 1])];
  }

  /// 按[count]数给列表分组
  List<List<T>> buffer(int count) {
    final result = <List<T>>[];

    final totalRound = (length / count).ceil();
    for (int i = 0; i < totalRound; i++) {
      final round = <T>[];
      for (int j = (i * count); j < ((i + 1) * count); j++) {
        if (j < length) {
          round.add(elementAt(j));
        } else {
          break;
        }
      }
      result.add(round);
    }

    return result;
  }

  /// 从第0个元素向后fallback, 直到符合[until]的条件
  ///
  /// 使用场景: 有时候数据源获取来的数据是空字符串(''), 要过滤这种情况非常繁琐, 这个时候就可以
  /// 使用此方法来简化操作
  T? fallback({bool Function(T) until = isNotEmpty}) {
    for (final item in this) {
      if (until(item)) return item;
    }
    return null;
  }

  Iterable<R> mapIndex<R>(R Function(int index, T e) cb) {
    return [for (var i = 0; i < length; i++) cb(i, elementAt(i))];
  }

  /// 获取随机元素
  T get randomOne {
    return elementAt(Random().nextInt(length));
  }

  /// 获取随机元素
  T? get randomOneOrNull {
    try {
      return elementAt(Random().nextInt(length));
    } catch (e) {
      return null;
    }
  }

  List<T> whereNotEmpty() => where(isNotEmpty).cast<T>().toList();

  /// 获取最后[count]个元素
  Iterable<T> takeLast(int count) {
    if (count < 0) {
      throw ArgumentError('count must be greater than or equal to zero.');
    }
    if (count == 0) {
      return const [];
    }
    return skip(max(0, length - count));
  }

  List<R> mapToList<R>(R Function(T e) toElement, {bool growable = false}) {
    return map(toElement).toList(growable: growable);
  }
}

extension NullableIterableX<T> on Iterable<T?>? {
  List<T> whereNotNull() {
    return (this ?? []).whereOrEmpty(notNull).cast<T>().toList();
  }
}

extension NumIterableX<T extends num> on Iterable<T> {
  num sum() {
    num result = 0;
    for (var value in this) {
      result += value;
    }
    return result;
  }

  num avg() {
    if (this.isEmpty) return 0;
    return sum() / length;
  }
}

extension ListX<T> on List<T> {
  List<T> get copied => List.of(this);

  void removeAfter(int index) {
    removeRange(index, length);
  }

  void removeBefore(int index) {
    removeRange(0, index);
  }

  void replace(int index, T element) {
    replaceRange(index, index + 1, [element]);
  }

  void replaceWhere(
    bool Function(T element) test,
    T element, {
    bool appendIfAbsent = false,
  }) {
    final index = indexWhere(test);
    if (index == -1) {
      if (appendIfAbsent) {
        add(element);
        return L.w('[DECORATED_FLUTTER] 未找到目标元素, 指定添加到末尾');
      } else {
        return L.w('[DECORATED_FLUTTER] 未找到目标元素, 略过replaceWhere');
      }
    }

    replace(index, element);
  }

  bool containsWhere(bool Function(T element) test) {
    return indexWhere(test) != -1;
  }

  @Deprecated('统一语义, 使用replaceItem代替')
  void replaceEquals(T element) {
    replaceItem(element);
  }

  /// 替换等价的元素
  ///
  /// 使用场景: 覆写了equals的类, 可以直接覆盖与之等价的对象
  void replaceItem(T element) {
    final index = indexOf(element);
    if (index == -1) return L.w('[DECORATED_FLUTTER] 未找到目标元素, 略过replaceEquals');

    replace(indexOf(element), element);
  }

  /// 替换等价的元素
  ///
  /// 使用场景: 覆写了equals的类, 可以直接覆盖与之等价的对象
  void replaceItems(List<T> elements) {
    for (final item in elements) {
      replaceItem(item);
    }
  }

  /// 重复列表[factor]次
  List<T> operator *(int factor) {
    return [for (int i = 0; i < factor; i++) ...this];
  }

  /// 获取子列表, 如果获取失败就返回空列表
  List<T> sublistOrEmpty(int start, [int? end]) {
    if (end != null) end = min(end, length);
    try {
      return sublist(start, end);
    } catch (e) {
      L.d(e);
      return [];
    }
  }

  T nextOf(T element) {
    final index = indexOf(element);
    final nextIndex = min(length - 1, index + 1);
    return this[nextIndex];
  }

  T previousOf(T element) {
    final index = indexOf(element);
    final nextIndex = max(0, index - 1);
    return this[nextIndex];
  }

  T? nextOfOrNull(T element) {
    final index = indexOf(element);
    try {
      return this[index];
    } catch (e) {
      L.w('[DECORATED_FLUTTER] 获取后一个元素时出现异常, 返回null');
      return null;
    }
  }

  T? previousOfOrNull(T element) {
    final index = indexOf(element);
    try {
      return this[index - 1];
    } catch (e) {
      L.w('[DECORATED_FLUTTER] 获取前一个元素时出现异常, 返回null');
      return null;
    }
  }

  T nextOfIndex(int index) {
    final nextIndex = min(length - 1, index + 1);
    return this[nextIndex];
  }

  T previousOfIndex(int index) {
    final nextIndex = max(0, index - 1);
    return this[nextIndex];
  }

  /// 右补齐
  List<T> padRight(int width, T padding) {
    if (length >= width) return this;

    addAll([for (int i = 0; i < width - length; i++) padding]);
    return this;
  }

  /// 左补齐
  List<T> padLeft(int width, T padding) {
    if (length >= width) return this;

    insertAll(0, [for (int i = 0; i < width - length; i++) padding]);
    return this;
  }
}

extension SelectableListX<T extends Selectable> on List<T> {
  /// 获取被选中的元素
  T? get selected => find((it) => it.isSelected);

  /// 选择第一个元素
  List<T> selectFirst() {
    if (this.isNotEmpty) {
      first.isSelected = true;
    }
    return this;
  }

  /// 选择第[index]个元素
  List<T> selectAtIndex(int index) {
    final target = getOrNull(index);
    if (target == null) {
      L.w('[DECORATED_FLUTTER] 索引 $index 处没有元素!');
    } else {
      target.isSelected = true;
    }
    return this;
  }

  List<T> whereSelected() {
    return whereOrEmpty((element) => element.isSelected).toList();
  }

  /// 整个列表重置
  void reset() {
    for (final item in this) {
      item.reset();
    }
  }

  /// 选中指定元素
  void select(T target) {
    for (final item in this) {
      item.isSelected = (item == target);
    }
  }

  /// 选中指定条件的元素
  void selectWhere(bool Function(T item) test) {
    for (final item in this) {
      item.isSelected = test(item);
    }
  }

  /// 被选中的元素的索引
  int get selectedIndex {
    if (selected == null) {
      return -1;
    } else {
      return indexOf(selected!);
    }
  }
}

extension FutureIterableX<T> on Iterable<Future<T>> {
  Future<List<T>> wait() {
    return Future.wait(this);
  }
}
