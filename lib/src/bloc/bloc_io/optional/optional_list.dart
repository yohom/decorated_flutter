part of '../base.dart';

/// 内部数据类型是[List]的输入业务单元
class OptionalListInput<T> extends Input<List<T>?> with OptionalListMixin<T> {
  OptionalListInput({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool printLog = true,
    bool isDistinct = false,
    int? forceCapacity,
    List<T>? Function()? onReset,
    bool Function(List<T>?, List<T>?)? isSame,
    PersistConfig<List<T>?>? persistConfig,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          printLog: printLog,
          onReset: onReset,
          isSame: isSame ?? listEquals,
          persistConfig: persistConfig,
        ) {
    _forceCapacity = forceCapacity;
  }
}

/// 内部数据类型是[List]的输出业务单元
///
/// 泛型[T]为列表项的类型
class OptionalListOutput<T, ARG> extends Output<List<T>?, ARG>
    with OptionalListMixin<T> {
  OptionalListOutput({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    int? forceCapacity,
    required FetchCallback<List<T>, ARG?> fetch,
    List<T>? Function()? onReset,
    PersistConfig<List<T>?>? persistConfig,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: fetch,
          printLog: printLog,
          onReset: onReset,
          persistConfig: persistConfig,
        ) {
    _forceCapacity = forceCapacity;
  }
}

/// 内部数据类型是[List]的输入输出业务单元
class OptionalListIO<T> extends IO<List<T>?> with OptionalListMixin {
  OptionalListIO({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    int? forceCapacity,
    FetchCallback<List<T>, dynamic>? fetch,
    bool Function(List<T>?, List<T>?)? isSame,
    List<T>? Function()? onReset,
    PersistConfig<List<T>?>? persistConfig,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          fetch: fetch,
          printLog: printLog,
          onReset: onReset,
          isSame: isSame ?? listEquals,
          persistConfig: persistConfig,
        ) {
    _forceCapacity = forceCapacity;
  }
}

/// 内部数据是[List]特有的成员
mixin OptionalListMixin<T> on BaseIO<List<T>?> {
  /// 强制内部列表最大长度, 超过这个长度后, 如果是从前面添加数据则弹出最后的数据, 从后面添加则反之.
  int? _forceCapacity;

  /// 按条件过滤, 并发射过滤后的数据
  List<T>? filterItem(bool Function(T element) test) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final List<T> filtered = latest!.where(test).toList();
    _subject.add(filtered);
    return filtered;
  }

  /// 搜索关键字
  Stream<List<T>> search(IO<String> keyword, {required SearchCallback<T> by}) {
    return whereNotNull().search(keyword.stream, by: by);
  }

  /// 转换为非空流
  Stream<List<T>> whereNotNull() {
    return _subject.stream.where(notNull).cast<List<T>>();
  }

  /// 转换为非空流
  Stream<List<T>> whereNotEmpty() {
    return _subject.stream.where(isNotEmpty).cast<List<T>>();
  }

  /// 追加, 并发射
  T? append(T element, {bool fromHead = false}) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    // 如果没有设置原始数据, 那么就用空列表
    latest ??= [];

    if (fromHead) {
      final List<T>? pending = latest?..insert(0, element);
      // 从前面添加, 就把后面的挤出去
      if (_forceCapacity != null && pending!.length > _forceCapacity!) {
        pending.removeLast();
      }
      _subject.add(pending);
    } else {
      final List<T>? pending = latest?..add(element);
      // 从后面添加, 就把前面的挤出去
      if (_forceCapacity != null && pending!.length > _forceCapacity!) {
        pending.removeAt(0);
      }
      _subject.add(pending);
    }
    return element;
  }

  /// 追加一个list, 并发射
  List<T>? appendAll(List<T> elements, {bool fromHead = false}) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    if (elements.isEmpty && latest != null) {
      L.d('append空列表, 略过');
      return latest;
    }

    // 如果没有设置原始数据, 那么就用空列表
    latest ??= [];

    if (fromHead) {
      final List<T>? pending = latest?..insertAll(0, elements);
      // 从前面添加, 就把后面的挤出去
      if (_forceCapacity != null && pending!.length > _forceCapacity!) {
        pending.removeRange(_forceCapacity! - 1, pending.length);
      }
      _subject.add(pending);
    } else {
      final List<T>? pending = latest?..addAll(elements);
      // 从后面添加, 就把前面的挤出去
      if (_forceCapacity != null && pending!.length > _forceCapacity!) {
        pending.removeRange(0, _forceCapacity!);
      }
      _subject.add(pending);
    }
    return elements;
  }

