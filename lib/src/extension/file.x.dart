import 'dart:io';

extension FileSystemEntityX on FileSystemEntity {
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

extension FileX on File {
  Future<void> createIfNotExists({bool recursive = false}) async {
    if (!await exists()) await create(recursive: recursive);
  }

  void createIfNotExistsSync({bool recursive = false}) {
    if (!existsSync()) createSync(recursive: recursive);
  }
}

extension DirectoryX on Directory {
  Future<void> createIfNotExists({bool recursive = false}) async {
    if (!await exists()) await create(recursive: recursive);
  }

  void createIfNotExistsSync({bool recursive = false}) {
    if (!existsSync()) createSync(recursive: recursive);
  }
}
