import 'package:fc_collection/repository/StatusMasterRepository.dart';
import 'package:fc_collection/ui/about/about_page.dart';
import 'package:fc_collection/ui/change_password/change_password.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_bloc.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_event.dart';
import 'package:fc_collection/ui/login/login_page.dart';
import 'package:fc_collection/ui/view_pdf/view_pdf_page.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/material.dart';
import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/ui/dashboard/list_dashboard_page.dart';
import 'package:fc_collection/ui/dashboard/documents_dashboard_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/repository/StorageManager.dart';

class HomePage extends StatefulWidget{

  @override
  HomePageState createState() => HomePageState();

}

class HomePageState extends State<HomePage>{
  final homepageBloc = HomePageBloc(customerInfoRepository: CustomerInfoRepository());
  GlobalKey<ScaffoldState> _scafffoldKey = GlobalKey<ScaffoldState>();
  StorageManager _storageManager = StorageManager();
  var appbarSelected = APPBAR.LIST_DASHBOARD;
  var _groupDashboardId = 1;
  var _username = "";
  var _fcCode = "";
  var _security = "";

  @override
  void initState() {
    super.initState();
    homepageBloc.add(HomePageFetchCustomersEvent(_groupDashboardId));
    _storageManager.getDataStorageSharedPreference(USER_NAME_KEY).then((value){
      setState(() {
        _fcCode = value;
      });
    });

    _storageManager.getDataStorageSharedPreference(FULLNAME_KEY).then((value){
      setState(() {
        _username = value;
      });
    });

    _storageManager.getDataStorageSharedPreference(SECURITY_KEY).then((value){
      setState(() {
        _security = value;
      });
    });
  }

  void _navigatorToScreen(screen){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  void _logout(){
    StorageManager().logOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);

  }

  void _selectedAppbar(appbarSelected1){
    setState(() {
      appbarSelected = appbarSelected1;
    });
  }

  _showHelp(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            scrollable: true,
            title: Text('Trợ giúp'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                    child: Text("Hướng dẫn sử dụng",style: TextStyle(color: Colors.black)),
                    onPressed: (){
                      _navigatorToScreen(ViewPdfPage(path: 'assets/pdf/userguide.pdf'));
                    }
                ),
                TextButton(
                    child: Text("Cấu hình đề nghị",style: TextStyle(color: Colors.black)),
                    onPressed: (){
                      _navigatorToScreen(ViewPdfPage(path: 'assets/pdf/recommended.pdf'));
                    }
                ),
                TextButton(
                    child: Text("Mã bảo mật: $_security",style: TextStyle(color: Colors.black)),
                    onPressed: (){

                    }
                ),
                SizedBox(height: 8.0)
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scafffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: COLOR_PRIMARY
                ),
                child: drawerCustomer(context,_username == null ? "" : _username, _fcCode == null ? "" : _fcCode)
            ),

            ListTile(
              leading: Icon(Icons.https),
              title: Text("Đổi mật khẩu"),
              onTap: (){
                _navigatorToScreen(ChangePassword());
              },
            ),

            ListTile(
              leading: Icon(Icons.info),
              title: Text("Về chúng tôi"),
              onTap: (){
                _navigatorToScreen(AboutPage());
              },
            ),

            ListTile(
              leading: Icon(Icons.forum),
              title: Text("Trợ giúp"),
              onTap: (){
                _showHelp();
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Đăng xuất"),
              onTap: (){
                _logout();
              },
            )

          ],
        )
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 56),
                child: BlocProvider(
                  create: (context) => homepageBloc,
                  child:  _showContentSelected()
                )
              ),

              Positioned(
                child: bottomAppBar(context),
                bottom: 0,
                left: 0,
                right: 0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showContentSelected(){
    if(appbarSelected == APPBAR.LIST_DASHBOARD){
      return DocumentsDashboardPage(homePageBloc: homepageBloc,groupDashboardId: _groupDashboardId,);
    }else{
      return ListDashboardPage(homePageBloc: homepageBloc,onTapList: (int group_dashboard_id){
        _selectedAppbar(APPBAR.LIST_DASHBOARD);
        _groupDashboardId = group_dashboard_id;
      });
    }
  }

  Widget bottomAppBar(context){
    return Container(
      height: heightAppBar,
      width: double.infinity,
      decoration: BoxDecoration(
        color: COLOR_PRIMARY,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(0,3)
          )
        ]
      ),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.view_headline_outlined,color: Colors.white,),
              onPressed: (){
                _scafffoldKey.currentState.openDrawer();
              }),
          IconButton(
              icon: Icon(Icons.assignment_outlined,color: Colors.white,),
              onPressed: (){
                _selectedAppbar(APPBAR.LIST_DASHBOARD);
              }),
          IconButton(
              icon: Icon(Icons.apps_outlined,color: Colors.white,),
              onPressed: (){
                _selectedAppbar(APPBAR.DASHBOARD);
              })
        ],
      ),
    );
  }
  
}