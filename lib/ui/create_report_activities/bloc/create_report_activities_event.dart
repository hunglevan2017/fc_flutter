
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/StatusMaster.dart';

abstract class CreateReportActivitiesEvent extends Equatable{
  const CreateReportActivitiesEvent();
}

class CreateReportActivitiesEventSaveReport extends CreateReportActivitiesEvent{
  const CreateReportActivitiesEventSaveReport();

  @override
  List<Object> get props => [];

}

class CreateReportActivitiesEventFetchMasterData extends CreateReportActivitiesEvent{
  const CreateReportActivitiesEventFetchMasterData();

  @override
  List<Object> get props => [];
}

class CreateReportActivitiesEventCountFolderCustomer extends CreateReportActivitiesEvent{
  final title;
  final cmnd;

  const CreateReportActivitiesEventCountFolderCustomer(this.title, this.cmnd);

  @override
  List<Object> get props => [title,cmnd];

}

class CreateReportActivitiesEventFetchAddress extends CreateReportActivitiesEvent{

  const CreateReportActivitiesEventFetchAddress();

  @override
  List<Object> get props => [];

}

class CreateReportActivitiesEventUpload extends CreateReportActivitiesEvent{
  final CustomerInfoStatus customerInfoStatus;
  final title;
  final cmnd;
  final StatusMaster resultAction;

  CreateReportActivitiesEventUpload(this.customerInfoStatus, this.title, this.cmnd, this.resultAction);

  @override
  List<Object> get props => [customerInfoStatus];

}

class CreateReportActivitiesEventHideUpload extends CreateReportActivitiesEvent{
  const CreateReportActivitiesEventHideUpload();
  @override
  List<Object> get props => [];

}