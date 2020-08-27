import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Pages/AlertDay.dart';
import '../Classes/AlertsManager.dart';

class DailyAlert extends StatefulWidget {
  final AlertList alertList;

  DailyAlert({@required this.alertList});

  @override
  _DailyAlert createState() => new _DailyAlert(alertList: this.alertList);
}

class _DailyAlert extends State<DailyAlert> {
  final AlertList alertList;

  _DailyAlert({@required this.alertList});

  @override
  Widget build(BuildContext context) {
    final _dayFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(65));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: Text(this.alertList.getDay(), style: _dayFont)),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => setState(() => this.alertList.toggleEnable()),
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                  child: this.alertList.isEnabled()
                  ? Icon(
                    Icons.radio_button_checked,
                    size: 30.0,
                    color: Color.fromARGB(255, 255, 115, 0),
                  )
                  : Icon(
                    Icons.radio_button_unchecked,
                    size: 30.0,
                    color: Color.fromARGB(255, 255, 115, 0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: this.alertList.isEnabled()
                ? GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => (AlertDay(alertsList: this.alertList)))), child: Icon(Icons.alarm, size: 30, color: Color.fromARGB(255, 0, 168, 78)))
                : Icon(Icons.alarm, size: 30, color: Colors.grey),
          )
        ],
      ),
    );
  }
}