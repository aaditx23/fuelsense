import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await Permission.photos.request();
  await Permission.camera.request();
}

