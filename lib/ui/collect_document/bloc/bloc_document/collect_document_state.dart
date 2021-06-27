
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/DocumentMaster.dart';
import 'package:fc_collection/entity/FolderEntity.dart';

abstract class CollectDocumentState extends Equatable{
  const CollectDocumentState();
}

class CollectDocumentStateInitial extends CollectDocumentState{
  const CollectDocumentStateInitial();
  @override
  List<Object> get props => [];

}

class CollectDocumentStateShowListFolder extends CollectDocumentState{
  final List<FolderEntity> list;

  CollectDocumentStateShowListFolder(this.list);

  @override
  List<Object> get props => [list];

}

class CollectDocumentStateError extends CollectDocumentState{
  final message;
  const CollectDocumentStateError(this.message);

  @override
  List<Object> get props => [message];

}

class CollectDocumentStateShowListDocumentMaster extends CollectDocumentState{
  final List<DocumentMaster> list;

  CollectDocumentStateShowListDocumentMaster(this.list);

  @override
  List<Object> get props => [list];
}

class CollectDocumentStateErrorDocumentMaster extends CollectDocumentState{
  final message;
  const CollectDocumentStateErrorDocumentMaster(this.message);

  @override
  List<Object> get props => [message];

}