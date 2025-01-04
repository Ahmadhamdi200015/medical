import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyService extends GetxService {

  late SharedPreferences sharedPrefrences;

  Future<MyService> inti() async {
    sharedPrefrences = await SharedPreferences.getInstance();
    return this;
  }
}

InitialService() async {
  await Get.putAsync(() => MyService().inti());
}
