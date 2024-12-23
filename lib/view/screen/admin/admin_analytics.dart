import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_analytics_controller.dart';

class AdminAnalytics extends StatelessWidget{
  const AdminAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    AdminAnalyticsController controller=Get.put(AdminAnalyticsController());
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics"),centerTitle: true,),
      body: Container(),
    );
  }
}