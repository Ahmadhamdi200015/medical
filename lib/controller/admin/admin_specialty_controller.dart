import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/function/notification_helper.dart';

class AdminSpecialtyController extends GetxController{
  late final TextEditingController specialtyController;

  late final TextEditingController specialtyDescController;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;  // التعديل هنا


  var users = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها
  var isLoading = true; // متغير لمراقبة حالة التحميل



  Future<void> addSpecialty(String name, String description) async {
    try {
      // التحقق إذا كان التخصص موجودًا بالفعل
      final querySnapshot = await FirebaseFirestore.instance
          .collection('specialties')
          .where('name', isEqualTo: name)
          .get();

      // إذا كان التخصص موجودًا، لا تضيفه مرة أخرى
      if (querySnapshot.docs.isNotEmpty) {
        print('التخصص موجود بالفعل');
        return;  // أو يمكنك إظهار رسالة تنبيه للمستخدم هنا
      }

      // إضافة التخصص الجديد إذا لم يكن موجودًا
      await FirebaseFirestore.instance.collection('specialties').add({
        'name': name,
        'description': description,
        'doctors': [], // قائمة الأطباء تبدأ فارغة
      });
      logAddSpecialtyEvent(name);

      print('تم إضافة التخصص بنجاح!');
    } catch (e) {
      print('حدث خطأ أثناء إضافة التخصص: $e');
    }
  }

  // دالة لتتبع حدث إضافة تخصص جديد
  Future<void> logAddSpecialtyEvent(String specialtyName) async {
    try {
      await _analytics.logEvent(
        name: 'add_specialty',
        parameters: {
          'specialty_name': specialtyName,
        },
      );
      print('Specialty event logged');
    } catch (e) {
      print('Error logging event: $e');
    }
  }

  @override
  void onInit() {
    specialtyController=TextEditingController();
    specialtyDescController=TextEditingController();
    super.onInit();
  }
}