
import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/DelinquencyMaster.dart';
import 'package:fc_collection/entity/StatusMaster.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/repository/StatusMasterRepository.dart';
import 'package:fc_collection/ui/collect_document/collect_document.dart';
import 'package:fc_collection/ui/create_report_activities/bloc/create_report_activities_bloc.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:fc_collection/util/FileCustomerManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'bloc/create_report_activities_event.dart';
import 'bloc/create_report_activities_state.dart';


class CreateReportActivitiesPage extends StatefulWidget{
  final title;
  final cmnd;
  final id;

  const CreateReportActivitiesPage({Key key, this.title, this.cmnd, this.id}) : super(key: key);

  @override
  CreateReportActivitiesPageState createState() => CreateReportActivitiesPageState();

}

class CreateReportActivitiesPageState extends State<CreateReportActivitiesPage>{

  final CreateReportActivitiesBloc _createReportActivitiesBloc = CreateReportActivitiesBloc(fileCustomerManager: FileCustomerManager(),customerInfoRepository: CustomerInfoRepository(),statusMasterRepostitory: StatusMasterRepostitory());
  final CreateReportActivitiesLocationBloc _createReportActivitiesLocationBloc = CreateReportActivitiesLocationBloc();
  final CreateReportActivitiesFolderBloc _createReportActivitiesFolderBloc = CreateReportActivitiesFolderBloc(fileCustomerManager: FileCustomerManager());
  final CreateReportActivitiesUploadBloc _createReportActivitiesUploadBloc = CreateReportActivitiesUploadBloc(fileCustomerManager: FileCustomerManager(),customerInfoRepository: CustomerInfoRepository());

  TextEditingController _controllerCurrentAddress = TextEditingController();
  TextEditingController _controllerNextTimeImpact = TextEditingController();
  TextEditingController _controllerAmountPromisePay = TextEditingController();
  TextEditingController _controllerDatePromisePay = TextEditingController();
  TextEditingController _controllerContactPerson = TextEditingController();
  TextEditingController _controllerRelationshipPerson = TextEditingController();
  TextEditingController _controllerPersonPay = TextEditingController();
  TextEditingController _controllerAmoutCollected = TextEditingController();
  TextEditingController _controllerReason = TextEditingController();

  TextEditingController _controllerCityProvince = TextEditingController();
  TextEditingController _controllerDistrict = TextEditingController();
  TextEditingController _controllerWard = TextEditingController();
  TextEditingController _controllerStreet = TextEditingController();

  DelinquencyMaster _valueDeliquency;
  StatusMaster _valueActionCode;
  StatusMaster _valueResultCode;
  StatusMaster _valueNextActionCode;
  DateFormat _dateFormat = DateFormat("dd/MM/yyyy");
  DateFormat _timeFormat = DateFormat("hh:mm:ss");

  String _currentAddress = "";
  String _timeImpact = "";

  @override
  void initState() {
    _permissionLocation();
    _timeImpact = '${_dateFormat.format(DateTime.now())} ${_timeFormat.format(DateTime.now())}';
    super.initState();
    _createReportActivitiesBloc.add(CreateReportActivitiesEventFetchMasterData());
    _createReportActivitiesFolderBloc.add(CreateReportActivitiesEventCountFolderCustomer(widget.title, widget.cmnd));
  }

  _setValueDeliquency(value){
    setState(() {
      _valueDeliquency = value;
    });
  }

  _setValueActionCode(value){
    setState(() {
      _valueActionCode = value;
    });
  }

  _setValueResultCode(value){
    setState(() {
      _valueResultCode = value;
    });
  }

  _setValueNextActionCode(value){
    setState(() {
      _valueNextActionCode = value;
    });
  }

