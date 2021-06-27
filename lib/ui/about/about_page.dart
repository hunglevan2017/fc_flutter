import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget{
  var iconLogo = Image(image: AssetImage('assets/images/logo.png'));
    
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Về chúng tôi"),
        backgroundColor: COLOR_PRIMARY,
      ),
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
                      SizedBox(height: 8.0),
                      Text("Phiên bản 1.0",style: TextStyle(color: COLOR_SUBTILE),),
                      Text("FINSGO - Collection-Mobile là ứng dụng điện thoại di động do Công ty TNHH SÀI GÒN BPO phát triển nhằm hỗ trợ đội ngũ nhân viên thu thập hồ sơ vay tiêu dùng quản lý công việc, chụp và gửi ảnh hồ sơ lên hệ thống nhập liệu của SÀI GÒN BPO nhanh chóng, tiện lợi và hiệu quả thông qua kết nối Internet.")
                      
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  
}