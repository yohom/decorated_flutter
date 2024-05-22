part of '../base.dart';

/// 内部数据类型是[List]的输入业务单元
class ListInput<T> extends Input<List<T>> with ListMixin<T> {
  ListInput({
    required super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.acceptEmpty,
    super.printLog,
    super.isDistinct,
    super.isSame,
    int? forceCapacity,
    super.onReset,
    super.persistConfig,
  }) {
    _forceCapacity = forceCapacity;
  }

  static OptionalListInput<T> optional<T>({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    List<T>? Function()? onReset,
    bool Function(List<T>?, List<T>?)? isSame,
    PersistConfig<List<T>?>? persistConfig,
  }) {
    return OptionalListInput<T>(
      semantics: semantics,
      seedValue: seedValue,
      sync: sync,
      isBehavior: isBehavior,
      acceptEmpty: acceptEmpty,
      printLog: printLog,
      isDistinct: isDistinct,
      onReset: onReset,
      isSame: isSame,
      persistConfig: persistConfig,
    );
  }
}

/// 内部数据类型是[List]的输出业务单元
class ListOutput<T, ARG> extends Output<List<T>, ARG> with ListMixin<T> {
  ListOutput({
    required super.seedValue,
    required super.semantics,
    super.sync = true,
    super.isBehavior = true,
    super.printLog = true,
    int? forceCapacity,
    required super.fetch,
    super.onReset,
    super.persistConfig,
    super.skipError,
  }) {
    _forceCapacity = forceCapacity;
  }

  static OptionalListOutput<T, ARG> optional<T, ARG>({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    int? forceCapacity,
    required FetchCallback<List<T>, ARG?> fetch,
    List<T> Function()? onReset,
    PersistConfig<List<T>?>? persistConfig,
    bool skipError = false,
  }) {
    return OptionalListOutput<T, ARG>(
      semantics: semantics,
      seedValue: seedValue,
      sync: sync,
      isBehavior: isBehavior,
      fetch: fetch,
      printLog: printLog,
      onReset: onReset,
      forceCapacity: forceCapacity,
      persistConfig: persistConfig,
    );
  }
}

/// 内部数据类型是[List]的输出业务单元
class ListStreamOutput<T> extends StreamOutput<List<T>> with ListMixin<T> {
  ListStreamOutput(
    super.source, {
    required super.seedValue,
    required super.semantics,
    super.sync = true,
    super.printLog = true,
    super.isBehavior = true,
    super.onReset,
    super.persistConfig,
    super.skipError,
  });

  // static OptionalStreamOutput<T> optional<T>(
  //   final Stream<T> source, {
  //   T? seedValue,
  //   required String semantics,
  //   bool sync = true,
  //   bool printLog = true,
  //   bool isBehavior = true,
  //   T? Function()? onReset,
  //   PersistConfig<T?>? persistConfig,
  //   bool skipError = false,
  // }) {
  //   return OptionalStreamOutput<T>(
  //     source,
  //     semantics: semantics,
  //     seedValue: seedValue,
  //     sync: sync,
  //     isBehavior: isBehavior,
  //     printLog: printLog,
  //     onReset: onReset,
  //     persistConfig: persistConfig,
  //     skipError: skipError,
  //   );
  // }
}

/// 内部数据类型是[List]的输入输出业务单元
class ListIO<T> extends IO<List<T>> with ListMixin<T> {
  ListIO({
    required super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    super.acceptEmpty,
    super.isDistinct,
    bool Function(List<T>, List<T>)? isSame,
    super.printLog,
    int? forceCapacity,
    super.fetch,
    super.onReset,
    super.persistConfig,
  }) : super(
          isSame: isSame ?? listEquals,
        ) {
    _forceCapacity = forceCapacity;
  }

  static OptionalListIO<T> optional<T>({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    int? forceCapacity,
    required FetchCallback<List<T>, dynamic> fetch,
    List<T> Function()? onReset,
    PersistConfig<List<T>?>? persistConfig,
  }) {
    return OptionalListIO<T>(
      semantics: semantics,
      seedValue: seedValue,
      sync: sync,
      isBehavior: isBehavior,
      fetch: fetch,
      printLog: printLog,
      onReset: onReset,
      forceCapacity: forceCapacity,
      persistConfig: persistConfig,
    );
  }
}

