import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PictureGallery extends StatefulWidget {
  final List<String> picturePaths;
  final int initialIndex;

  const PictureGallery({
    Key? key,
    required this.picturePaths,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _PictureGalleryState createState() => _PictureGalleryState();
}

class _PictureGalleryState extends State<PictureGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        pageController: PageController(initialPage: widget.initialIndex),
        itemCount: widget.picturePaths.length,
        builder: (context, index) => PhotoViewGalleryPageOptions(
          imageProvider: AssetImage(widget.picturePaths[index]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 10,
          heroAttributes:
              PhotoViewHeroAttributes(tag: widget.picturePaths[index]),
        ),
      ),
    );
  }
}
