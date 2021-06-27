
import 'package:fc_collection/entity/DataEntity.dart';

class DataInformation{
  String title;
  List<DataEntity> data;

  DataInformation({this.title,this.data});

  factory DataInformation.fromJSON(Map<String,dynamic> json){
    return DataInformation(
      title: json['title'],
      data: List.from(json['data']).map((e) => DataEntity.fromJSON(e)).toList()
    );
  }

}