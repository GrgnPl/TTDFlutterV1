import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;
  static const int VERSION = 1;

  static DatabaseHelper? _instance;
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._init();
    return _instance!;
  }

  DatabaseHelper._init();

  Future<Database> getDatabase() async {
    if (_db == null) {
      _db = await _initializeDb();
    }

    return _db!;
  }

  Future<Database> _initializeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, "ttd.db");
    return openDatabase(dbPath, version: VERSION, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE tb_Setting (Id INTEGER PRIMARY KEY AUTOINCREMENT, Key TEXT, Value TEXT)");
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}
}
