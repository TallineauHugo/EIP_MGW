import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/Post.dart';
import '../Widgets/PopWindow.dart';
import '../Widgets/LoadingIndicator.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  static final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifMailController = TextEditingController();
  final _verifPasswordController = TextEditingController();
  LoadingIndicator _loadingIndicator = LoadingIndicator();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920, allowFontScaling: true)..init(context);

    final _fieldTitleFont = TextStyle(fontSize: ScreenUtil.getInstance().setSp(65), fontWeight: FontWeight.bold);
    final _titleFont = TextStyle(
        color: Colors.white,
        fontSize: ScreenUtil.getInstance().setSp(100.0),
        fontFamily: 'Lobster',
        shadows: [Shadow(color: Colors.black, offset: Offset(2.0, 2.0))]
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: ScreenUtil.getInstance().setHeight(1920),
              width: ScreenUtil.getInstance().setWidth(1080),
              child: Column(
                children: <Widget>[
                Expanded(
                flex: 1,
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
              ),
                  Expanded(flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Container(
                        color: Color.fromARGB(255, 0, 168, 78),
                        child: Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text("Email:", style: _fieldTitleFont),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(100), right: ScreenUtil.getInstance().setWidth(100)),
                              child: Container(
                                height: ScreenUtil.getInstance().setHeight(150),
                                child: TextFormField(
                                  focusNode: _focusNode1,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNode2),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _mailController,
                                  validator: (value) {
                                    value = value.trim();
                                    if (value.isEmpty)
                                      return "Veuillez rentrer une adresse email.";
                                    else if (value != _verifMailController.text)
                                      return "Les adresses email doivent êtres identiques.";
                                    else if (!value.contains(new RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                                      return "Veuillez entrer une adresse email valide.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text("Confirmez l'email:", style: _fieldTitleFont),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(100), right: ScreenUtil.getInstance().setWidth(100)),
                              child: Container(
                                height: ScreenUtil.getInstance().setHeight(150),
                                child: TextFormField(
                                  focusNode: _focusNode2,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNode3),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _verifMailController,
                                  validator: (value) {
                                    value = value.trim();
                                    if (value.isEmpty)
                                      return "Veuillez valider votre addresse email.";
                                    else if (value != _mailController.text)
                                      return "Les adresses email doivent êtres identiques.";
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text("Mot de passe:", style: _fieldTitleFont),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(100), right: ScreenUtil.getInstance().setWidth(100)),
                              child: Container(
                                height: ScreenUtil.getInstance().setHeight(150),
                                child: TextFormField(controller: _passwordController, obscureText: true,
                                  focusNode: _focusNode3,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNode4),
                                  validator: (value) {
                                  if (value.isEmpty)
                                    return "Veuillez rentrer un mot de passe.";
                                  else if (value.length > 100)
                                    return "Mot de passe trop long !";
                                  else if (value != _verifPasswordController.text)
                                    return "Les mots de passe doivent êtres identiques.";
                                  else if (!value.contains(new RegExp(r'[A-Z]')))
                                    return "Veuillez inclure au moins une majuscule.";
                                  else if (!value.contains(new RegExp(r'[a-z]')))
                                    return "Veuillez inclure au moins une minuscule.";
                                  else if (!value.contains(new RegExp(r'[0-9]')))
                                    return "Veuillez inclure au moins un chiffre.";
                                  else if (value.length < 8)
                                    return "Veuillez inclure au moins 8 caractères";
                                  return null;
                                },),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text("Confirmez le mot de passe:", style: _fieldTitleFont),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(100), right: ScreenUtil.getInstance().setWidth(100)),
                              child: Container(
                                height: ScreenUtil.getInstance().setHeight(150),
                                child: TextFormField(controller: _verifPasswordController, obscureText: true,
                                  focusNode: _focusNode4,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      _loadingIndicator.setLoading(true);
                                      if (await tryRegister()) {
                                        _loadingIndicator.setLoading(false);
                                        Navigator.pop(context);
                                      }
                                      _loadingIndicator.setLoading(false);
                                    }
                                  },
                                  validator: (value) {
                                    value = value.trim();
                                    if (value.isEmpty)
                                      return "Veuillez re-rentrer votre mot de passe.";
                                    else if (value.length > 100)
                                      return "Mot de passe trop long !";
                                    else if (value != _passwordController.text)
                                      return "Les mots de passe doivent êtres identiques.";
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(35)),
                              child: RaisedButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    _loadingIndicator.setLoading(true);
                                    if (await tryRegister(/*context*/)) {
                                      _loadingIndicator.setLoading(false);
                                      Navigator.pop(context);
                                    }
                                    _loadingIndicator.setLoading(false);
                                  }
                                },
                                child: Text("Création"),
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                color: Color.fromARGB(255, 255, 115, 0),
                              ),
                            )
                          ],),
                        ),
                      ),
                    ),),
                ],
              ),
            ),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                iconTheme: IconThemeData(color: Colors.white),
              ),),
            Center(child: _loadingIndicator)]
        ),
      ),
    );
  }

  Future<bool> tryRegister() async {
      // CALL API REGISTER
      PostProvider postProvider = new PostProvider();
      Post answer = await postProvider.createPost("/auth/register", body: {
        "mail": _mailController.text,
        "password": _passwordController.text
      });

      if (answer.statusCode < 200 || answer.statusCode > 400) {
        // handle error
        print("register error " + answer.statusCode.toString());
        print(answer.map);
        switch (answer.statusCode) {
          case 400:
            popMessage(context, "Erreur lors de la création de compte", "Informations manquantes, veuillez contacter MGW pour reporter le problème.");
            break;
          case 409:
            popMessage(context, "Erreur lors de la création de compte", "Ce compte existe déjà.");
            break;
          case 422:
            popMessage(context, "Erreur lors de la création de compte", "Cette adresse est déjà utilisée.");
            break;
        }
        return false;
      }
      print("register success");
      return true;
  }
}