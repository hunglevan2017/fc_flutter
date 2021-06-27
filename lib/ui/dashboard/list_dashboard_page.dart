import 'package:fc_collection/entity/DashboardEntity.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_bloc.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_event.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_state.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListDashboardPage extends StatefulWidget{
  final HomePageBloc homePageBloc;
  final Function onTapList;

  const ListDashboardPage({Key key, this.homePageBloc, this.onTapList}) : super(key: key);
  
  @override
  ListDashboardPageState createState() => ListDashboardPageState();

}

class ListDashboardPageState extends State<ListDashboardPage>{
  
  @override
  void initState() {
    super.initState();
    widget.homePageBloc.add(HomePageFetchDashboardEvent());

  }

  IconData _getIconByName(String nameIcon){
    IconData iconData = Icons.calendar_today;

    switch(nameIcon){
      case 'ic_tacdong':
        iconData = Icons.calendar_today;
        break;

      case 'ic_tongphanbo':
        iconData = Icons.folder_open_outlined;
        break;

      case 'ic_chuatacdong':
        iconData = Icons.access_alarm;
        break;

      case 'ic_huathanhtoan':
        iconData = Icons.monetization_on_outlined;
        break;

      case 'ic_dathahtoan1phan':
        iconData = Icons.attach_money_outlined;
        break;

      case 'ic_dathanhtoandu':
        iconData = Icons.money_outlined;
        break;

      case 'ic_tuchoithanhtoan':
        iconData = Icons.money_off_outlined;
        break;

      case 'ic_tacdongkhac':
        iconData = Icons.wysiwyg_outlined;
        break;
    }

    return iconData;
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc,HomePageState>(
      builder: (context,state){

        if(state is HomePageListDashboardLoaded){
          return Container(
            child: ListView(
              children: [
                ..._listDashboard(state.listDashboard)
              ],
            ),
          );
        }

        return Text("");
      },
    );
  }

  List<Widget> _listDashboard(List<DashboardEntity> list){
    List<Widget> rows = [];

    list.forEach((element) {
      rows.add(
          _itemListDashboard(context, _getIconByName(element.icon_name), element.dashboard_name, "${element.sl}", "${element.num_percent}",element.group_dashboard_id)
      );
    });

    return rows;
  }

  Widget _itemListDashboard(context,leadingIcon,title,amount,percent,group_dashboard_id){
    Size screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: (){
        widget.onTapList(group_dashboard_id);
      },
      child: Card(
        margin: EdgeInsets.only(left: 8,top: 8, right: 8, bottom: 0),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: 8,top: 8, bottom: 8, right: 8 ),
                child: Icon(leadingIcon),
                width: 42.0,
                height: 42.0
            ),

            Container(
              width: screenSize.width - 150 - 8 - 42 - 24,
              child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: TITLE_HEADER)),
            ),
            Spacer(),
            Container(
              width: 60,
              child: Text(amount, textAlign: TextAlign.center,style: TextStyle(
                color: Colors.white,
              )),
              margin: EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 4),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: COLOR_PRIMARY,
                  borderRadius: BorderRadius.all(Radius.circular(3.0))
              ),
            ),

            Container(
              width: 60,
              child: Text('$percent%',textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white
              )),
              margin: EdgeInsets.only(left: 4, top: 0, bottom: 0, right: 8),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: COLOR_SECOND,
                  borderRadius: BorderRadius.all(Radius.circular(3.0))
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class ListDashboardPage1 extends StatelessWidget{
//
//   var listDashBoard;
//
//   ListDashboardPage({listDashboard});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView(
//         children: [
//           _itemListDashboard(context, Icons.calendar_today, "Hẹn tác động hôm nay", "12", "0"),
//           _itemListDashboard(context, Icons.folder_open_outlined, "Tổng phân bổ", "1000", "100"),
//           _itemListDashboard(context, Icons.access_alarm, "Chưa tác động", "20", "20"),
//           _itemListDashboard(context, Icons.monetization_on_outlined, "Hứa thanh toán", "20", "20"),
//           _itemListDashboard(context, Icons.attach_money_outlined, "Đã thanh toán một phần", "30", "30"),
//           _itemListDashboard(context, Icons.money_outlined, "Đã thanh toán đủ", "30", "30"),
//           _itemListDashboard(context, Icons.money_off_outlined, "Từ chối thanh toán", "80", "30"),
//           _itemListDashboard(context, Icons.wysiwyg_outlined, "Tác động khác", "30", "30")
//         ],
//       ),
//     );
//   }
//
//   Widget _itemListDashboard(context,leadingIcon,title,amount,percent){
//     Size screenSize = MediaQuery.of(context).size;
//
//     return InkWell(
//       onTap: (){
//
//       },
//       child: Card(
//         margin: EdgeInsets.only(left: 8,top: 8, right: 8, bottom: 0),
//         child: Row(
//           children: [
//             Container(
//               margin: EdgeInsets.only(left: 8,top: 8, bottom: 8, right: 8 ),
//               child: Icon(leadingIcon),
//               width: 42.0,
//               height: 42.0
//             ),
//
//             Container(
//               width: screenSize.width - 150 - 8 - 42 - 24,
//               child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: TITLE_HEADER)),
//             ),
//             Spacer(),
//             Container(
//               width: 60,
//               child: Text(amount, textAlign: TextAlign.center,style: TextStyle(
//                 color: Colors.white,
//               )),
//               margin: EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 4),
//               padding: EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 color: COLOR_PRIMARY,
//                 borderRadius: BorderRadius.all(Radius.circular(3.0))
//               ),
//             ),
//
//             Container(
//               width: 60,
//               child: Text('$percent%',textAlign: TextAlign.center, style: TextStyle(
//                   color: Colors.white
//               )),
//               margin: EdgeInsets.only(left: 4, top: 0, bottom: 0, right: 8),
//               padding: EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                   color: COLOR_SECOND,
//                   borderRadius: BorderRadius.all(Radius.circular(3.0))
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
// }