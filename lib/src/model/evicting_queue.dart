import 'package:collection/collection.dart';
import 'package:decorated_flutter/decorated_flutter.dart';

/// 固定长度队列
///
/// 长度超过[_capacity]后自动弹出队列前端的元素.
/// 命名参考 https://guava.dev/releases/snapshot/api/docs/com/google/common/collect/EvictingQueue.html
class EvictingQueue<E> extends QueueList<E> {
  EvictingQueue(this._capacity) : super(_capacity);

  final int _capacity;

  @override
  void add(E value) {
    if (length >= _capacity) {
      L.d('EvictingQueue超出容量, 移除首元素');
      removeFirst();
    }
    super.add(value);
  }

  @override
  void addAll(Iterable<E> elements) {
    if (length >= _capacity) {
      for (final _ in elements) {
        L.d('EvictingQueue超出容量, 移除首元素');
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
