import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'package:songer/services/app_audio_player.dart';
import 'package:songer/utils/single_provider.dart'; // Import for file operations

class SongController {
  CurrentSongProvider currentSong = CurrentSongProvider(null);
  late AppAudioPlayer _appAudioPlayer;

  VolumeProvider volumeProvider = VolumeProvider(1);
  SpeedProvider speedProvider = SpeedProvider(1);
  DurationProvider durationProvider = DurationProvider(null);
  PositionProvider positionProvider = PositionProvider(null);
  SongPlayingProvider isSongPlaying = SongPlayingProvider(false);
  LoopModeProvider loopMode = LoopModeProvider(LoopMode.off);
  SingleProvider<IcyMetadata?> currentMetaProvider =
      SingleProvider<IcyMetadata?>(null);

  AudioSource? playlist = null;

  SongController() {
    _appAudioPlayer = AppAudioPlayer.instance;
    _appAudioPlayer.volumeStream.listen((newVolume) {
      volumeProvider.update(newVolume);
    });

    _appAudioPlayer.speedStream.listen((newSpeed) {
      speedProvider.update(newSpeed);
    });

    _appAudioPlayer.durationStream.listen((newDuration) {
      durationProvider.update(newDuration);
    });

    _appAudioPlayer.positionStream.listen((newPosition) {
      print("SongPos:${newPosition.inSeconds}");
      positionProvider.update(newPosition);
    });

    _appAudioPlayer.icyMetadataStream.listen((newMetaData) {
      currentMetaProvider.update(newMetaData);
    });

    // _appAudioPlayer.playingStream.listen((playerState) {
    //   isSongPlaying.update(playerState.playing);
    // });

    _appAudioPlayer.playingStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        isSongPlaying.update(false);
      } else if (!isPlaying) {
        isSongPlaying.update(false);
      } else if (processingState != ProcessingState.completed) {
        isSongPlaying.update(true);
      } else {
        positionProvider.update(Duration.zero);
        // _pauseCurrent();
      }
    });

    _appAudioPlayer.loopModeStream.listen((loop) {
      loopMode.update(loop);
    });

    _appAudioPlayer.setVolume(0.01);
  }

  _pauseCurrent() {
    if (currentSong.value != null) play(currentSong.value!);
  }

  play(String song) {
    if (playlist == null) {
      playlist = ConcatenatingAudioSource(
        children: [
          AudioSource.file(song),
        ],
      );
      _appAudioPlayer.setAudioSource(
        playlist as ConcatenatingAudioSource,
      );
      currentSong.update(song);
      _appAudioPlayer.audioPlayer.play();
      return;
    }
    if (currentSong.value == song) {
      _appAudioPlayer.isPlaying()
          ? _appAudioPlayer.pause()
          : _appAudioPlayer.resume();
      return;
    }
    currentSong.update(song);
    // if (_appAudioPlayer.isPlaying()) _appAudioPlayer.stop();
    (_appAudioPlayer.audioPlayer.audioSource as ConcatenatingAudioSource)
        .clear();
    (_appAudioPlayer.audioPlayer.audioSource as ConcatenatingAudioSource)
        .add(AudioSource.file(song));
    if (!_appAudioPlayer.isPlaying()) _appAudioPlayer.resume();
    // (_appAudioPlayer.audioPlayer.audioSource as ConcatenatingAudioSource).removeAt(0);
    // _appAudioPlayer.audioPlayer.play();
    // _appAudioPlayer.play(song);
  }

  stopSong() {
    currentSong.update(null);
    _appAudioPlayer.stop();
  }

  void setSpeed(double speed) {
    _appAudioPlayer.setSpeed(speed);
  }

  void setVolume(double volume) {
    _appAudioPlayer.setVolume(volume);
  }

  void seekTo(Duration? duration) {
    _appAudioPlayer.seekTo(duration);
  }

  void toggleLoopMode() {
    if (loopMode.value == LoopMode.off) {
      _appAudioPlayer.setLoopMode(LoopMode.one);
    } else if (loopMode.value == LoopMode.one) {
      _appAudioPlayer.setLoopMode(LoopMode.off);
    }
  }
}

class VolumeProvider extends SingleProvider<double> {
  VolumeProvider(super.value);
}

class SpeedProvider extends SingleProvider<double> {
  SpeedProvider(super.value);
}

class DurationProvider extends SingleProvider<Duration?> {
  DurationProvider(super.value);
}

class PositionProvider extends SingleProvider<Duration?> {
  PositionProvider(super.value);
}

class SongPlayingProvider extends SingleProvider<bool> {
  SongPlayingProvider(super._value);
}

class CurrentSongProvider extends SingleProvider<String?> {
  CurrentSongProvider(super._value);
}

class LoopModeProvider extends SingleProvider<LoopMode> {
  LoopModeProvider(super._value);
}
