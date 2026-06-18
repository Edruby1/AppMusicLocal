import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:just_audio/just_audio.dart';

enum MusicStatus { playing, paused, stopped }

class MusicManager {
  static final _player = AudioPlayer();

  static FileModel? _actualSong;

  static Duration? _duration;

  static Duration? _position;

  static MusicStatus _status = MusicStatus.stopped;

  static FileModel? get song => _actualSong;

  static Duration? get duration => _duration;

  static MusicStatus get status => _status;

  static Duration? get position => _position;

  static Future<void> play({required FileModel song}) async {
    await _player.setUrl(song.path);
    await _player.play();
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
    _duration = null;
    _position = null;
    AppLogger.info("stoping song");
  }

  static Future<void> resume() async {
    _player.play();
    _status = MusicStatus.playing;
    AppLogger.info("resuming song");
  }
}
