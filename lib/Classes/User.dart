import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:pusher_beams_server/pusher_beams_server.dart';

import 'Carrot.dart';
import 'Plants.dart';
import '../Widgets/PopWindow.dart';

import 'Post.dart';
import 'Get.dart';
import 'Delete.dart';

User user = new User();

class User {
  bool _isConnected = false;
  String _mail;
  String _token;
  String _firstName;
  String _lastName;
  String _localisation;
  DateTime _birthday;
  bool _receiveMail;
  Map<String, Carrot> _carrots = new Map<String, Carrot>();

  User() {
    _birthday = null;
  }

  // Carrots
  Future<bool> createCarrot(BuildContext context, String name) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost("/carrots",
          header: {"auth": _token},
          body: {"name": name});

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      await fetchAllData(context, );

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  bool addCarrotToMap(Carrot carrot) {
    if (this._carrots.containsKey(carrot.getName()))
      return false;
    else
      this._carrots[carrot.getName()] = carrot;
    return true;
  }

  //pusher beams notifs
  Future<bool> zboui() {
    /*String instanceId = "MY_INSTANCE_ID"; //à choper sur le dashboard askip ???
    String secretKey = "MY_SECRET_KEY"; //à choper sur le dashboard askip ???

    final beamsClient = PushNotifications(instanceId, secretKey);*/

    //wait c'est pour faire un serveur ça je crois


  }

