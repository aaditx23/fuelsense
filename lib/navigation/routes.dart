import 'package:flutter/material.dart';
import 'package:fuelsense/views/screens/auth/login/login_screen.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_screen.dart';
import 'package:fuelsense/views/screens/screen01/screen01.dart';
import 'package:fuelsense/views/screens/screen02/screen02.dart';

Map<String, WidgetBuilder> getRoute(context) {
  return {
    "/screen01": (context) => Screen01(),
    "/screen02": (context) => Screen02(),
    "/login": (context) => LoginScreen(),
    "/signup": (context) => SignupScreen()
  };
}
