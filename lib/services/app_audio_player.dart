import 'package:just_audio/just_audio.dart';

// import 'package:just_audio/just_audio.dart';

class AppAudioPlayer {
  static final AppAudioPlayer instance = AppAudioPlayer._internal();
  AppAudioPlayer._internal() {
    setup();
  }

  bool _isInitialized = false;

  void setup() async {
    if (_isInitialized) return;
    _audioPlayer = AudioPlayer();
    _audioPlayer.setLoopMode(LoopMode.off);
    _isInitialized = true;
  }

  late final AudioPlayer _audioPlayer;
  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> play(String filePath) async {
    try {
      setup(); // Ensure it's initialized
      // await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  Future<void> resume() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print("Error resuming audio: $e");
    }
  }

  bool isPlaying() {
    setup();
    return _audioPlayer.playing;
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  //streams
  Stream<PlayerState> get playingStream => _audioPlayer.playerStateStream;
  Stream<double> get speedStream => _audioPlayer.speedStream;
  Stream<double> get volumeStream => _audioPlayer.volumeStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<IcyMetadata?> get icyMetadataStream => _audioPlayer.icyMetadataStream;
  Stream<LoopMode> get loopModeStream => _audioPlayer.loopModeStream;

  void setSpeed(double speed) {
    _audioPlayer.setSpeed(speed);
  }

  void setVolume(double volume) {
    _audioPlayer.setVolume(volume);
  }

  void seekTo(Duration? duration) {
    _audioPlayer.seek(duration);
  }

  void setLoopMode(LoopMode loop) {
    _audioPlayer.setLoopMode(loop);
  }

  void setAudioSource(ConcatenatingAudioSource source) {
    _audioPlayer.setAudioSource(source);
  }
}
