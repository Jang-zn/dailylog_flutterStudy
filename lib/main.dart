import 'dart:ui';
import 'package:table_calendar/table_calendar.dart';
import 'package:dailylog/data/database.dart';
import 'package:dailylog/data/diary.dart';
import 'package:dailylog/data/util.dart';
import 'package:dailylog/page/write_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const DailyLog());
}

class DailyLog extends StatelessWidget {
  const DailyLog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DailyLogMain(),
      theme : ThemeData(
      primarySwatch: Colors.blueGrey,
      primaryColor: const Color(0xFF607d8b),
      secondaryHeaderColor: const Color(0xFF607d8b),
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
  Diary todayDiary = Diary(
   image:"assets/img/wallpaper1.png",
   status:0,
   content:"",
   title:"",
   date:Utils.getFormatTime(DateTime.now()),
  );
  List<String> statusImages = [
    "assets/img/weather1.png",
    "assets/img/weather2.png",
    "assets/img/weather3.png",
    "assets/img/weather4.png"
  ];

  @override
  void initState() {
    super.initState();
    getTodayDiary();
  }

  void getTodayDiary() async {
    List<Diary> list = await dbHelper.getDiaryFromDate(Utils.getFormatTime(DateTime.now()));
    if(list.isNotEmpty){
      todayDiary=list.first;
      getPage();
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.black,
        onPressed: () async {
            await Navigator.of(context).push(
                MaterialPageRoute(
                    builder:(ctx)=>DiaryWritePage(
                        diary: todayDiary
                    )));
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
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (ctx, idx) {
          if(idx==0){
            return Container(
              child: TableCalendar(
                firstDay: DateTime.utc(2021,1,1),
                lastDay:DateTime.utc(2030,12,31),
                focusedDay: DateTime.now(),
              ),
            );
          }else{
            return Container();
          }
          return Container();

        }
    );
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
                child: Opacity(child:Image.asset(todayDiary.image, fit:BoxFit.cover,),opacity: 0.7,),
              ),
              Positioned.fill(
                child:ListView(
                  children:[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Container(
                            child : Text("${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            padding:EdgeInsets.all(6),
                            margin:EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:Colors.white.withOpacity(0.5),
                            ),
                        ),
                        Container(
                            child:Image.asset(statusImages[todayDiary.status], fit:BoxFit.contain, width: 60, height:60),
                              decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            margin:EdgeInsets.all(10),
                        ),
                      ]
                    ),
                    Container(
                        child:Column(
                          children:[
                          Text(todayDiary.title, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            Container(height: 20,),
                            Text(todayDiary.content)
                          ],
                          crossAxisAlignment :CrossAxisAlignment.start,
                        ),
                      padding:EdgeInsets.all(10),
                      margin:EdgeInsets.all(10),
                      height:350,
                      decoration:BoxDecoration(
                        color:Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                      )
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



