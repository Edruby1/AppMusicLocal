import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

enum MusicStatus { playing, paused, stopped }

Map<int, String> lastMusic = {};
String? last;

int songIndex = 0;
int maxIndex = 0;

class MusicManager {
  static final _player = AudioPlayer();

  static FileModel? _actualSong;

  static MusicStatus _status = MusicStatus.stopped;

  static FileModel? get song => _actualSong;

  static Stream<Duration?> get duration => _player.durationStream;

  static Stream<Duration?> get position => _player.positionStream;

  static MusicStatus get status => _status;

  static bool get isPlaying => _player.playing;

  static final ValueNotifier<FileModel?> actualSongEvent = ValueNotifier(null);

  static Future<void> init() async {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        play();
      }
    });
  }

  static void changeState({required MusicStatus newStatus}) {
    _status = newStatus;
  }

  static void _addNewSongToList(String id) {
    int musicId = lastMusic.length + 1;
    lastMusic[musicId] = id;
    songIndex = musicId;
    AppLogger.info("ID cambiada en \"_addNewSongToList\": $songIndex");
  }

  static Future<void> play({FileModel? song, bool isNewSong = true}) async {
    AppLogger.info("[PLAY] Intentando reproducir, id actual: $songIndex");
    if (song != null) {
      await _player.setFilePath(song.path);
      _player.play();
      _actualSong = song;
      _status = MusicStatus.playing;
      actualSongEvent.value = song;
      last = song.id;
      if (isNewSong) {
        _addNewSongToList(song.id);
        maxIndex++;
        AppLogger.info(
          "[PLAY] Añadiendo nueva cancion a la lista. MAX INDEX: $maxIndex",
        );
      }
      AppLogger.info("playing ${song.name}");
    } else {
      final newSong = await FileRepository.pickRandom(id: last);
      if (newSong != null) {
        await _player.setFilePath(newSong.path);
        _player.play();
        _actualSong = newSong;
        _status = MusicStatus.playing;
        actualSongEvent.value = newSong;
        last = newSong.id;
        if (isNewSong) {
          _addNewSongToList(newSong.id);
          maxIndex++;
        }
        AppLogger.info("playing ${newSong.name}");
      } else {
        AppLogger.warn("No tienes canciones guardadas, trata de agregar una");
      }
    }
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

  static Future<void> next() async {
    AppLogger.info("[NEXT] Usando id $songIndex");
    if (songIndex < maxIndex) {
      int newIndex = songIndex + 1;
      AppLogger.info("[NEXT] id usado y modificado $newIndex");
      final newSong = await FileRepository.getFile(id: lastMusic[newIndex]!);
      if (newSong != null) {
        songIndex = newIndex;
        play(song: newSong, isNewSong: false);
      } else {
        AppLogger.warn("No existe esa cancion");
      }
    } else {
      play();
    }
  }

  static Future<void> previus() async {
    AppLogger.info("[PREVIUS] Usando id $songIndex");
    if (songIndex > 1) {
      int newIndex = songIndex - 1;
      AppLogger.info("[PREVIUS] Id modificado y usado $newIndex");
      if (lastMusic.containsKey(newIndex)) {
        FileModel? song = await FileRepository.getFile(
          id: lastMusic[newIndex]!,
        );
        if (song == null) return;
        songIndex = newIndex;
        play(song: song, isNewSong: false);
      }
    }
  }
}
