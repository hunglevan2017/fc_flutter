
import 'dart:ffi';

import 'package:expandable/expandable.dart';
import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/DataEntity.dart';
import 'package:fc_collection/entity/DataInformation.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/ui/contract_detail/bloc/contract_detail_bloc.dart';
import 'package:fc_collection/ui/contract_detail/bloc/contract_detail_event.dart';
import 'package:fc_collection/ui/contract_detail/bloc/contract_detail_state.dart';
import 'package:fc_collection/ui/create_report_activities/create_report_activities.dart';
import 'package:fc_collection/ui/history_phone/history_phone.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractDetailPage extends StatefulWidget{
  final int id;
  final String title;
  final String cmnd;
  final int uploadFlag;
  final String details;

  ContractDetailPage({this.id,this.title, this.cmnd, this.uploadFlag, this.details});

  @override
  ContractDetailPageState createState() => ContractDetailPageState();

}

class ContractDetailPageState extends State<ContractDetailPage>{

  var _visibleDetail = false;
  CustomerInfoStatus _detailHistoryActivty;
  ContractDetailBloc contractDetailBloc = ContractDetailBloc(customerInfoRepository:  CustomerInfoRepository());

  @override
  void initState() {
    super.initState();
    // contractDetailBloc.add(ContractDetailGetContractById(id: widget.id));
    contractDetailBloc.add(ContractDetailParserDetail(widget.details));
  }

