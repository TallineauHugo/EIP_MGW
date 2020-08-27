import 'dart:collection';

PlantManager plantManager = new PlantManager();

class Plant {
  final int _id;
  final int _minTemp;
  final int _maxTemp;
  final int _humidity;
  final String _luminosity;
  final String _name;
  final String _image;
  final String _description;
  final String _link;
  final String _caracteristics;

  Plant(this._id, this._name, this._minTemp, this._maxTemp, this._humidity,
      this._luminosity, this._image, this._description, this._link, this._caracteristics);

  //getters
  int getId() { return _id; }
  String getName() { return _name; }
  int getMinTemperature() { return _minTemp; }
  int getMaxTemperature() { return _maxTemp; }
  int getHumidity() { return _humidity; }
  String getLuminosity() { return _luminosity; }
  String getImage() { return _image; }
  String getDescription() { return _description; }
  String getLink() { return _link; }
  String getCaracteristics() { return _caracteristics; }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return new Plant(
      json["id"],
      json["name"],
      json["minTemp"],
      json["maxTemp"],
      json["humidity"],
      json["light"],
      json["image"],
      json["description"],
      json["link"],
      json["caracteristics"]
    );
  }
}

class PlantList {
  List<Plant> plants = new List<Plant>();

  //Constructor
  PlantList();

  factory PlantList.fromJson(List<dynamic> list) {
    PlantList plantsList = new PlantList();

    plantsList.setList(list.map((plant) => Plant.fromJson(plant)).toList());

    return plantsList;
  }

  //setters
  void addPlant(Plant plant) {
    if (!plants.contains(plant))
      plants.add(plant);
  }

  void addPlantByName(String name) {
    Plant p = plantManager.getPlantByName(name);

    if (p != null && !(plants.contains(p)))
      plants.add(p);
  }

  void removePlantByName(String name) {
    Plant p = plantManager.getPlantByName(name);

    if (p != null && plants.contains(p))
      plants.remove(p);
  }

  void setList(List<Plant> list) {
    plants = list;
  }

  //getters
  Map<String, Plant> getMap() {
    Map<String, Plant> map = new Map<String, Plant>();

    plants.forEach((plant) =>
      map[plant.getName()] = plant);

    return map;
  }

  List<Plant> getList() {
    return plants;
  }
}

class PlantManager {
  Map<String, Plant> _existingPlants = new Map<String, Plant>();
  Map<String, Plant> _knownPlants = new Map<String, Plant>();
  int _indexPlantsApi = 0;

  void populateWithMap(Map<String, Plant> map) {
    map.forEach((name, plant) =>
      this.addPlant(plant));
  }

  void populateKnownPlants(Map<String, Plant> map) {
    map.forEach((name, plant) {
      this._knownPlants[name] = plant;
    });
  }

  int getNbPlants() {
    return _knownPlants.length;
  }

  bool isFullyLoaded() {
    return _indexPlantsApi >= _knownPlants.length;
  }

  bool addPlant(Plant plant) {
    //if (this._existingPlants.containsKey(plant.getName()))
      //return false;
    this._existingPlants[plant.getName()] = plant;
    return true;
  }

  int getPlantId(String name) {
    if (this._existingPlants.containsKey(name))
      return _existingPlants[name].getId();
    return null;
  }

  Plant getPlantByName(String name) {
    if (this._existingPlants.containsKey(name))
      return _existingPlants[name];
    return null;
  }

  Map<String, Plant> getExistingPlants() {
    /*_existingPlants = Map.fromEntries(
        _existingPlants.entries.toList()
            ..sort((e1,e2) => e1.key.compareTo(e2.key))
    );*/

    return _existingPlants;
  }

  List<Plant> getMatchingPlants(String search) {
    List<Plant> ret = new List<Plant>();

    _knownPlants.forEach((name, plant) {
      if (name.toLowerCase().contains(search.toLowerCase()))
        ret.add(plant);
    });

    return ret;
  }

  int getIndexPlantApi() {
    return _indexPlantsApi;
  }

  void incrementIndexPlantApi(int nb) {
    _indexPlantsApi += nb;
  }

  void resetIndexPlantApi() {
    _indexPlantsApi = 0;
  }
}