/// 内部数据是[List]特有的成员
mixin ListMixin<T> on BaseIO<List<T>> {
  /// 强制内部列表最大长度, 超过这个长度后, 如果是从前面添加数据则弹出最后的数据, 从后面添加则反之.
  int? _forceCapacity;

  /// 搜索关键字
  Stream<List<T>> search(
    IO<String> keyword, {
    required SearchKeywordCallback<T> by,
  }) {
    return _subject.stream.search(keyword.stream, by: by);
  }

  /// 按条件过滤, 并发射过滤后的数据
  List<T>? filterItem(bool Function(T element) test) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final List<T> filtered = latest.where(test).toList();
    _subject.add(filtered);
    return filtered;
  }

  /// 追加, 并发射
  T? append(T element, {bool fromHead = false}) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    // 需要拷贝一份, 防止影响原始数据, 比如说改变了_seedValue的内容
    final copied = List.of(latest);

    if (fromHead) {
      final List<T> pending = copied..insert(0, element);
      // 从前面添加, 就把后面的挤出去
      if (_forceCapacity != null && pending.length > _forceCapacity!) {
        pending.removeLast();
      }
      _subject.add(pending);
    } else {
      final List<T> pending = copied..add(element);
      // 从后面添加, 就把前面的挤出去
      if (_forceCapacity != null && pending.length > _forceCapacity!) {
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

    if (elements.isEmpty) {
      L.d('append空列表, 略过');
      return latest;
    }

    // 需要拷贝一份, 防止影响原始数据, 比如说改变了_seedValue的内容
    final copied = List.of(latest);

    if (fromHead) {
      final List<T> pending = copied..insertAll(0, elements);
      // 从前面添加, 就把后面的挤出去
      if (_forceCapacity != null && pending.length > _forceCapacity!) {
        pending.removeRange(_forceCapacity! - 1, pending.length);
      }
      _subject.add(pending);
    } else {
      final List<T> pending = copied..addAll(elements);
      // 从后面添加, 就把前面的挤出去
      if (_forceCapacity != null && pending.length > _forceCapacity!) {
        pending.removeRange(0, _forceCapacity!);
      }
      _subject.add(pending);
    }
    return elements;
  }

  /// 对list的item做变换之后重新组成list
  Stream<List<S>> flatMap<S>(S Function(T value) mapper) {
    return _subject.map((list) => list.map(mapper).toList());
  }

  /// 替换指定index的元素, 并发射
  T? replace(int index, T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    // 需要拷贝一份, 防止影响原始数据, 比如说改变了_seedValue的内容
    final copied = List.of(latest);

    _subject.add(copied..[index] = element);
    return element;
  }

  /// 替换指定元素, 并发射
  T? replaceItem(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    // 需要拷贝一份, 防止影响原始数据, 比如说改变了_seedValue的内容
    final copied = List.of(latest);

    _subject.add(copied..replaceItem(element));
    return element;
  }

  /// 替换最后一个的元素, 并发射
  T? replaceLast(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final copied = List.of(latest);

    if (latest.isNotEmpty) {
      _subject.add(copied
        ..replaceRange(
          copied.length - 1,
          copied.length,
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

    if (latest.isNotEmpty) {
      final copied = List.of(latest);
      _subject.add(copied..replaceRange(0, 1, [element]));
    }
    return element;
  }

  /// 删除最后一个的元素, 并发射
  T? removeLast() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final copied = List.of(latest);

    final T lastElement = copied.last;
    if (latest.isNotEmpty) {
      _subject.add(copied..removeLast());
    }
    return lastElement;
  }

  /// 删除一个的元素, 并发射
  T? remove(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final copied = List.of(latest);
    _subject.add(copied..remove(element));
    return element;
  }

  /// 删除一组的元素, 并发射
  Iterable<T>? removeBatch(Iterable<T> elements) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final copied = List.of(latest);
    _subject.add(copied..removeWhere((it) => elements.contains(it)));
    return elements;
  }

  /// 删除指定条件的元素
  void removeWhere(bool Function(T t) test) {
    if (_subject.isClosed) return;

    final copied = List.of(latest);
    _subject.add(copied..removeWhere(test));
  }

  /// 删除第一个的元素, 并发射
  T? removeFirst() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final copied = List.of(latest);

    final T firstElement = copied.first;
    if (latest.isNotEmpty) {
      _subject.add(copied..removeAt(0));
    }
    return firstElement;
  }

  /// 删除指定索引的元素, 并发射
  T? removeAt(int index) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final copied = List.of(latest);

    final T element = copied.elementAt(index);
    if (element != null) {
      _subject.add(copied..removeAt(index));
    }
    return element;
  }

  /// 对元素逐个执行操作后, 重新发射
  List<T>? forEach(ValueChanged<T> action) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }
    final copied = List.of(latest);

    copied.forEach(action);
    _subject.add(copied);
    return latest;
  }

  /// 对[target]进行单选操作, 如果[T]不为[Selectable]则什么都不做, 直接透传
  /// 根据[isRadio]判断是否是单选, 默认单选
  List<T>? select(T? target, {bool isRadio = true}) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
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

  /// 对[target]进行取消选择操作
  List<T>? deselect(T target) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    assert(latest is List<Selectable>);
    return forEach((T data) {
      if (data is Selectable) {
        if (data == target) data.isSelected = false;
      }
    });
  }
}
