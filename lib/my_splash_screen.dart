import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: const HomeScreen(),
      imageBackground: Image.asset('assets/images/back.jpg').image,
      useLoader: true,
      loaderColor: Colors.pinkAccent,
      loadingText: Text(
        'Loading',
        style: GoogleFonts.getFont(
          'Arvo',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 30.0,
        ),
      ),
    );
  }
}
