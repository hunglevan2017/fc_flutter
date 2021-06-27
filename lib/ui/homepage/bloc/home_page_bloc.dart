
import 'package:fc_collection/entity/CustomerInfo.dart';
import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/DelinquencyMaster.dart';
import 'package:fc_collection/entity/StatusMaster.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/repository/StatusMasterRepository.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_event.dart';
import 'package:fc_collection/ui/homepage/bloc/home_page_state.dart';
import 'package:fc_collection/validators/Validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_collection/util/ConnectManager.dart';

class HomePageBloc extends Bloc<HomePageEvent,HomePageState>{
  final CustomerInfoRepository customerInfoRepository;


  HomePageBloc({this.customerInfoRepository}) : super(HomePageCustomersInitState());

  @override
  HomePageState get initialState => HomePageCustomersInitState();

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    yield HomePageCustomersLoading();
    if(event is HomePageFetchCustomersEvent){
      try{
        if(await isConnectInterneted()){
          final listCustomerInfo = await customerInfoRepository.fetchCustomersInfo(event.groupDashboardId);
          yield HomePageCustomersLoaded(listCustomerInfo);
        }else{
          final listCustomerInfo = await customerInfoRepository.fetchCustomersInfoOffline(event.groupDashboardId);
          yield HomePageCustomersLoaded(listCustomerInfo);
        }
      } on Exception{
        yield HomePageCustomerError("Không thể lấy được dữ liệu vui lòng thử lại !");
      }
    }

    if(event is HomePageSearchAdvancedEvent){

      String error = validateSearchAdvanced(event.status,event.startDate, event.endDate);
      if(error.trim().length == 0){
        if(await isConnectInterneted()){
          final listCustomerInfo = await customerInfoRepository.fetchSearchCustomer(event.status, event.startDate, event.endDate);
          yield HomePageCustomersLoaded(listCustomerInfo);
        }else{
          yield HomePageCustomerError("Không thể lấy được dữ liệu vui lòng thử lại !");
        }
      }else{
        yield HomePageCustomerError(error);
      }


    }

    if(event is HomePageSearchCustomersEvent){
      List<CustomerInfo> listFilter = [];
      final listCustomerInfo = await customerInfoRepository.fetchCustomersInfoOffline(event.groupDashboardId);
      listCustomerInfo.forEach((element) {
        if(element.customerName.toUpperCase().contains(event.valueSearch.toString().toLowerCase()) || element.customerIDNo.contains(event.valueSearch) || element.agreementID.contains(event.valueSearch) ){
          listFilter.add(element);
        }
      });

      if(listFilter.length == 0){
        yield HomePageCustomerError("Không tìm thấy dữ liệu!");
      }else{
        yield HomePageCustomersLoaded(listFilter);
      }

    }

    if(event is HomePageFetchDashboardEvent){
      try{
        if(await isConnectInterneted()){
          final listDashboard = await customerInfoRepository.getDashboard();
          yield HomePageListDashboardLoaded(listDashboard);
        }else{
          final listDashboard = await customerInfoRepository.getDashboardOffline();
          yield HomePageListDashboardLoaded(listDashboard);
        }

      } on Exception{
        yield HomePageCustomerError("Không thể lấy được dữ liệu vui lòng thử lại !");
      }
    }

  }
}

//bloc status
class HomePageStatusMasterBloc extends Bloc<HomePageEvent,HomePageState>{
  final StatusMasterRepostitory statusMasterRepostitory;
  HomePageStatusMasterBloc({this.statusMasterRepostitory}) : super(HomePageCustomersInitState());

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    if(event is HomePageGetResultActionCode){
      if(await isConnectInterneted()){
        statusMasterRepostitory.fetchActionCode();
        List<StatusMaster> listResultCode = await statusMasterRepostitory.fetchResultCode();
        statusMasterRepostitory.fetchDelinquency();

        yield HomePageCustomerStateShowResultAction(listResultCode);
        }else{
        List<StatusMaster> listResultCode = await statusMasterRepostitory.fetchResultCodeOffline();
        yield HomePageCustomerStateShowResultAction(listResultCode);
      }
    }
  }

}