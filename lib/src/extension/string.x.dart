import 'dart:convert';

extension StringX on String {
  String plus(String addend) {
    final additionNum = num.parse(addend);
    final thisNum = num.parse(this);
    return '${additionNum + thisNum}';
  }

  dynamic get json {
    if (this == null) return null;
    return jsonDecode(this);
  }

  Uri get uri {
    if (this == null) return null;
    return Uri.tryParse(this);
  }

  int get intValue {
    if (this == null) return null;
    return int.tryParse(this);
  }

  double get doubleValue {
    if (this == null) return null;
    return double.tryParse(this);
  }
}
