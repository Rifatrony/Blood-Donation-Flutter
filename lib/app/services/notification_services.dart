import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User Granted Permission");
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User Granted Provisional Permission");
    } else{
      print("User Denied Permission");
    }
  }

  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((message){

    });
  }

  Future<String> getDeviceToken()async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event){
      event.toString();
      print('refresh');
    });
  }


}