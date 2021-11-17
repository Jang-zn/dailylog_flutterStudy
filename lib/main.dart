import 'package:flutter/material.dart';

void main(){
  runApp(DailyLog());
}

class DailyLog extends StatelessWidget {
  const DailyLog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DailyLogMain(
                title : "DailyLog",
        ),
      theme : ThemeData.light()
    );
  }
}

class DailyLogMain extends StatefulWidget {
  const DailyLogMain({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _DailyLogMainState createState() => _DailyLogMainState();
}

class _DailyLogMainState extends State<DailyLogMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child : Text("start")
    );
  }
}



