import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medicall/core/function/staterequest.dart';
import 'package:medicall/core/services/service.dart';

import '../../core/class/fire_service.dart';
import '../../core/constant/route.dart';
import '../../core/stripe_payment/payment_manger.dart';

class MessagePageController extends GetxController {
  final fireS = FireServices();
  List friends = [];
  bool isLoading = true;
  String? lastMessage;
  bool? isStatus;
  MyService myService = Get.find();
  String? userId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;  // تهيئة FirebaseAnalytics

  StatusRequest statusRequest = StatusRequest.none;

  goToChat(receiverID, receiverName, bool isStatus) {
    Get.toNamed(AppRoute.chatPage, arguments: {
      'receiverID': receiverID,
      'receiverName': receiverName,
      'isStatus': isStatus,
    });
  }

  Future<bool?> getDoctorStatus(String documentId) async {
    statusRequest = StatusRequest.lodaing;
    update();
    try {
      // الوصول إلى مجموعة friend_requests
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(documentId)
          .get();

      if (document.exists) {
        // استخراج قيمة الحقل doctorStatus
        return document['doctorStatus'] as bool;
      } else {
        print('Document not found!');
        statusRequest = StatusRequest.none;
        update();
        return null; // إذا لم يتم العثور على المستند
      }
    } catch (e) {
      print('Error: $e');
      statusRequest = StatusRequest.none;
      update();
      return null; // في حال حدوث خطأ
    }
  }

  Future<void> logEventToFirestore(String eventType) async {
    DocumentReference eventRef =
        firestore.collection('admin_events').doc(eventType);

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
            'payment_status': 'success',
          },
        );
      } else {
        await _analytics.logEvent(
          name: eventType,
          parameters:{
            'payment_status': 'success',
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

  payForService(String requestId) async {
    try {
      bool checkPayment = await PaymentManger.makePayment(10, "USD");
      if (checkPayment == true) {
        await logEventToFirestore('payment');

        openMessage(requestId);
        statusRequest = StatusRequest.lodaing; // تصحيح اسم الحالة
        update();
        Get.snackbar("Done", " payment process is Success");
      } else {
        Get.snackbar(
            "Error", "An error occurred during payment process is Failed");
        print('false');
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "An error occurred during payment process");
    }

    update(); // تأكد من استدعاء update فقط عند الانتهاء
  }

  // قبول الطلب
  void openMessage(String requestId) async {
    statusRequest = StatusRequest.lodaing;
    update();
    try {
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .update({
        'doctorStatus': true,
      });
      friends.clear();
      fetchFriends();
    } catch (e) {
      statusRequest = StatusRequest.none;
      update();
      print(e);
    }
    statusRequest = StatusRequest.none;
    update();
  }

  // قبول الطلب
  void closeMessage(String requestId) async {
    statusRequest = StatusRequest.lodaing;
    update();
    try {
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc(requestId)
          .update({
        'doctorStatus': false,
      });
      friends.clear();
      fetchFriends();
    } catch (e) {
      statusRequest = StatusRequest.none;
      update();
      print(e);
    }
    statusRequest = StatusRequest.none;
    update();
  }

  changeStatus(val) {
    isStatus = val;
    update();
  }

  Future<DocumentSnapshot> getUser(receiverID) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(
            'Users') // استبدل 'users' باسم جدول المستخدمين لديك إذا كان مختلفاً
        .doc(receiverID) // استخدم المعرف هنا لجلب المستخدم المحدد
        .get();
    return userDoc;
  }

  void fetchFriends() async {
    userId = myService.sharedPrefrences.getString('userId').toString();

    statusRequest = StatusRequest.lodaing;
    update();

    var receiverQuery = FirebaseFirestore.instance
        .collection('friend_requests')
        .where('status', isEqualTo: 'accepted')
        .where('receiverID', isEqualTo: userId)
        .get();

    var senderQuery = FirebaseFirestore.instance
        .collection('friend_requests')
        .where('status', isEqualTo: 'accepted')
        .where('senderID', isEqualTo: userId)
        .get();

    // تنفيذ الاستعلامين معًا ودمج النتائج
    await Future.wait([receiverQuery, senderQuery]).then((snapshots) {
      friends.addAll(snapshots[0].docs);
      friends.addAll(snapshots[1].docs);
    });
    statusRequest = StatusRequest.none;
    update();
  }

  @override
  void onInit() {
    fetchFriends();
    super.onInit();
  }
}

