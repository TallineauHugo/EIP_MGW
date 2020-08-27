import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Classes/User.dart';
import '../Classes/Post.dart';
import '../Classes/Get.dart';
import '../Classes/Plants.dart';
import '../Widgets/PopWindow.dart';
import '../Widgets/LoadingIndicator.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  static final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoadingIndicator _loadingIndicator = LoadingIndicator();

  static final _resetFormKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = TextEditingController();
  bool validateEditing = false;

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => tryReconnect(context));
  }
  
  Future<void> tryReconnect(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String token = prefs.getString("token");
    if (token != null) {
      user.setToken(token);
      user.setMail(prefs.getString("mail"));
      //check if token is still valid
      _loadingIndicator.setLoading(true);
      if (await user.fetchCarrots(context)) {
        if (await getAllPlantsID(context) &&
            await user.getXMorePlants(context, 10)) {
          await user.connect(context);

          _loadingIndicator.setLoading(false);
          Navigator.pushReplacementNamed(context, "/dashboard");
        }
        else
          _loadingIndicator.setLoading(false);
      }
      else
        _loadingIndicator.setLoading(false);
    }
    return;
  }

  Widget buildHeader() {
    final _titleFont = TextStyle(
        color: Colors.white,
        fontSize: ScreenUtil.getInstance().setSp(100.0),
        fontFamily: 'Lobster',
        shadows: [Shadow(color: Colors.black, offset: Offset(2.0, 2.0))]
    );

    return Expanded(
      flex: 2,
      child: SizedBox(
        width: ScreenUtil.getInstance().setWidth(1080),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 115, 0),
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: AssetImage("assets/images/login_header_bg.jpg"),
                  fit: BoxFit.cover)
          ),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(50)),
                      child: Image(image: AssetImage(
                          "assets/images/logo_grey_round_shadow.png")),
                    ),
                  ),
                Expanded(
                  flex: 1,
                  child: Text("MyGardenWatcher", style: _titleFont),
                )
              ],
            ),
          ),
      ),
    );
  }

  Widget buildForm(context) {
    final _fieldTitleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(60), fontWeight: FontWeight.bold);
    final _whiteText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), color: Colors.white);
    final _biggerText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40));
    final _underlineText = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), decoration: TextDecoration.underline);
    final _resetStyle = TextStyle(fontSize: ScreenUtil.getInstance().setSp(40), fontStyle: FontStyle.italic);

    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          color: Color.fromARGB(255, 0, 168, 78),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil.getInstance().setHeight(100),
                  left: ScreenUtil.getInstance().setWidth(50),
                  right: ScreenUtil.getInstance().setWidth(50)),
              child: Container(
                height: ScreenUtil.getInstance().setHeight(800),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 168, 78)),
                  child: Center(child: Column(
                    children: <Widget>[
                      Wrap(children: <Widget>[
                        Center(child: Text("Email :", style: _fieldTitleFont)),
                        Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil.getInstance().setWidth(100),
                              right: ScreenUtil.getInstance().setWidth(100),
                              bottom: ScreenUtil.getInstance().setHeight(40)),
                          child: Container(
                            height: ScreenUtil.getInstance().setHeight(150),
                            child: TextFormField(
                              focusNode: _focusNode1,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_focusNode2);
                              },
                              keyboardType: TextInputType.emailAddress,
                              key: Key("EmailFormField"),
                              controller: _mailController,
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Veuillez rentrer votre addresse email.";
                                return null;
                              },
                            ),
                          ),
                        ),
                      ]),
                      Expanded(
                        child: Wrap(children: <Widget>[
                          Center(child: Text("Mot de passe :", style: _fieldTitleFont)),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil.getInstance().setWidth(100),
                                right: ScreenUtil.getInstance().setWidth(100),
                                bottom: ScreenUtil.getInstance().setHeight(40)),
                            child: Container(
                              height: ScreenUtil.getInstance().setHeight(150),
                              child: TextFormField(
                                focusNode: _focusNode2,
                                onFieldSubmitted: (_) async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate())
                                    await login();
                                },
                                textInputAction: TextInputAction.next,
                                key: Key("PasswordFormField"),
                                controller: _passwordController, obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Veuillez rentrer votre mot de passe.";
                                  else if (value.length > 100)
                                    return "Mot de passe trop long !";
                                  return null;
                                  },
                              ),
                            ),
                          ),
                        ],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(child: Text("Mot de passe oublié ?", style: _resetStyle), onTap: () async {
                              _textFieldController.text = _mailController.text;
                              await displayInputDialog(context);
                              _resetFormKey.currentState.reset();
                              if (validateEditing)
                                print(_textFieldController.text);
                            })],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(20)),
                        child: RaisedButton(
                          key: Key("LoginButton"),
                          onPressed: () async {
                            if (_formKey.currentState.validate())
                              await login();
                          },
                          child: Text("Connexion", style: _whiteText),
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          color: Color.fromARGB(255, 255, 115, 0),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(45)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(flex: 2, child: Text("Vous n'avez pas de compte ?", style: _biggerText)),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                                      _formKey.currentState.reset();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Text("Créez en un !", style: _underlineText),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    final _footerTitleFont = TextStyle(fontSize: 24.0);

    return Expanded(
      child: Container(
        color: Color.fromARGB(255, 0, 168, 78),
        child: Column(
          children: <Widget>[
            Expanded(child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text("À propos de nous", style: _footerTitleFont),
            )),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: GestureDetector(
                      child: Image(
                            image: AssetImage("assets/images/icon_facebook.png")),
                      onTap: () async => launchUrl("https://www.facebook.com/mygardenwatcher")
                    )),
                    Expanded(child: GestureDetector(
                      child: Image(
                            image: AssetImage("assets/images/icon_twitter.png")),
                      onTap: () async => launchUrl("https://twitter.com/mygardenwatcher")
                    )),
                    Expanded(child: GestureDetector(
                      child: Image(
                            image: AssetImage("assets/images/icon_instagram.png")),
                      onTap: () async => launchUrl("https://www.instagram.com/mygardenwatcher/")
                    )),
                    Expanded(child: GestureDetector(
                      child: Image(
                            image: AssetImage("assets/images/icon_mail.png")),
                      onTap: () async {
                        Navigator.pushReplacementNamed(context, "/contact");
                      }
                    )),
                    Expanded(child: GestureDetector(
                      child: Image(
                            image: AssetImage("assets/images/icon_website.png")),
                      onTap: () async => launchUrl("http://mygardenwatcher.fr/")
                    )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920, allowFontScaling: true)..init(context);

    Future<bool> _onWillPop() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Êtes vous sûr ?'),
          content: new Text("Êtes vous sûr de vouloir quitter l'applocation ?"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Non'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Oui'),
            ),
          ],
        ),
      ) ?? false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: ScreenUtil.getInstance().setHeight(1920),
                width: ScreenUtil.getInstance().setWidth(1080),
                child: Column(
                  children: <Widget>[
                    buildHeader(),
                    buildForm(context),
                    buildFooter()
                  ],
                ),
              ),
            ),
            Center(child: _loadingIndicator)
          ]
        ),
      ),
    );
  }

  Future<void> login() async {
    _loadingIndicator.setLoading(true);
    if (await tryLogin(context) &&
    await getAllPlantsID(context) &&
    await user.getXMorePlants(context, 10)) {
    await user.connect(context);

    _loadingIndicator.setLoading(false);
    Navigator.pushReplacementNamed(context, "/dashboard");
    }
    else
    _loadingIndicator.setLoading(false);
  }

  // CALL API LOGIN
  Future<bool> tryLogin(BuildContext context) async {
    PostProvider postProvider = new PostProvider();

    try {
      Post answer = await postProvider.createPost("/auth/login", body: {
        "mail": _mailController.text,
        "password": _passwordController.text
      });

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        //handle error
        print("login error " + answer.statusCode.toString());
        switch (answer.statusCode) {
          case 400:
            popMessage(context, "Erreur d'authentification",
                "Informations manquantes, veuillez contacter MGW pour reporter le problème.");
            break;
          case 401:
            popWidgetList(context, "Erreur d'authentification",
                "Ce compte n'existe pas, veuillez vérifier vos informations et réessayer.",
                [
                  new FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text('Ok')
                  )
                ]
            );
            break;
        }
        return false;
      }

      user.setToken(answer.map['token']);
      user.setMail(_mailController.value.text);

      //stay connected
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", user.getToken());
      prefs.setString("mail", user.getMail());
    } catch (e) {
      popMessage(context, "Erreur lors de la connexion",
          "Vérifiez votre connexion internet et réessayez");
      return false;
    }
    return true;
  }

  Future<void> displayInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Quel est l'email de votre compte ?"),
            content: Form(
              key: _resetFormKey,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Email ..."),
                validator: (value) {
                  value = value.trim();
                  if (value.isEmpty)
                    return "Veuillez entrer une addresse email";
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Valider'),
                onPressed: () async {
                  if (_resetFormKey.currentState.validate()) {
                    validateEditing = true;
                    Navigator.of(context).pop();
                    _loadingIndicator.setLoading(true);
                    await user.resetPasswordInit(context, _textFieldController.text);
                    _loadingIndicator.setLoading(false);

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

  Future<bool> getAllPlantsID(BuildContext context) async {
    GetProvider provider = new GetProvider();
    try {
      Get answer = await provider.createGetPlantsList(
          "/plants",
          header: {"auth": user.getToken(), "Content-Type": "application/x-www-form-urlencoded"},
          params: {"attributes": "name,id"}
      );

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        print("getPlants: error code " + answer.statusCode.toString());
        return false;
      }
      print("reponse du /plants: " + answer.map.length.toString() + " plantes fetched");
      //answer.map.forEach((name, plant) => print(name));

      plantManager.populateKnownPlants(answer.map);
    } catch (e) {
      popMessage(context, "Erreur de récupération des plantes", e.toString());
      return false;
    }
    return true;
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}