import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:decorated_flutter/src/utils/log.dart';
import 'package:encrypt/encrypt.dart';
import 'package:meta/meta.dart';

class Codec {
  static Codec _instance;

  Codec._();

  factory Codec({String aesKey, String aesIv}) {
    if (_instance == null) {
      _instance = Codec._();
      _aes = _AES(key: aesKey, iv: aesIv);
      return _instance;
    } else {
      return _instance;
    }
  }

  static _AES _aes;

  dynamic _output;

  dynamic get() => _output;

  Codec jsonEncode([dynamic target]) {
    L.p('jsonEncode前: ${target ?? _output} 结束');
    _output = json.encode(target ?? _output);
    L.p('jsonEncode后: $_output 结束');
    return this;
  }

  Codec jsonDecode([dynamic target]) {
    L.p('jsonDecode前: ${target ?? _output} 结束');
    _output = json.decode(target ?? _output);
    L.p('jsonDecode后: $_output 结束');
    return this;
  }

  Codec urlEncode([String target]) {
    L.p('urlEncode前: ${target ?? _output} 结束');
    _output = Uri.encodeFull(target ?? _output);
    L.p('urlEncode后: $_output 结束');
    return this;
  }

  Codec urlDecode([String target]) {
    L.p('urlDecode前: ${target ?? _output} 结束');
    _output = Uri.decodeFull(target ?? _output);
    L.p('urlDecode后: $_output 结束');
    return this;
  }

  Codec aesEncrypt([String plainText]) {
    L.p('aesEncrypt前: ${plainText ?? _output} 结束');
    _output = _aes.encode(plainText ?? _output);
    L.p('aesEncrypt后: $_output 结束');
    return this;
  }

  Codec aesDecrypt([String base64Cipher]) {
    L.p('aesDecrypt前: ${base64Cipher ?? _output} 结束');
    _output = _aes.decode(base64Cipher ?? _output);
    L.p('aesDecrypt后: $_output 结束');
    return this;
  }

  Codec md5(String seed) {
    L.p('md5前: ${seed ?? _output} 结束');
    _output = String.fromCharCodes(crypto.md5.convert(seed.codeUnits).bytes);
    L.p('md5后: $_output 结束');
    return this;
  }

  Codec sha1(String seed) {
    L.p('sha1前: ${seed ?? _output} 结束');
    _output = String.fromCharCodes(crypto.sha1.convert(seed.codeUnits).bytes);
    L.p('sha1后: $_output 结束');
    return this;
  }

  Codec sha256(String seed) {
    L.p('sha256前: ${seed ?? _output} 结束');
    _output = String.fromCharCodes(crypto.sha256.convert(seed.codeUnits).bytes);
    L.p('sha256后: $_output 结束');
    return this;
  }
}

abstract class Algorithm {
  String encode(String plainText);

  String decode(String base64Cipher);
}

class _AES implements Algorithm {
  final Encrypter _encryptor;

  _AES({@required String key, @required String iv})
      : _encryptor = Encrypter(
          AES(Key.fromUtf8(key), IV.fromUtf8(iv), mode: AESMode.cbc),
        );

  /// 返回base64编码的密文
  String encode(String plainText) {
    final base64PlainText = base64.encode(plainText.codeUnits);
    return _encryptor.encrypt(base64PlainText).base64;
  }

  /// 返回未编码的明文
  String decode(String base64Cipher) {
    return String.fromCharCodes(
      base64.decode(
        _encryptor.decrypt(Encrypted.fromBase64(base64Cipher)),
      ),
    );
  }
}
