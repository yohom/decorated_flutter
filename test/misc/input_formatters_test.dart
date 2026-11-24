import 'package:decorated_flutter/src/misc/input_formatters.dart'
    show RangeTextInputFormatter;
import 'package:flutter/services.dart'
    show TextEditingValue, TextRange, TextSelection;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RangeTextInputFormatter', () {
    final formatter = RangeTextInputFormatter(min: 10, max: 100);

    test('keeps values in range and their selection', () {
      final oldValue = TextEditingValue(text: '20');
      final newValue = TextEditingValue(
        text: '25',
        selection: TextSelection.collapsed(offset: 1),
      );

      expect(formatter.formatEditUpdate(oldValue, newValue), newValue);
    });

    test('clamps values to the range and places the cursor at the end', () {
      final oldValue = TextEditingValue();
      final belowRange = TextEditingValue(
        text: '5',
        selection: TextSelection.collapsed(offset: 1),
      );
      final aboveRange = TextEditingValue(
        text: '101',
        selection: TextSelection.collapsed(offset: 3),
      );

      expect(
        formatter.formatEditUpdate(oldValue, belowRange),
        TextEditingValue(
          text: '10',
          selection: TextSelection.collapsed(offset: 2),
        ),
      );
      expect(
        formatter.formatEditUpdate(oldValue, aboveRange),
        TextEditingValue(
          text: '100',
          selection: TextSelection.collapsed(offset: 3),
        ),
      );
    });

    test('allows clearing and rejects non-numeric input', () {
      final oldValue = TextEditingValue(text: '20');
      final emptyValue = TextEditingValue();
      final invalidValue = TextEditingValue(text: '2a');
      final nonFiniteValue = TextEditingValue(text: 'NaN');

      expect(formatter.formatEditUpdate(oldValue, emptyValue), emptyValue);
      expect(formatter.formatEditUpdate(oldValue, invalidValue), oldValue);
      expect(formatter.formatEditUpdate(oldValue, nonFiniteValue), oldValue);
    });

    test('leaves composing input unchanged', () {
      final oldValue = TextEditingValue(text: '20');
      final composingValue = TextEditingValue(
        text: '200',
        selection: TextSelection.collapsed(offset: 3),
        composing: const TextRange(start: 2, end: 3),
      );

      expect(
        formatter.formatEditUpdate(oldValue, composingValue),
        composingValue,
      );
    });

    test('accepts decimal numbers', () {
      final decimalFormatter = RangeTextInputFormatter(min: 0.5, max: 2.5);
      final newValue = TextEditingValue(text: '1.25');

      expect(
        decimalFormatter.formatEditUpdate(TextEditingValue(), newValue),
        newValue,
      );
    });

    test('requires min to be no greater than max', () {
      expect(
        () => RangeTextInputFormatter(min: 2, max: 1),
        throwsAssertionError,
      );
    });
  });
}
