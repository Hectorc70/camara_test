import 'package:camera_test/camera_face.dart';
import 'package:camera_test/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  //await NotificationServiceLocal().init();
  runApp(
    const MaterialApp(home: MyApp()), // use MaterialApp
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: CamaraPage(),
      home: CameraFacePage(),
    );
  }
}
