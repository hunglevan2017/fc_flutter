
import 'package:fc_collection/entity/DocumentMaster.dart';
import 'package:fc_collection/repository/DocumentMasterRepository.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document_master/collect_document_master_event.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document_master/collect_document_master_state.dart';
import 'package:fc_collection/util/ConnectManager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectDocumentMasterBloc extends Bloc<CollectDocumentMasterEvent,CollectDocumentMasterState>{
  final DocumentMasterRepository documentMasterRepository;

  CollectDocumentMasterBloc({this.documentMasterRepository}) : super(CollectDocumentMasterStateInitial());
  List<DocumentMaster> listDocument = [];

  @override
  Stream<CollectDocumentMasterState> mapEventToState(CollectDocumentMasterEvent event) async* {
    if(event is CollectDocumentMasterEventFetchDocumentMaster){
      try{
        if(await isConnectInterneted()){
          var list = await documentMasterRepository.fetchDocumentMaster();
          listDocument = list;
          yield CollectDocumentMasterStateShowDocumentMaster(listDocument);
        }else{
          var list = await documentMasterRepository.fetchDocumentMasterOffline();
          listDocument = list;
          yield CollectDocumentMasterStateShowDocumentMaster(listDocument);
        }
      }on Exception{
        yield CollectDocumentMasterStateError("Không tìm thấy dữ liệu !");
      }
    }

    if(event is CollectDocumentMasterEventCheckedListDocumentMaster){
      yield* mapUpdateEventToState(event);
    }

  }

  Stream<CollectDocumentMasterState> mapUpdateEventToState(CollectDocumentMasterEventCheckedListDocumentMaster event) async*{
    try{
      List<DocumentMaster> list = [];

      for(var i=0; i<listDocument.length; i++){
        DocumentMaster documentMaster = event.list[i];
        DocumentMaster newDocumentMaster = DocumentMaster(insertdate: documentMaster.insertdate,id: documentMaster.id,isRequired: documentMaster.isRequired, docName: documentMaster.docName, isActive: documentMaster.isActive, docId: documentMaster.docId);
        if(i == event.index){
          newDocumentMaster.isRequired = event.isChecked;
        }

        list.add(newDocumentMaster);
      }

      yield CollectDocumentMasterStateShowDocumentMaster(list);
    }on Exception{

    }
  }

}