import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/AlertsManager.dart';

class AlertDay extends StatefulWidget {
  final AlertList alertsList;

  @override
  _AlertDay createState() => new _AlertDay(alertsList: this.alertsList);

  AlertDay({@required this.alertsList});
}

class _AlertDay extends State<AlertDay> {
  final AlertList alertsList;
  final _titleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(120), fontWeight: FontWeight.bold);
  final _hourFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(62));

  _AlertDay({@required this.alertsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SizedBox(
              width: ScreenUtil.getInstance().setWidth(1080),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: populateAlerts()
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(icon:Icon(Icons.arrow_back),
                      onPressed:() {
                        Navigator.pop(context);
                      }
                  )
              )
          ),
        ],
      ),
    );
  }

  List<Widget> populateAlerts() {
    List<Widget> l = new List<Widget>();
    List<Alert> alerts = alertsList.getAlertsList();
    int i = 0;

    // Day
    l.insert(i++, Padding(
      padding: const EdgeInsets.only(bottom: 50.0, top: 25.0),
      child: Text(this.alertsList.getDay(), style: _titleFont),
    ));

    // Alerts
    alerts.forEach((alert) {
      l.insert(i++, Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                child: GestureDetector(
                  child: Align(
                    child: Text(alert.getTime().hour.toString().padLeft(2, '0') + ":" + alert.getTime().minute.toString().padLeft(2, '0'), style: _hourFont),
                    alignment: Alignment.center,
                  ),
                  onTap: () async {
                    TimeOfDay picked = await showTimePicker(context: context, initialTime: alert.getTime());
                    if (picked != null) {
                      setState(() => alert.setTime(picked));
                    }
                  }
                )
            ),
            Expanded(
              child: GestureDetector(
                child: Icon(Icons.delete, color: Colors.red),
                onTap: () {
                  setState(() => alertsList.deleteAlert(alert));
                },
              )
          )
          ],
        ),
      ));
      //l.insert(i++, HourAlert(alert: alert));
    });

    // Add alerts button
    l.insert(i++, Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: RaisedButton(
        onPressed: () async {
          TimeOfDay picked = await showTimePicker(context: context, initialTime: new TimeOfDay.now());
          if (picked != null) {
            setState(() => alertsList.addAlert(picked));
          }
        },
        child: Text("+"),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: Color.fromARGB(255, 0, 168, 78),
      ),
    ));

    return (l);
  }
}