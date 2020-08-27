import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/Plants.dart';

class PlantInfo extends StatefulWidget {
  Plant plant;

  @override
  _PlantInfo createState() => new _PlantInfo(plant: this.plant);

  PlantInfo({@required this.plant});
}

class _PlantInfo extends State<PlantInfo> {
  Plant plant;
  List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    widgetList = new List<Widget>();
    Column generalView = Column(children: widgetList);
    SingleChildScrollView scrollView = SingleChildScrollView(child: generalView);

    buildHeader(context);
    buildInfo();

    return Scaffold(body: scrollView);
  }

  void buildHeader(BuildContext context) {
    List<Widget> topTitleView = new List<Widget>();
    Stack header = Stack (children: topTitleView);

    TextStyle titleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold);
    Text title = Text(this.plant.getName(), textAlign: TextAlign.center, style: titleFont);

    topTitleView.add(Align(child: title, alignment: Alignment.center));
    topTitleView.add(Padding(
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(25)),
      child: Align(child: GestureDetector(
        child: Icon(Icons.arrow_back),
        onTap: () {
          Navigator.pop(context);
        },
      ), alignment: Alignment.centerLeft),
    ));

    Container container = Container(width: ScreenUtil.getInstance().setWidth(1080), child: header);
    BoxDecoration decoration = BoxDecoration(color: Color.fromARGB(255, 0, 168, 78));
    Padding padding = Padding(padding: EdgeInsets.symmetric(vertical: ScreenUtil.getInstance().setHeight(25)), child: container);
    DecoratedBox decoratedBox = DecoratedBox(decoration: decoration, child: padding);

    SizedBox shadowSize = SizedBox(width: ScreenUtil.getInstance().setWidth(1080), height: ScreenUtil.getInstance().setHeight(3));
    BoxDecoration shadowDecoration = BoxDecoration(color: Color.fromARGB(255, 0, 75, 25));
    DecoratedBox shadowDecoratedBox = DecoratedBox(decoration: shadowDecoration, child: shadowSize);

    widgetList.add(decoratedBox);
    widgetList.add(shadowDecoratedBox);
  }

  void buildInfo() {
    TextStyle descStyle = new TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil.getInstance().setSp(50));
    TextStyle valueStyle = new TextStyle(fontStyle: FontStyle.italic, fontSize: ScreenUtil.getInstance().setSp(50));
    TextStyle titleStyle = new TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: ScreenUtil.getInstance().setSp(70));

    widgetList.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(25)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Image.asset("assets/images/icon_humidity_colored.png", height: ScreenUtil.getInstance().setHeight(75)),
        Text("Humidité idéale: ", style: descStyle),
        Text(plant.getHumidity().toString() + "%", style: valueStyle)
      ]),
    ));

    widgetList.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Image.asset("assets/images/icon_luminosity_colored.png", height: ScreenUtil.getInstance().setHeight(75)),
      Text("Luminosité idéale: ", style: descStyle),
      Text(plant.getLuminosity().toString(), style: valueStyle)
    ]));

    widgetList.add(Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(25)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Image.asset("assets/images/icon_temperature_colored.png", height: ScreenUtil.getInstance().setHeight(75)),
        Text("Température idéale: ", style: descStyle),
        Text(plant.getMinTemperature().toString() + "-" + plant.getMaxTemperature().toString() + "°C", style: valueStyle)
      ]),
    ));

    widgetList.add(Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(25)),
      child: Text("Description", style: titleStyle),
    ));
    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(25)),
      child: Text(plant.getDescription()),
    ));

    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil.getInstance().setHeight(25)),
      child: Text("Caractéristiques", style: titleStyle),
    ));
    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(25)),
      child: Text(plant.getCaracteristics()),
    ));

    widgetList.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(25)),
      child: Image.network(plant.getImage(), fit: BoxFit.fitWidth),
    ));
  }

  _PlantInfo({@required this.plant});
}