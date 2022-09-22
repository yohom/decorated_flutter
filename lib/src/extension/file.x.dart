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

  /// 在目标路径不存在的情况下再进行拷贝
  Future<void> copyIfTargetNotExists(String target) async {
    if (!await File(target).exists()) await copy(target);
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
