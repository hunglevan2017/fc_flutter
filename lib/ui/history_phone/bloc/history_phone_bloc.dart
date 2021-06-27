
import 'package:fc_collection/entity/HistoryPhoneEntity.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/ui/history_phone/bloc/history_phone_event.dart';
import 'package:fc_collection/ui/history_phone/bloc/history_phone_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPhoneBloc extends Bloc<HistoryPhoneEvent,HistoryPhoneState>{
  final CustomerInfoRepository customerInfoRepository;
  HistoryPhoneBloc({this.customerInfoRepository}) : super(HistoryPhoneStateInitial());

  @override
  Stream<HistoryPhoneState> mapEventToState(HistoryPhoneEvent event) async* {
    if(event is HistoryPhoneEventFetchHistoryPhone){
      try{
        List<HistoryPhoneEnity> listHistoryPhone = await customerInfoRepository.getHistoryPhoneByCustomerId(event.id);
        yield HistoryPhoneStateShowHistoryPhone(list: listHistoryPhone);
      }on Exception{
        yield HistoryPhoneStateError(message: "Kết nối máy chủ thất bại vui lòng thử lại !");
      }
    }
  }

}