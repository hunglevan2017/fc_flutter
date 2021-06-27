
import 'package:equatable/equatable.dart';
import 'package:fc_collection/entity/DelinquencyMaster.dart';
import 'package:fc_collection/entity/StatusMaster.dart';

abstract class CreateReportActivitiesState extends Equatable{
  const CreateReportActivitiesState();
}

class CreateReportActivitiesStateInitial extends CreateReportActivitiesState{
  const CreateReportActivitiesStateInitial();

  @override
  List<Object> get props => [];
}

class CreateReportActivitiesStateSaveReportSuccess extends CreateReportActivitiesState{
  const CreateReportActivitiesStateSaveReportSuccess();

  @override
  List<Object> get props => [];
}

class CreateReportActivitiesStateError extends CreateReportActivitiesState{
  final message;
  const CreateReportActivitiesStateError(this.message);

  @override
  List<Object> get props => [message];
}

class CreateReportActivitiesStateLoading extends CreateReportActivitiesState{
  const CreateReportActivitiesStateLoading();

  @override
  List<Object> get props => [];
}

class CreateReportActivitiesStateGetMasterDataSuccess extends CreateReportActivitiesState{
  final List<StatusMaster> listActionCode;
  final List<StatusMaster> listResultCode;
  final List<DelinquencyMaster> listDelinquency;
  final String currentDate;

  CreateReportActivitiesStateGetMasterDataSuccess(this.listActionCode, this.listResultCode, this.listDelinquency, this.currentDate);

  @override
  List<Object> get props => [listActionCode,listResultCode,listDelinquency,currentDate];

}

class CreateReportActivitiesStateCountFolderCustomer extends CreateReportActivitiesState{
  final count;

  const CreateReportActivitiesStateCountFolderCustomer(this.count);

  @override
  List<Object> get props => [count];

}

class CreateReportActivitiesStateShowAddress extends CreateReportActivitiesState{
  final address;

  const CreateReportActivitiesStateShowAddress(this.address);

  @override
  List<Object> get props => [address];

}


//state upload
class CreateReportActivitiesStateUploading extends CreateReportActivitiesState{
  const CreateReportActivitiesStateUploading();
  @override
  List<Object> get props => [];
}

class CreateReportActivitiesStateUploadError extends CreateReportActivitiesState {
  final message;

  const CreateReportActivitiesStateUploadError(this.message);

  @override
  List<Object> get props => [message];
}

class CreateReportActivitiesStateUploadSuccess extends CreateReportActivitiesState{

  const CreateReportActivitiesStateUploadSuccess();

  @override
  List<Object> get props => [];

}

class CreateReportActivitiesStateUploadHide extends CreateReportActivitiesState{

  const CreateReportActivitiesStateUploadHide();

  @override
  List<Object> get props => [];

}