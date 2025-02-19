
import 'package:ttd/data/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

abstract class ITTDSettingsRepository {
  addSetting(String key, String value);
  Future<String?> getSetting(String key);
  editSetting(String key, String value);
  deleteSetting(String key);
}

class TTDSettingsRepository implements ITTDSettingsRepository {
  addSetting(String key, String value) async {
    if (await getSetting(key) == null) {
      Database db;

      try {
        db = await DatabaseHelper.instance.getDatabase();
        Map<String, String> insertMap = new Map<String, String>();
        insertMap['Key'] = key;
        insertMap['Value'] = value;

        await db.insert("tb_Setting", insertMap);
      } catch (ex) {
        rethrow;
      }
    } else {
      await editSetting(key, value);
    }
  }

  Future<String?> getSetting(String key) async {
    Database db;

    try {
      db = await DatabaseHelper.instance.getDatabase();

      var result = await db.query("tb_Setting", where: 'Key = ?', whereArgs: [key]);
      if (result.length > 0) {
        String? value = result[0]['Value'] as String?;
        return value;
      } else {
        return null;
      }
    } catch (ex) {
      rethrow;
    }
  }

  editSetting(String key, String value) async {
    Database db;

    try {
      db = await DatabaseHelper.instance.getDatabase();

      Map<String, String> updateMap = new Map<String, String>();
      updateMap['Value'] = value;

      var x = await db.update("tb_Setting", updateMap, where: 'key = ?', whereArgs: [key]);
    } catch (ex) {
      rethrow;
    }
  }

  deleteSetting(String key) async {
    Database db;

    try {
      db = await DatabaseHelper.instance.getDatabase();

      await db.delete("tb_Setting", where: 'key = ?', whereArgs: [key]);
    } catch (ex) {
      rethrow;
    }
  }
}
