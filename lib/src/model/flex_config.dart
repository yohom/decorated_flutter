class FlexConfig {
  const FlexConfig.flexible(this.flex) : expanded = false;
  const FlexConfig.expanded(this.flex) : expanded = true;

  /// 没有指定到的index, 默认为1
  final List<int> flex;
  final bool expanded;
}
