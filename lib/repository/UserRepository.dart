import 'dart:convert';

import 'package:fc_collection/entity/ResponseStatus.dart';
import 'package:http/http.dart' as http;
import 'package:fc_collection/entity/AuthenEntity.dart';
import 'package:fc_collection/api/ApiManager.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:fc_collection/repository/StorageManager.dart';

class UserRepository{
  final storageManager = StorageManager();

  Future<AuthenEntity> login(String username,String password) async{
    var client = http.Client();
    var url = Uri.parse(urlAuthen);
    AuthenEntity authenEntity;

    String securityKey = await storageManager.getDataStorageSharedPreference(SECURITY_KEY);

    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type':'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              {
                'username':username,
                'password':password,
                'security_key':securityKey
              }
          )
      );



      if(response.statusCode == 200){
        authenEntity = AuthenEntity.fromJSON(json.decode(utf8.decode(response.bodyBytes)));
        storageManager.storageDataToSharedPreference(USER_NAME_KEY,username);
        storageManager.storageDataToSharedPreference(PASSWORD_KEY,password);
        storageManager.storageDataToSharedPreference(TOKEN_KEY,authenEntity.accessToken);
        storageManager.storageDataToSharedPreference(FULLNAME_KEY, authenEntity.message);
      }

    }finally{
      client.close();
    }

    return authenEntity;
  }

  Future<ResponseStatus> changePassword(String password) async{
    var client = http.Client();
    var url = Uri.parse(urlChangePassword);
    String userName = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    String token = await storageManager.getDataStorageSharedPreference(TOKEN_KEY);
    ResponseStatus responseStatus = ResponseStatus(success: false,message: "Không thể kết nối tới máy chủ, Vui lòng thử lại",data: null);

    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type':'application/json; charset=UTF-8',
            'Authorization':'Bearer $token'
          },
          body: jsonEncode(
              {
                'fcCode':userName,
                'password':password,
              }
          )
      );

      if(response.statusCode == 200){
        responseStatus = ResponseStatus.fromJson(json.decode(utf8.decode(response.bodyBytes)));

      }

    }finally{
      client.close();
    }

    return responseStatus;
  }

  Future<AuthenEntity> autoLogin() async{
    var client = http.Client();
    var url = Uri.parse(urlAuthen);
    AuthenEntity authenEntity;

    String userName = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    String password = await storageManager.getDataStorageSharedPreference(PASSWORD_KEY);
    String securityKey = await storageManager.getDataStorageSharedPreference(SECURITY_KEY);

    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type':'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              {
                'username':userName,
                'password':password,
                'security_key':securityKey
              }
          )
      );
      if(response.statusCode == 200){
        print("kiemtra ${utf8.decode(response.bodyBytes)}");
        authenEntity = AuthenEntity.fromJSON(json.decode(utf8.decode(response.bodyBytes)));
        storageManager.storageDataToSharedPreference(TOKEN_KEY,authenEntity.accessToken);
        storageManager.storageDataToSharedPreference(FULLNAME_KEY, authenEntity.message);
      }

    }finally{
      client.close();
    }

    return authenEntity;
  }

  Future<bool> checkHasAccount() async{
    String userName = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    String password = await storageManager.getDataStorageSharedPreference(PASSWORD_KEY);
    if(userName.isNotEmpty && password.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  void reAuthen() async{
    String userName = await storageManager.getDataStorageSharedPreference(USER_NAME_KEY);
    String password = await storageManager.getDataStorageSharedPreference(PASSWORD_KEY);
    String security = await storageManager.getDataStorageSharedPreference(SECURITY_KEY);

    var client = http.Client();
    var url = Uri.parse(urlAuthen);
    AuthenEntity authenEntity;

    try{
      var response = await client.post(
          url,
          headers: {
            'Content-Type':'application/json; charset=UTF-8'
          },
          body: jsonEncode(
              {
                'username':userName,
                'password':password,
                'security_key':security
              }
          )
      );

      if(response.statusCode == 200){
        authenEntity = AuthenEntity.fromJSON(json.decode(utf8.decode(response.bodyBytes)));
        storageManager.storageDataToSharedPreference(TOKEN_KEY,authenEntity.accessToken);
      }

    }finally{
      client.close();
    }
  }
}


