import 'dart:convert';

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
    _output = json.encode(target ?? _output);
    return this;
  }

  Codec jsonDecode([dynamic target]) {
    _output = json.decode(target ?? _output);
    return this;
  }

  Codec urlEncode([String target]) {
    _output = Uri.encodeFull(target ?? _output);
    return this;
  }

  Codec urlDecode([String target]) {
    _output = Uri.decodeFull(target ?? _output);
    return this;
  }

  Codec aesEncrypt([String plainText]) {
    _output = _aes.encode(plainText ?? _output);
    return this;
  }

  Codec aesDecrypt([String base64Cipher]) {
    _output = _aes.decode(base64Cipher ?? _output);
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
