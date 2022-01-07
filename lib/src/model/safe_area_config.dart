class SafeAreaConfig {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const SafeAreaConfig({
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
  });

  const SafeAreaConfig.top()
      : top = true,
        bottom = false,
        left = false,
        right = false;

  const SafeAreaConfig.bottom()
      : top = false,
        bottom = true,
        left = false,
        right = false;

  const SafeAreaConfig.left()
      : top = false,
        bottom = false,
        left = true,
        right = false;

  const SafeAreaConfig.right()
      : top = false,
        bottom = false,
        left = false,
        right = true;

  @override
  String toString() {
    return 'SafeAreaConfig{top: $top, bottom: $bottom, left: $left, right: $right}';
  }
}
