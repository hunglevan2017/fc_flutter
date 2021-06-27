import 'package:connectivity/connectivity.dart';

Future<bool> isConnectInterneted() async{
  var connectResult = await Connectivity().checkConnectivity();
  if(connectResult == ConnectivityResult.none){
    return false;
  }else{
    return true;
  }
}