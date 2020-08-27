import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../Classes/User.dart';
import '../Classes/Post.dart';

import '../Widgets/PopWindow.dart';
import '../Widgets/LoadingIndicator.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPage createState() => new _EditAccountPage();
}

class _EditAccountPage extends State<EditAccountPage> {
  List<Widget> widgetList;
  TextStyle titleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold);

  static final _idFormKey = GlobalKey<FormState>();
  static final _connectionFormKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateContoller = TextEditingController();
  final _localisationController = TextEditingController();

  final _mailController = TextEditingController();
  final _confirmMailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  DateTime date;

  bool preFilled = false;

  bool _isConfirmMailVisible = false;
  bool _isConfirmPasswordVisible = false;

  FocusNode _idFocusNode1 = FocusNode();
  FocusNode _idFocusNode2 = FocusNode();
  FocusNode _idFocusNode3 = FocusNode();
  FocusNode _idFocusNode4 = FocusNode();
  LoadingIndicator _loadingIndicator = LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    widgetList = new List<Widget>();
    Column generalView = Column(children: widgetList);
    SingleChildScrollView scrollView = SingleChildScrollView(child: generalView);

    preFill();
    buildIdEditor();
    buildAccountConnection();
    addButtons();

    return Stack(
        children: <Widget> [
          Scaffold(
            body: scrollView,
          ),
          Center(child: _loadingIndicator)
        ]
    );
  }

  void preFill() {
    if (!preFilled) {
      preFilled = true;
      _mailController.text = user.getMail();
      _firstNameController.text = user.getFirstName();
      if (user.getBirthday() != null) {
        _birthDateContoller.text = "${user
            .getBirthday()
            .day
            .toString()
            .padLeft(2, '0')}/${user
            .getBirthday()
            .month
            .toString()
            .padLeft(2, '0')}/${user
            .getBirthday()
            .year}";
        date = user.getBirthday();
      }
      _lastNameController.text = user.getLastName();
      _localisationController.text = user.getLocalisation();
    }
  }

  void buildIdEditor() {
    List<Widget> topTitleView = new List<Widget>();
    Stack header = Stack (children: topTitleView);

    Text title = Text("Modifier votre identité", textAlign: TextAlign.center, style: titleFont);

    topTitleView.add(Align(child: title, alignment: Alignment.center));
    topTitleView.add(Padding(
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(25)),
      child: Align(child: GestureDetector(
        child: Icon(Icons.arrow_back),
        onTap: () => Navigator.pushReplacementNamed(context, "/account"),
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

    List<Widget> formView = new List<Widget>();
    Column formColumn = Column(children: formView);

    Form form = Form(child: formColumn, key: _idFormKey);

    formView.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              focusNode: _idFocusNode1,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_idFocusNode2),
              key: Key("FirstNameFormField"),
              controller: _firstNameController,
              decoration: InputDecoration(hintText: "Prénom"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(15)),
              child: TextFormField(
                focusNode: _idFocusNode2,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_idFocusNode3),
                key: Key("LastNameFormField"),
                controller: _lastNameController,
                decoration: InputDecoration(hintText: "Nom"),
              ),
            ),
          )
        ],
      ),
    ));

    final dateFormat = DateFormat("dd/MM/yyyy");
    final DateTime currentBirthday = user.getBirthday();

    formView.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: DateTimeField(
        focusNode: _idFocusNode3,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_idFocusNode4),
        controller: _birthDateContoller,
        decoration: InputDecoration(hintText: "Date de naissance"),
        format: dateFormat,
        onShowPicker: (context, currentValue) async {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? ((currentBirthday != null) ? currentBirthday : DateTime.now()),
              lastDate: DateTime(2100));
          },
        onChanged: (dt) {
          setState(() {
            date = dt;
          });
          },
      ),
    ));

    formView.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: TextFormField(
        focusNode: _idFocusNode4,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
        key: Key("Location"),
        controller: _localisationController,
        decoration: InputDecoration(hintText: "Géolocalisation"),
      ),
    ));

    widgetList.add(form);
  }

  void buildAccountConnection() {
    List<Widget> topTitleView = new List<Widget>();
    Stack header = Stack (children: topTitleView);

    Text title = Text("Modifier vos informations \nde connexion", textAlign: TextAlign.center, style: titleFont);

    topTitleView.add(Align(child: title, alignment: Alignment.center));

    Container container = Container(width: ScreenUtil.getInstance().setWidth(1080), child: header);
    BoxDecoration decoration = BoxDecoration(color: Color.fromARGB(255, 0, 168, 78));
    Padding padding = Padding(padding: EdgeInsets.symmetric(vertical: ScreenUtil.getInstance().setHeight(25)), child: container);
    DecoratedBox decoratedBox = DecoratedBox(decoration: decoration, child: padding);

    SizedBox shadowSize = SizedBox(width: ScreenUtil.getInstance().setWidth(1080), height: ScreenUtil.getInstance().setHeight(3));
    BoxDecoration shadowDecoration = BoxDecoration(color: Color.fromARGB(255, 0, 75, 25));
    DecoratedBox shadowDecoratedBox = DecoratedBox(decoration: shadowDecoration, child: shadowSize);

    widgetList.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(50)),
      child: decoratedBox,
    ));
    widgetList.add(shadowDecoratedBox);

    List<Widget> formView = new List<Widget>();
    Column formColumn = Column(children: formView);

    Form form = Form(child: formColumn, key: _connectionFormKey);

    formView.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: TextFormField(
        key: Key("EmailFormField"),
        keyboardType: TextInputType.emailAddress,
        controller: _mailController,
        decoration: InputDecoration(hintText: "Email"),
      ),
    ));
    
    _mailController.addListener(() {
      setState(() {
        _isConfirmMailVisible = _mailController.text != user.getMail();
      });
    });

    formView.add(Visibility(visible: _isConfirmMailVisible,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
          child: TextFormField(
            key: Key("ConfirmEmailFormField"),
            keyboardType: TextInputType.emailAddress,
            controller: _confirmMailController,
            validator: (value) {
              if (value.isEmpty && _mailController.text != user.getMail())
                return "Veuillez rentrer votre addresse email.";
              if (value.isNotEmpty && value != _mailController.text)
                return "Veuillez rentrer deux emails identiques.";
              return null;
            },
            decoration: InputDecoration(hintText: "Confirmez l'email"),
          ),
        )
    ));

    formView.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: TextFormField(
        key: Key("newPasswordFormField"),
        controller: _newPasswordController,
        obscureText: true,
        decoration: InputDecoration(hintText: "Nouveau mot de passe"),
        validator: (value) {
          if (_currentPasswordController.text.isNotEmpty && value == _currentPasswordController.text)
            return "Veuillez rentrer un mot de passe différent de l'ancien.";
          return null;
        },
      ),
    ));

    formView.add(Visibility(
      visible: _isConfirmPasswordVisible,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
        child: TextFormField(
          key: Key("confirmNewPasswordFormField"),
          controller: _confirmNewPasswordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Confirmez le nouveau mot de passe"),
          validator: (value) {
            if (value.isEmpty && _newPasswordController.text.isNotEmpty)
              return "Veuillez confirmer votre nouveau mot de passe.";
            else if (value != _newPasswordController.text)
              return "Veuillez rentrer deux mots de passe identitiques";
            return null;
          },
        ),
      ),
    ));


    _newPasswordController.addListener(() {
      setState(() {
        _isConfirmPasswordVisible = _newPasswordController.text.isNotEmpty;
      });
    });

    widgetList.add(form);

    widgetList.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(150)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
        child: TextFormField(
            key: Key("oldPasswordFormField"),
            controller: _currentPasswordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "Mot de passe actuel"),
        ),
      ),
    ));
  }

  void addButtons() {
    final _whiteText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), color: Colors.white);

    List<Widget> buttonView = new List<Widget>();
    Column buttonColumn = Column(children: buttonView);

    buttonView.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(20)),
      child: RaisedButton(
        key: Key("ConfirmEditProfileButton"),
        onPressed: () async {
          if (await confirmForm())
            Navigator.pushReplacementNamed(context, "/account");
        },
        child: Text("Valider", style: _whiteText),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: Color.fromARGB(255, 255, 115, 0),
      ),
    ));

    buttonView.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(20)),
      child: RaisedButton(
        key: Key("DeleteProfileButton"),
        onPressed: () async {
          displayDeleteDialog(context);
        },
        child: Text("Supprimer le compte", style: _whiteText),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: Color.fromARGB(250, 170, 20, 20),
      ),
    ));

    widgetList.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(50)),
      child: buttonColumn,
    ));
  }

  Future<bool> displayDeleteDialog(BuildContext context) async {
    return popWidgetList(context, "Êtes vous sûrs ?",
        "Voulez vous vraiment supprimer votre compte ?",
        [
          new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Non')
          ),
          new FlatButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
                _loadingIndicator.setLoading(true);
                await user.deleteAccount(context);
                _loadingIndicator.setLoading(false);
                Navigator.pushReplacementNamed(context, "/login");
                print("delete account");
              },
              child: new Text('Oui')
          )
        ]
    );
  }

  Future<bool> confirmForm() async {
    if (_currentPasswordController.text.isEmpty) {
      await popMessage(context, "Erreur", "Veuillez rentrez votre mot de passe actuel");
    }
    else if (_connectionFormKey.currentState.validate() && _idFormKey.currentState.validate()) {
      String birthday = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

      _loadingIndicator.setLoading(true);
      await user.updateUserData(
          context,
          _mailController.text,
          _currentPasswordController.text,
          birthday,
          _firstNameController.text,
          _lastNameController.text,
          _localisationController.text,
          "1"
      );
      if (_currentPasswordController.text != _newPasswordController.text)
        await user.updatePassword(context, _mailController.text, _currentPasswordController.text, _newPasswordController.text);
      _loadingIndicator.setLoading(false);

      return true;
    }
    return false;
  }
}