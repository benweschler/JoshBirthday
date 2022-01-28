import 'package:floof/home/sound_row/sound.dart';
import 'package:flutter/material.dart';

import '../../style.dart';
import '../../utils/color_utils.dart';

class SoundTile extends StatelessWidget {
  final Sound sound;
  final Sound? currentlyPlaying;
  final GestureTapCallback onTap;

  const SoundTile({
    Key? key,
    required this.sound,
    required this.currentlyPlaying,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardColor =
        changeColorLightness(Theme.of(context).scaffoldBackgroundColor, -0.25);

    return Container(
      width: 195,
      padding: EdgeInsets.all(Insets.med),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 4),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(sound.name, style: TextStyles.h1),
          GestureDetector(
            child: Icon(
              currentlyPlaying == sound
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              size: 50,
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
