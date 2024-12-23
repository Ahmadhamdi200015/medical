import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../core/function/notification_helper.dart';

class AdminAnalyticsController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logPageVisit(String pageName) async {
    try {
      await _analytics.logEvent(
        name: 'l',
        parameters: {
          'page_name': pageName,
        },
      );
      print('Page visit event logged');
    } catch (e) {
      print('Error logging page visit event: $e');
    }
  }
@override
  void onInit() {
    logPageVisit('SignUpPage');
    super.onInit();
  }

}