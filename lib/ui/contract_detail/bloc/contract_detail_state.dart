
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/DataEntity.dart';
import 'package:fc_collection/entity/DetailContractEntity.dart';

abstract class ContractDetailState extends Equatable{
  const ContractDetailState();
}

class ContractDetailInitalState extends ContractDetailState{
  const ContractDetailInitalState();

  @override
  List<Object> get props => [];
}

class ContractDetailShowDetail extends ContractDetailState{
  final DetailContractEntity detailContractEntity;

  const ContractDetailShowDetail({this.detailContractEntity});

  @override
  List<Object> get props => [detailContractEntity];
}

class ContractDetailError extends ContractDetailState{
  final message;
  const ContractDetailError({this.message});

  @override
  List<Object> get props => [message];
}

class ContractDetailLoading extends ContractDetailState{
  const ContractDetailLoading();

  @override
  List<Object> get props => [];
}

class ContractDetailHistoryActivityLoading extends ContractDetailState{
  const ContractDetailHistoryActivityLoading();

  @override
  List<Object> get props => [];
}
