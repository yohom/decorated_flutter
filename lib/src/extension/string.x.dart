extension StringX on String {
  String plus(String addend) {
    final additionNum = num.parse(addend);
    final thisNum = num.parse(this);
    return '${additionNum + thisNum}';
  }
}
