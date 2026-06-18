import 'dart:math';

import 'package:app_local_music/core/logger/AppError.dart';
import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:hive_flutter/adapters.dart';

class FileRepository {
  static final Box<FileModel> _box = Hive.box<FileModel>("files");

  static Future<List<FileModel>> getAllFiles() async {
    final List<FileModel> files = _box.values.toList();
    return files;
  }

  static Future<void> addFile(FileModel file) async {
    await _box.add(file);
  }

  static Future<void> deleteFile(int id) async {
    for (final file in _box.values) {
      if (file.id == id) {
        await _box.delete(file);
        break;
      }
      throw AppError(msj: "El archivo no se encontro");
    }
  }

  static Future<void> modifyFile({
    required int id,
    required String? name,
    required String? path,
  }) async {
    for (final key in _box.keys) {
      final file = _box.get(key);
      if (file?.id == id) {
        final updated = FileModel(
          id: file!.id,
          name: name ?? file.name,
          path: path ?? file.path,
        );
        await _box.put(key, updated);
        break;
      }
    }
  }

  static Future<FileModel> pickRandom() async {
    final List<FileModel> songs = _box.values.toList();
    AppLogger.info(songs.length.toString());
    final random = Random();
    final FileModel song = songs[random.nextInt(songs.length)];
    return song;
  }
}
