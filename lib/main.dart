import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Pages/DashboardPage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/ReinitPwd.dart';
import 'Pages/Splashscreen.dart';
import 'Pages/AddPlant.dart';
import 'Pages/AccountPage.dart';
import 'Pages/EditAccountPage.dart';
import 'Pages/ContactPage.dart';
import 'Pages/PlantsPage.dart';
import 'Pages/AlertPage.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'Tools/LinkManagment.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initUniLinks();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyGardenWatcher',
      theme: ThemeData(primaryColor: Colors.white),
      home: Splashscreen(),
      routes: {
        "/dashboard": (_) => new DashboardPage(),
        "/addPlant": (_) => new AddPlant(),
        "/login": (_) => new LoginPage(),
        "/account": (_) => new AccountPage(),
        "/edit_account": (_) => new EditAccountPage(),
        "/contact": (_) => new ContactPage(),
        "/plants": (_) => new PlantsPage(),
        "/reinitialize": (_) => new ReinitPwd(),
        "/alerts": (_) => new AlertPage()
      },
    );
  }

  Future<Null> initUniLinks() async {
    String nfl = "NotFromLink";
    PasswordReinitialization reinitialization = PasswordReinitialization();
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      initialLink ??= nfl;
      print(initialLink);
      if (initialLink.startsWith("http://www.mygardenwatcher.fr/reset-password/")) {
        reinitialization.setReset(true);
        reinitialization.setToken(initialLink.substring(initialLink.lastIndexOf('/') + 1));
      }
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }
}