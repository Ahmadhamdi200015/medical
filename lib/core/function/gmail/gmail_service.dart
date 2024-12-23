import 'dart:convert';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// class GmailService {
//   final String _clientId = '759054847464-idougv1ri8dmh2ituduhurs78bou22r9.apps.googleusercontent.com'; // ضع هنا Client ID الخاص بك
//   final String _clientSecret = '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'; // ضع هنا Client Secret الخاص بك
//   final List<String> _scopes = ['https://www.googleapis.com/auth/gmail.send'];
//
//   final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
//
//   Future<void> sendEmail() async {
//     // إذا كان لدينا توكن موجود، نقوم باستخدامه
//     var accessToken = await _secureStorage.read(key: 'accessToken');
//
//     if (accessToken == null) {
//       // في حال لم يكن لدينا توكن، نطلب المصادقة من المستخدم
//       var client = await _authenticate();
//       var gmailApi = gmail.GmailApi(client);
//
//       final message = gmail.Message()
//         ..raw = base64UrlEncode(utf8.encode('To: recipient@example.com\nSubject: Test Email\n\nHello, this is a test email sent from Flutter!'));
//
//       // إرسال البريد
//       await gmailApi.users.messages.send(message, 'me');
//       print("Email Sent!");
//     } else {
//       // إذا كان لدينا توكن صالح، نستخدمه
//       var client = await _getAuthenticatedClient(accessToken);
//       var gmailApi = gmail.GmailApi(client);
//
//       final message = gmail.Message()
//         ..raw = base64UrlEncode(utf8.encode('To: recipient@example.com\nSubject: Test Email\n\nHello, this is a test email sent from Flutter!'));
//
//       // إرسال البريد
//       await gmailApi.users.messages.send(message, 'me');
//       print("Email Sent!");
//     }
//   }
//
//   // مصادقة OAuth 2.0
//   Future<http.Client> _authenticate() async {
//     var clientId = ClientId(_clientId, _clientSecret);
//     var flow = await clientViaUserConsent(clientId, _scopes, (url) async {
//       // فتح الرابط في المتصفح للموافقة
//       await launch(url);
//     });
//
//     // حفظ التوكن
//     await _secureStorage.write(key: 'accessToken', value: flow.credentials.accessToken.data);
//     var credentials = flow.credentials;
//     var client = authenticatedClient(http.Client(), credentials);
//
//     return client;  // هذا هو http.Client المطلوب
//   }
//
//   // استخدام توكن موجود
//   Future<http.Client> _getAuthenticatedClient(String accessToken) async {
//     var credentials = AccessCredentials(
//       AccessToken('Bearer', accessToken, DateTime.now().add(Duration(hours: 1))),
//       '',
//       _scopes,
//     );
//
//     // استخدام authenticatedClient بدلاً من AutoRefreshingAuthClient
//     var client = authenticatedClient(http.Client(), credentials);
//     return client;  // إرجاع authenticatedClient (الذي هو من نوع http.Client)
//   }
// }
