import 'dart:io';

extension FileX on FileSystemEntity {
  String get name {
    return path.split(Platform.pathSeparator).last;
  }

  void deleteIfExists({bool recursive = false}) {
    if (existsSync()) deleteSync(recursive: recursive);
  }
}
