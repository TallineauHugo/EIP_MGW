import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../Classes/Plants.dart';

import '../Pages/AddPlant.dart';
import '../Pages/PlantInfo.dart';

class AddPlantPreview extends StatefulWidget {
  Plant plant;
  AddPlantState addPlant;
  PlantList plantList;

  @override
  _AddPlantPreview createState() => new _AddPlantPreview(plant: this.plant, addPlant: addPlant, plantList: this.plantList);

  AddPlantPreview({@required this.plant, @required this.addPlant, @required this.plantList});
}

class _AddPlantPreview extends State<AddPlantPreview> {
  Plant plant;
  bool selected = false;
  AddPlantState addPlant;
  PlantList plantList;

  @override
  Widget build(BuildContext context) {
    List<Widget> view = new List<Widget>();
    Column columnView = Column(children: view, crossAxisAlignment: CrossAxisAlignment.center);

    TextStyle plantNameFont = new TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, fontWeight: FontWeight.bold);
    TextStyle descFont = new TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035);
    TextStyle dataFont = new TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04);

    view.add(Container(
        height: MediaQuery.of(context).size.height * 0.05,
        alignment: Alignment.center,
        child: AutoSizeText(
            plant.getName(),
            style: plantNameFont,
            textAlign: TextAlign.center,
            maxLines: 1,
        )
    ));

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

    view.add(Text(plant.getDescription(), maxLines: 3, style: descFont));

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
    humidityView.add(Text(plant.getHumidity().toString() + "%", style: dataFont));
    luminosityView.add(Image.asset("assets/images/icon_luminosity_colored.png", height: MediaQuery.of(context).size.height * 0.04));
    luminosityView.add(Text(plant.getLuminosity().toString(), style: dataFont));
    temperatureView.add(Image.asset("assets/images/icon_temperature_colored.png", height: MediaQuery.of(context).size.height * 0.04));
    temperatureView.add(Text(plant.getMinTemperature().toString() + "-" + plant.getMaxTemperature().toString() + "°C", style: dataFont));
    dataView.add(humidity);
    dataView.add(luminosity);
    secondDataView.add(temperature);
    secondDataView.add(Expanded(
        child: selected ? GestureDetector(
      onTap: () {
        setState(() {
          selected = false;
          plantList.removePlantByName(this.plant.getName());
          this.addPlant.updateButton();
        });
      },
          child: Icon(
            Icons.radio_button_checked,
            size: 30.0,
            color: Color.fromARGB(255, 255, 115, 0),
          )
    )
        : GestureDetector(
      onTap: () {
        setState(() {
          selected = true;
          plantList.addPlantByName(this.plant.getName());
          this.addPlant.updateButton();
        });
      },
      child: Icon(
        Icons.radio_button_unchecked,
        size: MediaQuery.of(context).size.height * 0.045,
        color: Color.fromARGB(255, 255, 115, 0),
      ),
        )));
    view.add(data);
    view.add(Divider(thickness: 1, color: Color.fromARGB(255, 175, 175, 175), height: MediaQuery.of(context).size.height * 0.01));
    view.add(secondData);

    return Card(
      color: selected ? Color.fromARGB(255, 175, 175, 175) : Color.fromARGB(255, 215, 215, 215),
      elevation: 5,
      child: GestureDetector(
          onTap: () => Navigator.push(context, new PageRouteBuilder(pageBuilder: (context, animation, secondAnimation) => new PlantInfo(plant: this.plant))),
          child: columnView
      ),
    );
  }

  _AddPlantPreview({@required this.plant, @required this.addPlant, @required this.plantList});
}