import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/User.dart';
import '../Classes/Plants.dart';

import '../Widgets/AddPlantPreview.dart';
import '../Widgets/LoadingIndicator.dart';
import '../Widgets/PopWindow.dart';
import '../Transitions/FadeRoute.dart';

class AddPlant extends StatefulWidget {
  @override
  AddPlantState createState() => new AddPlantState();
}

class AddPlantState extends State<AddPlant> {
  final searchController = TextEditingController();

  String _selectedCarrot;

  PlantList _plantList = new PlantList();
  List<Plant> plants = new List<Plant>();

  LoadingIndicator _loadingIndicator = LoadingIndicator();

  BoxDecoration _buttonDeco;

  //recherche
  static List<Plant> results = new List<Plant>();
  static List<Plant> tmp = new List<Plant>();
  static int indexSearch = 10;
  static bool searching = false;

  void updateButton() {
    setState(() {
      if (_plantList.getMap().length == 0 || _selectedCarrot == null)
        _buttonDeco = BoxDecoration(color: Colors.grey);
      else
        _buttonDeco = BoxDecoration(color: Color.fromARGB(255, 0, 168, 78));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> carrots = new List<String>();
    final _buttonFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(82), color: Colors.black);

    user.getCarrotsMap().forEach((name, carrot) => carrots.add(name));

    updateButton();

    Future<bool> _onWillPop() {
      return popWidgetList(context, "Êtes vous sûrs ?",
          "Voulez vous retourner sur la page principale ?",
          [
            new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Non')
            ),
            new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  Navigator.pushReplacementNamed(context, "/dashboard");
                },
                child: new Text('Oui')
            )
          ]
      );
    }

    if (!searching) {
      plantManager.getExistingPlants().forEach((plantName, plantObj) {
        plants.add(plantObj);
      });
    } else {
      for(var i = 0; i < tmp.length;i++)
        plants.add(tmp[i]);
    }

    final _blackText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), color: Colors.black);

    if (carrots.length == 1)
      _selectedCarrot = carrots[0];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: <Widget> [
          Scaffold(
              appBar: AppBar(
                leading: IconButton(icon:Icon(Icons.arrow_back),
                    onPressed: () {
                      cleanData();
                      Navigator.pushReplacementNamed(context, "/dashboard");
                    }),
                title: Center(
                  child: DropdownButton<String>(
                    hint: Text("- - - -"),
                      value: _selectedCarrot,
                      onChanged: (newValue) => setState(() =>_selectedCarrot = newValue),
                      items: carrots.map((String value) {
                        return DropdownMenuItem<String>(
                          child: new Text(value, style: TextStyle(fontSize: 20)),
                          value: value,
                        );
                      }).toList()
                  ),
                )
              ),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (context, index) => buildSearch(context),
                          childCount: 1
                      )
                  ),
                  SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
                          mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
                          crossAxisSpacing: MediaQuery.of(context).size.width * 0.01,
                          childAspectRatio: (MediaQuery.of(context).size.width * 0.55) / (MediaQuery.of(context).size.height * 0.4)
                          //childAspectRatio: (ScreenUtil.getInstance().setWidth(1080) / 2.5) / (ScreenUtil.getInstance().setHeight(1920) / 3.4)
                          //childAspectRatio: 9/13
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(child: AddPlantPreview(plant: plants[index], addPlant: this, plantList: _plantList)),
                        childCount: plants.length,
                      ),
                    ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(200)),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(200)),
                                child: RaisedButton(
                                  onPressed: () async {
                                    _loadingIndicator.setLoading(true);
                                    if (searching) {
                                      List<int> ids = new List<int>();

                                      for (var i = indexSearch - 10; i < indexSearch && i < results.length; i++)
                                        ids.add(results[i].getId());
                                      indexSearch += 10;

                                      tmp = await user.getFullInfoOnPlant(context, ids);
                                    } else {
                                      await user.getXMorePlants(context, 10);
                                    }

                                    _loadingIndicator.setLoading(false);
                                    setState(() {});
                                    },
                                  child: Text("Charger plus", style: _blackText),
                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  color: Color.fromARGB(255, 0, 168, 78),
                                ),
                              ),
                          childCount: 1
                      ),
                    ),
                  )
                ],
              )),
          Center(child: _loadingIndicator),
          Align(alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  _loadingIndicator.setLoading(true);
                  if (_selectedCarrot == null)
                    popMessage(context, "Erreur", "Veuillez selectionner une carotte à laquelle lier des plantes.");
                  else if (_plantList.getMap().length == 0)
                    popMessage(context, "Erreur", "Veuillez selectionner au minimum une plante à lier à la carotte.");
                  else {
                    _plantList.getList().forEach((plant) {
                      user.getCarrotByName(_selectedCarrot).addPlant(plant);
                      user.addPlantToCarrot(context, _selectedCarrot, plant);
                    });
                    cleanData();
                    _loadingIndicator.setLoading(false);
                    Navigator.pushReplacementNamed(context, "/dashboard");
                  }
                },
                child: GestureDetector(
                  child: SizedBox(height: MediaQuery.of(context).size.height * 0.1, width: MediaQuery.of(context).size.width,
                      child: DecoratedBox(decoration: _buttonDeco,
                          child: Center(child: Material(type: MaterialType.transparency, child: Text("Valider", style: _buttonFont))))),
                ),
              ))
        ],
      ),
    );
  }

  Widget buildSearch(BuildContext context) {
    List<Widget> resultView = new List<Widget>();
    Row result = Row(children: resultView);

    resultView.add(Expanded(
      flex: 4,
      child: Padding(
        padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(50), bottom: ScreenUtil.getInstance().setHeight(25)),
        child: TextField(
          decoration: InputDecoration(
              hintText: "Rechercher ...",
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 0, 168, 78)))
          ),
          keyboardType: TextInputType.text,
          key: Key("SearchFormField"),
          controller: searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) async => await search(),
        )
      ),
    )
    );

    resultView.add(Expanded(
      child: GestureDetector(
          child: Icon(Icons.search),
          onTap: () async => await search()
      ),
    ));

    resultView.add(Expanded(
      child: GestureDetector(
        child: Icon(Icons.clear, color: Colors.red),
        onTap: () {
          cleanData();
          Navigator.pushReplacement(context, FadeRoute(page: AddPlant()));
        },
      ),
    ));

    return result;
  }

  Future<void> search() async {
    FocusScope.of(context).unfocus();
    List<int> ids = new List<int>();

    results = plantManager.getMatchingPlants(searchController.text);
    results.forEach((plant) => print(plant.getName()));

    indexSearch = 10;
    for (var i = 0; i < indexSearch && i < results.length; i++)
      ids.add(results[i].getId());
    indexSearch += 10;

    _loadingIndicator.setLoading(true);
    tmp = await user.getFullInfoOnPlant(context, ids);
    _loadingIndicator.setLoading(false);

    searching = true;
    Navigator.pushReplacement(context, FadeRoute(page: AddPlant()));
  }

  void cleanData() {
    searching = false;
    indexSearch = 10;
    tmp.clear();
    results.clear();
  }
}