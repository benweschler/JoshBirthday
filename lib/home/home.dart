import 'dart:ui';

import 'package:floof/home/picture_row.dart';
import 'package:floof/home/sound_row.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Insets.offset),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
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
              Container(
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
              SoundRow(),
            ],
          ),
        ),
      ),
    );
  }
}
