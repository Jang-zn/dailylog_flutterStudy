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

  int imgIndex = 0;
  List<String> images=[
    "assets/img/wallpaper1.png",
    "assets/img/wallpaper2.png",
    "assets/img/wallpaper3.png"
  ];
  List<String> statusImages=[
    "assets/img/weather1.png",
    "assets/img/weather2.png",
    "assets/img/weather3.png",
    "assets/img/weather4.png"
  ];

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
         if(idx==0){
            return InkWell(child:Container(
              child : Image.asset(widget.diary.image, fit: BoxFit.contain),
              width:100,
              height:100,
              ),
              onTap: (){
              widget.diary.image= images[imgIndex];
              imgIndex++;
              imgIndex = imgIndex%images.length;
              setState(() {

              });
              },
            );
         }else if(idx==1){
           return Container(
             child:Row(
               children:List.generate(statusImages.length, (index) {
                 return InkWell(child:
                  Container(
                    child:Image.asset(statusImages[index]),
                    decoration: BoxDecoration(
                      color: index==widget.diary.status?Colors.lime:Colors.white,
                    ),
                    height:50,
                    width:50,
                  ),
                   onTap: (){
                   setState(() {
                     widget.diary.status = index;
                   });
                   },
                 );
               }),
             )
           );
         }else if(idx==2){

         }else if(idx==3){

         }else if(idx==4){

         }else{

         }
         return Container();
       },
       itemCount:6,

      )
    );
  }
}
