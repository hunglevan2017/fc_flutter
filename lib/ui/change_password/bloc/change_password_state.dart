
import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable{
  const ChangePasswordState();
}

class ChangePasswordStateInitial extends ChangePasswordState{
  const ChangePasswordStateInitial();

  @override
  List<Object> get props => [];
}

class ChangePasswordFail extends ChangePasswordState{
  final message;
  const ChangePasswordFail({this.message});

  @override
  List<Object> get props => [message];
}

class ChangePasswordSuccess extends ChangePasswordState{
  const ChangePasswordSuccess();

  @override
  List<Object> get props => [];

}

class ChangePasswordLoading extends ChangePasswordState{
  const ChangePasswordLoading();

  @override
  List<Object> get props => throw UnimplementedError();
}