import 'dart:convert';
import 'package:crypto/crypto.dart';

class Hash {
  static String convertStringToHash(String data) {
    final bytes1 = utf8.encode(data);
    return sha256.convert(bytes1).toString().replaceAll(RegExp(r'\s+'), '');
  }
}
