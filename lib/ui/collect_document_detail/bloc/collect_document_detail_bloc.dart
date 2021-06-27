
import 'dart:io';

import 'package:fc_collection/entity/ImageEntity.dart';
import 'package:fc_collection/ui/collect_document_detail/bloc/collect_document_detail_event.dart';
import 'package:fc_collection/ui/collect_document_detail/bloc/collect_document_detail_state.dart';
import 'package:fc_collection/util/FileCustomerManager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectDocumentDetailBloc extends Bloc<CollectDocumentDetailEvent,CollectDocumentDetailState>{
  final FileCustomerManager fileCustomerManager;
  CollectDocumentDetailBloc(this.fileCustomerManager) : super(CollectDocumentDetailStateInitial());

  @override
  Stream<CollectDocumentDetailState> mapEventToState(CollectDocumentDetailEvent event) async*{
    if(event is CollectDocumentDetailEventFetchFile){
      List<String> list = await fileCustomerManager.getChildFile(event.path);
      List<ImageEntity> listFile = [];
      for(String path in list){
        ImageEntity imageEntity = ImageEntity(file: File(path),isChecked: false);
        listFile.add(imageEntity);
      }
      yield CollectDocumentDetailStateShowFile(listFile);
    }

    if(event is CollectDocumentDetailEventCheckedImage){
      yield* checkedImageEventState(event);
    }

    if(event is CollectDocumentdetailEventRemoveCheckedImage){
      yield* removeImageCheckedEventState(event);
    }

  }

  Stream<CollectDocumentDetailState> checkedImageEventState(CollectDocumentDetailEventCheckedImage event) async*{
    List<ImageEntity> newList = [];
    for(var i=0; i<event.list.length; i++){
      ImageEntity imageEntity;
      if(i == event.index){
        imageEntity = ImageEntity(file: event.list[i].file,isChecked: event.isChecked);
      }else{
        imageEntity = ImageEntity(file: event.list[i].file,isChecked: event.list[i].isChecked);
      }
      newList.add(imageEntity);
    }

    yield CollectDocumentDetailStateShowFile(newList);
  }

  Stream<CollectDocumentDetailState> removeImageCheckedEventState(CollectDocumentdetailEventRemoveCheckedImage event) async*{
    List<ImageEntity> newList = [];
    for(var i=0; i<event.list.length; i++){
      if(!event.list[i].isChecked){
        ImageEntity imageEntity = ImageEntity(file: event.list[i].file,isChecked: event.list[i].isChecked);
        newList.add(imageEntity);
      }else{
        await fileCustomerManager.deleteFile(event.list[i].file.path);
      }
    }

    yield CollectDocumentDetailStateShowFile(newList);
  }

}