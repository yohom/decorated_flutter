Iterable<R> mapIndexed<T, R>(Iterable<T> list, R f(int index, T val)) sync* {
  int i = 0;
  for (T val in list) {
    yield f(i++, val);
  }
}
