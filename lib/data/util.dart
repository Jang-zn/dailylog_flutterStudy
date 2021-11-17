
class Utils{
  static int getFormatTime(DateTime date){
    //int.parse : "2021"->2021 로 바꾸는것
    return int.parse("${date.year}${makeToDigit(date.month)}${makeToDigit(date.day)}");
  }

  static DateTime numToDateTime(int num){
    String d = num.toString();
    int year = int.parse(d.substring(0,4));
    int mon = int.parse(d.substring(4,6));
    int day = int.parse(d.substring(6,8));
    return DateTime(year,mon,day);
  }

  static String makeToDigit(int num){
    //padleft
    //2->"02"
    //11->"11" 로 바꾸는것
    return num.toString().padLeft(2,"0");
  }
}