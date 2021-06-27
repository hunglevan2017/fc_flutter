import 'dart:typed_data';

import 'package:fc_collection/entity/DataSqliteEntity.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class LocalRepository{


  Future<Database> createTableLocalData() async{
    var dbPath = await getDatabasesPath();
    String path = p.join(dbPath,DB_NAME);
    String sqlTableData = 'CREATE TABLE IF NOT EXISTS $TABLE_DATA ($TABLE_DATA_ID INTEGER PRIMARY KEY AUTOINCREMENT,$TABLE_DATA_KEY TEXT, $TABLE_DATA_DATA TEXT, $TABLE_DATA_USERNAME TEXT )';

    final database = openDatabase(
        path,
      onCreate: (db,version){
        return db.execute(
            sqlTableData
        );
      },
      version: 1
    );

    return database;
  }

  Future<int> insertTableData(DataSqliteEntity dataSqliteEntity) async{
    final database = await createTableLocalData();

    List<DataSqliteEntity> list = await selectTableData(dataSqliteEntity.key,dataSqliteEntity.username);

    if(list.length > 0){
      return updateTableData(dataSqliteEntity);
    }else{
      return await database.insert(
          TABLE_DATA,
          dataSqliteEntity.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    }

  }

  Future<List<DataSqliteEntity>> selectTableData(String key,String username) async{
    final database = await createTableLocalData();

    String sql = 'SELECT * FROM $TABLE_DATA WHERE $TABLE_DATA_KEY="$key" and $TABLE_DATA_USERNAME="$username"';
    final List<Map<String,dynamic>> maps = await database.rawQuery(sql);

    return List.generate(maps.length, (index){
      return DataSqliteEntity(
        key: maps[index][TABLE_DATA_KEY],
        data: maps[index][TABLE_DATA_DATA],
        username: maps[index][TABLE_DATA_USERNAME],
      );
    });
  }

  Future<int> updateTableData(DataSqliteEntity dataSqliteEntity)async{
    final database = await createTableLocalData();
    String sql = 'UPDATE $TABLE_DATA SET $TABLE_DATA_DATA = ? WHERE  $TABLE_DATA_KEY= ? and $TABLE_DATA_USERNAME="${dataSqliteEntity.username}"';

    return database.rawUpdate(sql,[dataSqliteEntity.data,dataSqliteEntity.key]);
  }

}