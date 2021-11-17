import 'package:dailylog/page/write_page.dart';
import 'package:flutter/material.dart';

import 'data/diary.dart';
import 'data/util.dart';

void main(){
  runApp(DailyLog());
}

class DailyLog extends StatelessWidget {
  const DailyLog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DailyLogMain(),
      theme : ThemeData.light()
    );
  }
}

class DailyLogMain extends StatefulWidget {
  const DailyLogMain({Key? key}) : super(key: key);
  @override
  _DailyLogMainState createState() => _DailyLogMainState();
}

class _DailyLogMainState extends State<DailyLogMain> {
  int _idx=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.black,
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(
                  builder:(ctx)=>DiaryWritePage(
                      diary: Diary(
                        date : Utils.getFormatTime(DateTime.now()),
                        title : "",
                        status :0,
                        image:"",
                        memo:"",
                      ))));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:const [
          BottomNavigationBarItem(
            icon:Icon(Icons.today),
            label: "오늘",
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.event_note),
            label:"기록"
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.bar_chart),
            label:"통계"
          )
        ],
        onTap: (idx){
          _idx=idx;
          setState(() {

          });
        },
        currentIndex: _idx,
      ),
      body:Container(
        child : getPage(),
      ),
    );
  }

  Widget getPage(){
    if(_idx==0){
      return getToday();
    }else if(_idx==1){
      return getHistory();
    }else{
      return getChart();
    }
  }

  Widget getHistory(){
    return Container(child:Text("history"));
  }

  Widget getToday(){
    return Container(child:Text("Today"));
  }

  Widget getChart(){
    return Container(child:Text("Chart"));
  }
}



