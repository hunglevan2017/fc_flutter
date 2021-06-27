import 'dart:async';
import 'package:fc_collection/entity/AuthenEntity.dart';
import 'package:fc_collection/repository/UserRepository.dart';
import 'package:fc_collection/ui/homepage/home_page.dart';
import 'package:fc_collection/util/ConnectManager.dart';
import 'package:fc_collection/validators/Validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class LoginBloc{

  final userRepository = UserRepository();

  void autoLogined(BuildContext context) async{
    if(await isConnectInterneted()){
      AuthenEntity authenEntity = await userRepository.autoLogin();

      if(authenEntity != null && authenEntity.success){
        _navigatorToHomePage(context);
      }
    }else{
      if( await userRepository.checkHasAccount()){
        _navigatorToHomePage(context);
      }
    }
  }

  void checkLogin(BuildContext context,String userName,String password) async {
    String errorUserName = validUserName(userName);
    String errorPassword = validPassword(password);

    if(errorUserName.isEmpty){
      if(errorPassword.isEmpty){

        if(await isConnectInterneted()){
          var authenEntity = await userRepository.login(userName,password);
          if(authenEntity != null){
            if(authenEntity.success){
              _navigatorToHomePage(context);
            }else{
              showError(context,authenEntity.message);
            }
          }else{
            //login fail
            showError(context,"Đăng nhập thất bại !");
          }
        }else{
          showError(context,"Vui lòng kết nối mạng !");
        }
      }else{
        showError(context,errorPassword);
      }
    }else{
      showError(context, errorUserName);
    }
  }

  void _navigatorToHomePage(context){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void showError(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

}