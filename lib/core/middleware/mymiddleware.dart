import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/route.dart';
import '../services/service.dart';

class MyMiddleware extends GetMiddleware {
  @override
  int? get priority => 0;

  MyService myService = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    String? userId = myService.sharedPrefrences.getString("userId");
    String? userRole = myService.sharedPrefrences.getString('userRole');

    if (userId != null && userId.isNotEmpty) {
      if (userRole == 'admin') {
        return const RouteSettings(name: AppRoute.adminScreen);
      } else if (userRole == 'doctor') {
        return const RouteSettings(name: AppRoute.doctorHomeScreen);
      } else if (userRole == 'patient') {
        return const RouteSettings(name: AppRoute.patientHome);
      }
    }
    return const RouteSettings(name: AppRoute.login);
  }

}
