import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medicall/core/function/staterequest.dart';

import '../../core/function/notification_helper.dart';

class AdminAnalyticsController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StatusRequest statusRequest=StatusRequest.none;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  var events = <Map<String, dynamic>>[]; // قائمة تحتوي على الأحداث

  @override
  void onInit() {
    super.onInit();
    fetchEvents(); // جلب البيانات عند التهيئة
  }

  void fetchEvents() async {
    try {
      statusRequest=StatusRequest.lodaing;
      update();
      var snapshot = await FirebaseFirestore.instance
          .collection('admin_events')
          .orderBy('lastUpdated', descending: true)
          .get();

      // تحديث قائمة الأحداث
      events = snapshot.docs.map((doc) {
        return {
          "eventType": doc['eventType'],
          "count": doc['count'],
          "lastUpdated": (doc['lastUpdated'] as Timestamp).toDate(),
        };
      }).toList();
    } catch (e) {
      statusRequest=StatusRequest.none;
      update();
      print("Error fetching events: $e");
    } finally {
      statusRequest=StatusRequest.none;
      update();
  }
    update();


  }
}

