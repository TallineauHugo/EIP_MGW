import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileInList extends StatefulWidget {
  String fileName;
  Function onTap;

  FileInList({@required this.fileName, @required this.onTap});

  @override
  _FileInList createState() => new _FileInList(fileName: fileName, onTap: onTap);
}

class _FileInList extends State<FileInList> {
  String fileName;
  Function onTap;

  _FileInList({@required this.fileName, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil.getInstance().setHeight(5)),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 225, 225, 225),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil.getInstance().setWidth(30)),
          child: Row(children: <Widget>[
            Text(fileName),
            GestureDetector(
              onTap: () => onTap(),
              child: Padding(
                padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(15)),
                child: Icon(Icons.cancel, color: Colors.red),
              ),
            )
          ],),
        ),
      ),
    );
  }

}