
class Diary{
  int? id;
  String title;
  String memo;
  String category;
  int color;
  int done;
  int date; // 날짜비교를 위해서 int 사용..??

  Diary(
      {
        this.id, required this.title, required this.memo, required this.category, required this.color, required this.done, required this.date
      }
      );

  Map<String, dynamic> getMap(){
    Map<String, dynamic> map={
      "id":id,
      "title":title,
      "memo":memo,
      "category":category,
      "color":color,
      "done":done,
      "date":date
    };
    return map;
  }

}