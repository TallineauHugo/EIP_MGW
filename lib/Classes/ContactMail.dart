import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:file_picker/file_picker.dart';

import 'User.dart';

class ContactMail {
  final String mail;
  final String firstName;
  final String lastName;
  final String object;
  final String body;
  final List<File> attachmentsList;

  ContactMail({@required this.mail, @required this.firstName,
    @required this.lastName, @required this.object, @required this.body,
    @required this.attachmentsList});

  Future<bool> sendToApi(BuildContext context) async {
    if (user.isConnected())
      return await user.contactFormLoggedUser(
          context,
          firstName,
          lastName,
          "",
          "",
          "",
          mail,
          "",
          object,
          body,
          "des fichiers en masse tavu"
      );
    else
      return await user.contactFormNonLoggedUser(
        context,
        firstName,
        lastName,
        "",
        "",
        "",
        mail,
        "",
        object,
        body,
        "des fichiers en masse tavu"
      );
  }
}

/*class StorageManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getLocalFile(String filename) async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> getLocalFileAsString(String filename) async {
    final File file = await getLocalFile(filename);

    return await file.readAsString();
  }
}*/