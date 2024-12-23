import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/function/notification_helper.dart';

class LoginController extends GetxController {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;  // تهيئة FirebaseAnalytics

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController? emailLoginController;
  TextEditingController? passwordLoginController;

  bool isLoading=true;

  goToSignUpPage() {
    Get.toNamed(AppRoute.signPage);
  }


  Future<void> saveUserToken(String userId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('Users').doc(userId).update({
          'fcmToken': token,
        });
      }
    } catch (e) {
      print("Error saving FCM token: $e");
    }
  }


  // وظيفة لاسترجاع بيانات المستخدم والتحقق من دوره
  Future<String?> getUserRole(String userId) async {
    try {
      // جلب بيانات المستخدم بناءً على الـ User ID
      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        // الحصول على حقل role
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String role = userData['role']; // قيم مثل: patient, doctor, admin
        return role;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }


  // وظيفة لاسترجاع بيانات المستخدم والتحقق من دوره
  Future<String?> getUserStatus(String userId) async {
    try {
      // جلب بيانات المستخدم بناءً على الـ User ID
      DocumentSnapshot userDoc =
      await firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        // الحصول على حقل role
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String status = userData['status']; // قيم مثل: patient, doctor, admin
        return status;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  // توجيه المستخدم بناءً على دوره
  void navigateBasedOnRole(String role) {
    if (role == 'patient') {
      Get.toNamed(AppRoute.patientHome);
    } else if (role == 'doctor') {
      Get.offAllNamed(AppRoute.homeScreen);
    } else if (role == 'admin') {
      Get.toNamed(AppRoute.adminHome);
    } else {
      print('Invalid role');
    }
  }

  Future<void> signInWithEmailPassword() async {
    isLoading;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailLoginController!.text.trim(),
        password: passwordLoginController!.text.trim(),
      );

      String userId = auth.currentUser!.uid;


      String ? role=await getUserRole(userId);
      String ? status=await getUserStatus(userId);
      // تسجيل الحدث في Firebase Analytics عند تسجيل الدخول بنجاح
      await _analytics.logEvent(
        name: 'user_login',
        parameters:{
          'email': emailLoginController!.text.trim(),
          'login_status': 'success',
        },
      );
      if (role != null && status=='accepted') {
        navigateBasedOnRole(role);
        // الحصول على FCM Token
        String? fcmToken = await FirebaseMessaging.instance.getToken();


        if (fcmToken != null) {
          // حفظ الـ FCM Token في Firestore مع بيانات المستخدم
          await FirebaseFirestore.instance.collection('Users').doc(userId).update({
            'fcmToken': fcmToken,
          });


          print("تم حفظ FCM Token للمستخدم: $fcmToken");
        } else {
          print("لم يتم الحصول على FCM Token");
        }

      } else {
        Get.snackbar('Error', 'your request not accepted yet ');
      }
    } catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        }
      }

      Get.snackbar('Failed', 'message');
      isLoading=false;
    }
    isLoading=false;
    update();

  }

  @override
  void onInit() {
    emailLoginController = TextEditingController();
    passwordLoginController = TextEditingController();
    super.onInit();
  }
}
