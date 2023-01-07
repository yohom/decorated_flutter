/// 列表+元信息
class ListWrapper<T> {
  final int total;
  final int page;
  final bool hasNext;
  final List<T> dataList;

  ListWrapper({
    required this.total,
    required this.page,
    required this.hasNext,
    required this.dataList,
  });

  @override
  String toString() {
    return 'ListWrapper{total: $total, page: $page, hasNext: $hasNext, dataList: $dataList}';
  }
}
