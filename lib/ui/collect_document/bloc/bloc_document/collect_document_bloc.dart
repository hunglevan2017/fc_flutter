
import 'package:fc_collection/entity/DocumentMaster.dart';
import 'package:fc_collection/entity/FolderEntity.dart';
import 'package:fc_collection/repository/DocumentMasterRepository.dart';
import 'package:fc_collection/ui/change_password/bloc/change_password_state.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document/collect_document_event.dart';
import 'package:fc_collection/ui/collect_document/bloc/bloc_document/collect_document_state.dart';
import 'package:fc_collection/util/FileCustomerManager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectDocumentBloc extends Bloc<CollectDocumentEvent,CollectDocumentState>{
  final FileCustomerManager fileCustomerFilemanager;
  final DocumentMasterRepository documentMasterRepository;
  CollectDocumentBloc(this.fileCustomerFilemanager, this.documentMasterRepository) : super(CollectDocumentStateInitial());

  @override
  Stream<CollectDocumentState> mapEventToState(CollectDocumentEvent event) async* {
    if(event is CollectDocumentEventGetAllFileByCustomer){
      try{
        var list = await _getFolderCustomer(event.title,event.cmnd);
        yield CollectDocumentStateShowListFolder(list);
      }on Exception{
        yield CollectDocumentStateError("Không tìm thấy tệp trong hệ thống !");
      }
    }

    if(event is CollectDocumentEventDeleteFolderCustomer){
      yield* mapDeleteToState(event);
    }

    if(event is CollectDocumentEventCreateFolderCustomer){
      yield* mapCreateToState(event);
    }

  }

  Stream<CollectDocumentState> mapDeleteToState(CollectDocumentEventDeleteFolderCustomer event) async*{
    try{
      await fileCustomerFilemanager.deleteFile(event.path);
      var list = await _getFolderCustomer(event.title,event.cmnd);
      yield CollectDocumentStateShowListFolder(list);
    }on Exception{
      yield CollectDocumentStateError("Không thể xoá chứng từ !");
    }
  }

  Stream<CollectDocumentState> mapCreateToState(CollectDocumentEventCreateFolderCustomer event) async*{
    try{
      for(DocumentMaster element in event.listDocument){
        if(element.isRequired){
          String nameFolder = "${event.title}_${event.cmnd}/${element.docId}";
          await fileCustomerFilemanager.createFolderByName(nameFolder);
        }
      }

      var list = await _getFolderCustomer(event.title,event.cmnd);
      yield CollectDocumentStateShowListFolder(list);
    }on Exception{
      yield CollectDocumentStateError("Không thể tạo chứng từ !");
    }
  }

  Future<List<FolderEntity>> _getFolderCustomer(String name, String cmnd) async{
    var nameFolder = "${name}_$cmnd";
    List<FolderEntity> list = [];
    var pathFolderCustomer = await fileCustomerFilemanager.createFolderByName("$nameFolder");
    var listChildFile = await fileCustomerFilemanager.getChildFile(pathFolderCustomer);

    for(var i=0;i<listChildFile.length; i++ ){
      var element = listChildFile[i];
      var nameFolder = element.split("/").last;
      var listChild = await fileCustomerFilemanager.getChildFile(element);
      var folderEntity = FolderEntity(path: element,name:nameFolder,listPathChildFile: listChild );
      list.add(folderEntity);
    }

    return list;
  }

}
