import 'dart:collection';

/// A [CircularBuffer] with a fixed capacity supporting all [List] operations
///
/// ```dart
/// final buffer = CircularBuffer<int>(3)..add(1)..add(2);
/// print(buffer.length); // 2
/// print(buffer.first); // 1
/// print(buffer.isFilled); // false
/// print(buffer.isUnfilled); // true
///
/// buffer.add(3);
/// print(buffer.length); // 3
/// print(buffer.isFilled); // true
/// print(buffer.isUnfilled); // false
///
/// buffer.add(4);
/// print(buffer.first); // 2
/// ```
class CircularBuffer<T> with ListMixin<T> {
  /// Creates a [CircularBuffer] with a `capacity`
  CircularBuffer(this.capacity)
      : assert(capacity > 1, 'CircularBuffer must have a positive capacity.'),
        _buf = [],
        _len = 0;

  /// Creates a [CircularBuffer] based on another `list`
  CircularBuffer.of(List<T> list, [int? capacity])
      : assert(
          capacity == null || capacity >= list.length,
          'The capacity must be at least as long as the existing list',
        ),
        capacity = capacity ?? list.length,
        _buf = [...list],
        _len = list.length;

  final List<dynamic> _buf;

  /// Maximum number of elements of [CircularBuffer]
  final int capacity;

  int _start = 0;
  int _len;

  /// An alias to [reset].
  @Deprecated('Use `clear` instead')
  void reset() => clear();

  /// Clears the [CircularBuffer].
  ///
  /// [capacity] is unaffected.
  @override
  void clear() {
    _start = 0;
    _buf.clear();
    _len = 0;
  }

  @override
  void add(T element) {
    if (isUnfilled) {
      // The internal buffer is not at its maximum size.  Grow it.
      assert(_start == 0, 'Internal buffer grown from a bad state');
      _buf.add(element);
      _len++;
      return;
    }

    // All space is used, so overwrite the start.
    _buf[_start] = element;
    _start++;
    if (_start == capacity) {
      _start = 0;
    }
  }

  /// Adds an element as the first element
  void addHead(T element) {
    if (_len == 0) {
      _buf.add(element);
      _len++;
    } else if (isFilled) {
      if (_start == 0) {
        _start = _len - 1;
      } else {
        _start--;
      }
      _buf[_start] = element;
    } else if (_buf.length < capacity) {
      _buf
        ..addAll(_None.iterable(capacity - _len - 1))
        ..add(element);
      _len += 1;
      _start = capacity - 1;
    } else {
      if (_start == 0) {
        _start = _len - 1;
      } else {
        _start--;
      }
      _buf[_start] = element;
      _len += 1;
    }
  }

  /// Number of used elements of [CircularBuffer]
  @override
  int get length => _len;

  /// The [CircularBuffer] `isFilled` if the [length]
  /// is equal to the [capacity].
  bool get isFilled => _len == capacity;

  /// The [CircularBuffer] `isUnfilled` if the [length] is
  /// less than the [capacity].
  bool get isUnfilled => _len < capacity;

  @override
  T operator [](int index) {
    if (index >= 0 && index < _len) {
      return _buf[(_start + index) % _buf.length] as T;
    }
    throw RangeError.index(index, this);
  }

  @override
  void operator []=(int index, T value) {
    if (index >= 0 && index < _len) {
      _buf[(_start + index) % _buf.length] = value;
    } else {
      throw RangeError.index(index, this);
    }
  }

  /// The `length` mutation is forbidden
  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot resize a CircularBuffer.');
  }
}

class _None {
  const _None._();

  static Iterable<_None> iterable(int n) sync* {
    for (var i = 0; i < n; i++) {
      yield _none;
    }
  }
}

const _none = _None._();
