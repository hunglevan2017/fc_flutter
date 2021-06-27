
import 'package:equatable/equatable.dart';

abstract class ContractDetailEvent extends Equatable{
  const ContractDetailEvent();
}

class ContractDetailGetContractById extends ContractDetailEvent{
  final id;
  const ContractDetailGetContractById({this.id});

  @override
  List<Object> get props => [id];

}

class ContractDetailParserDetail extends ContractDetailEvent{
  final details;

  const ContractDetailParserDetail(this.details);

  @override
  List<Object> get props => [details];

}