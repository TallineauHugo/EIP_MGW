import 'package:flutter/material.dart';

Future<bool> popMessage(BuildContext context, String title, String message) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text(title),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text('Ok'),
        )
      ],
    ),
  ) ?? false;
}

Future<bool> popWidgetList(BuildContext context, String title, String message, List<Widget> widgets) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: widgets
    ),
  ) ?? false;
}