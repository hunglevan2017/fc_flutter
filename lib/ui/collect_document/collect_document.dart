import 'package:camerawesome/models/orientations.dart';
import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/entity/DocumentMaster.dart';
import 'package:fc_collection/entity/FolderEntity.dart';
import 'package:fc_collection/repository/DocumentMasterRepository.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document/collect_document_bloc.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document/collect_document_event.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document_master/collect_document_master_bloc.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document_master/collect_document_master_event.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document_master/collect_document_master_state.dart';
import 'package:fc_collection/ui/collect_document_detail/collect_document_detail.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:fc_collection/util/FileCustomerManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

import 'bloc/bloc_document/collect_document_state.dart';

class CollectDocumentPage extends StatefulWidget{
  final id;
  final title;
  final cmnd;

  const CollectDocumentPage({Key key, this.id, this.title, this.cmnd}) : super(key: key);

  @override
  CollectDocumentPageState createState() => CollectDocumentPageState();

}

class CollectDocumentPageState extends State<CollectDocumentPage>{

  CollectDocumentBloc _collectDocumentBloc = new CollectDocumentBloc(FileCustomerManager(),DocumentMasterRepository());
  CollectDocumentMasterBloc _collectDocumentMasterBloc = new CollectDocumentMasterBloc(documentMasterRepository: DocumentMasterRepository());
  var iconFolder = Image(image: AssetImage('images/ic_folder.png'));
  var _isShowDocumentMaster = false;

  @override
  void initState() {
    super.initState();
    _collectDocumentMasterBloc.add(CollectDocumentMasterEventFetchDocumentMaster());
    _collectDocumentBloc.add(CollectDocumentEventGetAllFileByCustomer(widget.title, widget.cmnd));
  }

  _setVisibleDocumentMaster(){
    setState(() {
      _isShowDocumentMaster = !_isShowDocumentMaster;
    });
  }

  _dialogDeleteDocument(String nameFolder,String path){
    showDialog<void>(
      context: (context),
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Bạn có chắc chắn muốn xoá chứng từ $nameFolder'),
          actions: <Widget>[
            TextButton(
              child: Text('HUỶ'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),

            TextButton(
              child: Text('ĐỒNG Ý'),
              onPressed: () {
                _collectDocumentBloc.add(CollectDocumentEventDeleteFolderCustomer(path,widget.title,widget.cmnd));
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showDocumentMaster(List<DocumentMaster> list){
      return Visibility(
        visible: _isShowDocumentMaster,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: COLOR_OVERLAY,
          child: AlertDialog(
            scrollable: true,
            title: Text("Danh sách chứng từ"),
            content: Column(
              children: list.asMap().map((i,e) =>
                  MapEntry(
                      i,
                      CheckboxListTile(
                          value: e?.isRequired,
                          activeColor: COLOR_SECOND,
                          title: Text("${i+1}. ${e?.docName}"),
                          onChanged: (bool){
                            _collectDocumentMasterBloc.add(CollectDocumentMasterEventCheckedListDocumentMaster(i,bool,list));
                          })
                  )
              ).values.toList(),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    _setVisibleDocumentMaster();
                  },
                  child: Text("HUỶ")
              ),

              TextButton(
                  onPressed: (){
                    _collectDocumentBloc.add(CollectDocumentEventCreateFolderCustomer(widget.title, widget.cmnd, list));
                    _setVisibleDocumentMaster();
                  },
                  child: Text("ĐỒNG Ý")
              ),

            ],
          ),
        ),
      );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: COLOR_PRIMARY,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 56),
                child: BlocProvider(
                  create: (context) => _collectDocumentBloc,
                  child: BlocBuilder<CollectDocumentBloc,CollectDocumentState>(
                    builder: (context,state){
                      if(state is CollectDocumentStateShowListFolder){
                        return _itemFolder(state.list);
                      }

                      if(state is CollectDocumentStateError){
                        return ErrorText(state.message);
                      }

                      return Loading();
                    },
                  ),
                ),
              ),

              Positioned(
                child: bottomAppBar(),
                bottom: 0,
                left: 0,
                right: 0,
              ),

              BlocProvider(
                create: (context) => _collectDocumentMasterBloc,
                child: BlocBuilder<CollectDocumentMasterBloc,CollectDocumentMasterState>(
                  builder: (context,state){

                    if(state is CollectDocumentMasterStateShowDocumentMaster){

                      return _showDocumentMaster(state.list);
                    }

                    return Text('');
                  },
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

  Widget _itemFolder(List<FolderEntity> list){
    return ListView(
      children: list.map((e) =>
          ListTile(
            leading: Container(
              width: 42,
              height: 42,
              child: Image.asset("assets/images/ic_folder.png"),
            ),
            title: Text(e.name,style: TextStyle(fontWeight: FontWeight.w500),),
            subtitle: Text("${e.listPathChildFile?.length} Hình ảnh"),
            onTap: (){
              print(e.path);
              Navigator.push(context, MaterialPageRoute(builder: (context) => CollectDocumentDetailPage(title: e.name,pathFolder: e.path))).then((value) => _collectDocumentBloc.add(CollectDocumentEventGetAllFileByCustomer(widget.title, widget.cmnd)));
            },
            onLongPress: () => _dialogDeleteDocument(e.name,e.path),
          )
      ).toList(),
    );
  }

  Widget bottomAppBar(){
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
              icon: Icon(Icons.assignment_outlined,color: Colors.white,),
              onPressed: (){
                _setVisibleDocumentMaster();
              }),
        ],
      ),
    );
  }

}

