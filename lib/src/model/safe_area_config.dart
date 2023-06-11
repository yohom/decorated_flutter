class SafeAreaConfig {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// 作用于内部
  final bool inner;

  const SafeAreaConfig({
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.inner = true,
  });

  const SafeAreaConfig.top({this.inner = true})
      : top = true,
        bottom = false,
        left = false,
        right = false;

  const SafeAreaConfig.bottom({this.inner = true})
      : top = false,
        bottom = true,
        left = false,
        right = false;

  const SafeAreaConfig.left({this.inner = true})
      : top = false,
        bottom = false,
        left = true,
        right = false;

  const SafeAreaConfig.right({this.inner = true})
      : top = false,
        bottom = false,
        left = false,
        right = true;

  @override
  String toString() {
    return 'SafeAreaConfig{top: $top, bottom: $bottom, left: $left, right: $right, inner: $inner}';
  }
}
