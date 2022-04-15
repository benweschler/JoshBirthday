import 'package:floof/home/picture_grid/picture_grid.dart';
import 'package:floof/home/sound_row/sound_row.dart';
import 'package:flutter/material.dart';

import '../style.dart';
import 'coupon_row/coupon_row.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(Insets.offset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: Insets.med),
                    child: Container(
                      padding: EdgeInsets.all(Insets.med),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: Corners.medBorderRadius,
                      ),
                      child: PictureRow(),
                    ),
                  ),
                ),
                SizedBox(height: Insets.spacer),
                Text(
                  "Sounds Topaz Thought You'd Like",
                  style: TextStyles.subtitle,
                ),
                SizedBox(height: Insets.med),
                const SoundRow(),
                SizedBox(height: Insets.spacer),
                Text(
                  "Coupons I Stole from Your Mom",
                  style: TextStyles.subtitle,
                ),
                SizedBox(height: Insets.med),
                const CouponRow(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
