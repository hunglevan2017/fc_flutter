import 'dart:convert';

import 'package:fc_collection/api/ApiManager.dart';
import 'package:fc_collection/entity/DataSqliteEntity.dart';
import 'package:fc_collection/repository/LocalRepository.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:fc_collection/entity/DocumentMaster.dart';
import 'package:fc_collection/repository/StorageManager.dart';

class DocumentMasterRepository{
  final storageManager = StorageManager();
  final localRepository = LocalRepository();

  Future<List<DocumentMaster>> fetchDocumentMaster() async{
    var client = http.Client();
    List<DocumentMaster> listDocumentMaster = [];
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);

    var url = Uri.parse("$urlGetDocumentMaster");

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

        DataSqliteEntity dataSqliteEntity = new DataSqliteEntity(username: username,key: DATA_LIST_DOCUMENT,data: stringBody);
        await localRepository.insertTableData(dataSqliteEntity);

        List jsonData = json.decode(stringBody);
        listDocumentMaster = jsonData.map((e) => DocumentMaster.fromJSON(e)).toList();

      }

    }finally{
      client.close();
    }

    return listDocumentMaster;
  }

  Future<List<DocumentMaster>> fetchDocumentMasterOffline() async{
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    List<DocumentMaster> listDocumentMaster = [];
    List<DataSqliteEntity> listSqliteData = await localRepository.selectTableData(DATA_LIST_DOCUMENT, username);

    listSqliteData.forEach((element) {
      List jsonData = json.decode(element.data);
      jsonData.forEach((element) {
        listDocumentMaster.add(DocumentMaster.fromJSON(element));
      });
    });

    return listDocumentMaster;
  }
}