import 'package:flutter/material.dart';
import 'package:fuelsense/data/remote/bike/schema/bike_model.dart';
import 'package:fuelsense/views/screens/add_bike/add_bike_screen.dart';
import 'package:fuelsense/views/screens/auth/login/login_screen.dart';
import 'package:fuelsense/views/screens/auth/signup/signup_screen.dart';
import 'package:fuelsense/views/screens/my_bikes/my_bikes_screen.dart';
import 'package:fuelsense/views/screens/pending_bikes/edit/bike_edit_screen.dart';
import 'package:fuelsense/views/screens/pending_bikes/pending_bike_screen.dart';
import 'package:fuelsense/views/screens/profile/profile_screen.dart';
import 'package:fuelsense/views/screens/screen02/screen02.dart';

import '../data/local/shared_preferences/shared_preferences.dart';
import '../di/setup_di.dart';
import '../views/screens/bikes/bikes_screen.dart';

Map<String, WidgetBuilder> getRoute(context) {
  return {
    "/profile": (context) => ProfileScreen(),
    "/screen02": (context) => Screen02(),
    "/login": (context) => LoginScreen(),
    "/signup": (context) => SignupScreen(),
    "/bikes": (context) => BikesScreen(),
    "/my_bikes": (context) => MyBikesScreen(),
    "/add_bike": (context) => AddBikeScreen(),
    "/pending_bikes": (context) => PendingBikeScreen(),
    "/edit_bike": (context) {
      final bike = ModalRoute.of(context)!.settings.arguments as BikeModel;
      return EditBikeScreen(bike: bike);
    },
  };
}

String getInitialRoute() {
  final prefs = getIt<AppSharedPreferences>();
  final userId = prefs.getUserId();
  if (userId == null) {
    return "/login";
  } else {
    return "/profile";
  }
}
