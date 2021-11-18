import 'package:dailylog/data/database.dart';
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
      theme : ThemeData(
      primarySwatch: Colors.blueGrey,
      primaryColor: const Color(0xFF607d8b),
      accentColor: const Color(0xFF607d8b),
      canvasColor: const Color(0xFFfafafa),
      )
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
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  late final Diary todayDiary;
  List<String> statusImages = [
    "assets/img/weather1.png",
    "assets/img/weather2.png",
    "assets/img/weather3.png",
    "assets/img/weather4.png"
  ];


  @override
  void initState() {
    getTodayDiary();
  }

  void getTodayDiary() async {
    List<Diary> list = await dbHelper.getDiaryFromDate(Utils.getFormatTime(DateTime.now()));
    if(list.isNotEmpty){
      todayDiary=list.first;
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
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
                        content:"",
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
    if(todayDiary==null) {
      return Container(
          child: Text("일기 작성하기")
      );
    }else{
      return Container(
        child:Stack(
            children:[
              Positioned.fill(
                child: Image.asset(todayDiary.image, fit:BoxFit.cover)
              ),
              Positioned.fill(
                child:ListView(
                  children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Text("${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Image.asset(statusImages[todayDiary.status], fit:BoxFit.contain),
                      ]
                    )
                  ]
                )
              )
            ]
        )
      );
    }
  }

  Widget getChart(){
    return Container(child:Text("Chart"));
  }
}



