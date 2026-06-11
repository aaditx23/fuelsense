import 'package:flutter/material.dart';
import 'package:fuelsense/views/screens/auth/login/login_screen.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_screen.dart';
import 'package:fuelsense/views/screens/profile/profile_screen.dart';
import 'package:fuelsense/views/screens/screen01/screen01.dart';
import 'package:fuelsense/views/screens/screen02/screen02.dart';

import '../data/local/shared_preferences/shared_preferences.dart';
import '../di/setup_di.dart';

Map<String, WidgetBuilder> getRoute(context) {
  return {
    "/profile": (context) => ProfileScreen(),
    "/screen02": (context) => Screen02(),
    "/login": (context) => LoginScreen(),
    "/signup": (context) => SignupScreen()
  };
}

String getInitialRoute(){
  final prefs = getIt<AppSharedPreferences>();
  final userId = prefs.getUserId();
  if(userId == null) {
    return "/login";
  } else {
    return "/profile";
  }
}