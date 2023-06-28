import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:desactvapp3/firebase_messaging.dart';
import 'package:desactvapp3/models/user_hive.dart';
import 'package:desactvapp3/screens/downloads_screen.dart';
import 'package:desactvapp3/screens/landing_page.dart';
import 'package:desactvapp3/services/network_service.dart';
import 'package:desactvapp3/services/notification_service_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:desactvapp3/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/controller_binding.dart';
import 'controller/login.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // Initialize Firebase Messaging\s
  //await FirebaseMessagingService().initialize();
  // Initialize the notification service
  //await NotificationServiceFirebase
  // ().initialize();
  runApp(const VideoApp());
  HttpOverrides.global = MyHttpOverrides();


}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';

  void checkUserId(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null && userId.isNotEmpty) {
      // User ID exists in SharedPreferences, navigate to HomeScreen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      // User ID does not exist or is empty, handle the logic accordingly
      // For example, you can navigate to a login or registration screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LandingPage()));
    }
  }

  void initState() {
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      print('source $_source');
      setState(() {
        switch (_source.keys.toList()[0]) {
          case ConnectivityResult.mobile:
            string = _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
            break;
          case ConnectivityResult.wifi:
            string = _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
            break;
          case ConnectivityResult.none:
          default:
            string = 'Offline';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String connectionStatus = '';
    if (string.contains('Online')) {
      checkUserId(context);
    } else {
      connectionStatus = 'Offline';
    }

    string == 'Mobile: Offline' || string == 'WiFi: Offline'
        ? Get.snackbar('', "You are offline")
        : Get.snackbar('', "Your connection is restored");

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Get.changeTheme(ThemeData.dark(useMaterial3: true));

    return GetMaterialApp(
      initialBinding: MyBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.amber),
      ),
      title: 'DESAC TV',
      home: connectionStatus == 'Online' ? LandingPage() : DownloadsScreen(),
    );
  }
}
