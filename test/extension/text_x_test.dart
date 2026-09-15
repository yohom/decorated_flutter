import 'package:decorated_flutter/src/extension/text.x.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Text can concatenate Text and InlineSpan without losing runs', () {
    const leftStyle = TextStyle(fontSize: 20);
    const rightStyle = TextStyle(fontWeight: FontWeight.bold);
    const leftSpan = TextSpan(text: 'left', style: leftStyle);
    final result = Text.rich(leftSpan, style: leftStyle) +
        const Text('right', style: rightStyle);

    final root = result.textSpan! as TextSpan;
    expect(result.style, leftStyle);
    expect(root.children, hasLength(2));
    expect(root.children![0], same(leftSpan));
    expect(root.children![1], isA<TextSpan>());
    expect((root.children![1] as TextSpan).text, 'right');
    expect((root.children![1] as TextSpan).style, rightStyle);
  });
}
