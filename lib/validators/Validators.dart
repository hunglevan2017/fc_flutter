import 'package:fc_collection/entity/CustomerInfoStatus.dart';
import 'package:fc_collection/entity/StatusMaster.dart';
import 'package:fc_collection/repository/StorageManager.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:intl/intl.dart';

String validUserName(String userName){
  if(userName.isEmpty){
    return "Tên đăng nhập không được rỗng !";
  }else{
    return "";
  }
}

String validPassword(String value){
  if(value.isEmpty){
    return "Vui lòng nhập mật khẩu";
  }else{
    return "";
  }
}

String validateStrongPassword(String value) {
  Pattern pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{9,}$';
  RegExp regex = new RegExp(pattern);

  if (value.isEmpty) {
    return 'Vui lòng nhập mật khẩu';
  } else {
    if (!regex.hasMatch(value))
      return 'Mật khẩu phải là bao gồm chữ in Hoa, ký tự đặc biệt, và 9 chữ số !';
    else
      return "";
  }
}

Future<String> validateOldPassword(String oldPassword,String newPasssword,String reNewPassword) async{
  var passwordStorage = await StorageManager().getDataStorageSharedPreference(PASSWORD_KEY);
  var errorStrongPassword = validateStrongPassword(newPasssword);

  if(oldPassword.isEmpty){
    return "Vui lòng nhập mật khẩu cũ !";
  }else if(passwordStorage != oldPassword){
    return "Mật khẩu cũ không đúng, Vui lòng thử lại !";
  }else if(newPasssword.isEmpty){
    return "Vui lòng nhập mật khẩu mới !";
  }else if(errorStrongPassword.isNotEmpty){
    return errorStrongPassword;
  }else if(newPasssword != reNewPassword){
    return "Nhập lại mật khẩu mới không khớp";
  }else{
    return "";
  }
}

String validateCustomerInfoReport(CustomerInfoStatus customerInfoStatus, StatusMaster actionResult){
  DateFormat _dateFormat = DateFormat("dd/MM/yyyy hh:mm:ss");

  if(customerInfoStatus.insert_date == null || customerInfoStatus.insert_date.isEmpty){
    return "Thời gian tác động không được rỗng";
  }

  if(customerInfoStatus.map_address == null || customerInfoStatus.map_address.isEmpty){
    return "Địa điểm tự động quét tự động rỗng";
  }

  if(customerInfoStatus.action_code == null || customerInfoStatus.action_code.isEmpty){
    return "Vui lòng chọn mã tác động";
  }

  if(customerInfoStatus.result_action == null || customerInfoStatus.result_action.isEmpty){
    return "Vui lòng chọn kết quả tác động";
  }

  if(actionResult != null && actionResult.nextActionDate){
    if(customerInfoStatus.next_action_date == null || customerInfoStatus.next_action_date.isEmpty){
      return "Vui lòng nhập ngày tác động tiếp theo";
    }else{
      try{
        _dateFormat.parse(customerInfoStatus.next_action_date);
      }catch(e){
        return "Vui lòng nhập đúng định dạng ngày tháng";
      }
    }
  }

  if(actionResult != null && actionResult.nextAction){
    if(customerInfoStatus.next_action == null || customerInfoStatus.next_action.isEmpty){
      return "Vui lòng chọn mã tác động tiếp theo";
    }
  }

  if(actionResult != null && actionResult.promiseAmount){
    if(customerInfoStatus.promise_amount == null || customerInfoStatus.promise_amount.isNaN){
      return "Vui lòng nhập số tiền hứa thanh toán";
    }
  }

  if(actionResult != null && actionResult.promiseActionDate){
    if(customerInfoStatus.promise_date == null || customerInfoStatus.promise_date.isEmpty){
      return "Vui lòng nhập ngày hứa thanh toán.";
    }
  }

  return "";

}

String validateSearchAdvanced(String status,String startDate, String endDate){
  DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

  if(status == null || status.trim().length == 0){
    return "Vui lòng chọn kết quả tác động";
  }

  if(startDate == null || startDate.trim().length == 0){
    return "Vui lòng chọn ngày bắt đầu";
  }

  try{
    _dateFormat.parse(startDate);
  }catch(e){
    return "Ngày bắt đầu không phải định dạng ngày tháng";
  }

  if(startDate == null || startDate.trim().length == 0){
    return "Vui lòng chọn ngày bắt đầu";
  }

  try{
    _dateFormat.parse(endDate);
  }catch(e){
    return "Ngày kết thúc không phải định dạng ngày tháng";
  }

  return "";

}