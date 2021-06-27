
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fc_collection/util/Constant.dart';

Widget customTextField(context,icon,hintText,controller,isObscure,isEnabled){
  return Container(
    child: TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
          hintText: hintText,
          enabled: isEnabled,
          contentPadding: icon != null ? EdgeInsets.only(left: 0,top: 16,right: 16,bottom: 0) : EdgeInsets.only(left: 8,top: 0,right: 8,bottom: 0),
          border: InputBorder.none,
          prefixIcon: icon != null ? Icon(icon) : null
      ),
    ),
    decoration: BoxDecoration(
        color: COLOR_GRAY,
        border: Border.all(
          width: 1.0,
          color: COLOR_GRAY,
        ),
        borderRadius: BorderRadius.all(Radius.circular(3.0))
    ),
  );
}

Widget customTextFieldOnTap(context,icon,hintText,controller,isObscure,isEnabled,Function onTap){
  return Container(
    child: TextField(
      controller: controller,
      obscureText: isObscure,
      enabled: isEnabled,
      decoration: InputDecoration(
          hintText: hintText,
          contentPadding: icon != null ? EdgeInsets.only(left: 0,top: 16,right: 16,bottom: 0) : EdgeInsets.only(left: 8,top: 0,right: 8,bottom: 0),
          border: InputBorder.none,
          prefixIcon: icon != null ? Icon(icon) : null
      ),
      onTap: (){
        onTap();
      },
    ),
    decoration: BoxDecoration(
        color: COLOR_GRAY,
        border: Border.all(
          width: 1.0,
          color: COLOR_GRAY,
        ),
        borderRadius: BorderRadius.all(Radius.circular(3.0))
    ),
  );
}

Widget customTextFieldOnChange(context,icon,hintText,controller,isObscure,isEnabled,Function onChange){
  return Container(
    child: TextField(
      onChanged: onChange,
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
          hintText: hintText,
          enabled: isEnabled,
          contentPadding: icon != null ? EdgeInsets.only(left: 0,top: 16,right: 16,bottom: 0) : EdgeInsets.only(left: 8,top: 0,right: 8,bottom: 0),
          border: InputBorder.none,
          prefixIcon: icon != null ? Icon(icon) : null
      ),
    ),
    decoration: BoxDecoration(
        color: COLOR_GRAY,
        border: Border.all(
          width: 1.0,
          color: COLOR_GRAY,
        ),
        borderRadius: BorderRadius.all(Radius.circular(3.0))
    ),
  );
}

Widget drawerCustomer(context,title,subTitle){
  var iconLogo = Image(image: AssetImage('assets/images/avatar.png'),width: 64,height: 64, fit: BoxFit.fill,);

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Spacer(),
      iconLogo,
      Container(
          margin: EdgeInsets.only(top: 16),
          child: Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 18),)
      ),
      Text(subTitle,style: TextStyle(color: Colors.white),)
    ],
  );
}

Widget ErrorText(message){
  return Center(child: Text(message,style: TextStyle(color: Colors.red)) );
}

Widget Loading(){
  return Center(
    child: CircularProgressIndicator(),
  );
}

Widget ImageCheckBox({bool isChecked,int index,String path,Function onChanged, Function onTap}){
  File file = File(path);

  return Stack(
    children: [
      InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.file(file,fit: BoxFit.cover,filterQuality: FilterQuality.low,cacheWidth: 100,cacheHeight: 100),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Checkbox(value: isChecked, onChanged: onChanged),
      )
    ],
  );
}

Widget popupDialog({String title,String message,bool isLoading,Function onOK}){
  
  if(isLoading){
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: COLOR_OVERLAY,
          child: AlertDialog(
            scrollable: true,
            title: Text(title),
            content: Row(
              children: [
                Loading(),
                SizedBox(width: 8.0,),
                Text(message)
              ],
            ),
          ),
        )
      ],
    );
  }else{
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: COLOR_OVERLAY,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(onPressed: onOK, child: Text("ĐỒNG Ý"))
            ],
          ),
        )
      ],
    );
  }
  
  
}



void showMessage(BuildContext context,String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void navigatorToScreen(context,screen){
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

