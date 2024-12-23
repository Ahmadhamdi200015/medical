import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medicall/view/screen/doctor/completed_page.dart';
import 'package:medicall/view/screen/doctor/doctor_home_page.dart';
import 'package:medicall/view/screen/doctor/rating_page.dart';

class DoctorScreenController extends GetxController{
  int currentpage=0;

  List<Widget> listPage=const[
    DoctorHomePage(),
    RatingPage(),
    CompletedPage(),
  ];

  List<String> titlebottombar=const[
    "Home",
    "Rating",
    "Completed",
  ];
  @override
  changePage(int i) {
    currentpage=i;
    update();

  }


}