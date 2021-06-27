import 'package:equatable/equatable.dart';

abstract class HomePageEvent extends Equatable{
  const HomePageEvent();
}

class HomePageFetchCustomersEvent extends HomePageEvent{
  final groupDashboardId;

  const HomePageFetchCustomersEvent(this.groupDashboardId);

  @override
  List<Object> get props => [groupDashboardId];
}

class HomePageFetchDashboardEvent extends HomePageEvent{
  const HomePageFetchDashboardEvent();

  @override
  List<Object> get props => [];
}

class HomePageSearchCustomersEvent extends HomePageEvent{
  final groupDashboardId;
  final valueSearch;

  HomePageSearchCustomersEvent({this.groupDashboardId, this.valueSearch});

  @override
  List<Object> get props => [groupDashboardId,valueSearch];

}

class HomePageGetResultActionCode extends HomePageEvent{
  const HomePageGetResultActionCode();
  @override
  List<Object> get props => [];

}

class HomePageSearchAdvancedEvent extends HomePageEvent{
  final String status;
  final String startDate;
  final String endDate;
  const HomePageSearchAdvancedEvent(this.status, this.startDate, this.endDate);

  @override
  List<Object> get props => [status,startDate,endDate];

}