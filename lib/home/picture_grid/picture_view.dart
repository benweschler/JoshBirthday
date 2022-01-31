import 'package:flutter/material.dart';

class PictureView extends StatelessWidget {
  final String path;

  const PictureView({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          maxScale: 10,
          clipBehavior: Clip.none,
          child: Hero(
            tag: path,
            child: Image.asset(path),
          ),
        ),
      ),
    );
  }
}