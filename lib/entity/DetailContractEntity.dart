
import 'dart:core';
import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/DataInformation.dart';

class DetailContractEntity{
  List<DataInformation> other_information;
  List<CustomerInfoStatus> history_activitys;

  DetailContractEntity({this.other_information,this.history_activitys});

  factory DetailContractEntity.fromJSON(Map<String,dynamic> json){
    return DetailContractEntity(
      other_information: json['other_information'] == null ? [] : List.from(json['other_information'])?.map((e) => DataInformation.fromJSON(e))?.toList(),
      history_activitys: json['history_activitys'] == null ? [] : List.from(json['history_activitys'])?.map((e) => CustomerInfoStatus.fromJSON(e))?.toList()
    );
  }

}