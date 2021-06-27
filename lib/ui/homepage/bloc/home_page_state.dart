
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/CustomerInfo.dart';
import 'package:fc_collection/entity/DashboardEntity.dart';
import 'package:fc_collection/entity/StatusMaster.dart';

abstract class HomePageState extends Equatable{
  const HomePageState();
}

class HomePageCustomersInitState extends HomePageState{
  const HomePageCustomersInitState();

  @override
  List<Object> get props => [];
}

class HomePageCustomersLoading extends HomePageState{
  const HomePageCustomersLoading();

  @override
  List<Object> get props => [];
}

class HomePageCustomersLoaded extends HomePageState{
  final List<CustomerInfo> listCustomerInfo;
  const HomePageCustomersLoaded(this.listCustomerInfo);

  @override
  List<Object> get props => [listCustomerInfo];
}

class HomePageListDashboardLoaded extends HomePageState{
  final List<DashboardEntity> listDashboard;
  const HomePageListDashboardLoaded(this.listDashboard);

  @override
  List<Object> get props => [listDashboard];
}

class HomePageCustomerError extends HomePageState{
  final String message;
  const HomePageCustomerError(this.message);

  @override
  List<Object> get props => [message];
}

class HomePageCustomerStateShowResultAction extends HomePageState{
  final List<StatusMaster> list;
  const HomePageCustomerStateShowResultAction(this.list);

  @override
  List<Object> get props => [list];
}