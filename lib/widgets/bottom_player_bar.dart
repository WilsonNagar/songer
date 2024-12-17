import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:songer/models/song_model.dart';
import 'package:songer/providers/song_provider.dart';
import 'package:songer/repositories/song_repository.dart';
import 'package:songer/utils/serviceLocator.dart';
import 'package:songer/utils/single_provider.dart';
import 'package:songer/utils/song_utils.dart';
import 'package:songer/widgets/volume_icon.dart';

class BottomSongPlayer extends StatelessWidget {
  const BottomSongPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentSongProvider>(
        builder: (context, CurrentSongProvider currentSong, child) {
      if (currentSong.value == null) {
        return const SizedBox.shrink(); // No song is playing, hide the player
      }
      Song? _song = SongRepository.getSong(currentSong.value!);

      return Container(
        height: 80,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${_song?.title}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Consumer<LoopModeProvider>(
                builder: (context, LoopModeProvider loopMode, child) {
              return Stack(
                children: [
                  IconButton(
                      icon: const Icon(
                        Icons.loop,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: () {
                        locator.get<SongController>().toggleLoopMode();
                      }),
                  if (loopMode.value == LoopMode.one)
                    Positioned(
                      right: 2,
                      bottom: 6,
                      child: Container(
                        height: 17,
                        width: 17,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    )
                ],
              );
            }),
            VolumeIcon(),
            //add slider widget here
            Consumer<VolumeProvider>(builder: (
              context,
              VolumeProvider volumeProvider,
              child,
            ) {
              return Row(
                children: [
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 20),
                    child: Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.white30,
                      value: volumeProvider.value.toDouble(),
                      max: 1,
                      onChanged: (value) {
                        // Seek to the new position
                        locator.get<SongController>().setVolume(value);
                      },
                    ),
                  ),
                ],
              );
            }),

            Consumer2<DurationProvider, PositionProvider>(builder: (
              context,
              DurationProvider durationProvider,
              PositionProvider positionProvider,
              child,
            ) {
              if (positionProvider.value != null &&
                  durationProvider.value != null) {
                return Row(
                  children: [
                    Text(
                      SongUtils.formatDuration(positionProvider.value!),
                      // "current",//_formatDuration(songProvider.currentPosition),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Container(
                      width: 200,
                      child: Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        value: positionProvider.value!.inSeconds
                            .toDouble(), //  .currentPosition.inSeconds.toDouble(),
                        max: durationProvider.value!.inSeconds.toDouble(),
                        onChanged: (value) {
                          // Seek to the new position
                          locator
                              .get<SongController>()
                              .seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Text(
                      SongUtils.formatDuration(durationProvider.value!),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                );
              }
              return const SizedBox();
            }),
            Consumer<SongPlayingProvider>(
                builder: (context, SongPlayingProvider isSongPlaying, child) {
              return IconButton(
                  icon: Icon(
                    isSongPlaying.value
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () {
                    locator.get<SongController>().play("${_song?.path}");
                  });
            }),
          ],
        ),
      );
    });
  }
}
