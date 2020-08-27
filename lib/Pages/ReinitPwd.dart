import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Classes/User.dart';
import '../Tools/LinkManagment.dart';
import '../Widgets/LoadingIndicator.dart';
import '../Widgets/PopWindow.dart';

class ReinitPwd extends StatefulWidget {
  @override
  _ReinitPwd createState() => new _ReinitPwd();
}

class _ReinitPwd extends State<ReinitPwd> {
  String token;

  static final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  LoadingIndicator _loadingIndicator = new LoadingIndicator();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();

  @override
  Widget build(BuildContext context) {
    PasswordReinitialization reinitialization = PasswordReinitialization();
    token = reinitialization.getToken;

    return Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      buildHeader(),
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                        child: GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, "/login"),
                            child: Icon(Icons.home, size: MediaQuery.of(context).size.height * .05, color: Color.fromARGB(255, 0, 168, 78))
                        ),
                      ),
                      buildForm(context),
                    ],
                  ),
                ),
              ),
              Center(child: _loadingIndicator)
            ]
          )
        );
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
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty)
                                  return "Veuillez rentrer votre addresse email.";
                                return null;
                              },
                              focusNode: _focusNode1,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNode2),
                            ),
                          ),
                        ),
                      ]),
                      Expanded(
                        child: Wrap(children: <Widget>[
                          Center(child: Text("Nouveau mot de passe :", style: _fieldTitleFont)),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil.getInstance().setWidth(100),
                                right: ScreenUtil.getInstance().setWidth(100)),
                            child: Container(
                              height: ScreenUtil.getInstance().setHeight(150),
                              child: TextFormField(
                                controller: _newPasswordController, obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Veuillez rentrer votre nouveau mot de passe.";
                                  else if (value.length > 100)
                                    return "Mot de passe trop long !";
                                  return null;
                                },
                                  focusNode: _focusNode2,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_focusNode3)
                              ),
                            ),
                          ),
                        ],),
                      ),
                      Expanded(
                        child: Wrap(children: <Widget>[
                          Center(child: Text("Confirmation :", style: _fieldTitleFont)),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil.getInstance().setWidth(100),
                                right: ScreenUtil.getInstance().setWidth(100)),
                            child: Container(
                              height: ScreenUtil.getInstance().setHeight(150),
                              child: TextFormField(
                                controller: _confirmPasswordController, obscureText: true,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "Veuillez rentrer votre nouveau mot de passe.";
                                  else if (value.length > 100)
                                    return "Mot de passe trop long !";
                                  else if (value != _newPasswordController.text)
                                    return "Veuiller rentrer un mot de passe identique.";
                                  return null;
                                },
                                  focusNode: _focusNode3,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) async => await resetPassword()
                              ),
                            ),
                          ),
                        ],),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08),
                        child: RaisedButton(
                          key: Key("LoginButton"),
                          onPressed: () async => resetPassword(),
                          child: Text("Valider", style: _whiteText),
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          color: Color.fromARGB(255, 255, 115, 0),
                        ),
                      ),
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

  Future<void> resetPassword() async {
    if (_formKey.currentState.validate()) {
      _loadingIndicator.setLoading(true);
      if (await user.resetPasswordChange(context, _emailController.text, token, _confirmPasswordController.text))
        popMessage(context, "Succès", "Votre mot de passe a bien été réinitialisé");
      else
        popMessage(context, "Echec", "Une erreur est survenue, veuillez contactez MGW pour en savoir plus");
      _loadingIndicator.setLoading(false);
    }
    return;
  }

}