import 'dart:convert';

extension StringX on String {
  String plus(String addend) {
    final additionNum = num.parse(addend);
    final thisNum = num.parse(this);
    return '${additionNum + thisNum}';
  }

  dynamic get json {
    return jsonDecode(this);
  }

  Uri? get uri {
    return Uri.tryParse(this);
  }

  int? get intValue {
    return int.tryParse(this);
  }

  double? get doubleValue {
    return double.tryParse(this);
  }

  String get packed {
    return replaceAll(RegExp(r"\s+"), '');
  }
}
