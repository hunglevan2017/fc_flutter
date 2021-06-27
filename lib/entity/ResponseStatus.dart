
class ResponseStatus{
  bool success;
  String message;
  dynamic data;

  ResponseStatus({this.success,this.message,this.data});

  factory ResponseStatus.fromJson(Map<String,dynamic> json){
    return ResponseStatus(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data']
    );
  }

}