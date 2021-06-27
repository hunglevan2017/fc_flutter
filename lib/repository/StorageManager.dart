import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show Random;
import 'package:fc_collection/util/Constant.dart';

class StorageManager{
  void storageDataToSharedPreference(String key,String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getDataStorageSharedPreference(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    return prefs.get(key);
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_NAME_KEY);
    prefs.remove(PASSWORD_KEY);

  }

  Future<String> generateSecurityKey() async {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random _rnd = Random();

    String getRandomString(int length) =>  String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String newSec = getRandomString(10);

    var sec = await getDataStorageSharedPreference(SECURITY_KEY);

    if(sec != null){
      return sec;
    }else{
      storageDataToSharedPreference(SECURITY_KEY,newSec);

      return newSec;
    }

  }
}