  //get sensor data
  Future<bool> getSensorData(BuildContext context, int carrotId,
      List<String> attributes, List<DateTime> dates) async {
    try {
      GetProvider provider = new GetProvider();
      Map<String, String> params = new Map<String, String>();

      params["carrotId"] = carrotId.toString();
      computeAttributes(attributes, params);
      computeDates(dates, params);

      print("creating get request");
      Get answer = await provider.createGetSensorData(
        "/sensorData",
        header: {"auth": user.getToken()},
        params: params
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        print("get sensor data: error code " + answer.statusCode.toString());
        switch (answer.statusCode) {
          case 0:
            print("not tested yet");
            break;
          case 401:
            print("error 401 unauthorized");
            break;
          case 404:
            print("error 404 user not found");
            break;
        }
        return null;
      }
      print("answer code: " + answer.statusCode.toString());
      answer.map.forEach((key, value) =>
        print(key + ": " + value));
      //TODO assign data, refresh data
      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue",
          e.toString());
      return false;
    }
  }

  bool computeAttributes(List<String> attributes, Map<String, String> params) {
    if (attributes.isNotEmpty) {
      String a = "";

      attributes.forEach((att) {
        a += att + ",";
      });

      if (a.endsWith(','))
        a = a.substring(0, a.length);
      print("attributes string for collecting sensor data: " + a);
      params["attributes"] = a;
      return true;
    }

    return false;
  }

  bool computeDates(List<DateTime> dates, Map<String, String> params) {
    if (dates.isNotEmpty && dates.length == 2 && dates[1].isAfter(dates[0])) {
      String d = "";
      dates.forEach((date) {
        d += date.year.toString().padLeft(4, '0') + "-";
        d += date.month.toString().padLeft(2, '0') + "-";
        d += date.day.toString().padLeft(2, '0') + " ";
        d += date.hour.toString().padLeft(2, '0') + ":";
        d += date.minute.toString().padLeft(2, '0') + ":";
        d += date.second.toString().padLeft(2, '0');
        d += ";";
      });

      if (d.endsWith(';'))
        d = d.substring(0, d.length);
      print("attributes string for collecting sensor data: " + d);
      params["dates"] = d;
      return true;
    }

    return false;
  }

  //alertes
  Future<bool> addAlert(BuildContext context, /*String carrot, */int plantId, TimeOfDay time) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost(
          "/alert",
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          body: {
            //"carrot": carrot,
            "plantId": plantId,
            "hours": time.hour,
            "minutes": time.minute
          }
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      //TODO refresh data

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue",
          e.toString());
      return false;
    }
  }

  Future<bool> updateAlert(BuildContext context, /*String carrot, int plantId, */TimeOfDay time, String days) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost(
          "/alert/update",
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          body: {
            //"carrot": carrot,
            //"plantId": plantId,
            "hours": time.hour,
            "minutes": time.minute,
            "days": days
          }
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      //TODO refresh data
      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue",
          e.toString());
      return false;
    }
  }

  Future<bool> toggleAlert(BuildContext context, /*String carrot, */int plantId, bool enable) async {
    PostProvider provider = new PostProvider();
    try {
      Post answer = await provider.createPost(
          "/alert/enable",
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          body: {
            //"carrot": carrot,
            "plantId": plantId,
            "enable": enable
          }
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      //TODO refresh data
      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue",
          e.toString());
      return false;
    }
  }

  Future<bool> removeAlert(BuildContext context, /*String carrot, */int plantId) async {
    DeleteProvider provider = new DeleteProvider();
    try {
      Delete answer = await provider.createDelete(
          "/alert" + plantId.toString(),
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          /*params: {
            "carrot": carrot,
            "plant": plant,
            "time": time.toString()
          }*/
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      //TODO assign alerts, refresh data
      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue",
          e.toString());
      return false;
    }
  }

  Future<bool> getAlerts(BuildContext context, /*String carrot, String plant*/) async {
    GetProvider provider = new GetProvider();
    try {
      Get answer = await provider.createGet(
          "/alert",
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          /*params: {
            "carrot": carrot,
            "plant": plant
          }*/
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      //TODO assign alerts, refresh data
      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue",
          e.toString());
      return false;
    }
  }

  Future<List<Plant>> getFullInfoOnPlant(BuildContext context, List<int> ids) async {
    String s = "";
    int size = ids.length;
    List<Plant> ret = new List<Plant>();

    for (var i = 0; i < size; i++) {
      s += ids[i].toString();
      if (i + 1 < size)
        s += ";";
    }

    try {
      GetProvider provider = new GetProvider();
      Get answer = await provider.createGetPlantsList(
          "/plants",
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          params: {"id": s}
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return null;
      }
      plantManager.populateWithMap(answer.map);
      answer.map.forEach((name, plant) => ret.add(plant));

      return ret;
    } catch (e) {
      popMessage(context, "Erreur innatendue",
          e.toString());
      return null;
    }
  }

  Future<bool> getPlants(BuildContext context, Map<String, String> param) async {
    GetProvider provider = new GetProvider();
    try {
      Get answer = await provider.createGetPlantsList(
          "/plants",
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          params: param
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      plantManager.populateWithMap(answer.map);

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> getXMorePlants(BuildContext context, int nb) async {
    int i = plantManager.getIndexPlantApi();
    int y = (i + nb > plantManager.getNbPlants()) ? plantManager.getNbPlants() : i + nb;
    String s;

    s = i.toString() + "," + y.toString();
    print("id: $s");
    plantManager.incrementIndexPlantApi(nb);

    return getPlants(context, {"id": s});
  }

  Future<bool> addPlantToCarrot(BuildContext context, String carrot, Plant plant) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost("/plants/link",
          header: {"auth": _token},
          body: {
            "plantId": plant.getId().toString(),
            "carrotId": getCarrotId(carrot).toString()
          });

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      await fetchPlantForCarrot(context, carrot, getCarrotId(carrot).toString());

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> removeCarrotFromMap(BuildContext context, int id) async {
    try {
      DeleteProvider provider = new DeleteProvider();

      Delete answer = await provider.createDelete("/carrots/" + id.toString(),
          header: {"auth": _token});

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      await fetchAllData(context);

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> removePlantFromCarrot(BuildContext context, String plant, String carrot) async {
    try {
      DeleteProvider provider = new DeleteProvider();

      Delete answer = await provider.createDelete(
          "/plants/" + getCarrotId(carrot).toString() + "/" +
              plantManager.getPlantId(plant).toString(),
          header: {"auth": _token});

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      await fetchPlantForCarrot(context, carrot, getCarrotId(carrot).toString());

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> renameCarrot(BuildContext context, String carrotName, String newName) async {
    try {
      if (!this._carrots.containsKey(carrotName))
        return false;

      PostProvider postProvider = new PostProvider();
      Post answer = await postProvider.createPost("/carrots/rename",
          header: {"auth": _token},
          body: {
            "id": getCarrotId(carrotName).toString(),
            "newName": newName
          });

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      this._carrots[carrotName].rename(newName);
      this._carrots[newName] = this._carrots[carrotName];
      this._carrots.remove(carrotName);
      await fetchAllData(context);

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Carrot getCarrotByName(String name) {
    return (_carrots.containsKey(name)) ? _carrots[name] : null;
  }

  Future<bool> deleteAccount(BuildContext context) async {
    try {
      DeleteProvider provider = new DeleteProvider();
      Delete answer = await provider.createDelete("/auth/user",
          header: {"auth": _token});

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      disconnect(context);

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  // Misc
  Map toMap() {
    var map = Map<String, dynamic>();

    map["mail"] = this._mail;
    map["token"] = this._token;
    map["carrots"] = this._carrots;

    return map;
  }

  Future<bool> fetchCarrots(BuildContext context) async {
    try {
      _carrots.clear();
      GetProvider provider = new GetProvider();
      Get answer = await provider.createGetCarrotsList(
          "/carrots", header: {"auth": _token});

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      this.populateCarrots(answer.map);

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  void populateCarrots(Map<String, Carrot> map) {
    map.forEach((name, carrot) =>
      this.addCarrotToMap(carrot));
  }

  Future<bool> fetchPlantForCarrot(BuildContext context, String carrotName, String carrotId) async {
    try {
      GetProvider provider = new GetProvider();

      Get answer = await provider.createGet("/carrots/" + carrotId,
          header: {"auth": _token});
      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      PlantList list = PlantList.fromJson(
          List<dynamic>.from(answer.map["plants"]));

      list.getList().forEach((plant) => plantManager.addPlant(plant));
      _carrots[carrotName].setPlants(list);

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> fetchPlants(BuildContext context) async {
    for (var name in _carrots.keys) {
      await fetchPlantForCarrot(context, name, _carrots[name].getId().toString());
    }

    return true;
  }

  Future<bool> fetchUserData(BuildContext context) async {
    try {
      GetProvider provider = new GetProvider();

      Get answer = await provider.createGet("/auth/user",
          header: {"auth": _token});

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      String b = answer.map["birthdate"];
      List<String> m = b.split("/");

      if (m.length == 3)
        _birthday =
        new DateTime(int.parse(m[2]), int.parse(m[1]), int.parse(m[0]));

      _mail = answer.map["mail"];
      _firstName = answer.map["firstName"];
      _lastName = answer.map["lastName"];
      _localisation = answer.map["geoLoc"];
      _receiveMail = answer.map["receiveMail"].toString().contains("true");

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> updateUserData(BuildContext context, String mail, String password, String birthday,
      String firstName, String lastName, String localisation, String receiveMail) async {
    try {
      PostProvider postProvider = new PostProvider();
      Post answer = await postProvider.createPost("/auth/user/update",
          header: {"auth": _token},
          body: {
            "mail": mail,
            "password": password,
            "birthdate": birthday,
            "firstName": firstName,
            "lastName": lastName,
            "localisation": localisation,
            "receiveMail": true.toString()
          });

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      await fetchUserData(context);
      return true;
    } catch(e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> updatePassword(BuildContext context, String mail, String oldPassword, String newPassword) async {
    try {
      PostProvider postProvider = new PostProvider();
      Post answer = await postProvider.createPost("/auth/user",
          header: {"auth": _token},
          body: {
            "mail": mail,
            "oldPassword": oldPassword,
            "newPassword": newPassword
          });

      if (answer.statusCode < 200 || answer.statusCode >= 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }
      await fetchUserData(context);

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<void> fetchAllData(BuildContext context) async {

    await fetchCarrots(context);
    await fetchPlants(context);
    await fetchUserData(context);

    return;
  }

  Future<void> connect(BuildContext context) async {
    await fetchAllData(context);

    _isConnected = true;

    print("testing sensor data route:");
    user.getSensorData(context, _carrots[_carrots.keys.first].getId(), new List<String>(), new List<DateTime>());
    return;
  }

  Future<void> disconnect(BuildContext context) async {
    this._mail = "";
    this._token = "";
    this._carrots.clear();
    _isConnected = false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      plantManager.resetIndexPlantApi();
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  int getCarrotId(String name) {
    int ret = -1;

    _carrots.forEach((carrotName, carrot) {
      if (carrotName == name)
        ret = carrot.getId();
    });

    return ret;
  }

  Future<bool> resetPasswordInit(BuildContext context, String mail) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost("/auth/reset/init",
          header: {},
          body: {"mail": mail});

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> resetPasswordChange(BuildContext context, String mail, String token, String newPass) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost("/auth/reset/change",
          header: {},
          body: {
            "mail": mail,
            "token": token,
            "newPassword": newPass
          });

      if (answer.statusCode < 200 || answer.statusCode >= 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> contactFormLoggedUser(BuildContext context, String firstName, String lastName, String companyName,
      String companyDescription, String askingType, String email, String phone,
      String title, String message, String files) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost("/forms/user",
          header: {"auth": _token},
          body: {
            "firstName": firstName,
            "lastName": lastName,
            "companyName": companyName,
            "companyDescription": companyDescription,
            "askingType": askingType,
            "email": email,
            "phone": phone,
            "title": title,
            "message": message,
            "files": files
          });

      if (answer.statusCode < 200 || answer.statusCode >= 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }

  Future<bool> contactFormNonLoggedUser(BuildContext context, String firstName, String lastName, String companyName,
      String companyDescription, String askingType, String email, String phone,
      String title, String message, String files) async {
    try {
      PostProvider provider = new PostProvider();
      Post answer = await provider.createPost("/forms/nonUser",
          header: {},
          body: {
            "firstName": firstName,
            "lastName": lastName,
            "companyName": companyName,
            "companyDescription": companyDescription,
            "askingType": askingType,
            "email": email,
            "phone": phone,
            "title": title,
            "message": message,
            "files": files
          });

      if (answer.statusCode < 200 || answer.statusCode >= 400) {
        popMessage(context, "Erreur " + answer.statusCode.toString(),
            answer.map["error"]);
        return false;
      }

      return true;
    } catch (e) {
      popMessage(context, "Erreur innatendue", e.toString());
      return false;
    }
  }



  String getFirstName() { return _firstName; }
  String getLastName() { return _lastName; }
  String getMail() { return _mail; }
  String getToken() { return _token; }
  String getLocalisation() { return _localisation; }
  DateTime getBirthday() { return _birthday; }
  Map<String, Carrot> getCarrotsMap() { return _carrots; }
  bool isConnected() { return _isConnected; }

  void setFirstName(String value) { _firstName = value; }
  void setLastName(String value) { _lastName = value; }
  void setMail(String value) { _mail = value; }
  void setToken(String value) { _token = value; }
  void setLocalisation(String value) { _localisation = value; }
  void setBirthday(DateTime value) { _birthday = value; }
}