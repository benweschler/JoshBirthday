import 'package:floof/home/home.dart';
import 'package:floof/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bootstrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Bootstrapper.checkAppID();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = randomBackgroundColor();
    return MaterialApp(
      title: 'FLOOF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        cardColor: changeColorLightness(backgroundColor, -0.25),
      ),
      home: const Home(),
    );
  }
}
