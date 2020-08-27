import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteProvider {
  http.Client client = new http.Client();

  Future<Delete> createDelete(String subRoute, {Map<String, String> header, Map<String, String> params}) async {
    return client.delete(
        new Uri.http("www.mygardenwatcher.fr:3001", subRoute, params), headers: header)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        //throw new Exception("Error while fetching data: error code " + statusCode.toString());
        return Delete.fromJson({"response": response.body}, statusCode);
      }
      try {
        return Delete.fromJson(json.decode(response.body), statusCode);
      } catch (FormatException) {
        return Delete.fromJson(json.decode('{"body": "' + response.body + '"}'), statusCode);
      }
    });
  }
}

class Delete {
  final Map<String, dynamic> map;
  int statusCode;

  Delete({this.map, this.statusCode});

  factory Delete.fromJson(Map<String, dynamic> json, int statusCode) {
    return Delete(
        map: json,
        statusCode: statusCode
    );
  }
}