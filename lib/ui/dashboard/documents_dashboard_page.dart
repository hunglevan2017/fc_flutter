import 'package:fc_collection/entity/CustomerInfo.dart';
import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/entity/StatusMaster.dart';
import 'package:fc_collection/repository/StatusMasterRepository.dart';
import 'package:fc_collection/ui/contract_detail/contract_detail.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_bloc.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_event.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_state.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DocumentsDashboardPage extends StatefulWidget{
  final HomePageBloc homePageBloc;
  final int groupDashboardId;

  const DocumentsDashboardPage({Key key, this.homePageBloc, this.groupDashboardId}) : super(key: key);

  @override
  DocumentsDashboardPageState createState() => DocumentsDashboardPageState();

}

class DocumentsDashboardPageState extends State<DocumentsDashboardPage>{
  TextEditingController _controllerSearch = TextEditingController();
  StatusMaster _valueResultCode;
  bool _isShowSearchAdvanced = false;
  TextEditingController _controllerStartDate = TextEditingController();
  TextEditingController _controllerEndDate = TextEditingController();
  final HomePageStatusMasterBloc _homePageStatusMasterBloc = HomePageStatusMasterBloc(statusMasterRepostitory: StatusMasterRepostitory());
  DateFormat _dateFormat = DateFormat("dd/MM/yyyy");
  DateFormat _timeFormat = DateFormat("hh:mm:ss");


  @override
  void initState() {
    super.initState();
    widget.homePageBloc.add(HomePageFetchCustomersEvent(widget.groupDashboardId));
  }

  _setValueResultCode(value){
    setState(() {
      _valueResultCode = value;
    });
  }

  _setSearchAdvanced(){
    setState(() {
      _isShowSearchAdvanced = !_isShowSearchAdvanced;
    });
  }

