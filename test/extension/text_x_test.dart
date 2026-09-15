import 'package:decorated_flutter/src/extension/text.x.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Text can concatenate InlineSpan without losing styles or recognizers',
      () {
    const leftStyle = TextStyle(fontSize: 20);
    const rightStyle = TextStyle(fontWeight: FontWeight.bold);
    const leftSpan = TextSpan(text: 'left', style: leftStyle);
    final recognizer = TapGestureRecognizer()..onTap = () {};
    addTearDown(recognizer.dispose);
    final rightSpan = TextSpan(
      text: 'right',
      style: rightStyle,
      recognizer: recognizer,
    );
    final result = Text.rich(leftSpan, style: leftStyle) + rightSpan;

    final root = result.textSpan! as TextSpan;
    expect(result.style, leftStyle);
    expect(root.children, hasLength(2));
    expect(root.children![0], same(leftSpan));
    expect(root.children![1], same(rightSpan));
    expect((root.children![1] as TextSpan).recognizer, same(recognizer));
  });
}
