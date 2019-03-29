import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class Codec {
  static Codec _instance;

  Codec._();

  factory Codec() {
    if (_instance == null) {
      _instance = Codec._();
      return _instance;
    } else {
      return _instance;
    }
  }

  final _aes = _AES();

  dynamic output;

  void jsonEncode([dynamic target]) {
    output = json.encode(target ?? output);
  }

  void jsonDecode([dynamic target]) {
    output = json.decode(target ?? output);
  }

  void urlEncode([String target]) {
    output = Uri.encodeFull(target ?? output);
  }

  void urlDecode([String target]) {
    output = Uri.decodeFull(target ?? output);
  }

  void aesEncrypt([String plainText]) {
    output = _aes.encode(plainText ?? output);
  }

  void aesDecrypt([String base64Cipher]) {
    output = _aes.decode(base64Cipher ?? output);
  }
}

abstract class Algorithm {
  String encode(String plainText);

  String decode(String base64Cipher);
}

class _AES implements Algorithm {
  static const _seed = '1234567890123456';
  static const _iv = '1234567890123456';
  static final _aesKey = Key.fromUtf8(_seed);
  static final _encrypter = Encrypter(
    AES(_aesKey, IV.fromUtf8(_iv), mode: AESMode.cbc),
  );

  /// 返回base64编码的密文
  String encode(String plainText) {
    final base64PlainText = base64.encode(plainText.codeUnits);
    return _encrypter.encrypt(base64PlainText).base64;
  }

  /// 返回未编码的明文
  String decode(String base64Cipher) {
    return String.fromCharCodes(
      base64.decode(
        _encrypter.decrypt(Encrypted.fromBase64(base64Cipher)),
      ),
    );
  }
}
