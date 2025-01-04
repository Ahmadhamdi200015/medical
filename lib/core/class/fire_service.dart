
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/model/message.dart';
import '../constant/route.dart';



class FireServices {
  // Instant of FireBase
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? getCurrentUser(){
    return auth.currentUser;
  }

  //Sign In
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  // تسجيل الدخول باستخدام Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // المستخدم ألغى التسجيل
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // إنشاء Credential باستخدام بيانات الـ Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول باستخدام popup
      await auth.signInWithCredential(credential);
      await Get.offAllNamed(AppRoute.homePage);

    } catch (e) {
      print("Error signing in: $e");
    }
  }



  //Sign Up
  Future<UserCredential> signUpWithEmailPassword(String email, password,name) async {
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      firebaseFirestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email,'name':name});
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Sign Out

  Future<void> signOut() async {
    return await auth.signOut();
  }

//================================================Chat=============================

  Stream<List<Map<String, dynamic>>> getUserEmail() {
    return firebaseFirestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, message,file) async {
    // getCurrent User info
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

// create a new message

    Message newMessage = Message(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        edited:false,
        isRead: false,
        file: file,
        timestamp: timestamp);

    //construct chat room id for the tow users sorted to ensure uniqueness!

    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    //add new message to database

    await firebaseFirestore
        .collection("chats")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return firebaseFirestore
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  //==================================add friends=====================================

  Future<void> sendFriendRequest(String friendUserId, friendEmail,receiverName,senderName) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;
      String currentUserEmail = currentUser.email!;

      // تحقق إذا كانت العلاقة موجودة بالفعل
      DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc('${currentUserId}_$friendUserId')
          .get();

      if (!friendSnapshot.exists) {
        // إنشاء علاقة طلب صداقة
        await FirebaseFirestore.instance
            .collection('friend_requests')
            .doc('${currentUserId}_$friendUserId')
            .set({
          'senderID': currentUserId,
          'receiverID': friendUserId,
          'receiverName': receiverName,
          'senderName': senderName,
          'doctorStatus':false,
          'status': 'pending',
        });

      } else {
        print("Friend request already sent.");
      }
    }
  }

  Future<void> acceptFriendRequest(String friendUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      // تحديث العلاقة إلى "accepted"
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc('${currentUserId}_$friendUserId')
          .update({
        'status': 'accepted',
      });

      await FirebaseFirestore.instance
          .collection('friends')
          .doc('${currentUserId}_$friendUserId')
          .set({
        'sender_id': currentUserId,
        'receiver_id': friendUserId,
        'friends_ids':[friendUserId],
      });

      // تحديث العلاقة في الاتجاه الآخر
      await FirebaseFirestore.instance
          .collection('friend_request')
          .doc('${friendUserId}_$currentUserId')
          .update({
        'status': 'accepted',
      });
    }
  }

  Future<void> rejectFriendRequest(String friendUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String currentUserId = currentUser.uid;

      // تحديث الحالة إلى "rejected"
      await FirebaseFirestore.instance
          .collection('friend_request')
          .doc('${currentUserId}_$friendUserId')
          .update({
        'status': 'rejected',
      });

      // تحديث العلاقة في الاتجاه الآخر
      await FirebaseFirestore.instance
          .collection('friend_request')
          .doc('${friendUserId}_$currentUserId')
          .update({
        'status': 'rejected',
      });
    }
  }
}
