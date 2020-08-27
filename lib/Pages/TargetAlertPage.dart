import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Widgets/DailyAlert.dart';
import '../Classes/AlertsManager.dart';

class TargetAlertPage extends StatefulWidget {
  final AlertsManager alertsManager;

  @override
  _TargetAlertPage createState() => new _TargetAlertPage(alertsManager: this.alertsManager);

  TargetAlertPage({@required this.alertsManager});
}

class _TargetAlertPage extends State<TargetAlertPage> {
  final AlertsManager alertsManager;

  _TargetAlertPage({@required this.alertsManager});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920, allowFontScaling: true)..init(context);
    final _titleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(80), fontWeight: FontWeight.bold);
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text((alertsManager != null) ? (this.alertsManager.getCarrotName() +
                        " - " + this.alertsManager.getPlantName()) : "AlertsManager is NULL",
                        style: _titleFont),
                  ),
                  DailyAlert(alertList: this.alertsManager.getAlertsByDay("Lundi")),
                  DailyAlert(alertList: this.alertsManager.getAlertsByDay("Mardi")),
                  DailyAlert(alertList: this.alertsManager.getAlertsByDay("Mercredi")),
                  DailyAlert(alertList: this.alertsManager.getAlertsByDay("Jeudi")),
                  DailyAlert(alertList: this.alertsManager.getAlertsByDay("Vendredi")),
                  DailyAlert(alertList: this.alertsManager.getAlertsByDay("Samedi")),
                  DailyAlert(alertList: this.alertsManager.getAlertsByDay("Dimanche")),
                  /*Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: RaisedButton(
                      onPressed: () async {
                      },
                      child: Text("Enregistrer"),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Color.fromARGB(255, 0, 168, 78),
                    ),
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}