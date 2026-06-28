import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ButtonsNavigateSoundsWidget extends StatefulWidget {
  const ButtonsNavigateSoundsWidget({super.key});

  @override
  State<ButtonsNavigateSoundsWidget> createState() =>
      _ButtonsNavigateSoundsWidgetState();
}

class _ButtonsNavigateSoundsWidgetState
    extends State<ButtonsNavigateSoundsWidget> {
  MusicStatus status = MusicStatus.stopped;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              MusicManager.previus();
            },
            icon: Icon(Icons.skip_previous),
          ),
          IconButton(
            onPressed: () async {
              if (status == MusicStatus.playing) {
                await MusicManager.pause();
                setState(() {
                  status = MusicStatus.paused;
                });
              } else if (status == MusicStatus.paused) {
                await MusicManager.resume();
                setState(() {
                  status = MusicStatus.playing;
                });
              } else {
                final statusPermission = await Permission.audio.request();
                if (statusPermission == PermissionStatus.granted) {
                  MusicManager.play();
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    if (!MusicManager.isPlaying) return;
                    status = MusicStatus.playing;
                  });
                }
              }
            },
            icon: Icon(Icons.play_arrow),
          ),
          IconButton(
            onPressed: () {
              MusicManager.next();
            },
            icon: Icon(Icons.skip_next),
          ),
        ],
      ),
    );
  }
}
