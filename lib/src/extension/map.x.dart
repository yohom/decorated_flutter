import 'package:decorated_flutter/decorated_flutter.dart';

extension MapX<K, V> on Map<K, V> {
  Object? valueFor({required String keyPath}) {
    final keysSplit = keyPath.split('.');
    final thisKey = keysSplit.removeAt(0);
    final thisValue = this[thisKey];
    if (keysSplit.isEmpty) {
      return thisValue;
    } else if (thisValue is Map) {
      return thisValue.valueFor(keyPath: keysSplit.join('.'));
    } else if (thisValue is List) {
      final nextKey = keysSplit.removeAt(0);
      if (nextKey.intValue != null) {
        final listIndex = nextKey.intValue!;
        final value = thisValue[listIndex];
        if (value is Map) {
          value.valueFor(keyPath: keysSplit.join('.'));
        } else {
          return value;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
    return null;
  }
}
