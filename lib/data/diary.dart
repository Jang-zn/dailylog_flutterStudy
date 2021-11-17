
class Diary{
  String title;
  String memo;
  String image;
  int date;
  int status;

  Diary(
      {
        required this.title, required this.memo, required this.date, required this.status, required this.image
      }
      );

  Map<String, dynamic> getMap(){
    Map<String, dynamic> map={
      "title":title,
      "memo":memo,
      "image":image,
      "status":status,
      "date":date
    };
    return map;
  }

}