import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateKey(String uri) {
  return md5.convert(utf8.encode(uri)).toString();
}
