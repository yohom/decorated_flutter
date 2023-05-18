part of '../base.dart';

/// 分页业务单元
class PageOutput<T, ARG> extends ListOutput<T, int> with PageMixin<T, ARG> {
  static int? defaultInitialPage;

  PageOutput({
    required super.seedValue,
    required super.semantics,
    super.sync,
    super.isBehavior,
    int? initPage,
    bool receiveFullData = true,
    super.printLog,
    int pageSize = 0,
    int? forceCapacity,
    required PageFetchCallback<List<T>, ARG?> pageFetch,
    super.onReset,
    super.persistConfig,
  }) : super(fetch: (_) => Future.value([])) {
    _initPage = initPage ?? defaultInitialPage ?? 0;
    _currentPage = _initPage;
    _pageFetch = pageFetch;
    _receiveFullData = receiveFullData;
    _pageSize = pageSize;
    _forceCapacity = forceCapacity;
  }

  static OptionalPageOutput<T, ARG> optional<T, ARG>({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    int? initPage,
    bool receiveFullData = true,
    bool printLog = true,
    int? forceCapacity,
    required PageFetchCallback<List<T>, ARG?> pageFetch,
    List<T>? Function()? onReset,
    PersistConfig<List<T>?>? persistConfig,
    MergeListCallback<T>? onMergeList,
    NoMoreDataCallback<T>? isNoMoreData,
  }) {
    return OptionalPageOutput<T, ARG>(
      seedValue: seedValue,
      semantics: semantics,
      sync: sync,
      isBehavior: isBehavior,
      initPage: initPage,
      receiveFullData: receiveFullData,
      printLog: printLog,
      forceCapacity: forceCapacity,
      pageFetch: pageFetch,
      onReset: onReset,
      persistConfig: persistConfig,
      onMergeList: onMergeList,
      isNoMoreData: isNoMoreData,
    );
  }

  /// 这里标记为protected, 防止被外部引用, 应该使用[refresh]方法
  @override
  @protected
  Future<List<T>> update([int? arg]) {
    return super.update(arg);
  }
}

/// 分页业务单元
class PageIO<T, ARG> extends ListIO<T> with PageMixin<T, ARG> {
  static int? defaultInitialPage;

  PageIO({
    required super.seedValue,
    required String semantics,
    super.sync,
    super.isBehavior,
    int? initPage,
    int pageSize = 0,
    super.printLog,
    bool receiveFullData = true,
    int? forceCapacity,
    PageFetchCallback<List<T>, ARG?>? pageFetch,
    super.onReset,
    super.persistConfig,
  }) : super(
          semantics: semantics,
          fetch: (_) => Future.error('请使用pageFetch回调!'),
        ) {
    _initPage = initPage ?? defaultInitialPage ?? 0;
    _currentPage = _initPage;
    _pageFetch = pageFetch ??
        (_, __) =>
            throw '[$semantics] 在未设置pageFetch回调时调用了refresh/loadMore方法, 请检查业务逻辑是否正确!';
    _receiveFullData = receiveFullData;
    _pageSize = pageSize;
    _forceCapacity = forceCapacity;
  }
}

mixin PageMixin<T, ARG> on ListMixin<T> {
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

  late PageFetchCallback<List<T>, ARG?> _pageFetch;

  /// 请求下一页数据
  ///
  /// 返回是否还有更多数据 true为还有更多数据 false为没有更多数据
  Future<bool> loadMore([ARG? args]) async {
    // 如果已经没有更多数据的话, 就不再请求
    if (!_noMoreData) {
      try {
        final nextPageData = await _pageFetch(++_currentPage, args);
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
    } else {
      L.d('[$_semantics] 没有更多数据');
    }
    return !_noMoreData;
  }

  /// 刷新列表
  ///
  /// 会重新加载第一页
  Future<List<T>?> refresh([ARG? args]) async {
    _currentPage = _initPage;
    _noMoreData = false;
    try {
      _dataList = await _pageFetch(_currentPage, args);

      if (_subject.isClosed) return null;
      _subject.add(_dataList);
    } catch (e) {
      if (_subject.isClosed) return null;
      _subject.addError(e);
    }
    return _dataList;
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
