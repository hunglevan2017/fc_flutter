
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/DocumentMaster.dart';

abstract class CollectDocumentMasterState extends Equatable{
  const CollectDocumentMasterState();
}

class CollectDocumentMasterStateInitial extends CollectDocumentMasterState{
  const CollectDocumentMasterStateInitial();
  @override
  List<Object> get props => [];
}

class CollectDocumentMasterStateShowDocumentMaster extends CollectDocumentMasterState{
  final List<DocumentMaster> list;
  const CollectDocumentMasterStateShowDocumentMaster(this.list);

  @override
  List<Object> get props => [list];
}

class CollectDocumentMasterStateError extends CollectDocumentMasterState{
  final message;
  const CollectDocumentMasterStateError(this.message);
  @override
  List<Object> get props => [message];
}
