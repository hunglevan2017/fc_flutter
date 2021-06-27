import 'package:fc_collection/entity/ResponseStatus.dart';
import 'package:fc_collection/repository/UserRepository.dart';
import 'package:fc_collection/ui/change_password/bloc/change_password_event.dart';
import 'package:fc_collection/ui/change_password/bloc/change_password_state.dart';
import 'package:fc_collection/validators/Validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent,ChangePasswordState>{
  final UserRepository userRepository;
  ChangePasswordBloc({this.userRepository}) : super(ChangePasswordStateInitial());

  @override
  ChangePasswordState get initialState => ChangePasswordStateInitial();

  @override
  Stream<ChangePasswordState> mapEventToState(ChangePasswordEvent event) async* {
    try{
      if(event is ChangePasswordExcute){
        String errorPassword = await validateOldPassword(event.password,event.newPassword,event.reNewPassword);
        if(errorPassword == ""){
          ResponseStatus responseStatus = await userRepository.changePassword(event.newPassword);
          if(responseStatus.success){
            yield ChangePasswordSuccess();
          }else{
            yield ChangePasswordFail(message: "Không thể kết nối được máy chủ vui lòng thử lại !");
          }
        }else{
          yield ChangePasswordFail(message: errorPassword);
        }
      }
    }on Exception{
      yield ChangePasswordFail(message: "Không thể kết nối được máy chủ vui lòng thử lại !");
    }
  }

}