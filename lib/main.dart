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

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Diary> selectedDiary = [];


  @override
  void initState() {
    super.initState();
    getTodayDiary();
    getSelectedDiary();
  }

  void getSelectedDiary() async {
      selectedDiary = await dbHelper.getDiaryFromDate(Utils.getFormatTime(_selectedDay));
      setState(() {

      });
  }


  void getTodayDiary() async {
    List<Diary> list = await dbHelper.getDiaryFromDate(Utils.getFormatTime(DateTime.now()));
    if(list.isNotEmpty) {
      setState(() {
        todayDiary = list.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child:const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.black,
        onPressed: () async {
          if(_idx==0) {
            await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (ctx) =>
                        DiaryWritePage(
                            diary: todayDiary
                        )));
          }else{
            await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (ctx) =>
                        DiaryWritePage(
                            diary: selectedDiary.isEmpty?Diary(
                              title:"",
                              content:"",
                              date:Utils.getFormatTime(_selectedDay),
                              status:0,
                              image:"assets/img/wallpaper1.png"
                            )
                                : selectedDiary.first
                        )));
          }
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






  Widget getHistory() {
    if(selectedDiary.isEmpty){
      Container();
    }
    return ListView.builder(
        itemCount: 2,
        itemBuilder: (ctx, idx) {
          if(idx==0){
            return Container(
              child: TableCalendar(
                firstDay: DateTime.utc(2021,1,1),
                lastDay:DateTime.utc(2030,12,31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  getSelectedDiary();
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; // update `_focusedDay` here as well
                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
              ),
            );
          }else{
            if(selectedDiary.isEmpty){
              return Container();
            }
            return Column(
                children:[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Container(
                          child : Text(""
                              "${Utils.numToDateTime(selectedDiary.first.date).year}."
                              "${Utils.numToDateTime(selectedDiary.first.date).month}."
                              "${Utils.numToDateTime(selectedDiary.first.date).day}",
                              style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          padding:const EdgeInsets.all(6),
                          margin:EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        Container(
                          child:Image.asset(statusImages[selectedDiary.first.status], fit:BoxFit.contain, width: 60, height:60),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          margin:const EdgeInsets.all(10),
                        ),
                      ]
                  ),
                  Container(
                      child:Column(
                        children:[
                          Text(selectedDiary.first.title, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          Container(height: 20,),
                          Text(selectedDiary.first.content)
                        ],
                        crossAxisAlignment :CrossAxisAlignment.start,
                      ),
                      padding:const EdgeInsets.all(10),
                      margin:EdgeInsets.all(10),
                      height:350,
                      decoration:BoxDecoration(
                        color:Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      )
                  )
                ]
            );
          }


        }
    );
  }

  Widget getToday(){
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
                            child : Text("${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}", style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            padding:const EdgeInsets.all(6),
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
                          Text(todayDiary.title==""?"일기를 작성하세요":todayDiary.title, style:TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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

  Widget getChart(){
    return Container(child:Text("Chart"));
  }
}



