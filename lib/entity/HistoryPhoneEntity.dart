
class HistoryPhoneEnity{
  int id;
  int customer_info_id;
  String date_call;
  String mobile_number;
  String app_id;
  String status;

  HistoryPhoneEnity({this.id,this.customer_info_id,this.date_call,this.mobile_number,this.app_id,this.status});

  factory HistoryPhoneEnity.fromJSON(Map<String,dynamic> json){
    return HistoryPhoneEnity(
      id: json['id'] as int,
      customer_info_id: json['customerInfoId'] as int,
      date_call: json['dateCall'] as String,
      mobile_number: json['mobileNumber'] as String,
      app_id: json['appId'] as String,
      status: json['status'] as String
    );
  }
}