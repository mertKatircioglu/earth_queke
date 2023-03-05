import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../global/globals.dart';

import '../locator.dart';

import '../view_models/queke_view_model.dart';
import '../widgets/custom_error_dialog.dart';
import '../widgets/home.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChangeNotifierProvider<EarthQuakeViewModel>(
            create: (context) => locator<EarthQuakeViewModel>(),
            child: const HomePage(
            ));
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRouteAuth() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const AuthScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  startTimer(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      Timer(const Duration(seconds: 3), () async {
        if (authUser.currentUser != null) {
          Navigator.of(context).pushReplacement(_createRoute());
        } else {
          Navigator.of(context).pushReplacement(_createRouteAuth());
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return CustomErrorDialog(message: "No Internet connection.");
          });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }




  @override
  void initState() {
    super.initState();
    startTimer(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/earthquake.png",
                width: 200, height: 200),
            Lottie.asset("images/splash.json",
                width: 80, height: 100),
            const Text(
              "Sismo Servis",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}
