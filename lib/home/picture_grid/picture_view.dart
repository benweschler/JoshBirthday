import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

//TODO: add double tap to fully zoom and double tap, hole, and swipe to pan zooming

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
              onPressed: () => savePhoto(context),
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

  void savePhoto(BuildContext context) async {
    if ((Platform.isAndroid && await Permission.storage.request().isGranted) ||
        (Platform.isIOS &&
            await Permission.photosAddOnly.request().isGranted)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Save Photo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                writeToLocalStorage();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text(
            'It looks like I ran into a problem while trying to save this'
            ' photo to your device. Make sure to tell Ben this'
            ' happened so he can get you up and running again :).',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it!'),
            ),
          ],
        ),
      );
    }
  }

  void writeToLocalStorage() async {
    // get the location in which to cache the image
    final tempDir = await getTemporaryDirectory();
    String savePath =
        tempDir.path + '/${path.substring(path.lastIndexOf('/'))}';

    // cache the image before persisting to local storage
    final bytes = await rootBundle.load(path);
    await File(savePath).writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    // persist the image to local storage
    await ImageGallerySaver.saveFile(savePath);
  }
}
