mixin Selectable {
  @Deprecated('语义精确化, 使用isSelected代替')
  bool get selected => isSelected;
  bool isSelected = false;

  /// 描述
  ///
  /// 设计上是用于显示用的字段, 也可以自由发挥
  String get description => toString();

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

/// 字符串可选
///
/// 用于显示字符串, 并且可以被选中
final class StringSelectable with Selectable {
  final String value;

  StringSelectable(this.value);

  @override
  String get description => value;
}

/// 可持久化
///
/// 仅仅是标记
typedef PersistSelectable = Selectable;
