import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/Get.dart';
import '../Classes/Plants.dart';

import '../Classes/User.dart';
import '../Widgets/LoadingIndicator.dart';
import '../Widgets/PlantPreview.dart';
import '../Widgets/PopWindow.dart';
import '../Transitions/FadeRoute.dart';

class PlantsPage extends StatefulWidget {
  @override
  _PlantsPage createState() => new _PlantsPage();
}

class _PlantsPage extends State<PlantsPage> {
  static final _searchFormKey = GlobalKey<FormState>();

  List<Widget> widgetList;

  LoadingIndicator _loadingIndicator = LoadingIndicator();

  List<Plant> plants = new List<Plant>();

  //recherche
  static List<Plant> results = new List<Plant>();
  static List<Plant> tmp = new List<Plant>();
  static int indexSearch = 10;
  static bool searching = false;

  @override
  Widget build(BuildContext context) {


    if (!searching) {
      plantManager.getExistingPlants().forEach((plantName, plantObj) {
        plants.add(plantObj);
      });
    } else {
      for(var i = 0; i < tmp.length;i++)
        plants.add(tmp[i]);
    }

    final _blackText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), color: Colors.black);

    return Stack(
      children: <Widget> [
        Scaffold(body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => buildHeader(context),
              childCount: 1
            ),
          ),
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
            ),
            delegate: SliverChildBuilderDelegate(
                (context, index) => Container(child: PlantPreview(plant: plants[index])),
              childCount: plants.length,
            ),
          ),
          SliverList(
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
          )
        ],
      )),
        Center(child: _loadingIndicator)
    ],
    );
  }

  Widget buildSearch(BuildContext context) {
    List<Widget> resultView = new List<Widget>();
    Row row = Row(children: resultView);
    Form result = Form(child: row, key: _searchFormKey);

    final searchController = TextEditingController();

    resultView.add(Expanded(
      flex: 4,
      child: Padding(
        padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(50), bottom: ScreenUtil.getInstance().setHeight(25)),
        child: TextFormField(
            decoration: InputDecoration(
                hintText: "Rechercher ...",
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 0, 168, 78)))
            ),
            keyboardType: TextInputType.text,
            key: Key("SearchFormField"),
            controller: searchController,
            validator: (value) {
              if (value.isEmpty)
                return "Veuillez rentrer une chaîne de caractères à rechercher.";
              return null;
            }
            ),
      ),
    )
    );

    resultView.add(Expanded(
      child: GestureDetector(
        child: Icon(Icons.search),
        onTap: () async {
          if (_searchFormKey.currentState.validate()) {
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
            Navigator.pushReplacement(context, FadeRoute(page: PlantsPage()));
          }
        }
      ),
    ));

    resultView.add(Expanded(
      child: GestureDetector(
        child: Icon(Icons.clear, color: Colors.red),
        onTap: () {
          cleanData();
          Navigator.pushReplacement(context, FadeRoute(page: PlantsPage()));
        },
      ),
    ));

    return result;
  }

  Widget buildHeader(BuildContext context) {
    List<Widget> resultView = new List<Widget>();
    Column result = Column(children: resultView);

    List<Widget> topTitleView = new List<Widget>();
    Stack header = Stack (children: topTitleView);

    TextStyle titleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold);
    Text title = Text("Nos plantes", textAlign: TextAlign.center, style: titleFont);

    topTitleView.add(Align(child: title, alignment: Alignment.center));
    topTitleView.add(Padding(
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(25)),
      child: Align(child: GestureDetector(
        child: Icon(Icons.arrow_back),
        onTap: () {
          cleanData();
          Navigator.pushReplacementNamed(context, "/dashboard");
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

    resultView.add(decoratedBox);
    resultView.add(shadowDecoratedBox);

    return result;
  }

  void cleanData() {
    searching = false;
    indexSearch = 10;
    tmp.clear();
    results.clear();
  }
}