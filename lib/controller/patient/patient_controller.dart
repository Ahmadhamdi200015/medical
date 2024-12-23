import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/function/staterequest.dart';

import '../../core/function/notification_helper.dart';

class PatientController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String tipText = '';
  List specialties = [];
  List doctors = [];
  StatusRequest statusRequest = StatusRequest.none;

  var users = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها
  var isLoading = true; // متغير لمراقبة حالة التحميل

  // void _initFirebaseMessaging() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // عرض الرسالة داخل Dialog
  //     if (message.notification != null) {
  //       _showDialog(message.notification!.title, message.notification!.body);
  //     }
  //   });
  // }

  void _showDialog(String title, String body) {
    Get.dialog(
        AlertDialog(
          title: Text(title),
          content: Text(
            body,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: true);
  }

  Future<void> fetchSpecialties() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('specialties').get();

      // تحويل الوثائق إلى قائمة من الخرائط
      specialties = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // معرف التخصص
          ...doc.data() as Map<String, dynamic>, // بيانات التخصص
        };
      }).toList();
      print(specialties[0]['id']);
      print('fetching specialties');
    } catch (e) {
      print('Error fetching specialties: $e');
    }
    update();
  }



  Future<void> getDoctorsBySpecialty(String specialtyId) async {
    statusRequest = StatusRequest.lodaing;
    update();
    try {
      final doctorsSnapshot = await FirebaseFirestore.instance
          .collection('specialties')
          .doc(specialtyId)
          .collection('doctors')
          .where('doctorStatus',isEqualTo: 'accepted')
          .get();

      // تحويل الوثائق إلى قائمة من الخرائط
      doctors = doctorsSnapshot.docs.map((doc) {
        return {
          'id': doc.id, // معرّف الطبيب
          ...doc.data() as Map<String, dynamic>, // بيانات الطبيب
        };
      }).toList();
      statusRequest = StatusRequest.none;
      print('fetching doctors:');
    } catch (e) {
      print('Error fetching doctors: $e');
    }
    update();
  }

  Future<String> getUserNameById(String userId) async {
    try {
      // الوصول إلى مجموعة المستخدمين
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      // التحقق إذا كان المستند موجودًا
      if (userDoc.exists) {
        // إرجاع اسم المستخدم
        return userDoc['name'] ?? 'Unknown Name';
      } else {
        return 'User not found';
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Error occurred';
    }
  }

  goToDetailsPage(String doctorId, String doctorName, String role) {
    Get.toNamed(AppRoute.detailsPage, arguments: {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorRole': role,
    });
  }

  // جلب المستخدمين الذين دورهم ليس admin وحالتهم pending
  Future<void> fetchPendingUsers() async {
    try {
      print('Success fetching users:');
      isLoading = true;
      QuerySnapshot querySnapshot = await firestore
          .collection('Users')
          .where('role', isEqualTo: 'doctor')
          .get();

      users = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading = false;
    }
    update();
  }

  Future<void> getLastTip() async {
    try {
      // جلب آخر نصيحة تم إضافتها من الكولكشن "tips"
      final querySnapshot = await FirebaseFirestore.instance
          .collection('tips')
          .orderBy('createdAt', descending: true) // ترتيب حسب وقت الإضافة
          .limit(1) // الحصول على النصيحة الأخيرة فقط
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final lastTipDoc = querySnapshot.docs.first; // تخزين المرجع في متغير
        tipText = lastTipDoc['tip']; // النصيحة المستخرجة من البيانات
        print("Last tip text: $tipText");

        // الآن يمكنك استخدام المرجع `lastTipDoc` للوصول إلى أي تفاصيل إضافية إذا لزم الأمر
      } else {
        print('No tips found.');
      }
    } catch (e) {
      print('Error fetching last tip: $e');
    }
  }

  @override
  void onInit() async {
    await fetchSpecialties();
    if (specialties.isNotEmpty) {
      getDoctorsBySpecialty(specialties[0]['id']);
    }
    fetchPendingUsers();
    await getLastTip();
    // _showDialog('Daily Advice', tipText);

    super.onInit();
  }
}
