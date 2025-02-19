import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:ttd/ui/home/NavigationPage.dart';
import 'package:ttd/ui/login/LoginPage.dart';
import 'package:ttd/utils/cert/TTDHttpOverrides.dart';
import 'package:ttd/utils/servicelocator/TTDServiceLocator.dart';
import 'package:firebase_core/firebase_core.dart';

GlobalKey<NavigatorState> _navigatorKeyHome = GlobalKey();
GlobalKey<NavigatorState> _navigatorKeyDuty = GlobalKey();
GlobalKey<NavigatorState> _navigatorKeyProfile = GlobalKey();

List<GlobalKey<NavigatorState>> navigatorKeys = [
  _navigatorKeyHome,
  _navigatorKeyDuty,
  _navigatorKeyProfile,
];

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  print("Gelen Mesaj ${message.notification!.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      print("Gelen Mesaj ${message.notification!.body}");
    }
  });

  //HttpOverrides.global = TTDHttpOverrides();
  TTDServiceLocator().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Tidy Tracker Device',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: LoginPage(),
          //navigatorKey: mainNavigatorKey,
        );
      },
    );
  }
}