
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/DocumentMaster.dart';
import 'package:fc_collection/entity/FolderEntity.dart';

abstract class CollectDocumentEvent extends Equatable{
  const CollectDocumentEvent();
}

class CollectDocumentEventGetAllFileByCustomer extends CollectDocumentEvent {
  final title;
  final cmnd;
  const CollectDocumentEventGetAllFileByCustomer(this.title, this.cmnd);

  @override
  List<Object> get props => [title,cmnd];
}

class CollectDocumentEventDeleteFolderCustomer extends CollectDocumentEvent{
  final title;
  final cmnd;
  final path;
  const CollectDocumentEventDeleteFolderCustomer(this.path, this.title, this.cmnd);

  @override
  List<Object> get props => [path,cmnd,path];
}

class CollectDocumentEventCreateFolderCustomer extends CollectDocumentEvent{
  final title;
  final cmnd;
  final List<DocumentMaster> listDocument;

  CollectDocumentEventCreateFolderCustomer(this.title, this.cmnd, this.listDocument);

  @override
  List<Object> get props => [title,cmnd,listDocument];

}