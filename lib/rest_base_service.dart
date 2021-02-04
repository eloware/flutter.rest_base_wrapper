import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './rest_base_functionality.dart';

abstract class RestBaseService<TModel> extends RestBaseFunctionality {
  final String _controller;

  get baseUrl => RestBaseFunctionality.BASE_URL;

  String? get url => baseUrl + '/' + _controller;

  TModel fromJSON(Map<String, dynamic>? json);

  RestBaseService(this._controller);

  Future<TModel> getById(String id) async {
    var result = await http.get(baseUrl + '/' + _controller + '/' + id,
        headers: getHeaders() as Map<String, String>);
    return fromJSON(processCall(result));
  }

  Future<List<TModel>?> getAll({int limit = 100}) async {
    var result = await http.get('$baseUrl/$_controller?take=$limit', headers: getHeaders() as Map<String, String>);
    return processCall(result)?.map((item) => fromJSON(item))
        ?.toList()
        ?.cast<TModel>();
  }

  Future<dynamic> getUnbound(String endpoint) async {
    var result = await http.get('$baseUrl/$_controller/$endpoint',
        headers: getHeaders() as Map<String, String>);
    return processCall(result);
  }

  Future<Map<String, dynamic>?> post(Map<String, dynamic> body) async {
    var result = await http.post('$baseUrl/$_controller',
        headers: getHeaders() as Map<String, String>, body: json.encode(body));
    return processCall(result);
  }

  Future<Map<String, dynamic>?> put(Map<String, dynamic> body,
      {String id = ''}) async {
    var result = await http.put(baseUrl + '/' + _controller + '/' + id,
        headers: getHeaders() as Map<String, String>, body: json.encode(body));
    return processCall(result);
  }

  Future<Map<String, dynamic>> patch(
      String id, List<Map<String, dynamic>> ops) async {
    var result = await http.patch(baseUrl + '/' + _controller + '/' + id,
        headers: getHeaders() as Map<String, String>, body: json.encode(ops));
    return processCall(result);
  }

  Future<bool> delete(String? id) async {
    var result =
        await http.delete('$baseUrl/$_controller/$id', headers: getHeaders() as Map<String, String>);
    return result.statusCode.isSuccessCode();
  }

  @protected
  Future<bool> patchUnbound(String endpoint, String content) async {
    var result = await http.patch(baseUrl + endpoint,
        headers: getHeaders() as Map<String, String>, body: content);
    return result.statusCode < 299 && result.statusCode >= 200;
  }

  dynamic processCall(http.Response result) {
    if (result.statusCode >= 299 || result.statusCode < 200)
      throw RestCallError(url: result.request.url.toString());

    if (result.statusCode == 204)
      return null;

    return json.decode(result.body);
  }
}

class RestCallError {
  String? errorMessage;
  String? url;

  RestCallError(
      {@optionalTypeArgs this.url, @optionalTypeArgs this.errorMessage}) {
    print('Error at url: ' + this.url!);
  }
}
