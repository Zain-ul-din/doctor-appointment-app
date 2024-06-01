import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:med_app/firebase_options.dart';
import 'package:med_app/screens/doctor_screen.dart';
import 'package:med_app/screens/doctors_screen.dart';
import 'package:med_app/screens/home_screen.dart';
import 'package:med_app/screens/loading_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initFirebaseApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFirebaseApp,
      builder: (context, snapShot) {
        if (snapShot.hasError) {
          print("Error");
          // return loading screen
          return const Text("Unknown Error Occur in firebase");
        }

        if (snapShot.connectionState == ConnectionState.done) {
          return const AppRoutes();
        }

        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.indigoAccent,
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const LoadingScreen(),
        );
      },
    );
  }
}

class AppRoutes extends StatelessWidget {
  const AppRoutes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigoAccent,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/doctor': (ctx) => const DoctorScreen(),
        '/doctors': (ctx) => const DoctorsScreen()
      },
      // home: const HomeScreen(),
    );
  }
}
