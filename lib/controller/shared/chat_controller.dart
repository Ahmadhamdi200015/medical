import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/class/fire_service.dart';
import '../../core/function/uploadfile.dart';

class ChatController extends GetxController {
  var messages = [];
  String? chatId;
  bool? isReceiverOnline;
  final fireS = FireServices();
  String? receiverID;
  bool isLoading = true;
  File? file;
  String? receiverName;
  late DateTime timeMessage;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool? isStatus;

  TextEditingController? messageController;
  bool isPressed = false;
  late ScrollController scrollController;
  TextEditingController? messageUpdate;
  String? senderId;
  var pressedMessageIndex = -1; // لتخزين مؤشر الرسالة المضغوط عليها

  void scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
    update();
  }

  var assets = <AssetEntity>[]; // قائمة الصور (قابلة للتحديث)

  Future<void> loadGalleryAssets() async {
    // طلب الأذونات
    final PermissionState permissionState =
        await PhotoManager.requestPermissionExtend();

    if (permissionState.isAuth) {
      // جلب ألبومات الصور
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image, // الحصول فقط على الصور
      );

      if (albums.isNotEmpty) {
        // تحميل الصور من الألبوم الأول
        List<AssetEntity> loadedAssets =
            await albums.first.getAssetListPaged(page: 0,size: 100); // حد أقصى 100 صورة
        assets.assignAll(loadedAssets); // تحديث قائمة الصور
      }
    } else {
      Get.snackbar('Permission Denied', 'We need access to your gallery.');
    }
  }

  void showDialog() {
    Get.dialog(
        AlertDialog(
          title: const Text('Image'),
          content: Text(
            file.toString(),
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
    loadGalleryAssets();

  }

  removeMessage(docId) {
    List<String> ids = [receiverID!, getCurrentUserId()];
    ids.sort();
    String chatRoomID = ids.join('_');
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .doc(docId)
        .delete();
  }

  updateMessage(docId, newMessage) {
    List<String> ids = [receiverID!, getCurrentUserId()];
    ids.sort();
    String chatRoomID = ids.join('_');
    // showBottomSheetCustom(context);
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .doc(docId)
        .set({'message': newMessage, 'edited': true, 'isRead': false},
            SetOptions(merge: true));
  }

  checkAccessMessage(docId) {
    List<String> ids = [receiverID!, getCurrentUserId()];
    ids.sort();
    String chatRoomID = ids.join('_');
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .doc(docId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        senderId = snapshot['senderId'];
        timeMessage = snapshot['timestamp'].toDate();
        update();
      }
    });
    update();
  }

  showBottomSheetCustom(context, String currentMessage, docId) {
    TextEditingController textController =
        TextEditingController(text: currentMessage);
    Get.bottomSheet(
      Container(
        color: Theme.of(context).colorScheme.secondary,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height / 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: textController,
                decoration:
                    const InputDecoration(hintText: "أدخل الرسالة الجديدة"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.green,
                  onPressed: () {
                    updateMessage(
                        docId, textController.text); // إرسال الرسالة الجديدة
                    resetPressed();
                    Get.back();
                    update();
                  },
                  child: const Text("تحديث",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.red,
                  onPressed: () {
                    resetPressed();
                    Get.back();
                    update();
                  },
                  child: const Text("الغاء",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    resetPressed();
    update();
  }

  void setPressedMessage(int index, docId, context) async {
    checkAccessMessage(docId);
    pressedMessageIndex = index;
    await Future.delayed(const Duration(milliseconds: 500));

    Duration difference = DateTime.now().difference(timeMessage);
    bool canDelete = difference.inMinutes < 30;

    await Future.delayed(const Duration(milliseconds: 500));
    if (senderId == getCurrentUserId() && canDelete) {
      Get.defaultDialog(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        confirm: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.green,
          onPressed: () {
            Get.back();
            showBottomSheetCustom(context, messages[index]['message'], docId);
            resetPressed();
          },
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.white),
          ),
        ),
        cancel: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.red,
          onPressed: () {
            removeMessage(docId);
            resetPressed();
            Get.back();
            update();
          },
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: "Choose Choice",
        middleText: "Choose what you want for message",
        barrierDismissible: true,
      );
    } else {
      Get.snackbar("خطأ", "لا يمكنك تحديث أو حذف هذه الرسالة.");
    }

    update();
  }

  void resetPressed() {
    pressedMessageIndex = -1;
    update(); // إعادة بناء الواجهة
  }

  String getCurrentUserId() {
    return auth.currentUser!.uid;
  }

  void sendMessage(receiverID, message,file) async {
    if(file.toString().isEmpty){
      await fireS.sendMessage(receiverID, message,'');
      scrollToBottom();
      update();
    }else{
      String cleanedFilePath = file.replaceFirst("File: ", "").replaceAll("'", "");
      await fireS.sendMessage(receiverID, message,cleanedFilePath);
      scrollToBottom();
      update();
    }
    update();
  }

  getMessages() {
    messages.clear();
    List<String> ids = [receiverID!, getCurrentUserId()];
    ids.sort();
    String chatRoomID = ids.join('_');
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      messages = snapshot.docs;
      isLoading = false;
      update();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    });
  }

  void markMessagesAsRead(String receiverId) async {
    List<String> ids = [receiverID!, getCurrentUserId()];
    ids.sort();
    String chatRoomID = ids.join('_');

    try {
      print("Marking messages as read...");
      QuerySnapshot unreadMessages = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomID)
          .collection('messages')
          .where('senderId', isEqualTo: receiverId)
          .where('receiverID', isEqualTo: getCurrentUserId())
          .where('isRead', isEqualTo: false)
          .get();

      print("Number of unread messages: ${unreadMessages.docs.length}");
      print("Current User ID: ${getCurrentUserId()}");
      print("Receiver ID: $receiverId");

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in unreadMessages.docs) {
        print("Updating message ID: ${doc.id}");
        batch.set(
            doc.reference,
            {
              'isRead': true,
            },
            SetOptions(merge: true));
      }
      await batch.commit();
      print("Messages marked as read successfully.");
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    scrollController = ScrollController();
    receiverID = Get.arguments['receiverID'];
    receiverName = Get.arguments['receiverName'];
    isStatus = Get.arguments['isStatus'];
    getMessages(); // fetchMessages();
    // استخدام addPostFrameCallback للتمرير بعد عرض الرسائل مباشرة
    markMessagesAsRead(receiverID!);
    messageController = TextEditingController();
    messageUpdate = TextEditingController();
    super.onInit();
  }
}
