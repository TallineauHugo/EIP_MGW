import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/Plants.dart';

import '../Pages/PlantInfo.dart';

class PlantPreview extends StatefulWidget {
  Plant plant;

  @override
  _PlantPreview createState() => new _PlantPreview(plant: this.plant);

  PlantPreview({@required this.plant});
}

class _PlantPreview extends State<PlantPreview> {
  Plant plant;

  @override
  Widget build(BuildContext context) {
    List<Widget> view = new List<Widget>();
    Column columnView = Column(children: view, crossAxisAlignment: CrossAxisAlignment.center);

    TextStyle plantNameFont = new TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, fontWeight: FontWeight.bold);

    view.add(Text(plant.getName(), style: plantNameFont, textAlign: TextAlign.center));

    view.add(AspectRatio(
      aspectRatio: (MediaQuery.of(context).size.width * 0.7) / (MediaQuery.of(context).size.height * 0.2),
      child: Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: FractionalOffset.center,
              image: new NetworkImage(plant.getImage()),
            )
        ),
      ),
    ));
    view.add(Text(plant.getDescription(), maxLines: 3));

    List<Widget> dataView = new List<Widget>();
    Row data = Row(children: dataView, mainAxisAlignment: MainAxisAlignment.center);
    List<Widget> secondDataView = new List<Widget>();
    Row secondData = Row(children: secondDataView, mainAxisAlignment: MainAxisAlignment.center);

    List<Widget> humidityView = new List<Widget>();
    Row humidity = Row(children: humidityView);
    List<Widget> luminosityView = new List<Widget>();
    Row luminosity = Row(children: luminosityView);
    List<Widget> temperatureView = new List<Widget>();
    Row temperature = Row(children: temperatureView);
    humidityView.add(Image.asset("assets/images/icon_humidity_colored.png", height: MediaQuery.of(context).size.height * 0.04));
    humidityView.add(Text(plant.getHumidity().toString() + "%"));
    luminosityView.add(Image.asset("assets/images/icon_luminosity_colored.png", height: MediaQuery.of(context).size.height * 0.04));
    luminosityView.add(Text(plant.getLuminosity().toString()));
    temperatureView.add(Image.asset("assets/images/icon_temperature_colored.png", height: MediaQuery.of(context).size.height * 0.04));
    temperatureView.add(Text(plant.getMinTemperature().toString() + "-" + plant.getMaxTemperature().toString() + "°C"));
    dataView.add(humidity);
    dataView.add(luminosity);
    secondDataView.add(temperature);
    view.add(data);
    view.add(Divider(thickness: 1, color: Color.fromARGB(255, 175, 175, 175), height: MediaQuery.of(context).size.height * 0.01));
    view.add(secondData);

    return Card(
      color: Color.fromARGB(255, 215, 215, 215),
      elevation: 5,
      child: GestureDetector(
          onTap: () => Navigator.push(context, new PageRouteBuilder(pageBuilder: (context, animation, secondAnimation) => new PlantInfo(plant: this.plant))),
          child: columnView
      ),
    );
  }

  _PlantPreview({@required this.plant});
}