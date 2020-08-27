import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Classes/User.dart';
import '../Transitions/FadeRoute.dart';
import '../Pages/DashboardPage.dart';
import '../Widgets/LoadingIndicator.dart';

class InfoCarrot extends StatefulWidget {
  final String name;
  final String crop;
  LoadingIndicator loadingIndicator;

  InfoCarrot({@required this.name, @required this.crop, @required this.loadingIndicator});

  @override
  _InfoCarrot createState() => _InfoCarrot(name: this.name, crop: this.crop, loadingIndicator: loadingIndicator);
}

class _InfoCarrot extends State<InfoCarrot> {
  final String name;
  final String crop;
  int _humidity = 0;
  int _temperature = 0;
  int _luminosity = 0;

  GlobalKey _key = GlobalKey();


  static final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();
  bool validateEditing = false;
  LoadingIndicator loadingIndicator;

  _InfoCarrot({@required this.name, @required this.crop, @required this.loadingIndicator});

  Offset _getPosition() {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    return renderBox.localToGlobal(Offset.zero);
  }

  Future<void> displayInputDialog(BuildContext context, String carrotName) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Renommer "' + carrotName + '"'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                key: Key("NameFormField"),
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Nouveau nom"),
                validator: (value) {
                  value = value.trim();
                  if (value.isEmpty)
                    return "Veuillez entrer un nom";
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('DONE'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    validateEditing = true;
                    Navigator.of(context).pop();
                  }
                },
              ),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920, allowFontScaling: true)..init(context);


    final _nameFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(70), fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 168, 78));
    final _cropFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(42));
    final _infoFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(60));

    return Padding(
      padding: EdgeInsets.only(top: 25),
      child: Container(
        height: ScreenUtil.getInstance().setHeight(1000),
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/carrot_widget_bg.png"))),
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(150)),
          child: Column(
            key: _key,
            children: [
              Container(width: ScreenUtil.getInstance().setWidth(700),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(300)),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          user.getCarrotByName(name).removePlantByName(crop);
                          loadingIndicator.setLoading(true);
                          user.removePlantFromCarrot(context, crop, name);
                          loadingIndicator.setLoading(false);
                          Navigator.pushReplacement(context, FadeRoute(page: DashboardPage()));
                        }),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 115, 50),
                                borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(8.0)),
                              child: Icon(Icons.delete, color: Color.fromARGB(255, 0, 168, 78)),
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(width: ScreenUtil.getInstance().setWidth(700),
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(80)),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(25)),
                        child: Text(this.name, style: _nameFont),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(25)),
                        child: Text(this.crop, style: _cropFont),
                      )
                    ],
                  ),
                ),
              ),
              Container(width: ScreenUtil.getInstance().setWidth(450),
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(70)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Image.asset("assets/images/icon_humidity.png", height: ScreenUtil.getInstance().setHeight(75)),
                            Text("$_humidity%", style: _infoFont),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(50), left: ScreenUtil.getInstance().setWidth(175)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("$_luminosity lx", style: _infoFont, textAlign: TextAlign.right),
                      Image.asset("assets/images/icon_temperature.png", height: ScreenUtil.getInstance().setHeight(75))
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(50), right: ScreenUtil.getInstance().setWidth(125)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/icon_luminosity.png", height: ScreenUtil.getInstance().setHeight(75)),
                      Text("$_luminosity lx", style: _infoFont)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*

  EXEMPLE POUR MODIFIER LES VALEURS

  void _doSomething() {
    setState(() {
      _humidity += 20;
    });
  }
  */
}