
class DocumentMaster{
  int id;
  String docId;
  String docName;
  String insertdate;
  bool isActive;
  bool isRequired;

  DocumentMaster({this.id,this.docId,this.docName,this.insertdate,this.isActive,this.isRequired});

  factory DocumentMaster.fromJSON(Map<String,dynamic> json) => DocumentMaster(
    id: json['id'] as int,
    docId: json['docId'] as String,
    docName: json['docName'] as String,
    insertdate: json['insertdate'] as String,
    isActive: json['isActive'] as bool,
    isRequired: json['isRequired'] as bool
  );
}