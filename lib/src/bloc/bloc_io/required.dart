part of 'base.dart';

/// 业务单元基类
abstract class BaseRequiredIO<T> extends BaseIO<T> {
  BaseRequiredIO({
    /// 初始值, 传递给内部的[_subject]
    required T seedValue,

    /// Event代表的语义
    required String semantics,

    /// 是否同步发射数据, 传递给内部的[_subject]
    bool sync = true,

    /// 是否打印日志, 有些IO add比较频繁时, 影响日志观看
    bool printLog = true,

    /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[_subject]会保存最近一次的值
    bool isBehavior = true,

    /// 重置回调方法, 如果设置了, 则调用reset的时候会优先使用此回调的返回值
    T Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          printLog: printLog,
          isBehavior: isBehavior,
          onReset: onReset,
          persistentKey: persistentKey,
        );
}

/// BLoC内的静态值, 也就是供初始化时的值, 之前都是直接写成字段, 这里提供一个类, 保持与IO的一致性
class Static<T> {
  late T _content;

  void set(T value) {
    _content = value;
  }

  T get() => _content;
}

/// 只输入数据的业务单元
class Input<T> extends BaseRequiredIO<T> with InputMixin<T> {
  Input({
    required T seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    T Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _printLog = printLog;
  }
}

/// 只输出数据的业务单元
class Output<T, ARG_TYPE> extends BaseRequiredIO<T>
    with OutputMixin<T, ARG_TYPE> {
  Output({
    required T seedValue,
    required String semantics,
    bool sync = true,
    bool printLog = true,
    bool isBehavior = true,
    required _Fetch<T, ARG_TYPE?> fetch,
    T Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    stream = _subject.stream;
    _fetch = fetch;
    _printLog = printLog;
  }
}

/// 既可以输入又可以输出的事件
class IO<T> extends BaseRequiredIO<T>
    with InputMixin<T>, OutputMixin<T, dynamic> {
  IO({
    required T seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    _Fetch<T, dynamic>? fetch,
    T Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    stream = _subject.stream;

    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _fetch = fetch ?? (_) => Future.value();
    _printLog = printLog;
  }
}

//region 衍生IO
/// 内部数据类型是[List]的输入业务单元
class ListInput<T> extends Input<List<T>> with ListMixin<T> {
  ListInput({
    required List<T> seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool printLog = true,
    bool isDistinct = false,
    int? forceCapacity,
    List<T> Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          printLog: printLog,
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    _forceCapacity = forceCapacity;
  }
}

/// 内部数据类型是[List]的输出业务单元
///
/// 泛型[T]为列表项的类型
class ListOutput<T, ARG_TYPE> extends Output<List<T>, ARG_TYPE>
    with ListMixin<T> {
  ListOutput({
    required List<T> seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    int? forceCapacity,
    required _Fetch<List<T>, ARG_TYPE?> fetch,
    List<T> Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: fetch,
          printLog: printLog,
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    _forceCapacity = forceCapacity;
  }
}

/// 分页业务单元
class PageOutput<T, ARG_TYPE> extends ListOutput<T, int>
    with PageMixin<T, ARG_TYPE> {
  PageOutput({
    required List<T> seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    int initPage = 0,
    bool receiveFullData = true,
    bool printLog = true,
    int pageSize = 0,
    int? forceCapacity,
    required _PageFetch<List<T>, ARG_TYPE?> pageFetch,
    List<T> Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: (_) => Future.value([]),
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    _initPage = initPage;
    _currentPage = _initPage;
    _pageFetch = pageFetch;
    _receiveFullData = receiveFullData;
    _pageSize = pageSize;
    _printLog = printLog;
    _forceCapacity = forceCapacity;
  }

  /// 这里标记为protected, 防止被外部引用, 应该使用[refresh]方法
  @protected
  Future<List<T>> update([int? arg]) {
    return super.update(arg);
  }
}

/// 分页业务单元
class PageIO<T, ARG_TYPE> extends ListIO<T> with PageMixin<T, ARG_TYPE> {
  PageIO({
    required List<T> seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    int initPage = 0,
    int pageSize = 0,
    bool printLog = true,
    bool receiveFullData = true,
    int? forceCapacity,
    _PageFetch<List<T>, ARG_TYPE?>? pageFetch,
    List<T> Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: (_) => Future.value([]),
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    _initPage = initPage;
    _currentPage = _initPage;
    _pageFetch = pageFetch ?? (_, __) => Future.value([]);
    _receiveFullData = receiveFullData;
    _pageSize = pageSize;
    _printLog = printLog;
    _forceCapacity = forceCapacity;
  }
}

/// 内部数据类型是[List]的输入输出业务单元
class ListIO<T> extends IO<List<T>> with ListMixin<T> {
  ListIO({
    required List<T> seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    int? forceCapacity,
    _Fetch<List<T>, dynamic>? fetch,
    List<T> Function()? onReset,
    String? persistentKey,
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
          persistentKey: persistentKey,
        ) {
    _forceCapacity = forceCapacity;
  }
}

/// 只接收int类型数据的IO
class IntIO extends IO<int> with IntMixin {
  IntIO({
    required int seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    int? min,
    int? max,
    int? remainder,
    _Fetch<int, dynamic>? fetch,
    int Function()? onReset,
    String? persistentKey,
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
          persistentKey: persistentKey,
        ) {
    _min = min;
    _max = max;
    _remainder = remainder;
  }
}

/// 只接收int类型数据的Input
class IntInput extends Input<int> with IntMixin {
  IntInput({
    required int seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    int? min,
    int? max,
    int? remainder,
    bool printLog = true,
    int Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          printLog: printLog,
          onReset: onReset,
          persistentKey: persistentKey,
        ) {
    this._min = min;
    this._max = max;
    this._remainder = remainder;
  }
}

/// 只接收bool类型数据的IO
class BoolIO extends IO<bool> with BoolMixin {
  BoolIO({
    required bool seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool acceptEmpty = true,
    bool isDistinct = false,
    bool printLog = true,
    _Fetch<bool, dynamic>? fetch,
    bool Function()? onReset,
    String? persistentKey,
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
          persistentKey: persistentKey,
        );
}

/// 只接收bool类型数据的Output
class BoolOutput<ARG_TYPE> extends Output<bool, ARG_TYPE> with BoolMixin {
  BoolOutput({
    required bool seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    bool printLog = true,
    required _Fetch<bool, ARG_TYPE?> fetch,
    bool Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: fetch,
          printLog: printLog,
          onReset: onReset,
          persistentKey: persistentKey,
        );
}

//endregion

/// 输入单元特有的成员
///
/// 泛型[T]为数据数据的类型
mixin InputMixin<T> on BaseRequiredIO<T> {
  bool _acceptEmpty = true;
  bool _isDistinct = false;

  /// 发射数据
  T? add(T data) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    if (_printLog)
      L.d('+++++++++++++++++++++++++++BEGIN+++++++++++++++++++++++++++++\n'
          'IO接收到**$_semantics**数据: $data');

    if (isEmpty(data) && !_acceptEmpty) {
      if (_printLog)
        L.d('转发被拒绝! 原因: 需要非Empty值, 但是接收到Empty值'
            '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++++');
      return data;
    }

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (_isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (data != latest) {
        if (_printLog) L.d('IO转发出**$_semantics**数据: $data');
        _subject.add(data);
      } else {
        if (_printLog)
          L.d('转发被拒绝! 原因: 需要唯一, 但是新数据与最新值相同'
              '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
      }
    } else {
      if (_printLog) L.d('IO转发出**$_semantics**数据: $data');
      _subject.add(data);
    }

    return data;
  }

  T? addIfAbsent(T data) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    // 如果最新值是_seedValue或者是空, 那么才add新数据, 换句话说, 就是如果event已经被add过
    // 了的话那就不add了, 用于第一次add
    if (_seedValue == latest || isEmpty(latest)) {
      add(data);
    }
    return data;
  }

  Future<T?> addStream(Stream<T> source, {bool cancelOnError: true}) {
    return _subject.addStream(source, cancelOnError: cancelOnError)
        as Future<T?>;
  }
}

/// 输出单元特有的成员
///
/// 泛型[T]为输出数据的类型, 泛型[ARG_TYPE]为请求数据时的参数类型. 一般参数只有一个时, 就
/// 直接使用该参数的类型, 如果有多个时, 就使用List接收.
mixin OutputMixin<T, ARG_TYPE> on BaseRequiredIO<T> {
  /// 输出Future
  Future<T> get future => stream.first;

  /// 输出Stream
  late Stream<T> stream;

  /// 监听流
  StreamSubscription<T> listen(
    ValueChanged<T> listener, {
    Function? onError,
    VoidCallback? onDone,
    bool? cancelOnError,
  }) {
    return stream.listen(
      listener,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 输出Stream
  late _Fetch<T, ARG_TYPE?> _fetch;

  /// 使用内部的trigger获取数据
  Future<T> update([ARG_TYPE? arg]) {
    return _fetch(arg)
      ..then((data) {
        if (!_subject.isClosed) _subject.add(data);
      })
      ..catchError((error) {
        if (!_subject.isClosed) _subject.addError(error);
      });
  }
}

/// 内部数据是[List]特有的成员
mixin ListMixin<T> on BaseRequiredIO<List<T>> {
  /// 强制内部列表最大长度, 超过这个长度后, 如果是从前面添加数据则弹出最后的数据, 从后面添加则反之.
  int? _forceCapacity;

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

    if (fromHead) {
      final List<T> pending = latest..insert(0, element);
      // 从前面添加, 就把后面的挤出去
      if (_forceCapacity != null && pending.length > _forceCapacity!) {
        pending.removeLast();
      }
      _subject.add(pending);
    } else {
      final List<T> pending = latest..add(element);
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

    if (fromHead) {
      final List<T> pending = latest..insertAll(0, elements);
      // 从前面添加, 就把后面的挤出去
      if (_forceCapacity != null && pending.length > _forceCapacity!) {
        pending.removeRange(_forceCapacity! - 1, pending.length);
      }
      _subject.add(pending);
    } else {
      final List<T> pending = latest..addAll(elements);
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

    _subject.add(latest..replaceRange(index, index + 1, <T>[element]));
    return element;
  }

  /// 替换最后一个的元素, 并发射
  T? replaceLast(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    if (latest.isNotEmpty) {
      _subject.add(latest
        ..replaceRange(
          latest.length - 1,
          latest.length,
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
      _subject.add(latest..replaceRange(0, 1, [element]));
    }
    return element;
  }

  /// 删除最后一个的元素, 并发射
  T? removeLast() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final T lastElement = latest.last;
    if (latest.isNotEmpty) {
      _subject.add(latest..removeLast());
    }
    return lastElement;
  }

  /// 删除一个的元素, 并发射
  T? remove(T element) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    _subject.add(latest..remove(element));
    return element;
  }

  /// 删除一组的元素, 并发射
  Iterable<T>? removeBatch(Iterable<T> elements) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    _subject.add(latest..removeWhere((it) => elements.contains(it)));
    return elements;
  }

  /// 删除指定条件的元素
  void removeWhere(bool Function(T t) test) {
    if (_subject.isClosed) return;

    _subject.add(latest..removeWhere(test));
  }

  /// 删除第一个的元素, 并发射
  T? removeFirst() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final T firstElement = latest.first;
    if (latest.isNotEmpty) {
      _subject.add(latest..removeAt(0));
    }
    return firstElement;
  }

  /// 删除指定索引的元素, 并发射
  T? removeAt(int index) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final T element = latest.elementAt(index);
    if (element != null) {
      _subject.add(latest..removeAt(index));
    }
    return element;
  }

  /// 对元素逐个执行操作后, 重新发射
  List<T>? forEach(ValueChanged<T> action) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    latest.forEach(action);
    _subject.add(latest);
    return latest;
  }

  /// 对[target]进行单选操作, 如果[T]不为[Selectable]则什么都不做, 直接透传
  List<T>? select(T target) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    assert(latest is List<Selectable>);
    return forEach((T data) {
      if (data is Selectable) {
        data.selected = (data == target);
      }
    });
  }
}

mixin BoolMixin on BaseRequiredIO<bool> {
  /// 切换true/false 并发射
  bool? toggle() {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    final toggled = !latest;
    _subject.add(toggled);
    return toggled;
  }
}

mixin IntMixin on BaseRequiredIO<int> {
  int? _min;
  int? _max;
  int? _remainder;

  /// 加一个值 并发射
  int? plus([int value = 1]) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    int result;
    if (_remainder != null) {
      result = (latest + value).remainder(_remainder!);
      if (_min != null) {
        result = math.max(_min!, result);
      }
    } else if (_max != null) {
      result = math.min(latest + value, _max!);
    } else {
      result = latest + value;
    }
    if (!_subject.isClosed) {
      _subject.add(result);
    }
    return result;
  }

  /// 减一个值 并发射
  int? minus([int value = 1]) {
    if (_subject.isClosed) {
      L.w('IO在close状态下请求发送数据');
      return null;
    }

    int result;
    if (_remainder != null) {
      result = (latest - value).remainder(_remainder!);
      if (_min != null) {
        result = math.max(_min!, result);
      }
    } else if (_min != null) {
      result = math.max(latest - value, _min!);
    } else {
      result = latest - value;
    }
    _subject.add(result);
    return result;
  }
}

mixin PageMixin<T, ARG_TYPE> on ListMixin<T> {
  /// 初始页 因为后端业务对初始页的定义不一定一样, 这里提供设置参数
  int _initPage = 0;

  /// nextPage时, 是否add整个列表, 为false时, 只add最新一页的数据
  bool _receiveFullData = true;

  /// 当前页数
  int _currentPage = 0;

  /// 全部数据
  List<T> _dataList = [];

  /// 是否还有更多数据
  ///
  /// 两种策略判断:
  ///   1. 设置过[_pageSize], 则判断当前页列表大小是否小于[_pageSize],
  ///   如果是, 那么当前页就是最后一页, 不需要再请求下一页
  ///   2. 没有设置过[_pageSize], 那么判断当前页是否为空列表.
  bool _noMoreData = false;

  /// 每页大小 用于判断是否已加载完全部数据
  int _pageSize = 0;

  late _PageFetch<List<T>, ARG_TYPE?>? _pageFetch;

  /// 请求下一页数据
  ///
  /// 返回是否还有更多数据 true为还有更多数据 false为没有更多数据
  Future<bool> loadMore([ARG_TYPE? args]) async {
    if (_pageFetch == null) return false;
    // 如果已经没有更多数据的话, 就不再请求
    if (!_noMoreData) {
      try {
        final nextPageData = await _pageFetch!(++_currentPage, args);
        if (_receiveFullData) {
          _dataList = [..._dataList, ...nextPageData];
        } else {
          _dataList = nextPageData;
        }
        // 如果当前页列表大小已经小于设置的每页大小, 那么说明已经到最后一页
        // 或者当前页是空, 也说明已经是最后一页
        _noMoreData = nextPageData.length < _pageSize || nextPageData.isEmpty;

        if (_subject.isClosed) return false;
        _subject.add(_dataList);
      } catch (e) {
        if (_subject.isClosed) return false;
        _subject.addError(e);
      }
    }
    return !_noMoreData;
  }

  /// 刷新列表
  ///
  /// 会重新加载第一页
  Future<void> refresh([ARG_TYPE? args]) async {
    if (_pageFetch == null) return;

    _currentPage = _initPage;
    _noMoreData = false;
    try {
      _dataList = await _pageFetch!(_currentPage, args);

      if (_subject.isClosed) return;
      _subject.add(_dataList);
    } catch (e) {
      if (_subject.isClosed) return;
      _subject.addError(e);
    }
  }

  /// 当前是否是第一页
  bool get isFirstPage {
    return _currentPage == _initPage;
  }

  /// 是否还有更多数据
  bool get hasMoreData {
    return !_noMoreData;
  }
}
