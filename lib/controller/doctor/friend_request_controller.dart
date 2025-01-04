import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medicall/core/function/staterequest.dart';
import 'package:medicall/core/services/service.dart';

import '../../core/class/fire_service.dart';

class FriendRequestController extends GetxController {
  final fireS = FireServices();
  List friendRequests = [];
  bool loading = false;
  String? userId;
  MyService myService = Get.find();
  StatusRequest statusRequest=StatusRequest.none;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void fetchRequests() {
    userId = myService.sharedPrefrences.getString('userId');
    statusRequest=StatusRequest.lodaing;
    update();
    friendRequests.clear();
    FirebaseFirestore.instance
        .collection('friend_requests')
        .where('status', isEqualTo: 'pending')
        .where('receiverID', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      friendRequests.addAll(snapshot.docs);
    });
    statusRequest=StatusRequest.none;
    update();
  }

  // قبول الطلب
  void acceptRequest(String requestId) async {
    try {
      statusRequest=StatusRequest.lodaing;
      update();
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .update({
        'status': 'accepted',
      });
      statusRequest=StatusRequest.none;
      update();
    } catch (e) {
      statusRequest=StatusRequest.none;
      update();
      print(e);
    }
    fetchRequests();
    update();
  }

  // رفض الطلب
  void rejectRequest(String requestId) async {
    statusRequest=StatusRequest.lodaing;
    update();
    await FirebaseFirestore.instance
        .collection('friend_requests')
        .doc(requestId)
        .update({
      'status': 'rejected',
    });

    update();
  }

  @override
  void onInit() {
    fetchRequests();
    super.onInit();
  }
}
