import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:googleapis/bigquery/v2.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/function/staterequest.dart';

class OtpPageController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController? otpText;
  String? userId;
  String? userApproval;
  String? otpCode;
  StatusRequest statusRequest = StatusRequest.none;

  // وظيفة لاسترجاع بيانات المستخدم والتحقق من دوره
  Future<String?> getUserApproval() async {
    try {
      // جلب بيانات المستخدم بناءً على الـ User ID
      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        // الحصول على حقل role
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String status = userData['approval']; // قيم مثل: patient, doctor, admin
        return status;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user approval: $e');
      return null;
    }
  }

  // وظيفة لاسترجاع بيانات المستخدم والتحقق من دوره
  Future<String?> getUserVerifyCode() async {
    try {
      // جلب بيانات المستخدم بناءً على الـ User ID
      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        // الحصول على حقل role
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String status =
            userData['verifyCode']; // قيم مثل: patient, doctor, admin
        print(status);
        return status;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user approval: $e');
      return null;
    }
  }

  Future<void> confirmUser() async {
    try {
      statusRequest = StatusRequest.lodaing;
      update();
      if (otpText!.text == otpCode.toString()) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'approval': '1',
        });
        Get.offAllNamed(AppRoute.login);
      } else {
        statusRequest = StatusRequest.none;
        update();
        Get.snackbar('warning', 'otpCode not Correct');
      }
    } catch (e) {
      statusRequest = StatusRequest.none;
      update();
      print("Error: $e");
    }
    update();
  }

  @override
  void onInit() async {
    userId = Get.arguments['userId'];
    userApproval = await getUserApproval();
    otpCode=await getUserVerifyCode();
    otpText = TextEditingController();
    super.onInit();
  }
}
