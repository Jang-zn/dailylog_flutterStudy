import 'dart:ui';

import 'package:dailylog/data/diary.dart';
import 'package:flutter/material.dart';

class DiaryWritePage extends StatefulWidget {
  const DiaryWritePage({Key? key, required this.diary}) : super(key: key);
  final Diary diary;

  @override
  _DiaryWritePageState createState() => _DiaryWritePageState();
}

class _DiaryWritePageState extends State<DiaryWritePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        actions: [
          TextButton(
              child:Text("저장", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:Colors.white)),
            onPressed: (){

            },
          )
        ],
      ),
      body:ListView.builder(
       itemBuilder: (ctx, idx){
         return Container();
       },
       itemCount:4,

      )
    );
  }
}
