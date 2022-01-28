import 'package:flutter/material.dart';
import 'package:floof/style.dart';

class SoundRow extends StatelessWidget {
  final List<Sound> sounds = [
    Sound('assets/sounds/anime-wow.mp3', 'Anime Wow'),
    Sound('assets/sounds/boom.mp3', 'BOOM'),
    Sound('assets/sounds/crickets.mp3', 'Crickets'),
    Sound('assets/sounds/disgusteng.mp3', 'DISGUSTENG'),
    Sound('assets/sounds/emotional-damage.mp3', 'Emotional Damage'),
    Sound('assets/sounds/epic-sax.mp3', 'Saxxy'),
    Sound('assets/sounds/fart-with-reverb.mp3', 'Fart of the Gods'),
    Sound('assets/sounds/hello-there.mp3', 'Hello There :)'),
    Sound('assets/sounds/oh-no.mp3', 'Oh No'),
    Sound('what-are-you-doing-in-my-swamp-.mp3', 'Go Away >:('),
  ];

  SoundRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: sounds
            .expand((sound) => [
                  Padding(
                    padding: EdgeInsets.all(Insets.med),
                    child: SoundTile(sound: sound),
                  ),
                  SizedBox(width: 10)
                ])
            .toList(),
      ),
    );
  }
}

class SoundTile extends StatefulWidget {
  final Sound sound;

  const SoundTile({
    Key? key,
    required this.sound,
  }) : super(key: key);

  @override
  _SoundTileState createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    HSLColor hsl =
        HSLColor.fromColor(Theme.of(context).scaffoldBackgroundColor);
    Color cardColor =
        hsl.withLightness((hsl.lightness - 0.25).clamp(0.1, 1.0)).toColor();
    Color textColor = HSLColor.fromColor(cardColor).lightness > 0.4
        ? Colors.black
        : Colors.white;

    return Container(
      padding: EdgeInsets.all(Insets.med),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
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
          Text(widget.sound.name,
              style: TextStyles.h1.copyWith(color: textColor)),
          Text(
              "${hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).lightness}",
              style: TextStyles.h1.copyWith(color: textColor)),
        ],
      ),
    );
  }
}

class Sound {
  final String path;
  final String name;

  Sound(this.path, this.name);
}
