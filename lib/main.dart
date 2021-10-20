import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'my_splash_screen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jarvis Object Detector App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MySplashScreen(),
    );
  }
}
