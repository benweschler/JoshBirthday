import 'package:audioplayers/audioplayers.dart';
import 'package:floof/home/sound_row/sound.dart';
import 'package:floof/home/sound_row/sound_tile.dart';
import 'package:flutter/material.dart';
import 'package:floof/theme/style.dart';

class SoundRow extends StatefulWidget {
  final List<Sound> sounds = const [
    Sound('sounds/anime-wow.mp3', 'Anime Wow'),
    Sound('sounds/azeeero.mp3', 'AZEEEEEERO'),
    Sound('sounds/badum-tss.mp3', 'Badum Tsss'),
    Sound('sounds/boom.mp3', 'BOOM'),
    Sound('sounds/crickets.mp3', 'Crickets'),
    Sound('sounds/disgusteng.mp3', 'DISGUSTENG'),
    Sound('sounds/emotional-damage.mp3', 'Emotional Damage'),
    Sound('sounds/epic-sax.mp3', 'Saxxy'),
    Sound('sounds/fart-with-reverb.mp3', 'Fart of the Gods'),
    Sound('sounds/hello-there.mp3', 'Hello There :)'),
    Sound('sounds/nope.mp3', 'nope.'),
    Sound('sounds/oh-no.mp3', 'Ohhh Nooo'),
    Sound('sounds/rickroll.mp3', 'Me Admitting I Have No Friends'),
    Sound('sounds/what-are-you-doing-in-my-swamp.mp3', 'Go Away >:('),
  ];

  const SoundRow({Key? key}) : super(key: key);

  @override
  State<SoundRow> createState() => _SoundRowState();
}

class _SoundRowState extends State<SoundRow> {
  final AudioCache player = AudioCache(fixedPlayer: AudioPlayer());
  Sound? currentlyPlaying;

  @override
  void initState() {
    player.loadAll(widget.sounds.map((e) => e.localPath).toList());
    super.initState();
  }

  @override
  void dispose() {
    player.fixedPlayer!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    player.fixedPlayer!.onPlayerCompletion.listen((event) {
      setState(() {
        currentlyPlaying = null;
      });
    });
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: widget.sounds
            .expand((sound) => [
                  SoundTile(
                    sound: sound,
                    currentlyPlaying: currentlyPlaying,
                    onTap: () {
                      if (currentlyPlaying != sound) {
                        setState(() => currentlyPlaying = sound);
                        player.play(sound.localPath);
                      } else {
                        setState(() => currentlyPlaying = null);
                        player.fixedPlayer!.stop();
                      }
                    },
                  ),
                  SizedBox(width: Insets.med)
                ])
            .toList(),
      ),
    );
  }
}
