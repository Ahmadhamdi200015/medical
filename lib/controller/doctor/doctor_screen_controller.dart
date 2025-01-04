import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/services/service.dart';
import 'package:medicall/view/screen/doctor/completed_page.dart';
import 'package:medicall/view/screen/doctor/doctor_approved_page.dart';
import 'package:medicall/view/screen/doctor/doctor_home_page.dart';
import 'package:medicall/view/screen/shared/message_page.dart';

import '../../core/class/fire_service.dart';

class DoctorScreenController extends GetxController{

  final fireS = FireServices();
  String? senderName;
  final FirebaseAuth auth = FirebaseAuth.instance;
  int currentPage=0;
  MyService myService=Get.find();
  String? userId;

  List<Widget> listPage=const[
    DoctorHomePage(),
    CompletedPage(),
    DoctorApprovedPage(),
  ];

  List<String> titlebottombar=const[
    "Home",
    "Completed",
    "Approved"
  ];

  goToRequestPage(){
    Get.toNamed(AppRoute.requestFriendsPage);
  }
  goToMessagePage(){
    Get.toNamed(AppRoute.messagePage);
  }


  logOut() async {
    myService.sharedPrefrences.clear();


    Get.offAllNamed(AppRoute.login);
  }

  changePage(int i) {
    currentPage=i;
    update();

  }


}