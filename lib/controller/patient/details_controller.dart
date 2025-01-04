import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/function/staterequest.dart';
import 'package:uuid/uuid.dart';

import '../../core/function/notification_helper.dart';
import '../../core/services/service.dart';

class DetailsController extends GetxController  with GetSingleTickerProviderStateMixin{
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

goToMessagePage(){
  Get.toNamed(AppRoute.messagePage);
}
  List<Map<String, dynamic>> appointments=[];
  List<Map<String, dynamic>> appointmentsPending=[];

// Controller لتخزين الوقت المحدد
  TimeOfDay? selectedTime;
  TimeOfDay? timeEnd;



  Future<void> deleteAppointmentById(String appointmentId) async {
    try {
      statusRequest=StatusRequest.lodaing;
      update();
      // استعلام للعثور على الوثيقة بناءً على معرف الحجز (appointmentId)
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('appointmentId', isEqualTo: appointmentId.toString())
          .get();

      // التحقق من وجود الوثيقة
      if (querySnapshot.docs.isNotEmpty) {
        // حذف الوثيقة الأولى التي تتوافق مع الشرط
        await querySnapshot.docs.first.reference.delete();
        statusRequest=StatusRequest.none;
        update();
        print('Appointment deleted successfully');
      } else {
        print('No appointment found with this ID');
      }
    } catch (e) {
      print('Error deleting appointment: $e');
    }
    update();
  }




  Future<void> fetchAppointmentsLast24Hours() async {
    String userName=auth.currentUser!.uid;
    try {
      statusRequest=StatusRequest.lodaing;
      update();
      // حساب الوقت قبل 12 ساعة
      DateTime twelveHoursAgo = DateTime.now().subtract(const Duration(hours: 24));

      // جلب الحجوزات
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId) // تصفية على معرف الطبيب
          .where('createdAt', isGreaterThanOrEqualTo: twelveHoursAgo) // الوقت خلال آخر 12 ساعة
          .where('appointmentStatus', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true) // ترتيب من الأحدث إلى الأقدم
          .get();

      // تحويل البيانات إلى قائمة من الخرائط
      appointments = querySnapshot.docs.map((doc) {
        return {
          'appointmentId': doc.id,
          'doctorId': doc['doctorId'],
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


  Future<void> fetchAppointmentsPendingLast12Hours() async {
    userId=myService.sharedPrefrences.getString('userId');

    try {
      statusRequest=StatusRequest.lodaing;
      update();
      // حساب الوقت قبل 12 ساعة
      DateTime twelveHoursAgo = DateTime.now().subtract(const Duration(hours: 12));

      // جلب الحجوزات
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId) // تصفية على معرف الطبيب
          .where('appointmentStatus',isEqualTo: 'pending')
          .where('patientId',isEqualTo: userId)
          .orderBy('createdAt', descending: true) // ترتيب من الأحدث إلى الأقدم
          .get();

      // تحويل البيانات إلى قائمة من الخرائط
      appointmentsPending = querySnapshot.docs.map((doc) {
        return {
          'appointmentId': doc.id,
          'doctorId': doc['doctorId'],
          'doctorName':doc['doctorName'],
          'specialty':doc['specialty'],
          'appointmentId':doc['appointmentId'],
          'appointmentStatus':doc['appointmentStatus'],
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





  // جلب المستخدمين الذين دورهم ليس admin وحالتهم pending
  Future<void> fetchRating() async {
    try {
      print('Success fetching users:');
      print('==========================');
      print(doctorId);
      print('==========================');

      QuerySnapshot querySnapshot = await firestore
          .collection('ratings')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      rating = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
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


  Future<void> bookAppointment() async {
    try {
      userId=myService.sharedPrefrences.getString('userId').toString();
      String userName = await getUserNameById(userId!);
      String appointmentId = uuid.v4();

      // مرجع المواعيد
      final appointmentsRef = FirebaseFirestore.instance.collection('appointments');

      // التحقق من التداخل الزمني
      final querySnapshot = await appointmentsRef
          .where('doctorId', isEqualTo: doctorId)
          .get();

      bool isConflict = false; // متغير للتحقق من التداخل
      for (var doc in querySnapshot.docs) {
        final existingStartTime = _timeOfDayFromString(doc['appointmentTime']);
        final existingEndTime = _timeOfDayFromString(doc['appointmentEnd']);

        if (_isTimeConflict(existingStartTime, existingEndTime, selectedTime!, timeEnd!)) {
          isConflict = true;
          break;
        }
      }

      if (!isConflict) {
        // إذا لم يكن هناك تداخل
        await appointmentsRef.add({
          'appointmentId':appointmentId,
          'doctorId': doctorId,
          'doctorName': doctorName,
          'patientId': userId,
          'patientName': userName,
          'specialty': doctorRole,
          'appointmentTime': '${selectedTime!.hour}:${selectedTime!.minute}',
          'appointmentEnd': '${timeEnd!.hour}:${timeEnd!.minute}',
          'appointmentStatus': 'pending',
          'createdAt': DateTime.now(),
        });
        fetchAppointmentsLast24Hours();
        Get.snackbar('Done', 'Appointment booked successfully!');
      } else {
        Get.snackbar('Warning', 'This time slot is already taken by another patient.');
      }
    } catch (e) {
      print('Error booking appointment: $e');
    }
  }

  TimeOfDay _timeOfDayFromString(String timeString) {
    final parts = timeString.split(':');
    if (parts.length == 2) {
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } else {
      throw const FormatException("Invalid time format");
    }
  }

  bool _isTimeConflict(TimeOfDay existingStart, TimeOfDay existingEnd, TimeOfDay newStart, TimeOfDay newEnd) {
    final existingStartInMinutes = existingStart.hour * 60 + existingStart.minute;
    final existingEndInMinutes = existingEnd.hour * 60 + existingEnd.minute;
    final newStartInMinutes = newStart.hour * 60 + newStart.minute;
    final newEndInMinutes = newEnd.hour * 60 + newEnd.minute;

    return (newStartInMinutes < existingEndInMinutes && newEndInMinutes > existingStartInMinutes);
  }


  // دالة لإضافة الدقائق إلى وقت معين
  TimeOfDay addMinutesToTime(TimeOfDay time, int minutesToAdd) {
    int totalMinutes = time.hour * 60 + time.minute + minutesToAdd;
    int hours = (totalMinutes ~/ 60) % 24; // التأكد من عدم تجاوز 24 ساعة
    int minutes = totalMinutes % 60;

    return TimeOfDay(hour: hours, minute: minutes);
  }

  // دالة تعرض الـ TimePicker
  Future<void> showTimePickerDialog(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // تخصيص الثيم
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      selectedTime = pickedTime;
      timeEnd=addMinutesToTime(pickedTime,30);
    }
  }



  late TabController tabController;
  bool isExpanded=true;

  void toggleExpanded() {
    isExpanded = !isExpanded;
    update();
  }

  @override
  void onInit() {
    doctorId=Get.arguments['doctorId'];
    doctorName=Get.arguments['doctorName'];
    doctorRole=Get.arguments['doctorRole'];
    fetchAppointmentsLast24Hours();
    fetchAppointmentsPendingLast12Hours();
    fetchRating();
    tabController = TabController(length: 2, vsync: this); // Adjust the length based on tabs

    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}