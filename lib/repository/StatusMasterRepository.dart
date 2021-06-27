
import 'dart:convert';

import 'package:fc_collection/api/ApiManager.dart';
import 'package:fc_collection/entity/DataSqliteEntity.dart';
import 'package:fc_collection/entity/DelinquencyMaster.dart';
import 'package:fc_collection/entity/StatusMaster.dart';
import 'package:fc_collection/repository/LocalRepository.dart';
import 'package:fc_collection/repository/StorageManager.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:http/http.dart' as http;

class StatusMasterRepostitory{
  final storageManager = StorageManager();
  final localRepository = LocalRepository();

  Future<List<StatusMaster>> fetchActionCode() async{
    var client = http.Client();
    List<StatusMaster> listStatusMaster = [];
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);

    var url = Uri.parse("$urlGetActionCode");

    try{
      var response = await client.get(
          url,
          headers: {
            'Authorization':'Bearer $token'
          }
      );

      if(response.statusCode == 200){
        var body = response.bodyBytes;
        var stringBody = utf8.decode(body);

        DataSqliteEntity dataSqliteEntity = new DataSqliteEntity(username: username,key: DATA_ACTION_CODE,data: stringBody);
        await localRepository.insertTableData(dataSqliteEntity);

        List jsonData = json.decode(stringBody);
        listStatusMaster = jsonData.map((e) => StatusMaster.fromJSON(e)).toList();
      }

    }finally{
      client.close();
    }

    return listStatusMaster;
  }

  Future<List<StatusMaster>> fetchActionCodeOffline() async{
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    List<StatusMaster> listStatusMaster = [];
    List<DataSqliteEntity> listSqliteData = await localRepository.selectTableData(DATA_ACTION_CODE, username);

    listSqliteData.forEach((element) {
      List jsonData = json.decode(element.data);
      jsonData.forEach((element) {
        listStatusMaster.add(StatusMaster.fromJSON(element));
      });
    });

    return listStatusMaster;
  }

  Future<List<StatusMaster>> fetchResultCode() async{
    var client = http.Client();
    List<StatusMaster> listStatusMaster = [];
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    var url = Uri.parse("$urlGetResultCode");

    try{
      var response = await client.get(
          url,
          headers: {
            'Authorization':'Bearer $token'
          }
      );

      if(response.statusCode == 200){
        var body = response.bodyBytes;
        var stringBody = utf8.decode(body);

        DataSqliteEntity dataSqliteEntity = new DataSqliteEntity(username: username,key: DATA_RESULT_CODE,data: stringBody);
        await localRepository.insertTableData(dataSqliteEntity);

        List jsonData = json.decode(stringBody);
        listStatusMaster = jsonData.map((e) => StatusMaster.fromJSON(e)).toList();
      }

    }finally{
      client.close();
    }

    return listStatusMaster;
  }

  Future<List<StatusMaster>> fetchResultCodeOffline() async{
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    List<StatusMaster> listStatusMaster = [];
    List<DataSqliteEntity> listSqliteData = await localRepository.selectTableData(DATA_RESULT_CODE, username);

    listSqliteData.forEach((element) {
      List jsonData = json.decode(element.data);
      jsonData.forEach((element) {
        listStatusMaster.add(StatusMaster.fromJSON(element));
      });
    });

    return listStatusMaster;
  }

  Future<List<DelinquencyMaster>> fetchDelinquency() async{
    var client = http.Client();
    List<DelinquencyMaster> listDelinquencyMaster = [];
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    var url = Uri.parse("$urlGetDelinquency");

    try{
      var response = await client.get(
          url,
          headers: {
            'Authorization':'Bearer $token'
          }
      );

      if(response.statusCode == 200){
        var body = response.bodyBytes;
        var stringBody = utf8.decode(body);

        DataSqliteEntity dataSqliteEntity = new DataSqliteEntity(username: username,key: DATA_REASON_DELINQUINCY,data: stringBody);
        await localRepository.insertTableData(dataSqliteEntity);

        List jsonData = json.decode(stringBody);
        listDelinquencyMaster = jsonData.map((e) => DelinquencyMaster.fromJSON(e)).toList();
      }

    }finally{
      client.close();
    }

    return listDelinquencyMaster;
  }

  Future<List<DelinquencyMaster>> fetchDelinquencyOffline() async{
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    List<DelinquencyMaster> listDelinquencyMaster = [];
    List<DataSqliteEntity> listSqliteData = await localRepository.selectTableData(DATA_REASON_DELINQUINCY, username);

    listSqliteData.forEach((element) {
      List jsonData = json.decode(element.data);
      jsonData.forEach((element) {
        listDelinquencyMaster.add(DelinquencyMaster.fromJSON(element));
      });
    });

    return listDelinquencyMaster;
  }

}