  _setDetailHistoryActivity(CustomerInfoStatus data){
    _hideAndShowDetailHistoryActivitys();

    setState(() {
      _detailHistoryActivty = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: COLOR_PRIMARY,
      ),
      floatingActionButton: Visibility(
        visible: widget.uploadFlag == 0 ? false : true,
        child: FloatingActionButton(
            child: Icon(Icons.edit),
            backgroundColor: COLOR_PRIMARY,
            onPressed: ()=>{
              navigatorToScreen(context, CreateReportActivitiesPage(title: widget.title,id: widget.id,cmnd: widget.cmnd))
            }
        ),
      ),
      body: BlocProvider(
        create: (context) => contractDetailBloc ,
        child: Stack(
          children: [
            SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: BlocBuilder<ContractDetailBloc,ContractDetailState>(
                    builder: (context,state){
                      if(state is ContractDetailShowDetail){

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _historyActivity(state.detailContractEntity.history_activitys),
                            _historyPhone(),
                            _informationCustomer(state.detailContractEntity.other_information),
                          ],
                        );

                      }

                      if(state is ContractDetailError){
                        return ErrorText(state.message);
                      }

                      return Loading();
                    }
                )
            ),

            _detailHistoryActivity()

          ],
        ),
      )
    );
  }

  List<ListTile> _itemHistoryActivity(List<CustomerInfoStatus> listHistory){
    List<ListTile> items = [];

    listHistory.forEach((element) {
      items.add(
        ListTile(
          dense: true,
          leading: Icon(Icons.announcement_outlined),
          title: Text(element.status,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
          subtitle: Text(element.insert_date,style: TextStyle(fontSize: 12)),
          onTap: ()=>{
            _setDetailHistoryActivity(element)
          }
        )
      );
    });

    return items;
  }

  Widget _historyActivity(List<CustomerInfoStatus> listHistory){
    return Container(
      child: ExpandablePanel(
          header: Container(child: Text("Lịch sử FC tác động",style: TextStyle(fontSize: 14,color: COLOR_SECOND, fontWeight: FontWeight.w500),), margin: EdgeInsets.fromLTRB(8, 10, 0, 0)),
          expanded: Card(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Column(
                children: [
                  ..._itemHistoryActivity(listHistory),
                ],
              ),
            ),
          ),
          collapsed: null,
      ),
    );
  }

  Widget _historyPhone(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(8, 16, 0, 0),
          child: Text("Lịch sử phone tác động",style: TextStyle(fontSize: 14,color: COLOR_SECOND, fontWeight: FontWeight.w500)),
        ),
        SizedBox(height: 8,),
        Card(
          child: ListTile(
              dense: true,
              leading: Icon(Icons.announcement_outlined),
              title: Text("Xem chi tiết >>>", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600)),
              onTap: ()=>{
                navigatorToScreen(context,HistoryPhonePage(id: widget.id,customerName: widget.title))
              }
          ),
        )
      ],
    );
  }

  Widget _informationCustomer(List<DataInformation> dataInformations){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._itemInformation(dataInformations)
      ],
    );
  }

  List<Widget> _itemInformation(List<DataInformation> dataInformations){
    List<Widget> items = [];

    dataInformations.forEach((element) {
      items.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child:  Text(element.title,style: TextStyle(fontSize: 14,color: COLOR_SECOND, fontWeight: FontWeight.w500))
              ),
              SizedBox(height: 8,),
              Card(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._itemChildInformation(element.data)
                    ],
                  ),
                ),
              )
            ],
          )
      );
    });

    return items;
  }

  List<Widget> _itemChildInformation(List<DataEntity> dataEntitys){
    List<Widget> items = [];

    dataEntitys.forEach((element) {
      items.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(element.title,style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
              Text(element.value),
              SizedBox(height: 8.0,)
            ],
          )
      );
    });

    return items;
  }

  Widget _detailHistoryActivity(){

    return AnimatedOpacity(
        opacity: _visibleDetail ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Stack(
          children: [
            Container(
              width: _visibleDetail ? double.infinity : 0,
              height: _visibleDetail ? double.infinity : 0,
              color: COLOR_OVERLAY,
              child: Container(
                margin: EdgeInsets.all(16),
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("FC tác động",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text("(${_detailHistoryActivty?.insert_by}) ${_detailHistoryActivty?.sale_name} "),
                              SizedBox(height: 8.0,),

                              Text("Địa điểm tự động quét",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.map_address == null ? "" : _detailHistoryActivty.map_address),
                              SizedBox(height: 8.0,),

                              Text("Địa điểm thực tế",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.input_address == null ? "" : _detailHistoryActivty.input_address),
                              SizedBox(height: 8.0,),

                              Text("Thời gian tác động",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.insert_date == null ? "" : _detailHistoryActivty.insert_date),
                              SizedBox(height: 8.0,),

                              Text("Mã tác động",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.action_code == null ? "" : _detailHistoryActivty.action_code),
                              SizedBox(height: 8.0,),

                              Text("Kết quả tác động",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.result_action == null ? "" : _detailHistoryActivty.result_action),
                              SizedBox(height: 8.0,),

                              Text("Thời gian tác động tiếp theo",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.next_action_date == null ? "" : _detailHistoryActivty.next_action_date),
                              SizedBox(height: 8.0,),

                              Text("Mã tác động tiếp theo",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.next_action == null ? "" : _detailHistoryActivty.next_action),
                              SizedBox(height: 8.0,),

                              Text("Số tiền hứa thanh toán",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.promise_amount == null ? "" : "${_detailHistoryActivty.promise_amount}"),
                              SizedBox(height: 8.0,),

                              Text("Ngày hứa thanh toán",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.promise_date == null ? "" : "${_detailHistoryActivty.promise_date}"),
                              SizedBox(height: 8.0,),

                              Text("Người tiếp xúc",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.contact_person == null ? "" : "${_detailHistoryActivty.contact_person}"),
                              SizedBox(height: 8.0,),

                              Text("Mối quan hệ",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.relationship == null ? "" : "${_detailHistoryActivty.relationship}"),
                              SizedBox(height: 8.0,),

                              Text("Lý do vi phạm",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.reason_violation == null ? "" : "${_detailHistoryActivty.reason_violation}"),
                              SizedBox(height: 8.0,),

                              Text("Ghi chú",style: TextStyle(fontSize: 13,color: COLOR_SUBTILE),),
                              Text(_detailHistoryActivty?.remark == null ? "" : "${_detailHistoryActivty.remark}"),
                              SizedBox(height: 8.0,),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: ()=>{
                              _hideAndShowDetailHistoryActivitys()
                            },
                            icon: Icon(Icons.clear,color: COLOR_SECOND,)),
                      )
                    ],
                ),
              ),
            )
          ],
        ),
    );
  }

  _hideAndShowDetailHistoryActivitys(){
    setState(() {
      _visibleDetail = !_visibleDetail;
    });
  }

}