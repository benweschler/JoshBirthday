import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PictureView extends StatelessWidget {
  final String path;

  const PictureView({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                //TODO: add image saving
              },
              icon: const Icon(Icons.save_alt_rounded))
        ],
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
