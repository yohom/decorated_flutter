import 'dart:io';

extension FileX on FileSystemEntity {
  String get name {
    return path.split(Platform.pathSeparator).last;
  }

  String get nameWithoutExtension {
    return path.split(Platform.pathSeparator).last.split('.').first;
  }

  void deleteIfExists({bool recursive = false}) {
    if (existsSync()) deleteSync(recursive: recursive);
  }
}
