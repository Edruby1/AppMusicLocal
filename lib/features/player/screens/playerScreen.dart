import 'dart:io';

import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:file_picker/file_picker.dart';
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
  bool isDragging = false;
  double? sliderValue;
  Duration? duration;
  Duration? position;

  @override
  void initState() {
    super.initState();
    actualState = MusicManager.status;
    MusicManager.duration.listen((dur) {
      setState(() {
        duration = dur;
      });
    });
    MusicManager.position.listen((pos) {
      if (!isDragging) {
        setState(() {
          position = pos;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                final path = await FilePicker.pickFiles(type: FileType.audio);
                if (path == null) return;
                await FileRepository.addFile(path.paths.first!);
              },
              icon: Icon(Icons.add),
            ),
            Text(actualState.toString()),
            Slider(
              value: sliderValue ?? position?.inMilliseconds.toDouble() ?? 0,
              max: duration?.inMilliseconds.toDouble() ?? 1,

              onChanged: (v) {
                setState(() {
                  isDragging = true;
                  sliderValue = v;
                });
              },

              onChangeEnd: (v) async {
                setState(() {
                  isDragging = false;
                  sliderValue = null;
                });
                await MusicManager.seek(Duration(milliseconds: v.toInt()));
              },
            ),
            IconButton(
              onPressed: () async {
                if (actualState == MusicStatus.playing) {
                  await MusicManager.pause();
                  setState(() {
                    actualState = MusicStatus.paused;
                  });
                } else if (actualState == MusicStatus.paused) {
                  await MusicManager.resume();
                  setState(() {
                    actualState = MusicStatus.playing;
                  });
                } else {
                  AppLogger.info("1");
                  final status = await Permission.audio.request();
                  if (status == PermissionStatus.granted) {
                    final FileModel song = await FileRepository.pickRandom();
                    await MusicManager.play(song: song);
                    setState(() {
                      actualState = MusicStatus.playing;
                      AppLogger.info("2");
                    });
                  }
                }
              },
              icon: Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
