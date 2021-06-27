import 'dart:convert';

import 'package:fc_collection/entity/DetailContractEntity.dart';
import 'package:fc_collection/repository/CustomerInfoRepository.dart';
import 'package:fc_collection/ui/contract_detail/bloc/contract_detail_event.dart';
import 'package:fc_collection/ui/contract_detail/bloc/contract_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractDetailBloc extends Bloc<ContractDetailEvent,ContractDetailState>{
  final CustomerInfoRepository customerInfoRepository;
  ContractDetailBloc({this.customerInfoRepository}) : super(ContractDetailInitalState());

  @override
  Stream<ContractDetailState> mapEventToState(ContractDetailEvent event) async* {
    yield ContractDetailLoading();
    //This is get online function
    // if(event is ContractDetailGetContractById){
    //   try{
    //     final detailContractEntity = await customerInfoRepository.getDetailCustomersInfoById(event.id.toInt());
    //     yield ContractDetailShowDetail(detailContractEntity: detailContractEntity);
    //   }on Exception{
    //     yield ContractDetailError(message: "Không thể kết nối tới máy chủ vui lòng thử lại sau !");
    //   }
    // }

    if(event is ContractDetailParserDetail){
       var jsonData = jsonDecode(event.details);
       DetailContractEntity detailContractEntity = DetailContractEntity.fromJSON(jsonData);
       if(detailContractEntity != null){
         yield ContractDetailShowDetail(detailContractEntity: detailContractEntity);
       }else{
         yield ContractDetailError(message: "Không tìm thấy dữ liệu !");
       }
    }

  }

}