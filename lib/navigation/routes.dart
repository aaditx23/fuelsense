import 'package:flutter/material.dart';
import 'package:fuelsense/data/datasources/local/shared_preferences/shared_preferences.dart';
import 'package:fuelsense/data/models/bike/bike_model.dart';
import 'package:fuelsense/presentation/screens/add_bike/add_bike_screen.dart';
import 'package:fuelsense/presentation/screens/auth/login/login_screen.dart';
import 'package:fuelsense/presentation/screens/auth/signup/signup_screen.dart';
import 'package:fuelsense/presentation/screens/my_bikes/my_bikes_screen.dart';
import 'package:fuelsense/presentation/screens/pending_bikes/edit/bike_edit_screen.dart';
import 'package:fuelsense/presentation/screens/pending_bikes/pending_bike_screen.dart';
import 'package:fuelsense/presentation/screens/profile/profile_screen.dart';

import '../di/setup_di.dart';
import '../presentation/screens/bikes/bikes_screen.dart';

Map<String, WidgetBuilder> getRoute(context) {
  return {
    "/profile": (context) => ProfileScreen(),
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
