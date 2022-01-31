import 'package:floof/home/home.dart';
import 'package:floof/utils/color_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = randomBackgroundColor();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        cardColor: changeColorLightness(backgroundColor, -0.25),
      ),
      home: const Home(),
    );
  }
}
