import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../Classes/User.dart';
import '../Classes/ContactMail.dart';
import '../Classes/Post.dart';

import '../Widgets/FileInList.dart';
import '../Widgets/LoadingIndicator.dart';
import '../Widgets/PopWindow.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPage createState() => new _ContactPage();
}

class _ContactPage extends State<ContactPage> {
  List<Widget> widgetList;

  List<File> files = new List<File>();
  List<Widget> filesView;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mailController = TextEditingController();
  final _objectController = TextEditingController();
  final _messageController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();

  LoadingIndicator _loadingIndicator = LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    widgetList = new List<Widget>();
    Column generalView = Column(children: widgetList);
    Form form = Form(child: generalView, key: _formKey);
    SingleChildScrollView scrollView = SingleChildScrollView(child: form);

    SafeArea sf = SafeArea(child: scrollView);

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidht = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    double paddingTop = mediaQueryData.padding.top;

    buildHeader(context);
    buildId();
    preFill();
    buildFiles(context);
    buildMessage();
    addButton(context);

    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Stack(
          children: <Widget> [
            Scaffold(
              body: sf,
            ),
            Center(child: _loadingIndicator)
          ]
      ),
    );
  }

  void buildHeader(BuildContext context) {
    List<Widget> topTitleView = new List<Widget>();
    Stack header = Stack (children: topTitleView);

    TextStyle titleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold);
    Text title = Text("Nous contacter", textAlign: TextAlign.center, style: titleFont);

    topTitleView.add(Align(child: title, alignment: Alignment.center));
    topTitleView.add(Padding(
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(25)),
      child: Align(child: GestureDetector(
        child: Icon(Icons.arrow_back),
        onTap: () {
          if (user.isConnected())
            Navigator.pushReplacementNamed(context, "/dashboard");
          else
            Navigator.pushReplacementNamed(context, "/login");
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

  void buildId() {
    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              key: Key("FirstNameFormField"),
              controller: _firstNameController,
              decoration: InputDecoration(hintText: "Prénom"),
              validator: (value) {
                if (value.isEmpty)
                  return "Veuillez rentrer votre prénom.";
                return null;
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(15)),
              child: TextFormField(
                key: Key("LastNameFormField"),
                controller: _lastNameController,
                decoration: InputDecoration(hintText: "Nom"),
                validator: (value) {
                  if (value.isEmpty)
                    return "Veuillez rentrer votre nom.";
                  return null;
                },
              ),
            ),
          )
        ],
      ),
    ));

    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        key: Key("EmailFormField"),
        controller: _mailController,
        validator: (value) {
          if (_mailController.text.isEmpty)
            return "Veuillez rentrer votre addresse email.";
          return null;
        },
        decoration: InputDecoration(hintText: "Email"),
      ),
    ));
  }

  void preFill() {
    if (user.isConnected()) {
      _firstNameController.text = user.getFirstName();
      _lastNameController.text = user.getLastName();
      _mailController.text = user.getMail();
    }
  }

  void deleteFile(String filePath) {
    setState(() {
      File toRemove;
      for (File file in files) {
        if (file.path == filePath) {
          print("-------- DELETE CONFIRM --------");
          print(file.path);
          print(filePath);
          toRemove = file;
          print("--------------------------------");
        }
      }
      files.remove(toRemove);
      print("--------- DELETE ---------");
      print(files);
    });
  }

  void buildFiles(BuildContext context) {
    final _whiteText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), color: Colors.white);

    List<Widget> columnView = new List<Widget>();
    Column row = Column(children: columnView);
    filesView = new List<Widget>();
    Column filesColumn = Column(children: filesView);
    SingleChildScrollView scrollFile = SingleChildScrollView(scrollDirection: Axis.horizontal, child: filesColumn);

    TextStyle nameStyle = TextStyle(fontSize: ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold);
    columnView.add(Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().setHeight(20)),
      child: Text("Fichiers: ", style: nameStyle),
    ));

    print("--------- ADDING ---------");
    filesView.clear();
    for (File file in files) {
      print(basename(file.path));
      filesView.add(FileInList(
          fileName: basename(file.path), onTap: () => deleteFile(file.path)));
    }

    columnView.add(scrollFile);

    columnView.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(20)),
      child: RaisedButton(
        key: Key("AddFileButton"),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Quelle méthode utiliser ?'),
              content: new Text('Comment voulez vous ajouter un nouveau fichier ?'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () async {
                    File image = await ImagePicker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        files.add(image);
                      });
                    }
                    Navigator.of(context).pop(false);
                  },
                  child: new Text('Caméra'),
                ),
                new FlatButton(
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                    List<File> previous = files;
                    files = await FilePicker.getMultiFile();
                    if (files == null)
                      files = previous;
                    else {
                      List<File> toRemove = new List<File>();
                      for (File file in files) {
                        File existing = previous.firstWhere((check) => check.path == file.path, orElse: () => null);
                        if (existing != null)
                          toRemove.add(file);
                      }
                      for (File file in toRemove)
                        files.remove(file);
                      previous.addAll(files);
                      setState(() {
                        files = previous;
                      });
                    }
                  },
                  child: new Text('Explorateur de fichier'),
                ),
              ],
            ),
          );
        },
        child: Text("Ajouter des fichiers", style: _whiteText),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: Color.fromARGB(255, 255, 115, 0),
      ),
    ));

    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(25)),
        child: row,
      ),
    ));
  }

  void buildMessage() {
    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: TextFormField(
        key: Key("ObjectFormField"),
        controller: _objectController,
        validator: (value) {
          if (value.isEmpty)
            return "Veuillez rentrer un objet.";
          return null;
        },
        decoration: InputDecoration(hintText: "Objet"),
      ),
    ));

    widgetList.add(Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil.getInstance().setHeight(25),
          horizontal: ScreenUtil.getInstance().setWidth(50)),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 10,
        maxLines: 100,
        key: Key("MessageFormField"),
        controller: _messageController,
        validator: (value) {
          if (value.isEmpty)
            return "Veuillez rentrer un message.";
          return null;
        },
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 168, 78), width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            hintText: "Message"),
      ),
    ));
  }

  void addButton(BuildContext context) {
    final _whiteText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), color: Colors.white);

    widgetList.add(Padding(
      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(20)),
      child: RaisedButton(
        key: Key("ConfirmEditProfileButton"),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _loadingIndicator.setLoading(true);
            await sendToApi(context);
            _loadingIndicator.setLoading(false);
            Navigator.pushReplacementNamed(context, (user.isConnected()) ? "/dashboard" : "/login");
          }
        },
        child: Text("Envoyer", style: _whiteText),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: Color.fromARGB(255, 0, 168, 78),
      ),
    ));
  }

  Future<bool> sendToApi(BuildContext context) async {
    ContactMail m = new ContactMail(
        mail: _mailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        object: _objectController.text,
        body: _messageController.text,
        attachmentsList: files);

    return m.sendToApi(context);
  }

}
