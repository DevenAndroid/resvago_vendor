import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendPushNotification(
    {required String deviceToken,
    required String title,
    required String body,
    required String image,
    required String orderID}) async {
  const String serverKey =
      'AAAAnE4Vn7w:APA91bGjcHrwJLiFTu9CwtEaTusO6JObu_Le62jMIeU67Uvl5am65VQw72o6ONQHxgapagbIUbokLBrE5rvNBXBVu4MYsziCN5QZnnjKtfg2Jg4RKdoYoM44vXVdKf3RwRsnos19mLe-';

  final Map<String, dynamic> notification = {
    'body': body,
    'title': title,
    'sound': 'default',
    'image': image,
  };

  final Map<String, dynamic> message = {
    'notification': notification,
    'priority': 'high',
    'data': {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'order_id': orderID,
    },
    'to': deviceToken,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}
