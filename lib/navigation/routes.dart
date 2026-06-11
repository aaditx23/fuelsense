import 'package:flutter/material.dart';
import 'package:template_flutter/views/screens/screen01/screen01.dart';
import 'package:template_flutter/views/screens/screen02/screen02.dart';

Map<String, WidgetBuilder> getRoute(context) {
  return {
    "/screen01": (context) => Screen01(),
    "/screen02": (context) => Screen02(),
  };
}
