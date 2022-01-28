import 'package:floof/home/sound_row/sound.dart';
import 'package:flutter/material.dart';

import '../../style.dart';

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
    return Container(
      width: 195,
      padding: EdgeInsets.all(Insets.med),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: Shadows.universal,
      ),
      child: Column(
        children: [
          Text(sound.name, style: TextStyles.h1),
          GestureDetector(
            child: Icon(
              currentlyPlaying == sound
                  ? Icons.stop_rounded
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
