import 'package:dailylog/data/diary.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final _databaseName = "diary.db";
  static final _databaseVersion = 1;
  static final diaryTable = "diary";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async{
    if(_database !=null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version:_databaseVersion, onCreate:_onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    //Diary 테이블 쿼리 수정
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $diaryTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      title String,
      memo String, 
      color INTEGER,
      category String,
      done INTEGER
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {

  }

  //CRUD
  Future<int> insertDiary(Diary diary) async {
    Database? db = await instance.database;
    if(diary.id==null){
      Map<String, dynamic> row = {
        "title" : diary.title,
        "date" : diary.date,
        "memo" : diary.memo,
        "color" : diary.color,
        "category" : diary.category,
        "done" : 0
      };
      return await db!.insert(diaryTable, row);
    }else{
      Map<String, dynamic> row = {
        "title" : diary.title,
        "date" : diary.date,
        "memo" : diary.memo,
        "color" : diary.color,
        "category" : diary.category,
        "done" : diary.done
      };
      return await db!.update(diaryTable, row, where: "id=?", whereArgs: [diary.id]);
    }
  }

  Future<List<Diary>> getAllDiary() async {
    Database? db = await instance.database;
    List<Diary> list = [];

    var queries = await db!.query(diaryTable,orderBy:"date DESC");
    for(var q in queries){
      list.add(Diary(id : q["id"] as int,
        title : q["title"] .toString(),
        color : q["color"] as int,
        memo : q["memo"] .toString(),
        category: q["category"] .toString(),
        date : q["date"] as int,
        done : q["done"] as int
      ));
    }
    return list;
  }

  Future<List<Diary>> getDiaryFromDate(int date) async {
    Database? db = await instance.database;
    List<Diary> list = [];

    var queries = await db!.query(diaryTable, where: "date=?", whereArgs: [date]);
    for(var q in queries){
      list.add(Diary(id : q["id"] as int,
          title : q["title"].toString(),
          color : q["color"] as int,
          memo : q["memo"].toString(),
          category: q["category"].toString(),
          date : q["date"] as int,
          done : q["done"] as int
      ));
    }
    return list;
  }

  Future<int?> updateDiary(Diary diary) async{
    Database? db = await instance.database;
    Future<int> result = db!.update(diaryTable, diary.getMap(), where:"id=?",whereArgs: [diary.id]);
    return result;
  }
}