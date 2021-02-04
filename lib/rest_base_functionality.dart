import 'package:flutter/material.dart';

class RestBaseFunctionality{
  // ignore: non_constant_identifier_names
  static String BASE_URL = '';
  static const String DEFAULT_URL = '';
  static String _token = "";
  String get token => _token;
  String get baseUrl => BASE_URL;

  @protected
  set token(String value) => _token = value;

  Map<String, String?> getHeaders()
  => {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "ApiKey": "",
    "Authorization": _token
  };
}

extension StatusCodeExtension on int{
  bool isSuccessCode() => this < 300 && this >= 200;
}
