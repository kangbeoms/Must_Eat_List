
import 'package:must_eat_place_sqlite_app/model/save_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {

  Future<Database> initalizeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'musteat.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE musteatplace '
          '(seq integer primary key autoincrement,'
          'name text(30),'
          'phone text(30),'
          'lat numeric(20),'
          'lng numeric(20),'
          'image blob,'
          'estimate text,'
          'initdate date)'
        );
      },
      version: 1,
    );
  }

  Future<List<SaveData>> queryReview() async {
    final Database db = await initalizeDB();
    final List<Map<String, Object?>> result = await db.rawQuery('SELECT * FROM musteatplace');

    return result.map((e) => SaveData.fromMap(e)).toList();
  }

  Future<int> insertReview(SaveData saveData) async {
    final Database db = await initalizeDB();
    int result;
    result = await db.rawInsert(
      'INSERT INTO musteatplace '
      '(name,phone,lat,lng,image,estimate,initdate) '
      'VALUES (?,?,?,?,?,?,?)',
      [saveData.name, saveData.phone, saveData.lat, saveData.lng, saveData.image, saveData.estimate, saveData.initdate]
    );
    return result;
  }

  Future<int> updateReview(SaveData saveData) async {
    final Database db = await initalizeDB();
    int result;
    result = await db.rawInsert(
      'UPDATE musteatplace SET '
      'name=?, phone=?, lat=?, lng=?, image=?, estimate=? '
      'WHERE seq=?',
      [saveData.name, saveData.phone, saveData.lat, saveData.lng, saveData.image, saveData.estimate, saveData.seq]
    );
    return result;
  }

  Future<void> deleteReview(int? seq) async {
    final Database db = await initalizeDB();
    await db.rawDelete(
      'DELETE FROM musteatplace '
      'WHERE seq = ?',
      [seq]
    );
  }

}