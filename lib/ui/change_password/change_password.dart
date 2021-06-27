import 'package:fc_collection/repository/UserRepository.dart';
import 'package:fc_collection/ui/change_password/bloc/change_password_bloc.dart';
import 'package:fc_collection/ui/change_password/bloc/change_password_event.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/material.dart';
import 'package:fc_collection/component/Component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/change_password_state.dart';

class ChangePassword extends StatelessWidget{
  var _oldPasswordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _reNewPasswordController = TextEditingController();
  var _changePasswordBloc = ChangePasswordBloc(userRepository: UserRepository());

  _resetFrom(){
    _oldPasswordController.text = "";
    _newPasswordController.text = "";
    _reNewPasswordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Đổi mật khẩu"),
        backgroundColor: COLOR_PRIMARY,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            customTextField(context,null,"Mật khẩu cũ",_oldPasswordController,true,true),
            SizedBox(height: 8),
            customTextField(context,null,"Mật khẩu mới",_newPasswordController,true,true),
            SizedBox(height: 8),
            customTextField(context,null,"Nhập lại mật khẩu mới",_reNewPasswordController,true,true),
            SizedBox(height: 24),
            Container(
              width: screenSize.width,
              child: ElevatedButton(
                child: Text("LƯU"),
                style: ElevatedButton.styleFrom(
                  primary: COLOR_SECOND,
                ),
                onPressed: (){
                  _changePasswordBloc.add(ChangePasswordExcute(password: _oldPasswordController.text, newPassword:_newPasswordController.text,reNewPassword: _reNewPasswordController.text));
                },
              ),
            ),

            BlocProvider(
                create: (contex) => _changePasswordBloc,
                child: BlocBuilder<ChangePasswordBloc,ChangePasswordState>(
                  builder: (context, state){

                    if(state is ChangePasswordFail){
                      return ErrorText(state.message);
                    }

                    if(state is ChangePasswordSuccess){
                      _resetFrom();
                      return ErrorText("Đổi mật khẩu thành công !");
                    }

                    return ErrorText("");
                  },
                ),
            )

          ],
        ),
      ),
    );
  }

}