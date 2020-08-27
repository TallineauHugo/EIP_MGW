// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_garden_watcher/main.dart';
import '../lib/Classes/Post.dart';
import '../lib/Pages/LoginPage.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  testWidgets('Login page UI test', (WidgetTester tester) async {
    Widget loginWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: new LoginPage())
    );
    await tester.pumpWidget(loginWidget);

    expect(find.text('MyGardenWatcher'), findsOneWidget);
    expect(find.text('Email :'), findsOneWidget);
    expect(find.text('Mot de passe :'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text("Vous n'avez pas de compte ?"), findsOneWidget);
    expect(find.text("Créez en un !"), findsOneWidget);
    expect(find.text("À propos de nous"), findsOneWidget);
    expect(find.byKey(new Key("EmailFormField")), findsOneWidget);
    expect(find.byKey(new Key("PasswordFormField")), findsOneWidget);
    expect(find.byKey(new Key("LoginButton")), findsOneWidget);
  });


  testWidgets('Login test', (WidgetTester tester) async {
    LoginPage loginPage = new LoginPage();
    Widget app = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: loginPage)
    );
    await tester.pumpWidget(app);

    Form formWidget = tester.widget<Form>(find.byType(Form));
    Finder emailForm = find.byKey(new Key("EmailFormField"));
    Finder passwordForm = find.byKey(new Key("PasswordFormField"));

    GlobalKey<FormState> formKey = formWidget.key;
    expect(formKey.currentState.validate(), isFalse);

    await tester.enterText(emailForm, "nathan.tual@epitech.eu");
    expect(find.text("nathan.tual@epitech.eu"), findsOneWidget);
    await tester.enterText(passwordForm, "test");
    expect(find.text("test"), findsOneWidget);

    expect(formKey.currentState.validate(), isTrue);

    final PostProvider postProvider = new PostProvider();
    final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsIm1haWwiOiJuYXRoYW4udHVhbEBlcGl0ZWNoLmV1IiwiaWF0IjoxNTczMTk1MDcyLCJleHAiOjE1NzMxOTg2NzJ9.0s1Jl599lc_zstFmKwb8n55rRClvK9uy_B2nt6R88yo";
    postProvider.client = MockClient((request) async {
      final mapJson = {'token':token};
      return Response(json.encode(mapJson), 200);
    });
    final item = await postProvider.createPost("/auth/login", body: {
      "mail": tester.widget<TextFormField>(emailForm).controller.value.text,
      "password": tester.widget<TextFormField>(passwordForm).controller.value.text
    });
    expect(item.map["token"], token);
  });
}
