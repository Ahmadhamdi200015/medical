import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/controller/admin/admin_analytics_controller.dart';
import 'package:medicall/view/widget/handlingdataview.dart';

class AdminAnalytics extends StatelessWidget{
  const AdminAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    AdminAnalyticsController controller=Get.put(AdminAnalyticsController());
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics"),centerTitle: true,),
      body: GetBuilder<AdminAnalyticsController>(builder: (controller) => HandlingDataView(statusRequest: controller.statusRequest, widget: ListView.builder(
        itemCount: controller.events.length,
        itemBuilder: (context, index) {
          final event = controller.events[index];
          return ListTile(
            title: Text('${event['eventType']}'),
            subtitle: Text('Count: ${event['count']}'),
            trailing: Text(
              'Last updated: ${event['lastUpdated']}',
            ),
          );
        },
      )),),
    );
  }
}
