
class StatusMaster{
  int id;
  String statusCode;
  String statusDescription;
  String statusComment;
  bool nextAction;
  bool nextActionDate;
  bool promiseAmount;
  bool promiseActionDate;
  int uploadFlag;
  String uploadName;
  bool personPay;
  bool amountCollected;

  StatusMaster({this.id,this.statusCode,this.statusDescription,this.statusComment,this.nextAction,this.nextActionDate,this.promiseAmount,this.promiseActionDate,this.uploadFlag,this.uploadName,this.amountCollected,this.personPay});

  factory StatusMaster.fromJSON(Map<String,dynamic> json) => StatusMaster(
    id: json['id'] as int,
    statusCode: json['statusCode'] as String,
    statusDescription: json['statusDescription'] as String,
    statusComment: json['statusComment'] as String,
    nextAction: json['nextAction'] as bool,
    nextActionDate: json['nextActionDate'] as bool,
    promiseAmount: json['promiseAmount'] as bool,
    promiseActionDate: json['promiseActionDate'] as bool,
    uploadFlag: json['uploadFlag'] as int,
    personPay: json['personPay'] as bool,
    amountCollected: json['amountCollected'] as bool
  );


}