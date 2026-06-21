import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:just_audio/just_audio.dart';

enum MusicStatus { playing, paused, stopped }

class MusicManager {
  static final _player = AudioPlayer();

  static FileModel? _actualSong;

  static MusicStatus _status = MusicStatus.stopped;

  static FileModel? get song => _actualSong;

  static Stream<Duration?> get duration => _player.durationStream;

  static Stream<Duration?> get position => _player.positionStream;

  static MusicStatus get status => _status;

  static Future<void> play({required FileModel song}) async {
    await _player.setFilePath(song.path);
    _player.play();
    _actualSong = song;
    _status = MusicStatus.playing;
    AppLogger.info("playing ${song.name}");
  }

  static Future<void> pause() async {
    await _player.pause();
    _status = MusicStatus.paused;
    AppLogger.info("pausing song");
  }

  static Future<void> stop() async {
    await _player.stop();
    _status = MusicStatus.stopped;
    _actualSong = null;
    AppLogger.info("stoping song");
  }

  static Future<void> seek(Duration pos) async {
    await _player.seek(pos);
  }

  static Future<void> resume() async {
    _player.play();
    _status = MusicStatus.playing;
    AppLogger.info("resuming song");
  }
}
