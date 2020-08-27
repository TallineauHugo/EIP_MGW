import 'package:flutter/material.dart';

import '../Classes/AlertsManager.dart';
import '../Classes/Carrot.dart';
import '../Classes/Plants.dart';
import '../Classes/User.dart';

import '../Widgets/DaySelector.dart';
import '../Widgets/PopWindow.dart';

import '../Tools/custom_icons.dart';

enum Stage {
  Start,
  Carrot,
  Plant
}

class AlertPage extends StatefulWidget {
  @override
  _AlertPage createState() => new _AlertPage();
}

class _AlertPage extends State<AlertPage> {
  TextStyle _titleFont;
  String _title;

  Stage _stage = Stage.Start;
  bool _allCarrotSelected = false;
  bool _allPlantsSelected = false;
  String _selectedCarrot = "";
  String _selectedPlant = "";

  Map<String, bool> _alertsIsActive = new Map<String, bool>();
  Map<String, Map<Alert, bool>> _allCarrotsAlertsIsActive = new Map<String, Map<Alert, bool>>();
  Map<String, Map<String, Map<Alert, bool>>> _allPlantsAlertsIsActive = new Map<String, Map<String, Map<Alert, bool>>>();

  Future<bool> handleBack() {
    switch (_stage) {
      case Stage.Start:
        Navigator.pushReplacementNamed(context, "/dashboard");
        break;
      case Stage.Carrot:
        setState(() {
          _selectedCarrot = "";
          _stage = Stage.Start;
        });
        break;
      case Stage.Plant:
        setState(() {
          if (_allCarrotSelected) {
            _allCarrotSelected = false;
            _stage = Stage.Start;
          }
          else {
            _selectedPlant = "";
            _allPlantsSelected = false;
            _stage = Stage.Carrot;
          }
        });
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case Stage.Carrot:
        _titleFont = TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07);
        _title = "Pour quelle plante de la carotte '$_selectedCarrot' modifier les alertes ?";
        break;
      case Stage.Plant:
        if (_allCarrotSelected)
          _title = "Gérez toutes vos alertes";
        else if (_allPlantsSelected)
          _title = "Gérez vos alertes pour la carotte '$_selectedCarrot'";
        else
          _title = "Gérez vos alertes pour la plante '$_selectedPlant' liée à la carotte '$_selectedCarrot'";
        break;
      default:
        _titleFont = TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08);
        _title = "Pour quelle carotte modifier les alertes ?";
    }

    return WillPopScope(
      onWillPop: () async {
        await handleBack();
        return;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () async {
                      bool res = await handleBack();
                      res ??= false;
                      if (res)
                        Navigator.pushReplacementNamed(context, "/dashboard");
                    },
                  ),
                )
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Text(_title, style: _titleFont, textAlign: TextAlign.center),
                    ))
                )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.23),
                  child: SingleChildScrollView(child: _stage == Stage.Start ? buildCarrots() : _stage == Stage.Carrot ? buildPlants() : buildAlerts()),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildCarrots() {
    List<Widget> widgets = new List<Widget>();
    Column result = Column(children: widgets);

    final TextStyle cardFont = TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.black);
    final TextStyle italicCardFont = TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.black, fontStyle: FontStyle.italic);

    int validCarrotCount = 0;

    user.getCarrotsMap().forEach((carrotName, carrot) {
      if (carrot.getPlantList().length > 0) {
        validCarrotCount++;
        widgets.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: GestureDetector(
            onTap: () => setState(() {
              _selectedCarrot = carrotName;
              _stage = Stage.Carrot;
            }),
            child: Card(
                color: Color.fromARGB(255, 0, 168, 78),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
                        child: Icon(CustomIcons.carrot, size: MediaQuery.of(context).size.width * 0.13, color: Color.fromARGB(255, 255, 115, 78)),
                      ),
                      Text(carrotName, style: cardFont),
                    ],
                  ),
                )
            ),
          ),
        ));
      }
    });

    if (validCarrotCount > 1) {
      widgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        child: GestureDetector(
          onTap: () async {
            bool delete = await popWidgetList(context, "Conserver ou supprimer ?", "Voulez vous conserver vos alertes déjà existantes ou les supprimer ?", <Widget>[
              FlatButton(
                child: new Text('Conserver'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: new Text('Supprimer'),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ]);
            setState(() {
              if (delete != null) {
                if (delete) {
                  _allPlantsAlertsIsActive.clear();
                  _allCarrotsAlertsIsActive.clear();
                  user.getCarrotsMap().forEach((carrotName, carrot) {
                    carrot.getPlantList().forEach((plant) {
                      carrot.getAlertsByPlant(plant.getName()).getAlertsMap().forEach((day, alertsToDelete) {
                        alertsToDelete.getAlertsList().clear();
                      });
                    });
                  });
                }
                _allCarrotSelected = true;
                _stage = Stage.Plant;
              }
            });
          },
          child: Card(
              color: Color.fromARGB(255, 0, 168, 78),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
                      child: Icon(CustomIcons.carrot, size: MediaQuery.of(context).size.width * 0.13, color: Color.fromARGB(255, 255, 115, 78)),
                    ),
                    Text("Toutes", style: italicCardFont),
                  ],
                ),
              )
          ),
        ),
      ));
    }

    return result;
  }

  Widget buildPlants() {
    List<Widget> widgets = new List<Widget>();
    Column result = Column(children: widgets);

    final TextStyle cardFont = TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.black);
    final TextStyle italicCardFont = TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, color: Colors.black, fontStyle: FontStyle.italic);

    Carrot carrot = user.getCarrotByName(_selectedCarrot);

    carrot.getPlantList().forEach((plant) {
      widgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        child: GestureDetector(
          onTap: () => setState(() {
            _selectedPlant = plant.getName();
            _stage = Stage.Plant;
          }),
          child: Card(
              color: Color.fromARGB(255, 0, 168, 78),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
                      child: Icon(CustomIcons.plant, size: MediaQuery.of(context).size.width * 0.13, color: Color.fromARGB(255, 255, 115, 78)),
                    ),
                    Text(plant.getName(), style: cardFont),
                  ],
                ),
              )
          ),
        ),
      ));
    });

    if (carrot.getPlantList().length > 1)
      widgets.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        child: GestureDetector(
          onTap: () async {
            bool delete = await popWidgetList(context, "Conserver ou supprimer ?", "Voulez vous conserver vos alertes déjà existantes ou les supprimer ?", <Widget>[
              FlatButton(
                child: new Text('Conserver'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: new Text('Supprimer'),
                onPressed: () => Navigator.of(context).pop(true),
              )
            ]);
            setState(() {
              if (delete != null) {
                if (delete) {
                  if (_allPlantsAlertsIsActive[_selectedCarrot] != null)
                    _allPlantsAlertsIsActive[_selectedCarrot].clear();
                  carrot.getPlantList().forEach((plant) {
                    print(plant.getName());
                    carrot.getAlertsByPlant(plant.getName()).getAlertsMap().forEach((day, alertsToDelete) {
                      alertsToDelete.getAlertsList().clear();
                    });
                  });
                }
                _allPlantsSelected = true;
                _stage = Stage.Plant;
              }
            });
          },
          child: Card(
              color: Color.fromARGB(255, 0, 168, 78),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.01),
                      child: Icon(CustomIcons.plant, size: MediaQuery.of(context).size.width * 0.13, color: Color.fromARGB(255, 255, 115, 78)),
                    ),
                    Text("Toutes", style: italicCardFont),
                  ],
                ),
              )
          ),
        ),
      ));

    return result;
  }

  Widget buildAlerts() {
    List<Widget> widgets = new List<Widget>();
    Column result = Column(children: widgets);

    TextStyle listFont = TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05);

    if (_selectedPlant != "" && _selectedCarrot != "") {
      AlertsManager alerts = user.getCarrotByName(_selectedCarrot)
          .getAlertsByPlant(_selectedPlant);

      int alertCount;
      int dayCount = 0;

      int totalDay = 0;

      alerts.getAlertsMap().forEach((day, list) {
        if (list.getAlertsList().length > 0) totalDay++;
      });

      alerts.getAlertsMap().forEach((day, list) {
        if (list.getAlertsList().length > 0) {
          alertCount = 0;
          list.getAlertsList().forEach((alert) {
            String alertName = "$_selectedCarrot-$_selectedPlant-$day-${alert.getTime().format(context)}";
            if (!_alertsIsActive.containsKey(alertName))
              _alertsIsActive[alertName] = alert.isEnabled();
            widgets.add(Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
              child: Row(children: <Widget>[
                if (alertCount == 0)
                  Text(day.substring(0, 3) + '.', style: listFont),
                Spacer(),
                Text(alert.getTime().format(context), style: listFont),
                Checkbox(
                    value: _alertsIsActive[alertName], onChanged: (bool value) {
                  setState(() {
                    _alertsIsActive[alertName] = value;
                    alert.setEnabled(value);
                  });
                }),
                GestureDetector(
                    onTap: () {
                      if (_selectedCarrot != "") {
                        Carrot carrot = user.getCarrotByName(_selectedCarrot);
                        if (_selectedPlant != "") {
                          AlertsManager alerts = carrot.getAlertsByPlant(_selectedPlant);
                          alerts.getAlertsByDay(day).deleteAlert(alert);
                          setState(() {});
                        }
                      }
                    },
                    child: Icon(Icons.delete, color: Colors.red)
                )
              ]),
            ));
            alertCount++;
          });
          dayCount++;
          if (dayCount < totalDay) {
            widgets.add(Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Divider(thickness: 2),
            ));
          }
        }
      });
    }
    else if (_allCarrotSelected) {
      int alertCount;
      int dayCount = 0;

      int totalDay = 0;
      _allCarrotsAlertsIsActive.forEach((day, alerts) {
        if (alerts.length > 0) {
          alertCount = 0;
          alerts.forEach((alert, active) {
            String alertName = "$day-${alert.getTime().format(context)}";
            _alertsIsActive[alertName] = active;
            widgets.add(Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
              child: Row(children: <Widget>[
                if (alertCount == 0)
                  Text(day.substring(0, 3) + '.', style: listFont),
                Spacer(),
                Text(alert.getTime().format(context), style: listFont),
                Checkbox(
                    value: _allCarrotsAlertsIsActive[day][alert], onChanged: (bool value) {
                      setState(() {
                        _allCarrotsAlertsIsActive[day][alert] = value;
                        user.getCarrotsMap().forEach((name, carrot) {
                          user.getCarrotByName(name).getPlantList().forEach((plant) {
                            AlertsManager toToggleAlerts = carrot.getAlertsByPlant(plant.getName());
                            toToggleAlerts.getAlertsByDay(day).getAlertsList().forEach((toCheckAlert) {
                              if (toCheckAlert.getTime() == alert.getTime()) {
                                String alertName = "$name-${plant.getName()}-$day-${alert.getTime().format(context)}";
                                _alertsIsActive[alertName] = value;
                                toCheckAlert.setEnabled(value);
                              }
                            });
                          });
                          setState(() {});
                        });
                      });
                    }),
                GestureDetector(
                    onTap: () {
                      _allCarrotsAlertsIsActive[day].remove(alert);
                      user.getCarrotsMap().forEach((name, carrot) {
                        user.getCarrotByName(name).getPlantList().forEach((plant) {
                          List<Alert> toDeleteInPlant = new List<Alert>();
                          AlertsManager toDeleteAlerts = carrot.getAlertsByPlant(plant.getName());
                          toDeleteAlerts.getAlertsByDay(day).getAlertsList().forEach((toCheckAlert) {
                            if (toCheckAlert.getTime() == alert.getTime())
                              toDeleteInPlant.add(toCheckAlert);
                          });
                          toDeleteInPlant.forEach((toDelete) => toDeleteAlerts.getAlertsByDay(day).deleteAlert(toDelete));
                        });
                        setState(() {});
                      });
                      },
                    child: Icon(Icons.delete, color: Colors.red)
                )
              ]),
            ));
            alertCount++;
          });
          dayCount++;
          if (dayCount < totalDay) {
            widgets.add(Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Divider(thickness: 2),
            ));
          }
        }
      });
    }
    else if (_allPlantsSelected) {
      int alertCount;
      int dayCount = 0;

      int totalDay = 0;
      _allPlantsAlertsIsActive[_selectedCarrot] ??= new Map<String, Map<Alert, bool>>();
      _allPlantsAlertsIsActive[_selectedCarrot].forEach((day, alerts) {
        if (alerts.length > 0) {
          alertCount = 0;
          alerts.forEach((alert, active) {
            String alertName = "$day-${alert.getTime().format(context)}";
            _alertsIsActive[alertName] = active;
            widgets.add(Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15),
              child: Row(children: <Widget>[
                if (alertCount == 0)
                  Text(day.substring(0, 3) + '.', style: listFont),
                Spacer(),
                Text(alert.getTime().format(context), style: listFont),
                Checkbox(
                    value: _allPlantsAlertsIsActive[_selectedCarrot][day][alert], onChanged: (bool value) {
                  setState(() {
                    _allPlantsAlertsIsActive[_selectedCarrot][day][alert] = value;
                    user.getCarrotsMap().forEach((name, carrot) {
                      user.getCarrotByName(name).getPlantList().forEach((plant) {
                        AlertsManager toToggleAlerts = carrot.getAlertsByPlant(plant.getName());
                        toToggleAlerts.getAlertsByDay(day).getAlertsList().forEach((toCheckAlert) {
                          if (toCheckAlert.getTime() == alert.getTime()) {
                            String alertName = "$name-${plant.getName()}-$day-${alert.getTime().format(context)}";
                            _alertsIsActive[alertName] = value;
                            toCheckAlert.setEnabled(value);
                          }
                        });
                      });
                      setState(() {});
                    });
                  });
                }),
                GestureDetector(
                    onTap: () {
                      _allPlantsAlertsIsActive[_selectedCarrot][day].remove(alert);
                      user.getCarrotsMap().forEach((name, carrot) {
                        user.getCarrotByName(name).getPlantList().forEach((plant) {
                          List<Alert> toDeleteInPlant = new List<Alert>();
                          AlertsManager toDeleteAlerts = carrot.getAlertsByPlant(plant.getName());
                          toDeleteAlerts.getAlertsByDay(day).getAlertsList().forEach((toCheckAlert) {
                            if (toCheckAlert.getTime() == alert.getTime())
                              toDeleteInPlant.add(toCheckAlert);
                          });
                          toDeleteInPlant.forEach((toDelete) => toDeleteAlerts.getAlertsByDay(day).deleteAlert(toDelete));
                        });
                        setState(() {});
                      });
                    },
                    child: Icon(Icons.delete, color: Colors.red)
                )
              ]),
            ));
            alertCount++;
          });
          dayCount++;
          if (dayCount < totalDay) {
            widgets.add(Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Divider(thickness: 2),
            ));
          }
        }
      });
    }

    int daysValue = 0;
    List<String> daysPicked = new List<String>();
    widgets.add(RaisedButton(
      onPressed: () async {
        await showDialog(context: context, builder: (context) => SimpleDialog(title: Text("Pour quel jour(s) voulez vous créer l'alerte ?"), children: <Widget>[
          DaySelector(
              onChange: (value) {
                daysValue = value;
              },
              mode: DaySelector.modeFull
          ),
          FlatButton(
            child: new Text('Valider'),
            onPressed: () {
              if (DaySelector.monday & daysValue == DaySelector.monday)
                daysPicked.add("Lundi");
              if (DaySelector.tuesday & daysValue == DaySelector.tuesday)
                daysPicked.add("Mardi");
              if (DaySelector.wednesday & daysValue == DaySelector.wednesday)
                daysPicked.add("Mercredi");
              if (DaySelector.thursday & daysValue == DaySelector.thursday)
                daysPicked.add("Jeudi");
              if (DaySelector.friday & daysValue == DaySelector.friday)
                daysPicked.add("Vendredi");
              if (DaySelector.saturday & daysValue == DaySelector.saturday)
                daysPicked.add("Samedi");
              if (DaySelector.sunday & daysValue == DaySelector.sunday)
                daysPicked.add("Dimanche");
              Navigator.of(context).pop();
            },
          )
        ]));
        TimeOfDay picked = await showTimePicker(context: context, initialTime: new TimeOfDay.now());
        if (picked != null) {
          if (_selectedCarrot != "") {
            Carrot carrot = user.getCarrotByName(_selectedCarrot);
            if (_selectedPlant != "") {
              AlertsManager alerts = carrot.getAlertsByPlant(_selectedPlant);
              daysPicked.forEach((day) {
                alerts.getAlertsByDay(day).addAlert(picked);
              });
              setState(() {});
            }
            else {
              daysPicked.forEach((day) {
                _allPlantsAlertsIsActive[_selectedCarrot][day] ??= new Map<Alert, bool>();
                _allPlantsAlertsIsActive[_selectedCarrot][day][new Alert(picked)] = true;
              });
              user.getCarrotByName(_selectedCarrot).getPlantList().forEach((plant) {
                AlertsManager alerts = carrot.getAlertsByPlant(plant.getName());
                daysPicked.forEach((day) {
                  alerts.getAlertsByDay(day).addAlert(picked);
                });
              });
              setState(() {});
            }
          }
          else {
            daysPicked.forEach((day) {
              _allCarrotsAlertsIsActive[day] ??= new Map<Alert, bool>();
              _allCarrotsAlertsIsActive[day][new Alert(picked)] = true;
            });
            user.getCarrotsMap().forEach((name, carrot) {
              user.getCarrotByName(name).getPlantList().forEach((plant) {
                AlertsManager alerts = carrot.getAlertsByPlant(plant.getName());
                daysPicked.forEach((day) {
                  alerts.getAlertsByDay(day).addAlert(picked);
                });
                setState(() {});
              });
            });
          }
        }
      },
      child: Text("+"),
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      color: Color.fromARGB(255, 0, 168, 78),
    ));

    return result;
  }
}