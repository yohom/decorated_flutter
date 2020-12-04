extension ListX<T> on List<T> {
  T getOrNull(int index) {
    try {
      final result = this[index];
      return result;
    } catch (e) {
      return null;
    }
  }

  T get firstOrNull => getOrNull(0);

  T get lastOrNull => getOrNull(length - 1);
}
