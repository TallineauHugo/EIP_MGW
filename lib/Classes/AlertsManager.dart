import 'package:flutter/material.dart';

class AlertsManager {
  final String _carrotName;
  final String _plantName;
  final Map<String, AlertList> _alertsByDay = new Map<String, AlertList>();

  AlertsManager(this._carrotName, this._plantName) {
    initAlertList();
  }

  void initAlertList() {
    _alertsByDay["Lundi"] = AlertList("Lundi");
    _alertsByDay["Mardi"] = AlertList("Mardi");
    _alertsByDay["Mercredi"] = AlertList("Mercredi");
    _alertsByDay["Jeudi"] = AlertList("Jeudi");
    _alertsByDay["Vendredi"] = AlertList("Vendredi");
    _alertsByDay["Samedi"] = AlertList("Samedi");
    _alertsByDay["Dimanche"] = AlertList("Dimanche");
  }

  String getCarrotName() => _carrotName;
  String getPlantName() => _plantName;
  AlertList getAlertsByDay(String day) => (_alertsByDay.containsKey(day)) ? _alertsByDay[day] : null;
  Map<String, AlertList> getAlertsMap() => _alertsByDay;
}

class AlertList {
  final String _day;
  bool _enabled = false;
  List<Alert> _alerts = new List<Alert>();

  AlertList(this._day);

  void deleteAlert(Alert alert) {
    if (_alerts.contains(alert))
      _alerts.remove(alert);
  }

  void addAlert(TimeOfDay time) {
    for (var alert in _alerts)
      if (alert.getTime() == time)
        return;

    _alerts.add(Alert(time));
  }

  bool toggleEnable() {
    _enabled = !_enabled;

    return _enabled;
  }

  String getDay() => _day;
  bool isEnabled() => _enabled;
  List<Alert> getAlertsList() => _alerts;
}

class Alert {
  TimeOfDay time;
  bool enabled = true;

  Alert(this.time);

  void setTime(TimeOfDay newTime) {
    time = newTime;
  }

  void setEnabled(bool value) {
    enabled = value;
  }

  TimeOfDay getTime() => time;
  bool isEnabled() => enabled;
}