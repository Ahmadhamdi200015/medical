import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationsHelper {
  // creat instance of fbm
  final _firebaseMessaging = FirebaseMessaging.instance;

  // initialize notifications for this app or device
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    // get device token
    String? deviceToken = await _firebaseMessaging.getToken();
    // DeviceToken = deviceToken;
    print(
        "===================Device FirebaseMessaging Token====================");
    print(deviceToken);
    print(
        "===================Device FirebaseMessaging Token====================");
  }


  // handle notifications when received
  void handleMessages(RemoteMessage? message) {
    if (message != null) {
      // navigatorKey.currentState?.pushNamed(NotificationsScreen.routeName, arguments: message);
      Get.snackbar('on Background Message notification',"Success");
    }
  }

  // handel notifications in case app is terminated
  void handleBackgroundNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((handleMessages));
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }

  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "medical-22851",
      "private_key_id": "84c2f84981d6872a0c257a85b6f68848ee05a7d9",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDaKGyxwJCrCgwQ\nkZAtpdS4bh4VAsruizX02AhNsnaS+47Men6Tct8LVKtkVz5PbF0YQihOApuwbbql\nPbO7Gk17iYBBMagDu4mHwuOVu/PtwBgd+rkUNUJ4+aisthBXocwGohHAhXm26nvs\nj9LotLRz5Numi6kcCN2cpHmHiwJ5W3Y+Ju9WvrdoJWCT2xRTN78hIuD8aMaVnFz8\nhphFo/mXGNBonH2A79oRpn99lO/MstxS+DiApQ7T5OFEt6blyBUh0NkzkOSxdTiv\np7jiaNf/u14ZCz0a8p6tbkDZhLsOvRVsiy7luY8VPVpBUrSnGBDIzx06JNYAea4p\nbYdpEY+9AgMBAAECggEACCjxl9x6DMu9aR6TZAG16TLFO/KfdeNjIJthWXakFMSw\nB1n1mLz34Xad9TeGLyEAgm3HEClCJYvqf/pvhJTBR9j8IR7NsrC1vjbonasqvpPW\n0xg+X/vLVrcP5hXmmpXaCc16GIIQQWqX5AtPz5XNbMr8pEgeX9wSXfo7ns7w8r+1\nUYIrDHVI49hNxQmFFyqzWIvlAnZXp0vibRBtt1NvO1P7bH4V+eety8RfW3FCfuRR\nW3GpZv9ISZhXclf4USlmORbQNGGNDzSrcQev8IRM4Wu5r1IN+zQ3kF0tGbBjidE5\nPcgYIIj9TOLohLw4PT64poBTA7mf6yJf+/QZshzfgQKBgQD+kmQhRI8ie077K3mM\nFWwerIoPdJzrccoiLNPa5UO5YGDTpvJuYWb6QFhE37NcaquwQ3OhaqXAuS7DyqUb\nHosXaA6W3Vkn+4gERx1vt3bZbXXzJs8ye5gB9dmFIcFe22MtYi7qXQ8ACjtdbeCf\ncS1jLJKtEMVumQKo6uqI8Y6JzQKBgQDbYbyeu3jAvRdkx8SFdFTMU4lE/vy38uza\ntBu3w0Idq9XYpIs8uf4CekKxjOYJuXU369WuVylcoiFLN2998c6Qt1pjJKwiR5qi\nlOkmIGhGhR50BvCBRCDijpDj8EenKXR2CLBzQQxBbW5zf8CnZy2qWYGNvuxs9tsF\nI+hC0DhtsQKBgQC/FNLjxbpKf5QBI9jQNSQ6wfe/MiC2+WpnzI4YuA3lj1oehClk\ngOfy32liCSdwLwFABOE+P/a6ekWH4QudF4f/wbNxuiO5xyuJSnfl6yfifC8UnATa\nN7sZfZgQPg4PTU1cO15LvB4OQZ/duSPpieIvlr1h+jy3j1JXyDzTHb2H4QKBgAe1\njIpLbjffrTXGa1qBNwWjHdzF1R2ltLsOvzaa7vTZ9/7P8XCl3I47u6I/oEnRMZRQ\nfkbNG0/9Box9Gzbiy258cvmu7TmbKIz0DKlhVCi+Ps62+7afLUSo2+CWrf3q0APh\n1EmIjKSz8sCuSZfYYVtuH8ZaYjaGCjZJB71pUcJRAoGBAO/oJBh8lOI3xItcuTXV\nURBXFVn3lW7obUYcH3uFXdbLqnPVPwc5AlVWUl72WlxskBu8ECtOrMyYdllpATZt\ntOCYSMYVnF9JHbz3Kr4A+xgk4dopL6wH/EyML66V2jES5UFBpCOxgqIZVl6sk9O7\nQIZihiThsRyK9jA7/h+oxaxw\n-----END PRIVATE KEY-----\n",
      "client_email": "medical-app@medical-22851.iam.gserviceaccount.com",
      "client_id": "110699434340853825196",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/medical-app%40medical-22851.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);

      client.close();
      print("======================");
      print(
          "Access Token: ${credentials.accessToken.data}");
      print("=============================");// Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
      return null;
    }
  }

  Map<String, dynamic> getBody({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) {
    return {
      "message": {
        "token": fcmToken,
        "notification": {"title": title, "body": body},
        "android": {
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default"
          }
        },
        "apns": {
          "payload": {
            "aps": {"content_available": true}
          }
        },
        "data": {
          "type": type,
          "id": userId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      }
    };
  }

  Future<void> sendNotifications({
    required String fcmToken,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) async {
    try {
      var serverKeyAuthorization = await getAccessToken();

      // change your project id
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/medical-22851/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';
      print('Bearer $serverKeyAuthorization');

      var response = await dio.post(
        urlEndPoint,
        data: getBody(
          userId: userId,
          fcmToken: fcmToken,
          title: title,
          body: body,
          type: type ?? "message",
        ),
      );

      // Print response status code and body for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
