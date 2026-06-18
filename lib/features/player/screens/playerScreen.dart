import 'dart:io';

import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late MusicStatus actualState;

  @override
  void initState() {
    super.initState();
    actualState = MusicManager.status;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Column(
        children: [
          Text(actualState.toString()),
          //Slider(value: 0, onChanged: (v) {}),
          IconButton(
            onPressed: () async {
              if (actualState == MusicStatus.playing) {
                await MusicManager.pause();
              } else if (actualState == MusicStatus.paused) {
                await MusicManager.resume();
              } else {
                final status = await Permission.audio.request();
                if (status == PermissionStatus.granted) {
                  final file = File("/storage/emulated/0/Download/Mai.mp4");

                  final a = await file.exists();
                  final b = await file.length();

                  AppLogger.info(a.toString());
                  AppLogger.info(b.toString());
                  final FileModel song = await FileRepository.pickRandom();
                  await MusicManager.play(song: song);
                }
              }
            },
            icon: Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
