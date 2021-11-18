import 'dart:ui';

import 'package:dailylog/data/database.dart';
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
  List<String> images = [
    "assets/img/wallpaper1.png",
    "assets/img/wallpaper2.png",
    "assets/img/wallpaper3.png"
  ];
  List<String> statusImages = [
    "assets/img/weather1.png",
    "assets/img/weather2.png",
    "assets/img/weather3.png",
    "assets/img/weather4.png"
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;


  @override
  void initState() {
    super.initState();
    titleController.text = widget.diary.title;
    contentController.text = widget.diary.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              child: const Text("저장",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white)),
              onPressed: () async {
                await dbHelper.insertDiary(widget.diary);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: ListView.builder(
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return InkWell(
                child: Container(
                  child: Image.asset(
                      widget.diary.image == ""
                          ? images[imgIndex]
                          : widget.diary.image,
                      fit: BoxFit.cover),
                  width: 80,
                  height: 200,
                ),
                onTap: () {
                  imgIndex++;
                  imgIndex = imgIndex % images.length;
                  widget.diary.image = images[imgIndex];
                  setState(() {});
                },
              );
            } else if (idx == 1) {
              return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(statusImages.length, (index) {
                      return InkWell(
                        child: Container(
                          child: Image.asset(statusImages[index]),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: index == widget.diary.status
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          height: 50,
                          width: 50,
                        ),
                        onTap: () {
                          setState(() {
                            widget.diary.status = index;
                          });
                        },
                      );
                    }),
                  ));
            } else if (idx == 2) {
              return Container(
                child: const Text("제목",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                margin:
                    const EdgeInsets.only(top: 15, bottom: 5, right: 25, left: 25),
              );
            } else if (idx == 3) {
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ))));
            } else if (idx == 4) {
              return Container(
                child: const Text("내용",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                margin:
                    const EdgeInsets.only(top: 25, bottom: 5, right: 25, left: 25),
              );
            } else {
              return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: contentController,
                    maxLines: 15,
                    minLines: 15,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    )),
                  ));
            }
          },
          itemCount: 6,
        ));
  }
}
