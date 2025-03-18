
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PasswordHasher {
  static String hashPassword(String password) {
    var bytes = const Utf8Encoder().convert(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool verifyPassword(String inputPassword, String hashedPassword){
    var inputHash = PasswordHasher.hashPassword(inputPassword);
    return inputHash == hashedPassword;
  }
}