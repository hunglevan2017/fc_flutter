
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/DocumentMaster.dart';

abstract class CollectDocumentMasterEvent extends Equatable{
  const CollectDocumentMasterEvent();
}

class CollectDocumentMasterEventFetchDocumentMaster extends CollectDocumentMasterEvent{
  const CollectDocumentMasterEventFetchDocumentMaster();

  @override
  List<Object> get props => [];
}

class CollectDocumentMasterEventHideDocumentMaster extends CollectDocumentMasterEvent{
  const CollectDocumentMasterEventHideDocumentMaster();

  @override
  List<Object> get props => [];
}

class CollectDocumentMasterEventCheckedListDocumentMaster extends CollectDocumentMasterEvent{
  final index;
  final isChecked;
  final List<DocumentMaster> list;
  const CollectDocumentMasterEventCheckedListDocumentMaster(this.index, this.isChecked, this.list);

  @override
  List<Object> get props => [index,isChecked,list];

}