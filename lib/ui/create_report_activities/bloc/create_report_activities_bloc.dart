
import 'dart:io';

import 'package:fc_collection/entity/DelinquencyMaster.dart';
import 'package:fc_collection/entity/ResponseStatus.dart';
import 'package:fc_collection/entity/StatusMaster.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/repository/StatusMasterRepository.dart';
import 'package:fc_collection/ui/create_report_activities/bloc/create_report_activities_event.dart';
import 'package:fc_collection/ui/create_report_activities/bloc/create_report_activities_state.dart';
import 'package:fc_collection/ui/create_report_activities/create_report_activities.dart';
import 'package:fc_collection/util/ConnectManager.dart';
import 'package:fc_collection/util/FileCustomerManager.dart';
import 'package:fc_collection/validators/Validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart' as Geo;
import 'package:location/location.dart';

class CreateReportActivitiesBloc extends Bloc<CreateReportActivitiesEvent,CreateReportActivitiesState>{
  final CustomerInfoRepository customerInfoRepository;
  final StatusMasterRepostitory statusMasterRepostitory;
  final _currentDateImpact = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final FileCustomerManager fileCustomerManager;

  CreateReportActivitiesBloc({this.fileCustomerManager,this.customerInfoRepository,this.statusMasterRepostitory}) : super(CreateReportActivitiesStateInitial());

  @override
  Stream<CreateReportActivitiesState> mapEventToState(CreateReportActivitiesEvent event) async*{
    if(event is CreateReportActivitiesEventFetchMasterData){
      try{
         if(await isConnectInterneted()){
           List<StatusMaster> listActionCode = await statusMasterRepostitory.fetchActionCode();
           List<StatusMaster> listResultCode = await statusMasterRepostitory.fetchResultCode();
           List<DelinquencyMaster> listDelinquency = await statusMasterRepostitory.fetchDelinquency();

           yield CreateReportActivitiesStateGetMasterDataSuccess(listActionCode, listResultCode, listDelinquency,_dateFormat.format(_currentDateImpact));
         }else{
           List<StatusMaster> listActionCode = await statusMasterRepostitory.fetchActionCodeOffline();
           List<StatusMaster> listResultCode = await statusMasterRepostitory.fetchResultCodeOffline();
           List<DelinquencyMaster> listDelinquency = await statusMasterRepostitory.fetchDelinquencyOffline();

           yield CreateReportActivitiesStateGetMasterDataSuccess(listActionCode, listResultCode, listDelinquency,_dateFormat.format(_currentDateImpact));
         }

      }on Exception{

      }
    }
  }
}

//bloc location
class CreateReportActivitiesLocationBloc extends Bloc<CreateReportActivitiesEvent,CreateReportActivitiesState> {
  CreateReportActivitiesLocationBloc() : super(CreateReportActivitiesStateInitial());

  @override
  Stream<CreateReportActivitiesState> mapEventToState(CreateReportActivitiesEvent event) async*{
    if(event is CreateReportActivitiesEventFetchAddress){
      yield* mapAddressEventToState(event);
    }
  }

  Stream<CreateReportActivitiesState> mapAddressEventToState(CreateReportActivitiesEventFetchAddress event) async*{
    var permissionLocationStatus = await Permission.location.status;
    String currentAddress = "";
      var location = Location();
      var _currentLocation = await location.getLocation();
      try{
        var addressConvert = await Geo.placemarkFromCoordinates(_currentLocation.latitude, _currentLocation.longitude);
        print(addressConvert.first);
        if(addressConvert.isNotEmpty){
            var element = addressConvert.first;
            print(element);
            currentAddress = "${element.subThoroughfare}, ${element.thoroughfare}, ${element.subAdministrativeArea}, ${element.administrativeArea} ";
        }else{
          currentAddress = "${_currentLocation.latitude},${_currentLocation.longitude}";
        }
      }on Exception{
        currentAddress = "${_currentLocation.latitude},${_currentLocation.longitude}";
      }

      yield CreateReportActivitiesStateShowAddress(currentAddress);
  }

}

//bloc count folder
class CreateReportActivitiesFolderBloc extends Bloc<CreateReportActivitiesEvent,CreateReportActivitiesState>{
  final FileCustomerManager fileCustomerManager;
  CreateReportActivitiesFolderBloc({this.fileCustomerManager}) : super(CreateReportActivitiesStateInitial());

  @override
  Stream<CreateReportActivitiesState> mapEventToState(CreateReportActivitiesEvent event) async* {
    if(event is CreateReportActivitiesEventCountFolderCustomer){
      yield* mapCountFolderEventToState(event);
    }
  }

  Stream<CreateReportActivitiesState> mapCountFolderEventToState(CreateReportActivitiesEventCountFolderCustomer event) async*{
    final customerName = '${event.title}_${event.cmnd}';
    String pathRoot = await fileCustomerManager.createFolderByName(customerName);
    List<String> pathFolders = await fileCustomerManager.getChildFile(pathRoot);
    yield CreateReportActivitiesStateCountFolderCustomer(pathFolders.length);
  }
}

//bloc convert pdf
class CreateReportActivitiesUploadBloc extends Bloc<CreateReportActivitiesEvent,CreateReportActivitiesState>{
  final CustomerInfoRepository customerInfoRepository;
  final FileCustomerManager fileCustomerManager;
  CreateReportActivitiesUploadBloc({this.customerInfoRepository, this.fileCustomerManager}) : super(CreateReportActivitiesStateInitial());

  @override
  Stream<CreateReportActivitiesState> mapEventToState(CreateReportActivitiesEvent event) async* {
    if(event is CreateReportActivitiesEventUpload){
      if(await isConnectInterneted()){
        yield CreateReportActivitiesStateUploading();
        yield* mapUploadEventToState(event);
      }else{
        yield CreateReportActivitiesStateUploadError("Vui lòng kết nối mạng để thực hiện chức năng này");
      }
    }

    if(event is CreateReportActivitiesEventHideUpload){
      yield CreateReportActivitiesStateUploadHide();
    }

  }

  Stream<CreateReportActivitiesState> mapUploadEventToState(CreateReportActivitiesEventUpload event) async*{
    String error = validateCustomerInfoReport(event.customerInfoStatus,event.resultAction);
    if(error.trim().length > 0){
      yield CreateReportActivitiesStateUploadError(error);
    }else{
      final customerName = '${event.title}_${event.cmnd}';
      String pathRoot = await fileCustomerManager.createFolderByName(customerName);
      List<String> pathFolders = await fileCustomerManager.getChildFile(pathRoot);
      for(String folder in pathFolders){
        await fileCustomerManager.convertImagesToPDF(folder,folder.split('/').last,customerName);
      }

      var dataResponse = await customerInfoRepository.getCountNumberUpload();

      if(dataResponse != null && dataResponse.success){
        final zipName = '${customerName}_${dataResponse.data}';
        final pathZip = await fileCustomerManager.zipFolderByPath(customerName,zipName);

        ResponseStatus responseStatus = await customerInfoRepository.uploadReportImpact(pathZip, event.customerInfoStatus);
        if(responseStatus.success){
          await fileCustomerManager.deleteFile(pathZip);
          await fileCustomerManager.deleteFile(pathRoot);
          yield CreateReportActivitiesStateUploadSuccess();
        }else{
          await fileCustomerManager.deleteFile(pathZip);
          yield CreateReportActivitiesStateUploadError(responseStatus.message);
        }
      }else{
        yield CreateReportActivitiesStateUploadError("Không thể lấy được dữ liệu từ máy chủ vui lòng thử lại !");
      }
    }



  }


}