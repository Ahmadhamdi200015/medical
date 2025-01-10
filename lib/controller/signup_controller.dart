import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicall/core/constant/route.dart';
import 'package:medicall/core/function/staterequest.dart';

import '../core/function/uploadfile.dart';

class SignupController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;  // تهيئة FirebaseAnalytics


  List<SelectedListItem> specialties = [];
  File? file;
  StatusRequest statusRequest=StatusRequest.none;

  GlobalKey<FormState> formState = GlobalKey();
  late TextEditingController catId;
  late TextEditingController catName;
  TextEditingController? nameController;
  late  TextEditingController emailController;
  late  TextEditingController passwordController;

  int? verifyCode;

  // متغير لتخزين القيمة المختارة
  var selectedValue = 'patient';

  // دالة لتغيير القيمة
  void changeValue(value) {
    selectedValue = value;
    update();
  }

  chooseImageOfCamera() async {
    file = await imageUploadCamera();
    update();
  }

  chooseImageFromGallery() async {
    file = await fileUploadGallery(false);
    update();
  }

  optionImageSelected() async {
    file =
        await showOptionMenuImage(chooseImageOfCamera, chooseImageFromGallery);
  }


  Future<void> logEventToFirestore(String eventType) async {
    DocumentReference eventRef = firestore.collection('admin_events').doc(eventType);

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(eventRef);

      if (!snapshot.exists) {
        // إذا لم يكن المستند موجودًا، قم بإنشائه
        transaction.set(eventRef, {
          'eventType': eventType,
          'count': 1,
          'lastUpdated': DateTime.now(),
        });
        await _analytics.logEvent(
          name: eventType,
          parameters:{
            'email': emailController.text.trim(),
            'Sign_status': 'success',
          },
        );
      } else {
        await _analytics.logEvent(
          name: eventType,
          parameters:{
            'email': emailController.text.trim(),
            'Sign_status': 'success',
          },
        );
        // إذا كان المستند موجودًا، قم بتحديث العدد وتاريخ التحديث
        int currentCount = snapshot.get('count');
        transaction.update(eventRef, {
          'count': currentCount + 1,
          'lastUpdated': DateTime.now(),
        });
      }
    }).catchError((error) {
      print("Failed to log event: $error");
    });
  }


  Future<int> generateUniqueRandomNumber() async {
    final random = Random();
    int randomNumber = random.nextInt(100000); // توليد رقم بين 0 و 999,999

    // التحقق إذا كان الرقم موجودًا بالفعل في قاعدة البيانات
    final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('verifyCode', isEqualTo: randomNumber)
        .get();

    // إذا كان الرقم موجودًا، حاول مرة أخرى
    if (userSnapshot.docs.isNotEmpty) {
      return generateUniqueRandomNumber();
    }

    return randomNumber;
  }



  // وظيفة لإضافة بيانات إلى الكولكشن
  Future<void> addUser(String userId, String email, String role, String name,
      String fcmToken,String catName,String file) async {
    try {
      if(selectedValue=='doctor'&& file.toString().isNotEmpty){
        String cleanedFilePath = file.replaceFirst("File: ", "").replaceAll("'", "");

        await firestore.collection('Users').doc(userId).set({
          'id': userId,
          'name': name,
          'email': email,
          'role': role, // مثل: patient, doctor, admin
          'status': 'pending',
          'file':cleanedFilePath,
          'fcmToken': fcmToken,
          'specialty':catName,
          'specialtyId': catId.text,
          'approval':'0',
          'verifyCode':verifyCode.toString(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }else{

        await firestore.collection('Users').doc(userId).set({
          'id': userId,
          'name': name,
          'email': email,
          'role': role, // مثل: patient, doctor, admin
          'status': 'pending',
          'file':'',
          'fcmToken': fcmToken,
          'specialty':'',
          'specialtyId': '',
          'approval':'0',
          'verifyCode':verifyCode.toString(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      print('User added successfully!');
    } catch (e) {
      print('Error adding user: $e');
    }
  }
  Future<String> getUserNameById(String userId) async {
    try {
      // الوصول إلى مجموعة المستخدمين
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
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

  Future<void> addSpecialtyAutoId(String specialtyName, String doctorIds,String nameDoctor) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // إضافة وثيقة جديدة بتخصص ومعرف يتم إنشاؤه تلقائيًا
      await firestore.collection('specialties').add({
        'id':doctorIds,
        'specialty': specialtyName,
        'doctors': nameDoctor,
      });

      print('تمت إضافة التخصص بنجاح بمعرف تلقائي!');
    } catch (e) {
      print('حدث خطأ: $e');
    }
  }

  Future<void> addDoctorToCategory(String categoryId, String doctorName, String doctorId, String doctorEmail) async {
    final doctorsRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .collection('doctors');

    await doctorsRef.add({
      'doctorName': doctorName,
      'doctorId': doctorId,
      'doctorEmail': doctorEmail,
      'createdAt': DateTime.now(),
    });
  }



  Future<String?> getCategoryIdByName(String categoryName) async {
    final categoriesRef = FirebaseFirestore.instance.collection('categories');

    final querySnapshot = await categoriesRef
        .where('name', isEqualTo: categoryName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // إرجاع معرّف الوثيقة
    } else {
      print("Category not found");
      return null;
    }
  }



  Future<void> signUpWithEmailPassword() async {
    statusRequest=StatusRequest.lodaing;
    update();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await logEventToFirestore('signUp');
      if(selectedValue=='doctor'){
        try {
        await  addDoctorToSpecialty(catId.text,auth.currentUser!.uid,nameController!.text,emailController.text);
          print('تمت إضافة التخصص بنجاح!');
        } catch (e) {
          print('حدث خطأ: $e');
        }
      }
      // الحصول على FCM Token
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      addUser(auth.currentUser!.uid, emailController.text, selectedValue,
          nameController!.text, fcmToken!,selectedValue=='doctor'? catName.text:"",file.toString());
      Get.toNamed(AppRoute.login);
    } catch (e) {
      print('Error: $e');
    }
    update();
  }



  Future<List<Map<String, dynamic>>> getSpecialties() async {
    try {
      // استعلام لجلب كل التخصصات من كولكشن "Specialties"
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('specialties').get();

      // تحويل الوثائق إلى قائمة من الخرائط (List of Maps)
      List<Map<String, dynamic>> specialties = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // معرف الوثيقة
          ...doc.data() as Map<String, dynamic> // بيانات الوثيقة
        };
      }).toList();

      return specialties;
    } catch (e) {
      print('Error fetching specialties: $e');
      return [];
    }
  }


  Future<void> fetchSpecialties() async {
    List<Map<String, dynamic>> specialtiesData = await getSpecialties();
    specialties = specialtiesData.map((item) {
      return SelectedListItem(
        name: item['name'],
        value: item['id'],
      );
    }).toList();
    update();
  }


  Future<void> addDoctorToSpecialty(
      String specialtyId, String doctorId, String doctorName, String doctorEmail) async {
    try {
      // تحديد موقع Subcollection الأطباء داخل التخصص
      final doctorsRef = FirebaseFirestore.instance
          .collection('specialties')
          .doc(specialtyId) // معرّف التخصص
          .collection('doctors');

      // إضافة بيانات الطبيب
      await doctorsRef.doc(doctorId).set({
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorEmail': doctorEmail,
        'doctorSpecialty':catName.text,
        'doctorStatus':'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Doctor added successfully to specialty!');
    } catch (e) {
      print('Error adding doctor to specialty: $e');
    }
  }

  goToLoginPage() {
    Get.toNamed(AppRoute.login);
  }

  @override
  void onInit()async {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    catId = TextEditingController();
    catName = TextEditingController();
    verifyCode= await generateUniqueRandomNumber();
    await fetchSpecialties();
    super.onInit();
  }
}

