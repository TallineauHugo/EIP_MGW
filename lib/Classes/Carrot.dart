import 'dart:core';

import 'Plants.dart';
import 'Post.dart';
import 'User.dart';
import 'AlertsManager.dart';

class Carrot {
  int _id;
  String _name;
  List<Plant> _crops = new List<Plant>();
  Map<String, AlertsManager> _alertsByPlant = new Map<String, AlertsManager>();

  Carrot(this._id, this._name, this._crops) {
    retrieveAlerts();
  }

  factory Carrot.fromJson(Map<String, dynamic> json) {
    return new Carrot(
      json["id"],
      json["name"],
      []
    );
  }

  // Alerts
  void retrieveAlerts() {
    //TODO get existing alerts from API
    this._crops.forEach((plant) =>
    this._alertsByPlant[plant.getName()] = AlertsManager(this._name, plant.getName()));
  }

  //getters
  int getId() { return _id; }
  String getName() { return _name; }
  List<Plant> getPlantList() { return _crops; }

  Plant getPlantById(int id) {
    for (final plant in this._crops) {
      if (plant.getId() == id)
        return plant;
    }
    return null;
  }

  Plant getPlantByName(String name) {
    for (final plant in this._crops) {
      if (plant.getName() == name)
        return plant;
    }
    return null;
  }

  AlertsManager getAlertsByPlant(String plantName) =>
      (_alertsByPlant.containsKey(plantName)) ? _alertsByPlant[plantName] : null;

  //modifiers
  void setPlants(PlantList list) {
    print("setting plantes for carrot " + _name);
    list.getMap().forEach((id, p) {
      print(p.getName());
    });
    _crops = list.getList();
    _crops.forEach((plant) => this._alertsByPlant[plant.getName()] = AlertsManager(this._name, plant.getName()));
  }

  bool addPlant(Plant plant) {
    if (this._crops.contains(plant))
      return false;
    this._crops.add(plant);
    this._alertsByPlant[plant.getName()] = AlertsManager(this._name, plant.getName());
    return true;
  }

  void ApiRemovePlant(int id) {
    //PostProvider provider = new PostProvider();
    
    //provider.createPost("/plants", header: {"auth": user.getToken()}, body: {});
  }
  
  bool removePlantByName(String name) {
    for (final plant in this._crops) {
      if (plant.getName() == name) {
        this._crops.removeAt(this._crops.indexOf(plant));
        ApiRemovePlant(plant.getId());
        this._alertsByPlant.remove(plant.getName());
        return true;
      }
    }
    return false;
  }

  bool removePlantById(int id) {
    for (final plant in this._crops) {
      if (plant.getId() == id) {
        this._crops.removeAt(this._crops.indexOf(plant));
        ApiRemovePlant(plant.getId());
        this._alertsByPlant.remove(plant.getName());
        return true;
      }
    }
    return false;
  }

  void rename(String newName) {
    _name = newName;
  }
}

class CarrotList {
  List<Carrot> carrots = new List<Carrot>();

  CarrotList();

  factory CarrotList.fromJson(List<dynamic> list) {
    CarrotList carrotsList = new CarrotList();

    carrotsList.setList(list.map((carrot) => Carrot.fromJson(carrot)).toList());

    return carrotsList;
  }

  void setList(List<Carrot> list) {
    carrots = list;
  }

  Map<String, Carrot> getMap() {
    Map<String, Carrot> map = new Map<String, Carrot>();

    carrots.forEach((carrot) =>
      map[carrot.getName()] = carrot);

    return map;
  }
}