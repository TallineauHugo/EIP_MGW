import 'package:flutter/cupertino.dart';

abstract class PasswordReinitializationBase {
  @protected
  bool reset;
  @protected
  String token;

  bool get hasToReset => reset;
  String get getToken => token;

  void setReset(bool value) => reset = value;
  void setToken(String value) => token = value;
}

class PasswordReinitialization extends PasswordReinitializationBase {
  static final PasswordReinitialization _instance = PasswordReinitialization._internal();

  factory PasswordReinitialization() {
    return _instance;
  }

  PasswordReinitialization._internal() {
    reset = false;
    token = "";
  }
}