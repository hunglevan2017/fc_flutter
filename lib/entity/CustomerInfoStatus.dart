
class CustomerInfoStatus{
  var id;
  var customer_info_id;
  String status;
  String insert_date;
  String insert_by;
  String action_code;
  String next_action;
  String next_action_date;
  String promise_date;
  var promise_amount;
  String remark;
  String delinquency_code;
  String data_json;
  String map_address;
  String input_address;
  int upload_id;
  String sale_name;
  String result_action;
  String contact_person;
  String relationship;
  String reason_violation;
  String created_time;
  var latitude;
  var longitude;

  CustomerInfoStatus({this.id,this.customer_info_id,this.status,this.insert_date,this.insert_by,this.action_code, this.next_action,this.next_action_date,this.promise_date,this.promise_amount,this.remark,this.delinquency_code,this.data_json,this.map_address,this.input_address,this.upload_id,this.sale_name,this.result_action, this.contact_person,
  this.relationship,
  this.reason_violation,
    this.created_time,
    this.latitude,
    this.longitude
  });

  Map<String,dynamic> toJson()=>{
    'id':id,
    'customer_info_id':customer_info_id,
  'status':status,
   'insert_date':insert_date,
   'insert_by':insert_by,
   'action_code':action_code,
   'next_action':next_action,
   'next_action_date':next_action_date,
   'promise_date':promise_date,
   'promise_amount':promise_amount,
   'remark':remark,
   'delinquency_code':delinquency_code,
   'data_json':data_json,
   'map_address':map_address,
   'input_address':input_address,
   'upload_id':upload_id,
   'sale_name':sale_name,
   'result_action':result_action,
   'contact_person':contact_person,
   'relationship':relationship,
   'reason_violation':reason_violation,
   'created_time':created_time,
   'latitude':latitude,
   'longitude':longitude
  };

  factory CustomerInfoStatus.fromJSON(Map<String,dynamic> json){
    return CustomerInfoStatus(
      id: json['id'],
      customer_info_id: json['customer_info_id'],
      status: json['status'] as String,
      insert_date: json['insert_date'] as String,
      insert_by: json['insert_by'] as String,
      action_code: json['action_code'] as String,
      next_action: json['next_action'] as String,
      next_action_date: json['next_action_date'] as String,
      promise_date: json['promise_date'] as String,
      promise_amount: json['promise_amount'],
      remark: json['remark'] as String,
      delinquency_code: json['delinquency_code'] as String,
      data_json: json['data_json'] as String,
      map_address: json['map_address'] as String,
      input_address: json['input_address'] as String,
      upload_id: json['upload_id'] as int,
        sale_name: json['sale_name'] as String,
        result_action: json['result_action'] as String,
        contact_person: json['contact_person'] as String,
        relationship: json['relationship'] as String,
        reason_violation: json['reason_violation'] as String,
        created_time: json['created_time'] as String,
        latitude: json['latitude'],
      longitude: json['longitude']
    );
  }



}