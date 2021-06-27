
import 'package:equatable/equatable.dart';

abstract class HistoryPhoneEvent extends Equatable{
  const HistoryPhoneEvent();
}

class HistoryPhoneEventFetchHistoryPhone extends HistoryPhoneEvent{
  final id;
  const HistoryPhoneEventFetchHistoryPhone({this.id});

  @override
  List<Object> get props => [id];

}