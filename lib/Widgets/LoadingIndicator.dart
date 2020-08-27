import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingIndicator extends StatefulWidget {
  final _LoadingIndicator _loadingIndicator = _LoadingIndicator();

  void setLoading(bool state) {
    _loadingIndicator.setLoading(state);
  }

  @override
  _LoadingIndicator createState() => _loadingIndicator;
}

class _LoadingIndicator extends State<LoadingIndicator> {
  bool _loading = false;

  void setLoading(bool state) {
    setState(() {_loading = state;});
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _loading ?
    AbsorbPointer(child: Container(
      color: Color.fromARGB(150, 0, 0, 0),
      width: ScreenUtil.getInstance().setWidth(1080),
      height: ScreenUtil.getInstance().setHeight(1920),
      child: Padding(padding: const EdgeInsets.all(5.0), child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 144, 0)), //orange
          )
      )),
    )) : new Container();

    return loadingIndicator;
  }
}