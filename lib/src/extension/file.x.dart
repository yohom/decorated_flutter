import 'dart:io';

extension FileX on FileSystemEntity {
  String get name {
    return Uri.parse(path).path.split(Platform.pathSeparator).last;
  }

  String get nameWithoutExtension {
    return name.split('.').first;
  }

  void deleteIfExists({bool recursive = false}) {
    if (existsSync()) deleteSync(recursive: recursive);
  }
}
