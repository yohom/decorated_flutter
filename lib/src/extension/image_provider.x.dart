import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

extension AssetImageX on ImageProvider {
  Future<Uint8List> get imageData async {
    final _this = this;
    if (_this is AssetImage) {
      return rootBundle
          .load(_this.assetName)
          .then((value) => value.buffer.asUint8List());
    } else if (_this is NetworkImage) {
      return (await NetworkAssetBundle(Uri.parse(_this.url)).load(_this.url))
          .buffer
          .asUint8List();
    } else {
      throw '暂未支持的Image类型';
    }
  }
}
