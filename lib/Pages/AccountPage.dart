import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/User.dart';

import '../Widgets/AccountCarrot.dart';
import '../Widgets/LoadingIndicator.dart';

import '../Transitions/FadeRoute.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPage createState() => new _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  List<Widget> widgetList;
  LoadingIndicator _loadingIndicator = LoadingIndicator();

  static final _formKey = GlobalKey<FormState>();
  TextEditingController _carrotNameController = TextEditingController();
  bool validateEditing = false;

  @override
  Widget build(BuildContext context) {
    widgetList = new List<Widget>();
    Column generalView = Column(children: widgetList);
    SingleChildScrollView scrollView = SingleChildScrollView(child: generalView);

    buildIdentity();
    buildCarrotList();

    return Stack(
      children: <Widget>[
        Scaffold(
          body: scrollView,
        ),
        Center(child: _loadingIndicator)
      ]
    );
  }

  void buildIdentity() {
    List<Widget> genView = new List<Widget>();
    Stack header = Stack (children: genView);
    List<Widget> view = new List<Widget>();
    Column identity = Column(children: view);

    genView.add(Padding(
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(25)),
      child: Align(child: GestureDetector(
        child: Icon(Icons.arrow_back),
        onTap: () => Navigator.pushReplacementNamed(context, "/dashboard"),
      ), alignment: Alignment.centerLeft),
    ));
    genView.add(Align(child: identity, alignment: Alignment.center));
    genView.add(Padding(
      padding: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(25)),
      child: Align(child: GestureDetector(
          child: Icon(Icons.edit),
          onTap: () => Navigator.pushReplacementNamed(context, "/edit_account")
      ),
          alignment: Alignment.centerRight),
    ));

    Container container = Container(width: ScreenUtil.getInstance().setWidth(1080), child: header);
    BoxDecoration decoration = BoxDecoration(color: Color.fromARGB(255, 0, 168, 78));
    Padding padding = Padding(padding: EdgeInsets.symmetric(vertical: ScreenUtil.getInstance().setHeight(25)), child: container);
    DecoratedBox decoratedBox = DecoratedBox(decoration: decoration, child: padding);

    SizedBox shadowSize = SizedBox(width: ScreenUtil.getInstance().setWidth(1080), height: ScreenUtil.getInstance().setHeight(3));
    BoxDecoration shadowDecoration = BoxDecoration(color: Color.fromARGB(255, 0, 75, 25));
    DecoratedBox shadowDecoratedBox = DecoratedBox(decoration: shadowDecoration, child: shadowSize);

    TextStyle emailFont = TextStyle(color: Colors.black, fontSize: ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold);
    Text email = Text(user.getMail(), style: emailFont);

    TextStyle nameFont = TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontSize: ScreenUtil.getInstance().setSp(40));
    String name = "";

    view.add(email);

    if (user.getFirstName() != null)
      name += user.getFirstName();
    if (user.getLastName() != null)
      name += name != "" ? " " + user.getLastName() : user.getLastName();
    if (name != "")
      view.add(Text(name, style: nameFont));


    widgetList.add(decoratedBox);
    widgetList.add(Padding(padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(20)), child: shadowDecoratedBox));
  }

  void buildCarrotList() {
    List<Widget> view = new List<Widget>();
    Column carrots = Column(children: view);
    TextStyle titleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(100));
    Text title = Text("Vos carottes", style: titleFont);

    view.add(Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(25)),
      child: title,
    ));
    int i = 0;
    user.getCarrotsMap().forEach((name, carrot) {
      view.add(AccountCarrot(carrot: carrot, loadingIndicator: _loadingIndicator));
      if (++i < user.getCarrotsMap().length)
        view.add(Divider(thickness: ScreenUtil.getInstance().setHeight(5)));
    });
    view.add(GestureDetector(
        onTap: () async {
          await displayInputDialog(context);
          if (validateEditing) {
            _loadingIndicator.setLoading(true);
            await user.createCarrot(context, _carrotNameController.text);
            _loadingIndicator.setLoading(false);
            validateEditing = false;
            Navigator.pushReplacement(context, FadeRoute(page: AccountPage()));
          }
        },
        child: Icon(Icons.add_box, color: Color.fromARGB(255, 0, 168, 78), size: ScreenUtil.getInstance().setHeight(100))
        )
    );

    widgetList.add(carrots);
  }

  Future<void> displayInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Nouvelle Carotte"),
            content: Form(
              key: _formKey,
              child: TextFormField(
                key: Key("NameFormField"),
                controller: _carrotNameController,
                decoration: InputDecoration(hintText: "Nom"),
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
                child: new Text('Valider'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    validateEditing = true;
                    Navigator.of(context).pop();
                  }
                },
              ),
              new FlatButton(
                child: new Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

}