import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/repository/StorageManager.dart';
import 'package:fc_collection/ui/homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/services.dart';
import 'package:fc_collection/util/ClipboardManager.dart';
import 'package:fc_collection/ui/login/bloc/login_bloc.dart';


class LoginPage extends StatefulWidget{
  var title;
  LoginPage({Key key, this.title}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final LoginBloc loginBloc = LoginBloc();
  final storageManager = StorageManager();
  var isChecked = false;
  var iconLogo = Image(image: AssetImage('assets/images/logo.png'));
  var security = "";
  var controllerUserName = TextEditingController();
  var controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();

    storageManager.generateSecurityKey().then((value) => setState((){
      security = value;
    }));

    loginBloc.autoLogined(context);
  }

  void _getCheckValue(value){
    if(isChecked == false){
      setState(() {
        isChecked = true;
      });
    }else{
      setState(() {
        isChecked = false;
      });
    }
  }

  void _login(context){
    loginBloc.checkLogin(context,controllerUserName.text, controllerPassword.text);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder:(context)=> SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: screenSize.width - screenSize.width * 0.08,
                  height: 340,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconLogo,
                      SizedBox(height: 40.0),
                      customTextField(context,Icons.person,"Tên đăng nhập",controllerUserName,false,true),
                      SizedBox(height: 16.0),
                      customTextField(context,Icons.https_outlined,"Mật khẩu",controllerPassword,true,true),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (valueChange){
                              _getCheckValue(valueChange);
                              },
                            checkColor: Colors.white,
                            activeColor: COLOR_PRIMARY,
                            tristate: false,
                          ),
                          Text("Hiển thị mật khẩu")
                        ],
                      ),
                      Container(
                        width: screenSize.width,
                        child: ElevatedButton(
                          child: Text("ĐĂNG NHẬP"),
                          style: ElevatedButton.styleFrom(
                            primary: COLOR_PRIMARY,
                          ),
                          onPressed: (){
                            _login(context);
                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.content_copy_outlined),
                          onPressed: (){
                            copyTextToClipboard(security);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã sao chép mã bảo mật")));
                          }
                          ),
                      Text(
                        "Mã bảo mật : ",
                        style: TextStyle(
                          color: COLOR_PRIMARY,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        security,
                        style: TextStyle(
                            color: COLOR_SECOND,
                            fontWeight: FontWeight.w500
                        ),
                      )
                    ],
                  ),
                  bottom: 16,
                  right: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}