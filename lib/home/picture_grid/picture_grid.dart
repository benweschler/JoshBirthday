import 'package:floof/home/picture_grid/picture_gallery.dart';
import 'package:flutter/material.dart';

class PictureRow extends StatelessWidget {
  final List<String> picturePaths = [
    for (int i = 1; i <= 30; i++) 'assets/picture_row/$i.jpeg'
  ];

  PictureRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        crossAxisCount: 3,
      ),
      itemCount: picturePaths.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PictureGallery(
              picturePaths: picturePaths,
              initialIndex: index,
            ),
          )),
          child: Hero(
            tag: picturePaths[index],
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(picturePaths[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
