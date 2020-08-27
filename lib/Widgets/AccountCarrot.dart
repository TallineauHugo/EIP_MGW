import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/Carrot.dart';
import '../Classes/User.dart';

import '../Transitions/FadeRoute.dart';

import '../Pages/AccountPage.dart';

import '../Widgets/LoadingIndicator.dart';

class AccountCarrot extends StatefulWidget {
  Carrot carrot;
  LoadingIndicator loadingIndicator;

  @override
  _AccountCarrot createState() => new _AccountCarrot(carrot: this.carrot, loadingIndicator: this.loadingIndicator);

  AccountCarrot({@required this.carrot, this.loadingIndicator});
}

class _AccountCarrot extends State<AccountCarrot> {
  Carrot carrot;
  LoadingIndicator loadingIndicator;

  static final _formKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();
  bool validateEditing = false;


  @override
  Widget build(BuildContext context) {
    List<Widget> view = new List<Widget>();
    Row widget = Row(children: view);
    TextStyle carrotNameFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(75));
    Text carrotName = Text(this.carrot.getName(), style: carrotNameFont);
    Padding padding = Padding(padding: EdgeInsets.only(
        left: ScreenUtil.getInstance().setWidth(15)),
        child: carrotName);

    view.add(padding);

    List<Widget> actionsView = new List<Widget>();
    Row actions = Row(children: actionsView, mainAxisAlignment: MainAxisAlignment.end);

    actionsView.add(GestureDetector(
        onTap: () async {
          await displayInputDialog(context);
          if (validateEditing) {
            loadingIndicator.setLoading(true);
            await user.renameCarrot(context, carrot.getName(), _textFieldController.text.trim());
            loadingIndicator.setLoading(false);
            validateEditing = false;
            Navigator.pushReplacement(context, FadeRoute(page: AccountPage()));
          }
        },
        child: Icon(Icons.edit, color: Color.fromARGB(255, 0, 168, 78))
    ));
    actionsView.add(GestureDetector(
        onTap: () async {
          loadingIndicator.setLoading(true);
          await user.removeCarrotFromMap(context, carrot.getId());
          loadingIndicator.setLoading(false);
          Navigator.pushReplacement(context, FadeRoute(page: AccountPage()));
        },
        child: Icon(Icons.delete, color: Colors.red)
    ));

    view.add(Expanded(child: actions));

    return widget;
  }

  Future<void> displayInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Renommer "' + carrot.getName() + '"'),
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

  _AccountCarrot({@required this.carrot, this.loadingIndicator});
}