import 'package:get/get.dart';

class AdminDetailsController extends GetxController {
  String? fileName;

  @override
  void onInit() {
    fileName = Get.arguments['fileName'];
    super.onInit();
  }
}
