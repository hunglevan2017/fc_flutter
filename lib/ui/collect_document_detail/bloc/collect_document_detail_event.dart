
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/ImageEntity.dart';

abstract class CollectDocumentDetailEvent extends Equatable{
  const CollectDocumentDetailEvent();
}

class CollectDocumentDetailEventFetchFile extends CollectDocumentDetailEvent{
  final path;

  const CollectDocumentDetailEventFetchFile(this.path);

  @override
  List<Object> get props => [path];
}

class CollectDocumentDetailEventCheckedImage extends CollectDocumentDetailEvent{
  final List<ImageEntity> list;
  final int index;
  final bool isChecked;
  const CollectDocumentDetailEventCheckedImage(this.list, this.index, this.isChecked);

  @override
  List<Object> get props => [list,index,isChecked];
}

class CollectDocumentdetailEventRemoveCheckedImage extends CollectDocumentDetailEvent{
  final List<ImageEntity> list;
  const CollectDocumentdetailEventRemoveCheckedImage(this.list);

  @override
  List<Object> get props => [list];

}
