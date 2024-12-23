import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:medicall/core/function/notification_helper.dart';

import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/auth_io.dart';

import 'dart:typed_data';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AdminHomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  NotificationsHelper notificationsHelper = NotificationsHelper();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;  // التعديل هنا


  var users = <Map<String, dynamic>>[]; // قائمة للمستخدمين يمكن مراقبتها
  var isLoading = true; // متغير لمراقبة حالة التحميل



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

  Future<void> sendEmail(String status) async {
  // إذا كان لدينا توكن موجود، نقوم باستخدامه
  var accessToken = await _secureStorage.read(key: 'accessToken');

  if (accessToken == null) {
  // في حال لم يكن لدينا توكن، نطلب المصادقة من المستخدم
  var client = await _authenticate();
  var gmailApi = gmail.GmailApi(client);

  final message = gmail.Message()
  ..raw = base64UrlEncode(utf8.encode(
  'To: elkahloutahmad5@gmail.com\nSubject: Medical Email\n\nHello,\n this is a email sent from Medical App to know that your Request $status!'));

  // إرسال البريد
  await gmailApi.users.messages.send(message, 'me');
  print("Email Sent!");
  } else {
  // إذا كان لدينا توكن صالح، نستخدمه
  var client = await _getAuthenticatedClient(accessToken);
  var gmailApi = gmail.GmailApi(client);

  final message = gmail.Message()
  ..raw = base64UrlEncode(utf8.encode(
  'To: elkahloutahmad5@gmail.com\nSubject: Medical Email\n\nHello,\n this is a email sent from Medical App to know that your Request $status!'));

  // إرسال البريد
  await gmailApi.users.messages.send(message, 'me');
  print("Email Sent!");
  }
  }

  // مصادقة OAuth 2.0
  Future<http.Client> _authenticate() async {
  var clientId = ClientId(_clientId, _clientSecret);
  var flow = await clientViaUserConsent(clientId, _scopes, (url) async {
  // فتح الرابط في المتصفح للموافقة
  await launch(url);
  });

  // حفظ التوكن
  await _secureStorage.write(
  key: 'accessToken', value: flow.credentials.accessToken.data);
  var credentials = flow.credentials;
  var client = authenticatedClient(http.Client(), credentials);

  return client;
  }

  // الحصول على عميل مصدق باستخدام التوكن الحالي
  Future<http.Client> _getAuthenticatedClient(String accessToken) async {
  // تأكد من تحويل التاريخ إلى UTC
  var credentials = AccessCredentials(
  AccessToken(
  'Bearer',
  accessToken,
  DateTime.now().toUtc().add(const Duration(hours: 1)) // تحويل التاريخ إلى UTC
  ),
  '',
  _scopes,
  );

  var client = authenticatedClient(http.Client(), credentials);
  return client;
  }


// دالة لتحديث حالة الطبيب إلى "مقبول"
  Future<void> acceptDoctor(String doctorId,String specialtyID) async {
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
      print('Error accepting doctor: $e');
    }
  }

  // قبول الطلب
  Future<void> acceptRequest(String userId) async {
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

      if (fcmToken != null) {
        await sendEmail('Accepted');
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
      print('Error accepting request: $e');
      Get.snackbar('Error', 'Failed to accept user request.');
    }
  }

  // رفض الطلب
  Future<void> rejectRequest(String userId) async {
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

      if (fcmToken != null) {
        await sendEmail('rejected');
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
      print('Error rejecting request: $e');
      Get.snackbar('Error', 'Failed to reject user request.');
    }
  }



  @override
  void onInit()async {
    fetchPendingUsers();
    super.onInit();
  }
}
