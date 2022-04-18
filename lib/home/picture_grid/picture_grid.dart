import 'dart:io';

import 'package:floof/home/picture_grid/picture_gallery.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PictureRow extends StatelessWidget {
  const PictureRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileImage>>(
      future: _loadPictures(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<FileImage> imageList = snapshot.data!;
          return PictureGrid(imageList);
        } else {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }
      },
    );
  }

  Future<List<FileImage>> _loadPictures() async {
    List<FileImage> imageList = [];
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    await for (FileSystemEntity picture
        in Directory("${appDocDir.path}/pictures").list()) {
      // This check should always be true but is put in place just in case
      // something other than a picture makes it into the pictures directory.
      if (picture is File) {
        imageList.add(FileImage(picture));
      }
    }

    // Assume that each image file is named with a number in Firebase storage.
    // Sort the images by their number rather than the order that Firebase
    // orders them.
    final sortedList = imageList
      ..sort((a, b) {
        String pathA = a.file.path;
        String pathB = b.file.path;
        String fileNumberA = pathA.substring(
            pathA.lastIndexOf("/") + 1, pathA.lastIndexOf("."));
        String fileNumberB = pathB.substring(
            pathB.lastIndexOf("/") + 1, pathB.lastIndexOf("."));
        return int.parse(fileNumberA).compareTo(int.parse(fileNumberB));
      });

    return sortedList;
  }
}

class PictureGrid extends StatelessWidget {
  final List<FileImage> imageList;

  const PictureGrid(this.imageList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          crossAxisCount: 3,
        ),
        itemCount: imageList.length,
        // TODO: this is a hacky way to cache the entire GridView. There's a better way to do this.
        cacheExtent: (imageList.length / 3) * constraints.maxWidth,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PictureGallery(
                imageProviders: imageList,
                initialIndex: index,
              ),
            )),
            child: Hero(
              tag: index,
              child: Image(
                fit: BoxFit.cover,
                image: imageList[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
