
class DelinquencyMaster{
  int id;
  String delinquencyReason;
  String remark;

  DelinquencyMaster({this.id,this.delinquencyReason,this.remark});

  factory DelinquencyMaster.fromJSON(Map<String,dynamic> json) => DelinquencyMaster(
    id: json['id'],
    delinquencyReason: json['delinquencyReason'] as String,
    remark: json['remark'] as String
  );

}