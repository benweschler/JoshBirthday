import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:floof/auth_screen.dart';
import 'package:floof/not_activated_screen.dart';
import 'package:floof/theme/theme.dart';
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
    return MaterialApp(
      title: 'FLOOF',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return isActivated ? const Home() : const NotActivatedScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }

  void _checkActivation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isActivated = prefs.getString('app_id') != null;
    });
  }
}
