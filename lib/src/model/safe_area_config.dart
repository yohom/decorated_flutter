class SafeAreaConfig {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  SafeAreaConfig({
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  @override
  String toString() {
    return 'SafeAreaConfig{top: $top, bottom: $bottom, left: $left, right: $right}';
  }
}
