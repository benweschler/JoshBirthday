import 'dart:async';

import 'package:floof/auth_screen.dart';
import 'package:floof/not_activated_screen.dart';
import 'package:floof/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bootstrapper.dart';
import 'firebase_options.dart';
import 'home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Bootstrapper.bootstrapApp();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late bool isActivated = false;

  @override
  void initState() {
    scheduleMicrotask(_checkActivation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = randomBackgroundColor();
    return MaterialApp(
      title: 'FLOOF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        cardColor: changeColorLightness(backgroundColor, -0.35),
      ),
      //home: const AuthScreen(),
      home: isActivated ? const Home() : const NotActivatedScreen(),//Home(),
    );
  }

  void _checkActivation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isActivated = prefs.getString('app_id') != null;
    });
  }
}
