import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String receiverID;
  final String senderEmail;
  final String message;
 final bool edited;
  final bool isRead;
  final String file;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.receiverID,
    required this.senderEmail,
    required this.message,
    required this.edited,
    required this.isRead,
    required this.file,
    required this.timestamp,
  });

  // لتحويل بيانات Firestore إلى نموذج Message
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Message(
      senderID: data['senderID'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ??'',
      receiverID: data['receiverID'] ?? '',
      edited: data['edited'] ?? false,
      isRead: data['isRead']??false,
      file: data['file'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
    );
  }

  // لتحويل نموذج Message إلى خريطة لتخزينها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderID,
      'receiverID':receiverID,
      'senderEmail':senderEmail,
      'message': message,
      'edited':edited,
      'isRead':isRead,
      'file': file,
      'timestamp': Timestamp.now(),
    };
  }
}
