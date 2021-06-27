import 'dart:convert';
import 'dart:typed_data';
import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/DashboardEntity.dart';
import 'package:fc_collection/entity/DataSqliteEntity.dart';
import 'package:fc_collection/entity/DetailContractEntity.dart';
import 'package:fc_collection/entity/HistoryPhoneEntity.dart';
import 'package:fc_collection/entity/ResponseStatus.dart';
import 'package:fc_collection/repository/LocalRepository.dart';
import 'package:fc_collection/repository/StorageManager.dart';
import 'package:http/http.dart' as http;
import 'package:fc_collection/entity/CustomerInfo.dart';
import 'package:fc_collection/api/ApiManager.dart';
import 'package:fc_collection/util/Constant.dart';

class CustomerInfoRepository{
  final storageManager = StorageManager();
  final localRepository = LocalRepository();

  Future<List<CustomerInfo>> fetchCustomersInfo(int groupDashboardId) async{
    var client = http.Client();
    List<CustomerInfo> listCustomerInfo = [];
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);

    var url = Uri.parse("$urlGetListCustomer?groupDashboardId=$groupDashboardId&fcCode=$username");

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

        DataSqliteEntity dataSqliteEntity = new DataSqliteEntity(username: username,key: DATA_TABLE_LISTDASHBOARD,data: stringBody);
        await localRepository.insertTableData(dataSqliteEntity);

        List jsonData = json.decode(utf8.decode(body));

        jsonData.forEach((element) {
          if(element['group_dashboard_id'] == "$groupDashboardId"){
            listCustomerInfo.add(CustomerInfo.fromJson(element));
          }
        });
      }

    }finally{
      client.close();
    }

    return listCustomerInfo;
  }

  Future<List<CustomerInfo>> fetchCustomersInfoOffline(int groupDashboardId) async{
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);

    List<CustomerInfo> listCustomerInfo = [];
    List<DataSqliteEntity> listSqliteData = await localRepository.selectTableData(DATA_TABLE_LISTDASHBOARD, username);

    listSqliteData.forEach((element) {
      List jsonData = json.decode(element.data);
      jsonData.forEach((element) {
        if(element['group_dashboard_id'] == "$groupDashboardId"){
          listCustomerInfo.add(CustomerInfo.fromJson(element));
        }
      });
    });

    return listCustomerInfo;
  }

  Future<DetailContractEntity> getDetailCustomersInfoById(int id) async{
    var client = http.Client();
    DetailContractEntity detailContractEntity;
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);

    var url = Uri.parse("$urlGetDetailCustomerByID?id=$id");

    try{
      var response = await client.get(
          url,
          headers: {
            'Authorization':'Bearer $token'
          }
      );

      if(response.statusCode == 200){
        var jsonData = json.decode(utf8.decode(response.bodyBytes));
        detailContractEntity = DetailContractEntity.fromJSON(jsonData);
      }

    }finally{
      client.close();
    }

    return detailContractEntity;
  }

  Future<List<HistoryPhoneEnity>> getHistoryPhoneByCustomerId(int id) async{
    var client = http.Client();
    List<HistoryPhoneEnity> listData = [];

    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var url = Uri.parse("$urlGetHistoryPhoneByCustomerId?id=${id.toInt()}");

    try{
      var response = await client.get(
          url,
          headers: {
            'Authorization':'Bearer $token'
          }
      );

      if(response.statusCode == 200){
        List jsonData = json.decode(utf8.decode(response.bodyBytes));
        if(jsonData != null){
          listData = jsonData.map((e) => HistoryPhoneEnity.fromJSON(e)).toList();
        }
      }

    }finally{
      client.close();
    }

    return listData;
  }

  Future<List<DashboardEntity>> getDashboard() async{
    var client = http.Client();
    List<DashboardEntity> listData = [];

    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);

    var url = Uri.parse("$urlGetDashboard?fcCode=$username");

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

        DataSqliteEntity dataSqliteEntity = new DataSqliteEntity(username: username,key: DATA_TABLE_DASHBOARD,data: stringBody);
        await localRepository.insertTableData(dataSqliteEntity);

        List jsonData = json.decode(stringBody);
        if(jsonData != null){
          listData = jsonData.map((e) => DashboardEntity.fromJSON(e)).toList();
        }
      }

    }finally{
      client.close();
    }

    return listData;
  }

  Future<List<DashboardEntity>> getDashboardOffline() async{
    List<DashboardEntity> listData = [];
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    var list = await localRepository.selectTableData(DATA_TABLE_DASHBOARD, username);
    list.map((element){
      List jsonData = json.decode(element.data);
      listData = jsonData.map((e) => DashboardEntity.fromJSON(e)).toList();
    }).toList();

    return listData;
  }

  Future<ResponseStatus> getCountNumberUpload() async{
    var client = http.Client();
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);

    var url = Uri.parse("$urlGetNumberUpload?fcCode=$username");
    ResponseStatus responseStatus;
    try{
      var response = await client.get(
          url,
          headers: {
            'Authorization':'Bearer $token'
          }
      );

      if(response.statusCode == 200){
        var jsonData = json.decode(utf8.decode(response.bodyBytes));
        responseStatus =  ResponseStatus.fromJson(jsonData);
      }

    }finally{
      client.close();
    }

    return responseStatus;
  }

  Future<ResponseStatus> uploadReportImpact(String pathZip, CustomerInfoStatus customerInfoStatus) async{
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);

    customerInfoStatus.insert_by = username;

    var url = Uri.parse("$urlUploadReportImpact");

    var request = http.MultipartRequest("POST",url);

    String jsonData = jsonEncode(customerInfoStatus);
    request.fields["data"] = jsonData;

    var fileParam = await http.MultipartFile.fromPath("file", pathZip);
    request.files.add(fileParam);
    Map<String,String> headers = Map<String,String>();
    headers.addAll({ 'Authorization':'Bearer $token' });
    request.headers.addAll(headers);

    var resposne = await request.send();
    var responseData = await resposne.stream.toBytes();
    var stringResponse = new String.fromCharCodes(responseData);

    var jsonData1 = json.decode(stringResponse);
    ResponseStatus  responseStatus =  ResponseStatus.fromJson(jsonData1);


    return responseStatus;
  }

  Future<List<CustomerInfo>> fetchSearchCustomer(String status, String startDate, String endDate) async{
    var client = http.Client();
    List<CustomerInfo> listCustomerInfo = [];
    var token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    var username = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    var url = Uri.parse(urlSearchAdvanced);
    print("kiemtra $urlSearchAdvanced");
    try{
      var response = await client.post(
          url,
          headers: {
            'Authorization':'Bearer $token',
            'Content-Type':'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              {
                'fcCode':username,
                'status':status,
                'startDate':startDate,
                'endDate':endDate
              }
          )
      );

      if(response.statusCode == 200){
        var body = response.bodyBytes;
        var stringBody = utf8.decode(body);

        List jsonData = json.decode(stringBody);

        jsonData.forEach((element) {
          listCustomerInfo.add(CustomerInfo.fromJson(element));
        });
      }

    }finally{
      client.close();
    }

    return listCustomerInfo;
  }

}