class Build {
  static BuildMode mode = () {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.release;
    }
    var result = BuildMode.profile;
    assert(() {
      result = BuildMode.debug;
      return true;
    }());
    return result;
  }();
}

enum BuildMode { debug, profile, release }
