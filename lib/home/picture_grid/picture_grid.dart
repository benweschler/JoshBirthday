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
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              crossAxisCount: 3,
            ),
            itemCount: imageList.length,
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
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageList[index],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
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

    //TODO: debugging
    print('reading photos from cache');
    print('number of photos found: ${(await Directory("${appDocDir.path}/pictures").list().toList()).length}');
    int num = 1;

    await for (FileSystemEntity picture
        in Directory("${appDocDir.path}/pictures").list()) {
      print("picture: ${num++}");
      // This check should always be true but is put in place just in case
      // something other than a picture makes it into the pictures directory.
      if (picture is File) {
        imageList.add(FileImage(picture));
      }
    }

    return imageList;
  }
}
