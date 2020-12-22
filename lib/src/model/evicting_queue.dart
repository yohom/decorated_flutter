import 'dart:collection';

/// 固定长度队列
///
/// 长度超过[_capacity]后自动弹出队列前端的元素.
/// 命名参考 https://guava.dev/releases/snapshot/api/docs/com/google/common/collect/EvictingQueue.html
class EvictingQueue<E> extends ListQueue<E> {
  EvictingQueue(this._capacity) : super(_capacity);

  final int _capacity;

  @override
  void add(E value) {
    if (length >= _capacity) {
      removeFirst();
    }
    super.add(value);
  }

  @override
  void addAll(Iterable<E> elements) {
    if (length >= _capacity) {
      for (final _ in elements) {
        removeFirst();
      }
    }
    super.addAll(elements);
  }

  @override
  void addLast(E value) {
    add(value);
  }

  @override
  void addFirst(E value) {
    if (length >= _capacity) {
      removeLast();
    }
    super.addFirst(value);
  }
}