  _showDatePicker(TextEditingController controller){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(-100),
      lastDate: DateTime(3000),
    ).then((value){
      if(value != null){
        controller.text = "${_dateFormat.format(value)}";
      }
    });
  }
  
  _pressSearch(){
    widget.homePageBloc.add(HomePageSearchAdvancedEvent(_valueResultCode.statusDescription,_controllerStartDate.text,_controllerEndDate.text));
    _setSearchAdvanced();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(child: customTextFieldOnChange(context,Icons.search,"",_controllerSearch,false,true,(e){
                    widget.homePageBloc.add(HomePageSearchCustomersEvent(groupDashboardId: widget.groupDashboardId,valueSearch: e));
                  })),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: IconButton(icon: Icon(Icons.settings),color: Colors.white, onPressed: (){
                      _homePageStatusMasterBloc.add(HomePageGetResultActionCode());
                      _setSearchAdvanced();
                    }),
                    decoration: BoxDecoration(
                        color: COLOR_PRIMARY,
                        borderRadius: BorderRadius.all(Radius.circular(3.0))
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<HomePageBloc,HomePageState>(
                    builder: (context, state){
                      if(state is HomePageCustomerError){
                        final message = state.message;
                        return ErrorText(message);
                      }

                      if(state is HomePageCustomersLoaded){
                        return _tableDocument(context,state.listCustomerInfo);
                      }

                      return Loading();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        _searchAdvanced()

      ],
    );
  }

  List<TableRow> _rowTableDocument(BuildContext context,List<CustomerInfo> customers){
    List<TableRow> rows = [];

    rows.add(TableRow(
        decoration: BoxDecoration(
            color: COLOR_PRIMARY
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("App ID",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white) ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4,right: 4),
            child: Text("Khách hàng",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4,right: 4),
            child: Text("DPD",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4,right: 4),
            child: Text("Số tiền thu",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4,right: 4),
            child: Text(""),
          ),
        ]
    ));

    customers.forEach((element) {
      rows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(element.agreementID,style: TextStyle(fontSize: 12)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(element.customerName.toUpperCase(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                  Text("Năm sinh: ${element.customerDOB}",style: TextStyle(fontSize: 11)),
                  Text("CMND: ${element.customerIDNo}",style: TextStyle(fontSize: 11))
                ],
              ),
            ),
            Text("${element.dpd}",textAlign: TextAlign.center,style: TextStyle(fontSize: 12)),
            Text("${element.netReceivable}",textAlign: TextAlign.center,style: TextStyle(fontSize: 12)),
            InkWell(
              child: Icon(Icons.search,color: COLOR_SECOND,),
              onTap: ()=>{
                navigatorToScreen(context,ContractDetailPage(id: element.id,title: element.customerName,cmnd: element.customerIDNo,uploadFlag: element.uploadFlag,details: element.details,))
              },
            )
          ]
      ));
    });

    return rows;
  }

  Widget _tableDocument(BuildContext context,List<CustomerInfo> customers){
    return Table(
      columnWidths: {0:FlexColumnWidth(.7),1:FlexColumnWidth(2.0),2:FlexColumnWidth(0.5),4:FlexColumnWidth(0.5)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.symmetric(outside: BorderSide(color: Colors.grey,width: 1),inside: BorderSide(color: Colors.black26,width: 1)),
      children: _rowTableDocument(context,customers),

    );
  }

  Widget _searchAdvanced(){
    return Visibility(
      visible: _isShowSearchAdvanced,
      child: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: COLOR_OVERLAY,
            ),
            Center(
              child: Container(
                width: 350,
                height: 300,
                child: Center(
                  child: Container(
                    child: Card(
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text:TextSpan(
                                        text: "Kết quả tác động",
                                        style:TextStyle(fontSize: 14,color: COLOR_SUBTILE),
                                        children: [
                                          TextSpan(text: "("),
                                          TextSpan(text: "*",style: TextStyle(color: Colors.red)),
                                          TextSpan(text: ")")
                                        ]
                                    )
                                ),
                                SizedBox(height: 8.0,),
                                BlocProvider(create: (context)=> _homePageStatusMasterBloc,
                                  child: BlocBuilder<HomePageStatusMasterBloc,HomePageState>(
                                      builder: (context,state){

                                        if(state is HomePageCustomerStateShowResultAction){
                                          return spinnerResultCode(state.list);
                                        }

                                        return Text("");
                                      }),
                                ),
                                SizedBox(height: 16.0,),

                                Text("Ngày tác động tiếp theo",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE),),
                                SizedBox(height: 8.0,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: customTextFieldOnTap(context, null, "", _controllerStartDate, false, false,(){

                                      }),
                                    ),
                                    Container(
                                      width: 40,
                                      color: COLOR_PRIMARY,
                                      child: IconButton(icon: Icon(Icons.event,color: Colors.white),onPressed: (){
                                        _showDatePicker(_controllerStartDate);
                                      }),
                                    ),
                                    SizedBox(width: 8.0,),

                                    Text("đến",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE),),
                                    SizedBox(width: 8.0,),
                                    Expanded(
                                      child: customTextFieldOnTap(context, null, "", _controllerEndDate, false,false, (){

                                      }),
                                    ),
                                    Container(
                                      width: 40,
                                      color: COLOR_PRIMARY,
                                      child: IconButton(icon: Icon(Icons.event,color: Colors.white),onPressed: (){
                                        _showDatePicker(_controllerEndDate);
                                      }),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 24.0,),

                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: Text("TÌM"),
                                    style: ElevatedButton.styleFrom(
                                      primary: COLOR_SECOND,
                                    ),
                                    onPressed: (){
                                      _pressSearch();
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(icon: Icon(Icons.close),color: COLOR_SECOND,onPressed: (){
                              _setSearchAdvanced();
                            }),
                          )
                        ],
                      ),

                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget spinnerResultCode(List<StatusMaster> listResultCode){
    return Column(
      children: [

        DropdownButton(
          isExpanded: true,
          value: _valueResultCode,
          hint: Text("Vui lòng chọn"),
          items: listResultCode.map((e) =>
              DropdownMenuItem(
                value: e,
                child: Text(e != null ? e.statusComment : ""),
              )
          ).toList(),
          onChanged: (e){
            _setValueResultCode(e);
          },
        ),
        SizedBox(height: 8.0,),
      ],
    );
  }

}
