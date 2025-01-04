import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis/looker/v1.dart';
import 'package:medicall/core/services/service.dart';
import 'package:medicall/view/screen/admin/admin_analytics.dart';
import 'package:medicall/view/screen/admin/admin_home.dart';
import 'package:medicall/view/screen/admin/admin_settings.dart';
import 'package:medicall/view/screen/admin/admin_specialty.dart';

import '../../core/class/fire_service.dart';
import '../../core/constant/route.dart';
import '../../view/screen/admin/admin_advice.dart';

class AdminScreenController extends GetxController {
  final fireS = FireServices();
  String? senderName;
  MyService myService=Get.find();
  final FirebaseAuth auth = FirebaseAuth.instance;
  int currentPage = 0;

  List<Widget> listPage = const [
    AdminHome(),
    AdminAdvice(),
    AdminSpecialty(),
    AdminAnalytics(),
  ];

  List<String> titlebottombar = const [
    "Home",
    "Advice",
    "Specialty",
    "Analytics"
  ];

  goToSettingPage(){
    Get.toNamed(AppRoute.adminSetting);
  }

  //Current User info
  String? getCurrentUserID() {
    return myService.sharedPrefrences.getString('userId').toString();
  }



  changePage(int i) {
    currentPage = i;
    update();
  }
}
