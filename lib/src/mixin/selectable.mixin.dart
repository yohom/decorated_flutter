mixin Selectable {
  bool selected = false;

  void reset() {
    selected = false;
  }

  /// 翻转选中的值
  ///
  /// 返回翻转后的值
  bool toggle() {
    selected = !selected;
    return selected;
  }
}
