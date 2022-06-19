// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

// 这里使用SizedBox.shrink代替了
const NIL = SizedBox.shrink();
const SLIVER_NIL = SliverToBoxAdapter(child: SizedBox.shrink());

/// A widget which is not in the layout and does nothing.
/// It is useful when you have to return a widget and can't return null.
@Deprecated('不是很好用, 像StreamBuilder的场景就必须要有RenderObject')
class Nil extends Widget {
  /// Creates a [Nil] widget.
  const Nil({Key? key}) : super(key: key);

  @override
  Element createElement() => _NilElement(this);
}

class _NilElement extends Element {
  _NilElement(Nil widget) : super(widget);

  @override
  void mount(Element? parent, dynamic newSlot) {
    assert(parent is! MultiChildRenderObjectElement, """
        You are using Nil under a MultiChildRenderObjectElement.
        This suggests a possibility that the Nil is not needed or is being used improperly.
        Make sure it can't be replaced with an inline conditional or
        omission of the target widget from a list.
        """);

    super.mount(parent, newSlot);
  }

  @override
  bool get debugDoingBuild => false;

  @override
  void performRebuild() {}
}
