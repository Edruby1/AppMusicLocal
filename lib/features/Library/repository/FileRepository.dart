import 'dart:async';
import 'dart:math';

import 'package:app_local_music/core/logger/AppError.dart';
import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:path/path.dart' as p;
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

class FileRepository {
  static final Box<FileModel> _box = Hive.box<FileModel>("files");

  static Future<List<FileModel>> getAllFiles() async {
    final List<FileModel> files = _box.values.toList();
    return files;
  }

  static Future<FileModel?> getFile({required String id}) async {
    final List<FileModel> files = _box.values.toList();
    if (files.isEmpty) return null;
    for (FileModel file in files) {
      if (file.id == id) {
        return file;
      }
    }
    return null;
  }

  static Future<void> addFile(String path) async {
    final uuid = Uuid();
    final file = FileModel(
      id: uuid.v4(),
      name: p.basename(path),
      icon: null,
      path: path,
    );
    await _box.add(file);
  }

  static Future<void> deleteFile(String id) async {
    for (final file in _box.values) {
      if (file.id == id) {
        await _box.delete(file);
        break;
      }
      throw AppError(msj: "El archivo no se encontro");
    }
  }

  static Future<void> modifyFile({
    required String id,
    required String? name,
    required String? icon,
    required String? path,
  }) async {
    for (final key in _box.keys) {
      final file = _box.get(key);
      if (file?.id == id) {
        final updated = FileModel(
          id: file!.id,
          name: name ?? file.name,
          icon: icon ?? file.icon,
          path: path ?? file.path,
        );
        await _box.put(key, updated);
        break;
      }
    }
  }

  static Future<FileModel?> pickRandom({String? id}) async {
    final List<FileModel> songs = _box.values.toList();
    if (songs.isNotEmpty) {
      final random = Random();
      while (id != null && songs.length > 1) {
        final FileModel song = songs[random.nextInt(songs.length)];
        if (song.id != id) return song;
      }

      final FileModel song = songs[random.nextInt(songs.length)];
      return song;
    } else {
      AppLogger.error("No hay canciones guardadas");
      return null;
    }
  }

  static Future<void> clearAllFiles() async {
    await _box.clear();
  }
}
