import 'package:firebase_auth/firebase_auth.dart';
import 'package:floof/home/picture_grid/picture_grid.dart';
import 'package:floof/home/sound_row/sound_row.dart';
import 'package:floof/utils/network_utils.dart';
import 'package:flutter/material.dart';

import '../theme/style.dart';
import 'coupon_row/coupon_row.dart';

class Home extends StatelessWidget {
  final VoidCallback rerollTheme;

  const Home({
    Key? key,
    required this.rerollTheme,
  }) : super(key: key);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Row(
                        children: const [
                          Text("Reroll Theme "),
                          Icon(Icons.swap_horiz_rounded),
                        ],
                      ),
                      onPressed: rerollTheme,
                    ),
                    SizedBox(width: Insets.med),
                    TextButton(
                      child: const Text("Logout"),
                      onPressed: FirebaseAuth.instance.signOut,
                    ),
                  ],
                ),
                SizedBox(height: Insets.med),
                Center(
                  child: Text(
                    "HAPPY BIRTHDAY SQUISH!!!",
                    style: TextStyles.title,
                    textAlign: TextAlign.center,
                  ),
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: Corners.medBorderRadius,
                      ),
                      child: const PictureRow(),
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
                const Text("Version ${AccessVersion.version}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
