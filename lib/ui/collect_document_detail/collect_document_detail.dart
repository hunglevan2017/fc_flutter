import 'dart:io';

import 'package:fc_collection/component/Component.dart';
import 'package:fc_collection/entity/ImageEntity.dart';
import 'package:fc_collection/ui/camera/camera_page.dart';
import 'package:fc_collection/ui/collect_document_detail/bloc/collect_document_detail_bloc.dart';
import 'package:fc_collection/ui/collect_document_detail/bloc/collect_document_detail_event.dart';
import 'package:fc_collection/ui/show_image/show_image_page.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:fc_collection/util/FileCustomerManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/collect_document_detail_state.dart';

class CollectDocumentDetailPage extends StatefulWidget{
  final title;
  final pathFolder;

  const CollectDocumentDetailPage({Key key, this.title, this.pathFolder}) : super(key: key);
  
  @override
  CollectDocumentDetailPageState createState() => CollectDocumentDetailPageState();

}

class CollectDocumentDetailPageState extends State<CollectDocumentDetailPage>{
  final _collectDocumentDetailBloc = CollectDocumentDetailBloc(FileCustomerManager());
  List<ImageEntity> listImage = [];

  @override
  void initState() {
    super.initState();
    _collectDocumentDetailBloc.add(CollectDocumentDetailEventFetchFile(widget.pathFolder));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: COLOR_PRIMARY,
        actions: [
          IconButton(onPressed: (){
            _collectDocumentDetailBloc.add(CollectDocumentdetailEventRemoveCheckedImage(listImage));
          }, icon: Icon(Icons.delete))
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                bottom: 56.0,
                left: 8.0,
                right: 8.0,
                top: 8.0,
                child: BlocProvider(
                  create: (context) => _collectDocumentDetailBloc,
                  child: BlocBuilder<CollectDocumentDetailBloc,CollectDocumentDetailState>(
                    builder: (context,state){
                      if(state is CollectDocumentDetailStateShowFile){
                        return _itemGridView(state.listFile);
                      }
                      return Text('');
                    },
                  ),
                )
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: bottomAppBar(),
            )
          ],
        ),
      )
    );
  }

  Widget _itemGridView(List<ImageEntity> list){
    listImage = list;
    return GridView.count(
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        crossAxisCount: 4,
        children: list.asMap().map((i, value) =>
          MapEntry(
              i,
              ImageCheckBox(path: value.file.path,index: i,isChecked: value.isChecked,onChanged: (val){
                _collectDocumentDetailBloc.add(CollectDocumentDetailEventCheckedImage(list,i,val));
              },
              onTap: (){
               navigatorToScreen(context, ShowImagePage(path: value.file.path));
              })
          )
        ).values.toList()
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
      child: Center(
        child: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage(nameFolder: widget.title,pathFolder: widget.pathFolder))).then((value) => _collectDocumentDetailBloc.add(CollectDocumentDetailEventFetchFile(widget.pathFolder)));
            },
            icon: Icon(Icons.camera_alt,color: Colors.white)
        ),
      )
    );
  }

}