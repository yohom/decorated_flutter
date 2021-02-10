import 'dart:io';

extension FileX on File {
  String get name {
    return path.split(Platform.pathSeparator).last;
  }
}
