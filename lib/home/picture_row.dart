import 'package:flutter/material.dart';
import 'package:floof/home/picture.dart';

class PictureRow extends StatelessWidget {
  final List<String> pictures = [
    for (int i = 1; i <= 21; i++) 'assets/picture_row/$i.jpeg'
  ];

  PictureRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
      itemCount: pictures.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => Picture(path: pictures[index]))),
          child: Hero(
            tag: pictures[index],
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(pictures[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
