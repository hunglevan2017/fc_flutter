import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/entity/HistoryPhoneEntity.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/ui/history_phone/bloc/history_phone_bloc.dart';
import 'package:fc_collection/ui/history_phone/bloc/history_phone_event.dart';
import 'package:fc_collection/ui/history_phone/bloc/history_phone_state.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_state.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPhonePage extends StatefulWidget{
  final int id;
  final String customerName;
  HistoryPhonePage({this.id,this.customerName});

  @override
  HistoryPhonePageState createState() => HistoryPhonePageState();
}

class HistoryPhonePageState extends State<HistoryPhonePage>{

  final HistoryPhoneBloc historyPhoneBloc = HistoryPhoneBloc(customerInfoRepository: CustomerInfoRepository());

  @override
  void initState() {
    super.initState();
    historyPhoneBloc.add(HistoryPhoneEventFetchHistoryPhone(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử phone (${widget.customerName})",style: TextStyle(fontSize: 14),),
        backgroundColor: COLOR_PRIMARY,
      ),
      body: BlocProvider(
        create: (context) => historyPhoneBloc,
        child: BlocBuilder<HistoryPhoneBloc,HistoryPhoneState>(
          builder: (context,state){

            if(state is HistoryPhoneStateShowHistoryPhone){
              return ListView(
                children: [
                  ..._itemHistoryPhone(state.list)
                ],
              );
            }

            if(state is HistoryPhoneStateError){
              return ErrorText(state.message);
            }

            return Loading();
          },
        ),
      ),
    );
  }

  List<Widget> _itemHistoryPhone(List<HistoryPhoneEnity> list){
    List<Widget> items = [];
    list.forEach((element) {
      items.add(
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(element.mobile_number),
                            Text(element.status,style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                          ],
                        ),
                      )
                  ),

                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(element.app_id),
                          Text(element.date_call,style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                        ],
                      )
                  ),
                ],
              ),

              Divider(
                height: 2.0,
                color: COLOR_SUBTILE,
              )
            ],
          )
      );
    });


    return items;
  }

}