import 'package:get/get.dart';

import '../core/function/fcmconfig.dart';
import '../core/services/service.dart';

class LocalController extends GetxController{
  MyService myService = Get.find();





  @override
  void onInit() {
    RequestPermissoinNotification();
    fcmconfig();
    super.onInit();
  }
}