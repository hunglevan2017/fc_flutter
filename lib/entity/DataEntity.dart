
class DataEntity{
  String title;
  String value;

  DataEntity({this.title,this.value});

  factory DataEntity.fromJSON(Map<String,dynamic> json){
    return DataEntity(
      title: json['title'] as String,
      value: json['value'] as String
    );
  }

}