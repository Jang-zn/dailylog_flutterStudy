
class Diary{
  String title;
  String content;
  String image;
  int date;
  int status;

  Diary(
      {
        required this.title, required this.content, required this.date, required this.status, required this.image
      }
      );

  Map<String, dynamic> getMap(){
    Map<String, dynamic> map={
      "title":title,
      "memo":content,
      "image":image,
      "status":status,
      "date":date
    };
    return map;
  }

}