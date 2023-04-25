mixin Selectable {
  @Deprecated('语义精确化, 使用isSelected代替')
  bool get selected => isSelected;
  bool isSelected = false;

  void reset() {
    isSelected = false;
  }

  /// 翻转选中的值
  ///
  /// 返回翻转后的值
  bool toggle() {
    isSelected = !isSelected;
    return isSelected;
  }
}

/// 可持久化
///
/// 仅仅是标记
typedef PersistSelectable = Selectable;
