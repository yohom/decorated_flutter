part of '../base.dart';

/// 分页业务单元
class OptionalPageOutput<T, ARG> extends OptionalListOutput<T, int>
    with OptionalPageMixin<T, ARG> {
  static int? defaultInitialPage;

  OptionalPageOutput({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    int? initPage,
    bool receiveFullData = true,
    bool printLog = true,
    int? forceCapacity,
    required _PageFetchCallback<List<T>, ARG?> pageFetch,
    List<T>? Function()? onReset,
    String? persistentKey,
    _MergeListCallback<T>? onMergeList,
    _NoMoreDataCallback<T>? isNoMoreData,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: (_) => Future.error('请使用pageFetch回调!'),
          onReset: onReset,
          persistentKey: persistentKey,
          printLog: printLog,
        ) {
    _initPage = initPage ?? defaultInitialPage ?? 0;
    _currentPage = _initPage;
    _pageFetch = pageFetch;
    _receiveFullData = receiveFullData;
    _forceCapacity = forceCapacity;
    _onMergeList = onMergeList;
    _isNoMoreData = isNoMoreData;
  }

  /// 这里标记为protected, 防止被外部引用, 应该使用[refresh]方法
  @override
  @protected
  Future<List<T>?> update([int? arg]) {
    return super.update(arg);
  }
}

/// 分页业务单元
class OptionalPageIO<T, ARG> extends OptionalListIO<T>
    with OptionalPageMixin<T, ARG> {
  OptionalPageIO({
    List<T>? seedValue,
    required String semantics,
    bool sync = true,
    bool isBehavior = true,
    int initPage = 0,
    bool printLog = true,
    bool receiveFullData = true,
    int? forceCapacity,
    _PageFetchCallback<List<T>, ARG?>? pageFetch,
    List<T>? Function()? onReset,
    String? persistentKey,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          fetch: (_) => Future.value([]),
          onReset: onReset,
          persistentKey: persistentKey,
          printLog: printLog,
        ) {
    _initPage = initPage;
    _currentPage = _initPage;
    _pageFetch = pageFetch ??
        (_, __) => throw '[$semantics] 在未设置fetch回调时调用了update方法, 请检查逻辑是否正确!';
    _receiveFullData = receiveFullData;
    _forceCapacity = forceCapacity;
  }
}

mixin OptionalPageMixin<T, ARG> on OptionalListMixin<T> {
  /// 初始页 因为后端业务对初始页的定义不一定一样, 这里提供设置参数
  int _initPage = 0;

  /// nextPage时, 是否add整个列表, 为false时, 只add最新一页的数据
  bool _receiveFullData = true;

  /// 当前页数
  int _currentPage = 0;

  /// 是否在加载中
  bool _inLoading = false;

  /// 全部数据
  List<T> _dataList = [];

  /// 是否还有更多数据
  ///
  /// 两种策略判断:
  ///   1. 设置过[_pageSize], 则判断当前页列表大小是否小于[_pageSize],
  ///   如果是, 那么当前页就是最后一页, 不需要再请求下一页
  ///   2. 没有设置过[_pageSize], 那么判断当前页是否为空列表.
  bool _noMoreData = false;

  late _PageFetchCallback<List<T>, ARG?> _pageFetch;

  /// 自定义的数据合并回调
  _MergeListCallback<T>? _onMergeList;

  /// 自定义的列表是否为空的回调
  _NoMoreDataCallback<T>? _isNoMoreData;

  /// 当前页数
  int get currentPage => _currentPage;

  /// 是否在加载中
  bool get inLoading => _inLoading;

  /// 请求下一页数据
  ///
  /// 返回是否还有更多数据 true为还有更多数据 false为没有更多数据
  Future<bool> loadMore([ARG? args]) async {
    _inLoading = true;

    // 如果已经没有更多数据的话, 就不再请求
    if (!_noMoreData) {
      try {
        final nextPageData = await _pageFetch(++_currentPage, args);
        if (_receiveFullData) {
          // 如果有自定义的合并逻辑, 则调用之, 否则直接合并列表
          if (_onMergeList != null) {
            _dataList = _onMergeList!(_dataList, nextPageData);
          } else {
            _dataList = [..._dataList, ...nextPageData];
          }
        } else {
          _dataList = nextPageData;
        }
        // 如果有提供判断是否列表为空的回调, 则调用之, 否则直接判断是否为空列表
        if (_isNoMoreData != null) {
          _noMoreData = _isNoMoreData!(nextPageData);
        } else {
          _noMoreData = nextPageData.isEmpty;
        }

        if (_subject.isClosed) return false;
        _subject.add(_dataList);
      } catch (e) {
        if (_subject.isClosed) return false;
        _subject.addError(e);
      }
    } else {
      L.d('$_semantics 没有更多数据!');
    }

    _inLoading = false;
    return !_noMoreData;
  }

  /// 请求指定页数的数据
  Future<void> loadPage(int page, [ARG? args]) async {
    _inLoading = true;

    try {
      _dataList = await _pageFetch(page, args);
      _currentPage = page;

      if (_subject.isClosed) return;
      _subject.add(_dataList);
    } catch (e) {
      if (_subject.isClosed) return;
      _subject.addError(e);
    }

    _inLoading = false;
  }

  /// 刷新列表
  ///
  /// 会重新加载第一页
  Future<List<T>?> refresh([ARG? args]) async {
    _inLoading = true;

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

    _inLoading = false;
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
