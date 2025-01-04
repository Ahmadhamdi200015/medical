import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> userIds;
  final DateTime timestamp;

  Chat({required this.id, required this.userIds, required this.timestamp});

  // إنشاء دالة لتحويل البيانات من Firestore إلى نموذج Chat
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Chat(
      id: doc.id,
      userIds: List<String>.from(data['userIds']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // دالة لتحويل نموذج Chat إلى بيانات لتخزينها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'userIds': userIds,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
