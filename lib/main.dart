import 'package:flutter/material.dart';
import 'package:flutter_template/di/setup_di.dart';
import 'package:flutter_template/navigation/routes.dart';
import 'package:flutter_template/views/screens/screen01/screen01_provider.dart';
import 'package:flutter_template/views/screens/screen02/screen02_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Screen01Provider()),
        ChangeNotifierProvider(create: (_) => Screen02Provider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/screen01",
      routes: getRoute(context),
      title: 'flutter_template',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
