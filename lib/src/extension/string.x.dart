import 'dart:convert';

extension StringX on String {
  String plus(String addend) {
    final additionNum = num.parse(addend);
    final thisNum = num.parse(this);
    return '${additionNum + thisNum}';
  }

  dynamic parseJson() {
    if (this == null) return null;
    return jsonDecode(this);
  }

  Uri parseUri() {
    if (this == null) return null;
    return Uri.tryParse(this);
  }
}
