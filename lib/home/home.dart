import 'package:floof/home/picture_row/picture_row.dart';
import 'package:floof/home/sound_row/sound_row.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            padComponent([
              Text(
                "HAPPY BIRTHDAY SQUISH!!!",
                style: TextStyles.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Insets.spacer),
              Text(
                "Pictures for U :)))",
                style: TextStyles.subtitle,
              ),
              SizedBox(
                height: 400,
                child: Padding(
                  padding: EdgeInsets.only(top: Insets.med),
                  child: PictureRow(),
                ),
              ),
              SizedBox(height: Insets.spacer),
              Text(
                "Sounds Topaz Thought You'd Like",
                style: TextStyles.subtitle,
              ),
            ]),
            SoundRow(),
          ],
        ),
      ),
    );
  }

  Widget padComponent(List<Widget> widgets) {
    return Padding(
      padding: EdgeInsets.all(Insets.offset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
