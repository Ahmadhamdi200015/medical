import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/core/constant/route.dart';

import 'package:medicall/core/function/notification_helper.dart';

import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/auth_io.dart';

import 'dart:typed_data';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/core/function/staterequest.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminHomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;  // التعديل هنا
  StatusRequest statusRequest=StatusRequest.none;
  var users = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها
  var isLoading = true; // متغير لمراقبة حالة التحميل
  var currentUser = Rx<GoogleSignInAccount?>(null); // المستخدم الحالي
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/gmail.send'],
  );
  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in: $e');
    }
  }

  goToDetailsPage(String fileName){
    Get.toNamed(AppRoute.adminDetails,arguments: {
      'fileName':fileName
    });
  }

  Future<String?> getUserFcm(String userId) async {
    try {
      // استدعاء مجموعة "users" من Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      // التحقق من وجود المستند
      if (userDoc.exists) {
        // جلب اسم المستخدم من المستند
        String fcmToken = userDoc[
            'fcmToken']; // تأكد من أن الحقل الذي يحتوي على الاسم هو 'name'
        return fcmToken;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }

  // جلب المستخدمين الذين دورهم ليس admin وحالتهم pending
  Future<void> fetchPendingUsers() async {
    try {
      isLoading = true;
      QuerySnapshot querySnapshot = await firestore
          .collection('Users')
          .where('role', isNotEqualTo: 'admin')
          .where('status', isEqualTo: 'pending') // المستخدمون قيد الانتظار فقط
          .get();

      users = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading = false;
    }
    update();
  }



  final String _clientId =
  '759054847464-idougv1ri8dmh2ituduhurs78bou22r9.apps.googleusercontent.com'; // ضع هنا Client ID الخاص بك
  final String _clientSecret =
  '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'; // ضع هنا Client Secret الخاص بك
  final List<String> _scopes = ['https://www.googleapis.com/auth/gmail.send'];

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();


  Future<void> sendEmail(String status,String email,String verifyCode) async {
    try {
      if (currentUser.value == null) {
        await signIn();
      }

      final authHeaders = await currentUser.value!.authHeaders;
      final accessToken = authHeaders['Authorization']!.split(' ')[1];

      // إعداد الرسالة
      final message = base64Url.encode(utf8.encode(
          'To: $email\n'
              'Subject: Medical Email\n\n'
              'Hello,\nThis is an email sent from Medical App to notify you that your Request is $status.\n verifyCode is $verifyCode'));

      final url = Uri.parse('https://www.googleapis.com/gmail/v1/users/me/messages/send');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'raw': message}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Email sent successfully!');
      } else {
        Get.snackbar('Error', 'Failed to send email: ${response.body}');
      }
    } catch (error) {
      Get.snackbar('Error', 'Error sending email: $error');
    }
  }
  // وظيفة لاسترجاع بيانات المستخدم والتحقق من دوره
  Future<String?> getUserVerifyCode(String userId) async {
    try {
      // جلب بيانات المستخدم بناءً على الـ User ID
      DocumentSnapshot userDoc =
      await firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        // الحصول على حقل role
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String status = userData['verifyCode']; // قيم مثل: patient, doctor, admin
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

// دالة لتحديث حالة الطبيب إلى "مقبول"
  Future<void> acceptDoctor(String doctorId,String specialtyID) async {
    statusRequest=StatusRequest.lodaing;
    update();
    try {
      // تحديث حالة الطبيب إلى "مقبول"
      await FirebaseFirestore.instance
          .collection('specialties')
          .doc(specialtyID) // هنا ضع id التخصص
          .collection('doctors')
          .doc(doctorId)
          .update({
        'doctorStatus': 'accepted', // تحديث الحقل status إلى "accepted"
      });
      print('تم تحديث حالة الطبيب إلى مقبول');
    } catch (e) {
      statusRequest=StatusRequest.none;
      update();
      print('Error accepting doctor: $e');
    }
    update();
  }

  // قبول الطلب
  Future<void> acceptRequest(String userId,String email) async {
    statusRequest=StatusRequest.lodaing;
    update();
    try {
      await firestore.collection('Users').doc(userId).update({
        'status': 'accepted',
      });
      // الحصول على توكن المستخدم
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      String? fcmToken = userDoc.get('fcmToken');

      String? verifyCode=await getUserVerifyCode(userId);
      if (fcmToken != null) {
        await sendEmail('Accepted',email,verifyCode!);
        // إرسال الإشعار
        await notificationsHelper.sendNotifications(
          fcmToken: fcmToken, // ضع FCM Token هنا
          title: " Success", // عنوان الإشعار
          body: "User request accepted!", // محتوى الإشعار
          userId: userId, // معرّف المستخدم المرتبط
        );
      }
      fetchPendingUsers(); // تحديث القائمة بعد القبول
      Get.snackbar('Success', 'User request accepted!');
    } catch (e) {
      statusRequest=StatusRequest.none;
      update();
      print('Error accepting request: $e');
      Get.snackbar('Error', 'Failed to accept user request.');
    }
    update();
  }

  // رفض الطلب
  Future<void> rejectRequest(String userId,String email) async {
    statusRequest=StatusRequest.lodaing;
    update();
    try {
      await firestore.collection('Users').doc(userId).update({
        'status': 'rejected',
      });
      // الحصول على توكن المستخدم
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      String? fcmToken = userDoc.get('fcmToken');
      String? verifyCode=await getUserVerifyCode(userId);

      if (fcmToken != null) {
        await sendEmail('rejected',email,verifyCode!);
        // إرسال الإشعار
        await notificationsHelper.sendNotifications(
          fcmToken: fcmToken, // ضع FCM Token هنا
          title: " Failed", // عنوان الإشعار
          body: "User request rejected!", // محتوى الإشعار
          userId: userId, // معرّف المستخدم المرتبط
        );
      }
      fetchPendingUsers(); // تحديث القائمة بعد الرفض
      Get.snackbar('Failed', 'User request rejected!');
    } catch (e) {
      statusRequest=StatusRequest.none;
      update();
      print('Error rejecting request: $e');
      Get.snackbar('Error', 'Failed to reject user request.');
    }
    update();
  }



  @override
  void onInit()async {
    fetchPendingUsers();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      currentUser.value = account;
    });
    _googleSignIn.signInSilently(); // تسجيل دخول تلقائي إذا كان المستخدم قد سجل مسبقًا
    super.onInit();
  }
}
