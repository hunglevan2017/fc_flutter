
class AuthenEntity{
  bool success;
  String message;
  String accessToken;
  String tokenType;

  AuthenEntity({bool success, String message, String accessToken, String tokenType}){
    this.success = success;
    this.message = message;
    this.accessToken = accessToken;
    this.tokenType = tokenType;
  }

  factory AuthenEntity.fromJSON(Map<String,dynamic> json){
    return AuthenEntity(
        success: json['success'] as bool,
        message: json['message'] as String,
        accessToken: json['accessToken'] as String,
        tokenType: json['tokenType'] as String
    );
  }

}