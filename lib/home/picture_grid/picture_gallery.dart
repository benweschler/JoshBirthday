import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PictureGallery extends StatefulWidget {
  final List<FileImage> imageProviders;
  final int initialIndex;

  const PictureGallery({
    Key? key,
    required this.imageProviders,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _PictureGalleryState createState() => _PictureGalleryState();
}

class _PictureGalleryState extends State<PictureGallery> {
  late int currentPhotoIndex = widget.initialIndex;
  bool appBarIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => setState(() => appBarIsVisible = !appBarIsVisible),
        onVerticalDragStart: (_) => Navigator.pop(context),
        child: Stack(
          children: [
            _photoGallery,
            _photoAppBar,
          ],
        ),
      ),
    );
  }

  Widget get _photoGallery => PhotoViewGallery.builder(
        pageController: PageController(
          initialPage: widget.initialIndex,
        ),
        itemCount: widget.imageProviders.length,
        builder: (context, index) => PhotoViewGalleryPageOptions(
          imageProvider: widget.imageProviders[index],
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 10,
          heroAttributes:
              PhotoViewHeroAttributes(tag: index),
          scaleStateCycle: (scaleState) {
            switch (scaleState) {
              case PhotoViewScaleState.initial:
                return PhotoViewScaleState.originalSize;
              default:
                return PhotoViewScaleState.initial;
            }
          },
        ),
        onPageChanged: (index) => setState(() => currentPhotoIndex = index),
      );

  Widget get _photoAppBar => IgnorePointer(
    ignoring: !appBarIsVisible,
    child: AnimatedOpacity(
          opacity: appBarIsVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: SizedBox(
            height: 100,
            child: AppBar(
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                    onPressed: () => _savePhoto(
                        context, widget.imageProviders[currentPhotoIndex]),
                    icon: const Icon(Icons.save_alt_rounded)),
              ],
            ),
          ),
        ),
  );

  void _savePhoto(BuildContext context, FileImage image) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Saving photos is only supported for mobile devices.")));
      return;
    }

    PermissionStatus status = Platform.isAndroid
        ? await Permission.storage.request()
        : await Permission.photosAddOnly.request();

    if (status.isGranted || status.isLimited) {
      _showSavePhotoDialog(context, image);
    } else if (status.isDenied || status.isPermanentlyDenied) {
      String permissionType = Platform.isAndroid
          ? "access your device storage "
          : "access your photo gallery ";
      _showGoToSettingsDialog(context, permissionType);
    } else {
      // [status] is restricted
      _showErrorDialog(context);
    }
  }

  _showSavePhotoDialog(BuildContext context, FileImage image) => showDialog(
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
            // persist image to local storage
            ImageGallerySaver.saveFile(image.file.path);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        )
      ],
    ),
  );

  _showGoToSettingsDialog(BuildContext context, String permissionType) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
              'In order to save this photo, I need permission to $permissionType.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const TextButton(
              onPressed: openAppSettings,
              child: Text('Settings'),
            )
          ],
        ),
      );

  _showErrorDialog(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text(
            "It looks like your device is configured to prevent photos from "
            "being saved. This could be due to parental controls, or to "
            "another type of restriction.",
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