  _showDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000),
    ).then((value){
      if(value != null){
        _controllerNextTimeImpact.text = "${_dateFormat.format(value)} ${_timeFormat.format(DateTime.now())}";
      }
    });
  }

  _updateReport(){
    CustomerInfoStatus customerInfoStatus = CustomerInfoStatus(
      remark: _controllerReason?.text,
      longitude: 0.0,
      latitude: 0.0,
      status: _valueResultCode?.statusDescription,
      customer_info_id: widget.id,
      input_address: _controllerCurrentAddress?.text,
      map_address: _currentAddress,
      data_json: '',
      delinquency_code: _valueDeliquency?.delinquencyReason,
      promise_amount: _controllerAmountPromisePay?.text != "" ? double.parse( _controllerAmountPromisePay?.text.toString())  : 0.0 ,
      promise_date: _controllerDatePromisePay?.text,
      next_action_date: _controllerNextTimeImpact?.text,
      next_action: _valueNextActionCode?.statusDescription,
      action_code: _valueActionCode?.statusDescription,
      insert_by: '',
      insert_date: _timeImpact,
      contact_person: _controllerContactPerson?.text,
      reason_violation: _valueDeliquency?.delinquencyReason,
      relationship: _controllerRelationshipPerson?.text,
      result_action: _valueResultCode?.statusComment,
      sale_name: ''
    );
    _createReportActivitiesUploadBloc.add(CreateReportActivitiesEventUpload(customerInfoStatus,widget.title,widget.cmnd,_valueResultCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_PRIMARY,
      ),
      body: BlocProvider(
        create: (context)=> _createReportActivitiesBloc,
        child: BlocBuilder<CreateReportActivitiesBloc,CreateReportActivitiesState>(
          builder: (context,state){

            if(state is CreateReportActivitiesStateGetMasterDataSuccess){
              return _createReportActivities(state.listActionCode,state.listResultCode,state.listDelinquency,state.currentDate);
            }

            return Loading();
          },
        )
      ),
    );
  }

  Widget _createReportActivities(List<StatusMaster> listActionCode, List<StatusMaster> listResultCode, List<DelinquencyMaster> listDelinquency, String dateImpact){
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text:TextSpan(
                        text: "Thời gian tác động",
                        style:TextStyle(fontSize: 14,color: COLOR_SUBTILE),
                        children: [
                          TextSpan(text: "("),
                          TextSpan(text: "*",style: TextStyle(color: Colors.red)),
                          TextSpan(text: ")")
                        ]
                    )
                ),
                Text(_timeImpact),
                SizedBox(height: 8.0,),


                RichText(
                    text:TextSpan(
                        text: "Địa điểm tự động quét",
                        style:TextStyle(fontSize: 14,color: COLOR_SUBTILE),
                        children: [
                          TextSpan(text: "("),
                          TextSpan(text: "*",style: TextStyle(color: Colors.red)),
                          TextSpan(text: ")")
                        ]
                    )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: BlocProvider(
                          create: (context) => _createReportActivitiesLocationBloc,
                          child: BlocBuilder<CreateReportActivitiesLocationBloc,CreateReportActivitiesState>(
                            builder: (context,state){
                              if(state is CreateReportActivitiesStateShowAddress){
                                _currentAddress = state.address;
                                return Text(state.address);
                              }

                              return Text("");

                            },
                          ),
                        )
                        // child: Text(_currentAddress)
                    ),
                    IconButton(
                        onPressed: ()=>{

                        },
                        color: COLOR_PRIMARY,
                        icon: Icon(Icons.location_on_rounded)
                    )
                  ],
                ),
                SizedBox(height: 8.0,),
                Text("Địa điểm thực tế",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
                customTextFieldOnTap(context,null,"",_controllerCurrentAddress,false,true,(){
                  // _popupAddress();
                }),
                SizedBox(height: 8.0,),

                RichText(
                    text:TextSpan(
                        text: "Mã tác động",
                        style:TextStyle(fontSize: 14,color: COLOR_SUBTILE),
                        children: [
                          TextSpan(text: "("),
                          TextSpan(text: "*",style: TextStyle(color: Colors.red)),
                          TextSpan(text: ")")
                        ]
                    )
                ),
                DropdownButton(
                  isExpanded: true,
                  value: _valueActionCode,
                  hint: Text("Vui lòng chọn"),
                  items: listActionCode.map((e) =>
                      DropdownMenuItem(
                        value: e,
                        child: Text(e.statusComment),
                      )
                  ).toList(),
                  onChanged: (e){
                    _setValueActionCode(e);
                  },
                ),
                SizedBox(height: 8.0,),


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
                DropdownButton(
                  isExpanded: true,
                  value: _valueResultCode,
                  hint: Text("Vui lòng chọn"),
                  items: listResultCode.map((e) =>
                      DropdownMenuItem(
                        value: e,
                        child: Text(e.statusComment),
                      )
                  ).toList(),
                  onChanged: (e){
                    _setValueResultCode(e);
                  },
                ),
                SizedBox(height: 8.0,),

                _layoutNextTimeImpact(),
                _layoutNextActionCode(listActionCode),
                _layoutPromisePay(),
                _layoutPromiseDate(),
                _layoutPersonPay(),
                _layoutAmountCollected(),

                Text("Người tiếp xúc",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
                customTextField(context,null,"",_controllerContactPerson,false,true),
                SizedBox(height: 8.0,),


                Text("Mối quan hệ",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
                customTextField(context,null,"",_controllerRelationshipPerson,false,true),
                SizedBox(height: 8.0,),


                Text("Lý do vi phạm",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
                DropdownButton(
                  isExpanded: true,
                  isDense: true,
                  hint: Text("Vui lòng chọn"),
                  style: TextStyle(fontSize: 13,color: Colors.black),
                  value: _valueDeliquency,
                  items: listDelinquency.map((e) =>
                    DropdownMenuItem(
                      value: e,
                      child: Text(e?.remark),
                    )
                  ).toList(),
                  onChanged: (e){
                    _setValueDeliquency(e);
                  },
                ),
                SizedBox(height: 8.0,),


                Text("Ghi chú",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controllerReason,
                    maxLines: 4,
                    decoration: InputDecoration(
                        hintText: "",
                        border: InputBorder.none,
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
                ),
                SizedBox(height: 8.0,),


                InkWell(
                  onTap: (){
                    navigatorToScreen(context,CollectDocumentPage(id: widget.id, cmnd: widget.cmnd,title: widget.title));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt,color: COLOR_PRIMARY,),
                      Text("Chụp hình chứng từ ",style: TextStyle(color: COLOR_PRIMARY),),
                      BlocProvider(
                          create: (context) => _createReportActivitiesFolderBloc,
                          child: BlocBuilder<CreateReportActivitiesFolderBloc,CreateReportActivitiesState>(
                            builder: (context,state){

                              if(state is CreateReportActivitiesStateCountFolderCustomer){
                                return Text("(${state.count})",style: TextStyle(color: COLOR_PRIMARY));
                              }

                              return Text("(0)",style: TextStyle(color: COLOR_PRIMARY));
                            },
                          ),
                      )

                    ],
                  ),
                ),
                SizedBox(height: 24.0,),


                Row(
                  children: [
                    Expanded(child: Container(
                      child: ElevatedButton(
                        child: Text("CẬP NHẬP"),
                        style: ElevatedButton.styleFrom(
                          primary: COLOR_PRIMARY,
                        ),
                        onPressed: (){
                          _updateReport();
                        },
                      ),
                    ),),
                    SizedBox(width: 8.0,),
                    Expanded(child: Container(
                      child: ElevatedButton(
                        child: Text("HUỶ"),
                        style: ElevatedButton.styleFrom(
                          primary: COLOR_SECOND,
                        ),
                        onPressed: (){

                        },
                      ),
                    ),)

                  ],
                )

              ],
            ),
          ),
        ),
        BlocProvider(
          create: (context) => _createReportActivitiesUploadBloc,
          child: BlocBuilder<CreateReportActivitiesUploadBloc,CreateReportActivitiesState>(
            builder: (context,state){

              if(state is CreateReportActivitiesStateUploading){
                return popupDialog(title: 'Thông báo',message: 'Đang tải về hệ thống...',isLoading: true);
              }

              if(state is CreateReportActivitiesStateUploadError){
                return popupDialog(title: 'Thông báo',message: state.message,isLoading: false,onOK: (){
                  _createReportActivitiesUploadBloc.add(CreateReportActivitiesEventHideUpload());
                });
              }

              if(state is CreateReportActivitiesStateUploadSuccess){
                return popupDialog(title: 'Thông báo',message: 'Tải dữ liệu thành công.',isLoading: false,onOK: (){
                  _createReportActivitiesUploadBloc.add(CreateReportActivitiesEventHideUpload());
                  Navigator.of(context).pop();
                });
              }

              if(state is CreateReportActivitiesStateUploadHide){
                return SizedBox(height:0.0);
              }

              return SizedBox(height: 0.0,);
            },
          ),
        )
      ],
    );
  }

  Widget _layoutNextTimeImpact(){
    if(_valueResultCode?.nextActionDate == true){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( "Thời gian tác động tiếp theo",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
          Row(
            children: [
              Expanded(child: customTextField(context, null, "dd/mm/yyyy", _controllerNextTimeImpact, false,false)),
              Container(
                color: COLOR_PRIMARY,
                child: IconButton(
                    color: Colors.white,
                    onPressed: (){
                      _showDatePicker();
                    }, icon: Icon(Icons.event)),
              )
            ],
          ),
          SizedBox(height: 8.0,),
        ],
      );
    }else{
      return SizedBox(height: 0.0,);
    }
  }

  Widget _layoutNextActionCode(List<StatusMaster> listActionCode){
    if(_valueResultCode?.nextActionDate == true){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mã tác động tiếp theo",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
          DropdownButton(
            isExpanded: true,
            value: _valueNextActionCode,
            hint: Text("Vui lòng chọn"),
            items: listActionCode.map((e) =>
                DropdownMenuItem(
                  value: e,
                  child: Text(e.statusComment),
                )
            ).toList(),
            onChanged: (e){
              _setValueNextActionCode(e);
            },
          ),
          SizedBox(height: 8.0,),
        ],
      );
    }else{
      return SizedBox(height: 0.0,);
    }
  }

  Widget _layoutPromisePay(){
    if(_valueResultCode?.promiseAmount == true){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Số tiền hứa thanh toán",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
          customTextField(context,null,"",_controllerAmountPromisePay,false,true),
          SizedBox(height: 8.0,),
        ],
      );
    }else{
      return SizedBox(height: 0.0,);
    }

  }

  Widget _layoutPromiseDate(){
    if(_valueResultCode?.promiseActionDate == true){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ngày hứa thanh toán",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
          customTextField(context,null,"",_controllerDatePromisePay,false,true),
          SizedBox(height: 8.0,),
        ],
      );
    }else{
      return SizedBox(height: 0.0,);
    }
  }

  Widget _layoutPersonPay(){
    if(_valueResultCode?.personPay == true){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Người thanh toán",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
          customTextField(context,null,"",_controllerPersonPay,false,true),
          SizedBox(height: 8.0,),
        ],
      );
    }else{
      return SizedBox(height: 0.0,);
    }
  }

  Widget _layoutAmountCollected(){
    if(_valueResultCode?.amountCollected == true){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Số tiền đã thu",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
          customTextField(context,null,"",_controllerAmoutCollected,false,true),
          SizedBox(height: 8.0,),
        ],
      );
    }else{
      return SizedBox(height: 0.0,);
    }
  }

   _popupAddress(){
    showDialog(context: context, builder: (_) =>
        AlertDialog(
          scrollable: true,
          title: Text("Địa chỉ thực tế"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tỉnh/Thành phố",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
              customTextField(context,null,"",_controllerCityProvince,false,true),
              SizedBox(height: 8.0,),

              Text("Quận/Huyện",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
              customTextField(context,null,"",_controllerDistrict,false,true),
              SizedBox(height: 8.0,),

              Text("Phường/Xã",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
              customTextField(context,null,"",_controllerWard,false,true),
              SizedBox(height: 8.0,),

              Text("Đường/Số nhà",style:TextStyle(fontSize: 14,color: COLOR_SUBTILE)),
              customTextField(context,null,"",_controllerStreet,false,true),
              SizedBox(height: 8.0,),
            ],
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context,'Huy');
            }, child: Text("HUỶ",style: TextStyle(
                color: Colors.teal
            ))),

            TextButton(onPressed: (){
              Navigator.pop(context,'DongY');
            }, child: Text("ĐỒNG Ý",style: TextStyle(
                color: Colors.teal
            )))
          ],
        ),
    );
  }

  _permissionLocation() async {
    var permissionLocationStatus = await Permission.location.status;
    if(permissionLocationStatus.isDenied){
      Permission.location.request().then((value){
        if(value.isGranted){
          _createReportActivitiesLocationBloc.add(CreateReportActivitiesEventFetchAddress());
        }
      });
    }if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }else if(permissionLocationStatus.isGranted){
      _createReportActivitiesLocationBloc.add(CreateReportActivitiesEventFetchAddress());
    }
  }

}