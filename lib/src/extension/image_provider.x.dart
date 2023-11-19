import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

extension AssetImageX on AssetImage {
  Future<Uint8List> get imageData {
    return rootBundle
        .load(assetName)
        .then((value) => value.buffer.asUint8List());
  }
}
