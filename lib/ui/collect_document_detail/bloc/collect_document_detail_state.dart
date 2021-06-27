
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/ImageEntity.dart';

abstract class CollectDocumentDetailState extends Equatable{
  const CollectDocumentDetailState();
}

class CollectDocumentDetailStateInitial extends CollectDocumentDetailState{
  const CollectDocumentDetailStateInitial();

  @override
  List<Object> get props => [];

}

class CollectDocumentDetailStateShowFile extends CollectDocumentDetailState{
  final List<ImageEntity> listFile;
  const CollectDocumentDetailStateShowFile(this.listFile);

  @override
  List<Object> get props => [listFile];
}

class CollectDocmentDetailStateError extends CollectDocumentDetailState{
  final message;

  const CollectDocmentDetailStateError(this.message);

  @override
  List<Object> get props => [message];

}