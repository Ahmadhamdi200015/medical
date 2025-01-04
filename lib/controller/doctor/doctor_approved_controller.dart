import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:googleapis/authorizedbuyersmarketplace/v1.dart';
import 'package:medicall/core/services/service.dart';
import 'package:uuid/uuid.dart';

import '../../core/function/notification_helper.dart';
import '../../core/function/staterequest.dart';

class DoctorApprovedController extends GetxController{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  var rating = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها

  StatusRequest statusRequest=StatusRequest.none;
  String? doctorName;
  String? doctorRole;
  String?doctorId;
  MyService myService=Get.find();
  String? userId;

  final uuid = Uuid();


  List<Map<String, dynamic>> appointments=[];
  List<Map<String, dynamic>> appointmentsPending=[];

// Controller لتخزين الوقت المحدد
  TimeOfDay? selectedTime;
  TimeOfDay? timeEnd;

  Future<void> fetchAppointmentsApproved() async {
    userId=myService.sharedPrefrences.getString('userId').toString();

    try {
      statusRequest=StatusRequest.lodaing;
      update();

      // جلب الحجوزات
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: userId) // تصفية على معرف الطبيب
          .where('appointmentStatus', isEqualTo: 'approved')
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
      statusRequest=StatusRequest.none;
      update();
      print('Error fetching appointments: $e');
    }
    update();

  }



  Future<void> approveAppointment(String appointmentId) async {
    try {
      statusRequest=StatusRequest.lodaing;
      update();
      // البحث عن الوثيقة بناءً على appointmentId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('appointmentId', isEqualTo: appointmentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // جلب أول مستند من نتائج الاستعلام
        final doc = querySnapshot.docs.first;

        // تحديث الوثيقة باستخدام معرف الوثيقة
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(doc.id)
            .update({
          'appointmentStatus': 'completed',
          'updatedAt': DateTime.now(),
        });
        fetchAppointmentsApproved();
        print('تم تحديث حالة الموعد بنجاح إلى: completed');
      } else {
        print('لم يتم العثور على الموعد.');
      }
    } catch (e) {
      statusRequest=StatusRequest.none;
      update();
      print('حدث خطأ أثناء تحديث حالة الموعد: $e');
    }
    update();
  }



  Future<void> rejectAppointment(String appointmentId) async {
    try {
      statusRequest=StatusRequest.lodaing;
      update();
      // البحث عن الوثيقة بناءً على appointmentId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('appointmentId', isEqualTo: appointmentId)
          .get();
      fetchAppointmentsApproved();
      if (querySnapshot.docs.isNotEmpty) {
        // جلب أول مستند من نتائج الاستعلام
        final doc = querySnapshot.docs.first;
        // تحديث الوثيقة باستخدام معرف الوثيقة
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(doc.id)
            .update({
          'appointmentStatus': 'rejected',
          'updatedAt': DateTime.now(),
        });
        statusRequest=StatusRequest.none;
        update();
        print('تم تحديث حالة الموعد بنجاح إلى: rejected');
      } else {
        print('لم يتم العثور على الموعد.');
      }
    } catch (e) {
      print('حدث خطأ أثناء تحديث حالة الموعد: $e');
    }
    update();
  }


  @override
  void onInit() {
    fetchAppointmentsApproved();
    super.onInit();
  }

}