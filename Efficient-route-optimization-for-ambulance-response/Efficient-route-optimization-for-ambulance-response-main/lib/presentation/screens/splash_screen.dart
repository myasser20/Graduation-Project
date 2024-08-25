import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:map_project/presentation/screens/map.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash:
          Container(
            child:
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/logo.png',
                      height: 800,
                      width: 800,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),


      nextScreen: const Mapscreen(),
     backgroundColor:  Color.fromARGB(255, 94, 163, 212) ,
      splashIconSize: 250,
      duration: 4000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
