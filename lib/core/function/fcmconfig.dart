import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';



RequestPermissoinNotification()async{
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}


fcmconfig(){
  FirebaseMessaging.onMessage.listen((message){
    print("===============================================");
    print(message.notification?.title);
    print(message.notification?.body);
    print(Get.currentRoute);
    print("===============================================");
    Get.snackbar("${message.notification?.title}","${message.notification?.body}");
    // refreshNotification(message.data);

  });
}
// refreshNotification(data){
//   if(Get.currentRoute=="/PendingOrders" && data['pagename']=="refreshorderpending"){
//     PendingorderController controller=Get.find();
//     controller.getOrders();
//   }
// }