  /// 对list的item做变换之后重新组成list
  Stream<List<S>> flatMap<S>(S Function(T value) mapper) {
    return _subject.map((list) => list!.map(mapper).toList());
  }

  /// 替换指定index的元素, 并发射
  T? replace(int index, T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    _subject.add(latest?..[index] = element);
    return element;
  }

  /// 替换最后一个的元素, 并发射
  T? replaceLast(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    if (latest!.isNotEmpty) {
      _subject.add(latest
        ?..replaceRange(
          latest!.length - 1,
          latest!.length,
          [element],
        ));
    }
    return element;
  }

  /// 替换第一个的元素, 并发射
  T? replaceFirst(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    if (latest!.isNotEmpty) {
      _subject.add(latest?..replaceRange(0, 1, [element]));
    }
    return element;
  }

  /// 删除最后一个的元素, 并发射
  T? removeLast() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final T lastElement = latest!.last;
    if (latest!.isNotEmpty) {
      _subject.add(latest?..removeLast());
    }
    return lastElement;
  }

  /// 删除一个的元素, 并发射
  T? remove(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    _subject.add(latest?..remove(element));
    return element;
  }

  /// 删除一组的元素, 并发射
  Iterable<T>? removeBatch(Iterable<T> elements) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    _subject.add(latest?..removeWhere((it) => elements.contains(it)));
    return elements;
  }

  /// 删除指定条件的元素
  void removeWhere(bool Function(T t) test) {
    if (_subject.isClosed) return;

    _subject.add(latest?..removeWhere(test));
  }

  /// 删除第一个的元素, 并发射
  T? removeFirst() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final T firstElement = latest!.first;
    if (latest!.isNotEmpty) {
      _subject.add(latest?..removeAt(0));
    }
    return firstElement;
  }

  /// 删除指定索引的元素, 并发射
  T? removeAt(int index) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final T element = latest!.elementAt(index);
    if (element != null) {
      _subject.add(latest?..removeAt(index));
    }
    return element;
  }

  /// 对元素逐个执行操作后, 重新发射
  List<T>? forEach(ValueChanged<T> action) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    latest!.forEach(action);
    _subject.add(latest);
    return latest;
  }

  /// 对[target]进行单选操作, 如果[T]不为[Selectable]则什么都不做, 直接透传
  List<T>? select(T target, {bool isRadio = true}) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    if (isEmpty(latest)) {
      L.w('当前IO数据为null, 略过选择操作');
      return null;
    }

    assert(latest is List<Selectable>);
    return forEach((T data) {
      if (data is Selectable) {
        if (isRadio) {
          data.isSelected = (data == target);
        } else {
          if (data == target) data.isSelected = true;
        }
      }
    });
  }

  /// 对[index]处进行单选操作, 如果[T]不为[Selectable]则什么都不做, 直接透传
  List<T>? selectIndex(int index) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    if (isEmpty(latest)) {
      L.w('当前IO数据为null, 略过选择操作');
      return null;
    }

    assert(latest is List<Selectable>);
    for (var i = 0; i < latest!.length; i++) {
      final item = latest![i];
      if (item is Selectable) {
        item.isSelected = index == i;
      }
    }

    // 刷新数据
    invalidate();

    return latest;
  }
}
