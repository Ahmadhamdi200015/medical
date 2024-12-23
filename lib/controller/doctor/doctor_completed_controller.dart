import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:googleapis/authorizedbuyersmarketplace/v1.dart';
import 'package:uuid/uuid.dart';

import '../../core/function/notification_helper.dart';
import '../../core/function/staterequest.dart';

class DoctorCompletedController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  var rating = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها

  StatusRequest statusRequest=StatusRequest.none;
  String? doctorName;
  String? doctorRole;
  String?doctorId;

  final uuid = Uuid();


  List<Map<String, dynamic>> appointments=[];
  List<Map<String, dynamic>> appointmentsPending=[];

// Controller لتخزين الوقت المحدد
  TimeOfDay? selectedTime;
  TimeOfDay? timeEnd;

  Future<void> fetchAppointmentsCompleted() async {
    String userId=auth.currentUser!.uid;
    try {
      statusRequest=StatusRequest.lodaing;
      update();

      // جلب الحجوزات
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: userId) // تصفية على معرف الطبيب
          .where('appointmentStatus', isEqualTo: 'completed')
          .orderBy('createdAt', descending: true) // ترتيب من الأحدث إلى الأقدم
          .get();

      // تحويل البيانات إلى قائمة من الخرائط
      appointments = querySnapshot.docs.map((doc) {
        return {
          'appointmentId': doc.id,
          'doctorId': doc['doctorId'],
          'patientId':doc['patientId'],
          'appointmentId':doc['appointmentId'],
          'patientName': doc['patientName'],
          'appointmentTime': doc['appointmentTime'],
          'appointmentEnd': doc['appointmentEnd'],
          'createdAt': doc['createdAt'],
        };
      }).toList();
      statusRequest=StatusRequest.none;
      update();
      print('Success fetching appointments');
    } catch (e) {
      print('Error fetching appointments: $e');
    }
    update();

  }
  @override
  void onInit() {
    fetchAppointmentsCompleted();
    super.onInit();
  }
}