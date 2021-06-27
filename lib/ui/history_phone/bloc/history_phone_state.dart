
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/HistoryPhoneEntity.dart';

abstract class HistoryPhoneState extends Equatable{
  const HistoryPhoneState();
}

class HistoryPhoneStateShowHistoryPhone extends HistoryPhoneState{
  final List<HistoryPhoneEnity> list;
  const HistoryPhoneStateShowHistoryPhone({this.list});

  @override
  List<Object> get props => [list];
}

class HistoryPhoneStateInitial extends HistoryPhoneState{
  const HistoryPhoneStateInitial();

  @override
  List<Object> get props => [];
}

class HistoryPhoneStateLoading extends HistoryPhoneState{
  const HistoryPhoneStateLoading();

  @override
  List<Object> get props => [];
}

class HistoryPhoneStateError extends HistoryPhoneState{
  final message;
  const HistoryPhoneStateError({this.message});

  @override
  List<Object> get props => [message];

}