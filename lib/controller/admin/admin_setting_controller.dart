import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/services/service.dart';

import '../../core/class/fire_service.dart';

class AdminSettingController extends GetxController{
  final fireS = FireServices();
  String? senderName;
  MyService myService=Get.find();
  final FirebaseAuth auth = FirebaseAuth.instance;


  //Current User info
  String? getCurrentUserID() {
    return fireS.getCurrentUser()?.uid;
  }

  logOut() async {
     myService.sharedPrefrences.clear();
    Get.offAllNamed(AppRoute.login);
  }
}