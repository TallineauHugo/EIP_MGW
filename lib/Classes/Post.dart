import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostProvider {
  http.Client client = new http.Client();

  Future<Post> createPost(String subRoute, {Map<String, String> header, Map<String, dynamic> body}) async {
    return client.post(
        new Uri.http("www.mygardenwatcher.fr:3001", subRoute), headers: header, body: body)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null)
        return Post.fromJson({"error": "error " + statusCode.toString() + ": " + response.body}, statusCode);

      try {
        return Post.fromJson(json.decode(response.body), statusCode);
      } catch (FormatException) {
        return Post.fromJson(json.decode('{"body": "' + response.body + '"}'), statusCode);
      }
    });
  }
}

class Post {
  final Map<String, dynamic> map;
  int statusCode;

  Post({this.map, this.statusCode});

  factory Post.fromJson(Map<String, dynamic> json, int statusCode) {
    return Post(
        map: json,
        statusCode: statusCode
    );
  }
}