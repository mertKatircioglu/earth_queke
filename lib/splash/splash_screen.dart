import 'dart:async';

import 'package:sismy/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  startTimer(){
    Timer(const Duration(seconds: 5), () async {
      bool result = await InternetConnectionChecker().hasConnection;
      if(result == true) {
          Navigator.pop(context);
      } else {
      //  Fluttertoast.showToast(msg: "İnternete bağlı değilsiniz", toastLength: Toast.LENGTH_LONG);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child:Container(
                  width: 150,
                    height: 150,
                    child: Lottie.asset('images/splash.json')),
              ),
              const SizedBox(height: 10,),
              const Padding(padding:EdgeInsets.all(8.0),
                child: Text("Türkiye Deprem Listesi", textAlign: TextAlign.center,
                  style: TextStyle(color: kPrymaryColor, fontSize: 30,  letterSpacing: 2),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
