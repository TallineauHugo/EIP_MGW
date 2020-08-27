import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'LoginPage.dart';
import 'ReinitPwd.dart';

import '../Tools/LinkManagment.dart';

class Splashscreen extends StatefulWidget {
  @override
  _Splashscreen createState() => new _Splashscreen();
}

class _Splashscreen extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    PasswordReinitialization reinitialization = PasswordReinitialization();
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920, allowFontScaling: true)..init(context);
    final _titleFont = TextStyle(
        color: Color.fromARGB(255, 255, 115, 0),
        fontSize: ScreenUtil.getInstance().setSp(100.0),
        fontFamily: 'Lobster',
        shadows: [Shadow(color: Colors.black, offset: Offset(2.0, 2.0))]
    );
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: reinitialization.hasToReset ? new ReinitPwd() : new LoginPage(),
        title: new Text('MyGardenWatcher', style: _titleFont),
        image: new Image.asset("assets/images/logo_grey_round_shadow.png"),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Color.fromARGB(255, 0, 168, 78)
    );
  }
}