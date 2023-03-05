import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
final FirebaseAuth authUser = FirebaseAuth.instance;
int globalCount=0;
const Color kBackGroundColor = Color(0xFFF5F5F5);
const Color kPrymaryColor = Color(0xFFFDBF30);
SharedPreferences? sharedPreferences;