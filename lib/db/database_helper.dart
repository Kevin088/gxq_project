import 'package:gxq_project/bean/point_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  final String tableName = "pointInfo";
  final String columnId = "id";
  final String columnCreateTime = "createTime";
  final String columnTempType = "tempType";
  final String columnUserId = "userId";
  final String columnIsUpload = "isUpload";
  final String columnBlueToothId = "blueToothId";
  final String columnBlueToothName = "blueToothName";
  final String columnDeviceId = "deviceId";
  final String columnTempValueMax = "tempValueMax";
  final String columnTempValueMin = "tempValueMin";
  final String columnTempValueAverage = "tempValueAverage";
  final String columnDetailInfo = "detailInfo";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqflite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName($columnId text not null primary key,"
            "$columnCreateTime text not null ,"
            "$columnTempType text not null ,"
            "$columnUserId text not null ,"
            "$columnIsUpload text not null ,"
            "$columnBlueToothId text not null ,"
            "$columnBlueToothName text not null ,"
            "$columnDeviceId text not null ,"
            "$columnTempValueMax text not null ,"
            "$columnTempValueMin text not null ,"
            "$columnTempValueAverage text not null ,"
            "$columnDetailInfo text not null )");

    print("Table is created");
  }

//插入
  Future<int> saveItem(PointInfo pointInfo) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", pointInfo.toMap());
    print(res.toString());
    return res;
  }

  //查询
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ");
    return result.toList();
  }

  //查询总数
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }

//按照id查询
  Future<PointInfo> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return PointInfo.fromMap(result.first);
  }


  //清空数据
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }


  //根据id删除
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "$columnId = ?", whereArgs: [id]);
  }

  //修改
  Future<int> updateItem(PointInfo user) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", user.toMap(),
        where: "$columnId = ?", whereArgs: [user.id]);
  }

  //关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}