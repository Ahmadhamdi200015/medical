import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/function/notification_helper.dart';

class AdminAdviceController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late TextEditingController adviceController;

  NotificationsHelper notificationsHelper = NotificationsHelper();
  Future<void> addTip(String tipText) async {
    try {
      // إضافة النصيحة إلى كولكشن "tips"
      await FirebaseFirestore.instance.collection('tips').add({
        'tip': tipText, // النصيحة
        'createdAt': FieldValue.serverTimestamp(), // توقيت إضافة النصيحة
      });
      print('Tip added successfully!');
    } catch (e) {
      print('Error adding tip: $e');
    }
  }
@override
  void onInit() {
    adviceController=TextEditingController();
    super.onInit();
  }


}