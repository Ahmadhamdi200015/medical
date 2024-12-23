import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../core/function/notification_helper.dart';
import '../../core/function/staterequest.dart';

class DoctorRatingController extends GetxController{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  var rating = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها

  StatusRequest statusRequest=StatusRequest.none;

  String?doctorId;



// جلب المستخدمين الذين دورهم ليس admin وحالتهم pending
  Future<void> fetchRating() async {
    String userId=auth.currentUser!.uid;
    try {
      statusRequest=StatusRequest.lodaing;
      update();
      print('Success fetching users:');
      print('==========================');
      print(doctorId);
      print('==========================');

      QuerySnapshot querySnapshot = await firestore
          .collection('ratings')
          .where('doctorId', isEqualTo: userId)
          .get();

      rating = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      statusRequest=StatusRequest.none;
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
    }
    update();
  }
  @override
  void onInit() {
    fetchRating();
    super.onInit();
  }
}