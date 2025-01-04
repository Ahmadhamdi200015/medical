import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/function/staterequest.dart';
import 'package:medicall/core/services/service.dart';

import '../../core/class/fire_service.dart';
import '../../core/function/notification_helper.dart';

class PatientController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool isSearch = false;
  bool exists=false;
  MyService myService=Get.find();
  String? userId;

   int? selectedCat;




  final fireS = FireServices();
  String? senderName;
  String? senderId;
  late TextEditingController doctorSearch;
  String tipText = '';
  List specialties = [];
  List doctorsNames = [];
  List doctors = [];
  StatusRequest statusRequest = StatusRequest.none;

  var users = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها


  changeChoose(val) {
    selectedCat = val;
    update();
  }
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

  goToMessagePage() {
    Get.toNamed(AppRoute.messagePage);
  }

  logOut() async {
    print(userId);
    myService.sharedPrefrences.clear();
    Get.offAllNamed(AppRoute.login);
  }

  checkSearch(val) {
    if (val == "" || RegExp(r"\s").hasMatch(doctorSearch.text)) {
      isSearch = false;
      update();
    } else {
      isSearch = true;
      update();
    }
    update();
  }




  onSearchItems() async {
    statusRequest = StatusRequest.lodaing;
    update();
    if (doctorSearch.text.isEmpty ||
        RegExp(r"\s").hasMatch(doctorSearch.text)) {
      print("===============nodata in search");
      isSearch = false;
      statusRequest = StatusRequest.none;
      update();
    } else {
      isSearch = true;
      doctorsNames.clear();
      await searchDoctorByName(doctorSearch.text);
      statusRequest = StatusRequest.none;
      update();
    }
    update();
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
      update();
      print('fetching specialties');
    } catch (e) {
      print('Error fetching specialties: $e');
    }
    update();
  }

  requestFriends(String receiverId, String receiverEmail, String receiverName) async{
    statusRequest = StatusRequest.lodaing;
    update();
    try {
    await  fireS.sendFriendRequest(
          receiverId, receiverEmail, receiverName, senderName);
      statusRequest = StatusRequest.none;
      Get.snackbar('Alert', 'friend request process success');
      update();
    } catch (e) {
      statusRequest = StatusRequest.none;
      update();
      print('error is :$e');
    }
    update();
  }

  Future<DocumentSnapshot> getUser() async {
    userId=myService.sharedPrefrences.getString('userId');
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(
            'Users') // استبدل 'users' باسم جدول المستخدمين لديك إذا كان مختلفاً
        .doc() // استخدم المعرف هنا لجلب المستخدم المحدد
        .get();
    senderName = userDoc['name'];
    senderId=userDoc['id'];
    return userDoc;
  }


  getAllDoctors() async {
    print("Fetching doctors...");

    // تأكد من إفراغ القائمة عند البداية
    doctors.clear();
    statusRequest = StatusRequest.lodaing;
    isSearch=false;
    update();

    try {
      isSearch=false;
      // الوصول إلى جميع التخصصات
      final QuerySnapshot specialtiesSnapshot =
          await FirebaseFirestore.instance.collection('specialties').get();

      // التكرار على جميع التخصصات
      for (var specialty in specialtiesSnapshot.docs) {
        // جلب مجموعة الأطباء داخل التخصص
        final QuerySnapshot doctorsSnapshot = await FirebaseFirestore.instance
            .collection('specialties')
            .doc(specialty.id)
            .collection('doctors')
            .where('doctorStatus', isEqualTo: 'accepted')
            .get();

        // إضافة الأطباء إلى القائمة
        doctors.addAll(doctorsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>));
      }
      statusRequest = StatusRequest.none;
    } catch (e) {
      print('Error fetching doctors: $e');
    }

    update();
  }

  Future<void> getDoctorsBySpecialty(String specialtyId) async {
    doctors.clear();
    statusRequest = StatusRequest.lodaing;
    update();
    try {
      final doctorsSnapshot = await FirebaseFirestore.instance
          .collection('specialties')
          .doc(specialtyId)
          .collection('doctors')
          .where('doctorStatus', isEqualTo: 'accepted')
          .get();

      // تحويل الوثائق إلى قائمة من الخرائط
      doctors = doctorsSnapshot.docs.map((doc) {
        return {
          'id': doc.id, // معرّف الطبيب
          ...doc.data(), // بيانات الطبيب
        };
      }).toList();
      statusRequest = StatusRequest.none;
      print('fetching doctors:');
    } catch (e) {
      print('Error fetching doctors: $e');
    }
    update();
  }

  Future<void> searchDoctorByName(String doctorName) async {
    statusRequest = StatusRequest.lodaing;
    update();
    try {
      // الوصول إلى جميع التخصصات
      final QuerySnapshot specialtiesSnapshot =
          await FirebaseFirestore.instance.collection('specialties').get();

      // التكرار على جميع التخصصات
      for (var specialty in specialtiesSnapshot.docs) {
        // جلب مجموعة الأطباء داخل التخصص
        final QuerySnapshot doctorsSnapshot = await FirebaseFirestore.instance
            .collection('specialties')
            .doc(specialty.id)
            .collection('doctors')
            .where('doctorName', isEqualTo: doctorName)
            .get();
        isSearch=true;

        // إضافة الأطباء إلى القائمة
        for (var doctor in doctorsSnapshot.docs) {
          doctorsNames.add(doctor.data() as Map<String, dynamic>);
          print(doctor['doctorName']);
        }
      }
    } catch (e) {
      statusRequest = StatusRequest.none;
      update();
      print('Error: $e');
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
    doctorSearch = TextEditingController();
    await getLastTip();
    _showDialog('Daily Advice', tipText);
    await fetchSpecialties();
    await getAllDoctors();
    await getLastTip();
    await getUser();


    super.onInit();
  }
}
