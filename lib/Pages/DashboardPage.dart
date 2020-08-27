import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AlertPage.dart';

import '../Transitions/FadeRoute.dart';

import '../Widgets/InfoCarrot.dart';
import '../Widgets/LoadingIndicator.dart';

import '../Classes/User.dart';

import '../Tools/custom_icons.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardPage();
  }
}

class _DashboardPage extends State<DashboardPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();
  LoadingIndicator _loadingIndicator = LoadingIndicator();

  List<Widget> populateDashboard() {
    List<Widget> _carrotList = new List<Widget>();
    print("");
    print("populate dashboard");

    user.getCarrotsMap().forEach((carrotName, carrot) {
      print("for carrot id: " + carrot.getId().toString() + " | name: " + carrotName);
      carrot.getPlantList().forEach((plant) {
        print(plant.getName().toString());
        _carrotList.add(InfoCarrot(name: carrotName, crop: plant.getName(), loadingIndicator: _loadingIndicator));
      });
    });
    print("");

    return _carrotList;
  }

  /*@override
  void initState() {
    super.initState();
      WidgetsBinding.instance
          .addPostFrameCallback((_) =>
          _refreshIndicatorKey.currentState.show());
  }*/

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920, allowFontScaling: true)..init(context);

    final _drawerItemFont = TextStyle(color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(60));

    Future<bool> _onWillPop() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Êtes vous sûr ?'),
          content: new Text("Voulez vous quitter l'appliccation MGW ?"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Non'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Oui'),
            ),
          ],
        ),
      ) ?? false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: <Widget>[
          Scaffold(
          endDrawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Color.fromARGB(255, 0, 168, 78),
            ),
            child: Drawer(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(context, "/alerts"),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.alarm, size: ScreenUtil.getInstance().setHeight(100), color: Colors.white),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text("Mes alertes", style: _drawerItemFont),
                            ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.white, height: 25),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, "/account"),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.account_circle, size: ScreenUtil.getInstance().setHeight(100), color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text("Mon compte", style: _drawerItemFont),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.white, height: 25),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, "/plants"),
                          child: Row(
                            children: <Widget>[
                              Icon(CustomIcons.plant, size: ScreenUtil.getInstance().setHeight(100), color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text("Nos plantes", style: _drawerItemFont),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.white, height: 25),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, "/contact"),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.mail_outline, size: ScreenUtil.getInstance().setHeight(100), color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text("Nous contacter", style: _drawerItemFont),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              onTap: () {
                                user.disconnect(context); //TODO add loading indicator if needed
                                Navigator.pushReplacementNamed(context, "/login");
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.exit_to_app, size: ScreenUtil.getInstance().setHeight(100), color: Colors.white),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text("Déconnexion", style: _drawerItemFont),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),)
                      ],
                    ),
                  )
              ),
            ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Stack(
            children: <Widget>[
              ListView(children: populateDashboard()),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),),
              Positioned(
                top: ScreenUtil.getInstance().setHeight(1700),
                left: ScreenUtil.getInstance().setWidth(900),
                right: 0,
                child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, "/addPlant"),
                    child: Icon(Icons.add_circle, color: Color.fromARGB(255, 0, 168, 78), size: ScreenUtil.getInstance().setHeight(100))
                ),
              )
            ],
          )),
          ),
          Center(child: _loadingIndicator)
      ]),
    );
  }

  Future<Null> _refresh() async {
    Navigator.pushReplacement(context, FadeRoute(page: DashboardPage()));
    return null;
  }
}