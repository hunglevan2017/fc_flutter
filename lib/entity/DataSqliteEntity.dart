import 'dart:typed_data';

class DataSqliteEntity{
  int id;
  String key;
  String data;
  String username;

  DataSqliteEntity({this.key, this.data, this.username});

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'key': key,
      'data': data,
      'username':username
    };
  }

  @override
  String toString() {
    return 'DataSqliteEntity{id: $id, key: $key, data: $data, username: $username}';
  }
}