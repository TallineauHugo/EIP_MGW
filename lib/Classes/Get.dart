import 'dart:async';
import 'dart:convert';
import 'Plants.dart';
import 'Carrot.dart';
import 'package:http/http.dart' as http;

class GetProvider {
  http.Client client = new http.Client();

  Future<Get> createGet(String subRoute, {Map<String, String> header, Map<String, String> params}) async {
    return await client.get(new Uri.http("www.mygardenwatcher.fr:3001", subRoute, params), headers: header).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null)
        return Get.fromJson({"error": "error " + statusCode.toString() + ": " + response.body}, statusCode);

      try {
        return Get.fromJson(json.decode(response.body), statusCode);
      } catch (e) {
        throw new Exception("Error while parsing data");
      }
    });
  }

  Future<Get> createGetSensorData(String subRoute, {Map<String, String> header, Map<String, String> params}) async {
    return await client.get(new Uri.http("www.mygardenwatcher.fr:3001", subRoute, params), headers: header).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null)
        return Get.fromJson({"error": "error " + statusCode.toString() + ": " + response.body}, statusCode);

      try {
        return Get.fromSensorData(json.decode(response.body), statusCode);
      } catch (e) {
        throw new Exception("Error while parsing data");
      }
    });
  }

  Future<Get> createDelete(String subRoute, {Map<String, String> header}) async {
    return client.delete(new Uri.http("www.mygardenwatcher.fr:3001", subRoute), headers: header).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null)
        return Get.fromJson({"error": "error " + statusCode.toString() + ": " + response.body}, statusCode);

      try {
        return Get.fromJson(json.decode(response.body), statusCode);
      } catch (e) {
        throw new Exception("Error while parsing data");
      }
    });
  }

  Future<Get> createGetPlantsList(String subRoute, {Map<String, String> header, Map<String, String> params}) async {
    return client.get(new Uri.http("www.mygardenwatcher.fr:3001", subRoute, params), headers: header).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null)
        return Get.fromJson({"error": "error " + statusCode.toString() + ": " + response.body}, statusCode);

      try {
        return Get.fromListPlants(json.decode(response.body), statusCode);
      } catch (e) {
        throw new Exception("Error while parsing data");
      }
    });
  }

  Future<Get> createGetCarrotsList(String subRoute, {Map<String, String> header}) async {
    return client.get(new Uri.http("www.mygardenwatcher.fr:3001", subRoute), headers: header).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null)
        return Get.fromJson({"error": "error " + statusCode.toString() + ": " + response.body}, statusCode);

      try {
        return Get.fromListCarrots(json.decode(response.body), statusCode);
      } catch (e) {
        throw new Exception("Error while parsing data");
      }
    });
  }
}


class Get {
  Map<String, dynamic> map;
  int statusCode;

  Get({this.map, this.statusCode});

  factory Get.fromJson(Map<String, dynamic> json, int statusCode) {
    return Get(
        map: json,
        statusCode: statusCode
    );
  }

  factory Get.fromSensorData(List<dynamic> list, int statusCode) {
    //PlantList plantList = PlantList.fromJson(list);
    //TODO make sensor data class

    return Get(
        map: null,
        statusCode: 0//statusCode
    );
  }

  factory Get.fromListPlants(List<dynamic> list, int statusCode) {
    PlantList plantList = PlantList.fromJson(list);

    return Get(
        map: plantList.getMap(),
        statusCode: statusCode
    );
  }

  factory Get.fromListCarrots(Map<String, dynamic> list, int statusCode) {
    CarrotList carrotList = CarrotList.fromJson(list["carrots"]);

    return Get(
        map: carrotList.getMap(),
        statusCode: statusCode
    );
  }

  /*factory Get.fromListCarrots(List<dynamic> list, int statusCode) {
    CarrotList carrotList = CarrotList.fromJson(list);

    return Get(
        map: carrotList.getMap(),
        statusCode: statusCode
    );
  }*/
}