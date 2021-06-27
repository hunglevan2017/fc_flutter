
import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable{
  const ChangePasswordEvent();
}

class ChangePasswordExcute extends ChangePasswordEvent {
  final String password;
  final String newPassword;
  final String reNewPassword;
  const ChangePasswordExcute({this.password,this.newPassword,this.reNewPassword});

  @override
  List<Object> get props => [password,newPassword,reNewPassword];
}
