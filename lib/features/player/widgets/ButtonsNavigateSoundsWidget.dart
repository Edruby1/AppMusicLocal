import 'package:app_local_music/core/AppColors.dart';
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
            icon: Icon(Icons.skip_previous, color: AppColors.icons),
          ),
          IconButton(
            onPressed: () async {
              if (MusicManager.status == MusicStatus.playing) {
                await MusicManager.pause();
                MusicManager.changeState(newStatus: MusicStatus.paused);
              } else if (MusicManager.status == MusicStatus.paused) {
                await MusicManager.resume();
                MusicManager.changeState(newStatus: MusicStatus.playing);
              } else {
                final statusPermission = await Permission.audio.request();
                if (statusPermission == PermissionStatus.granted) {
                  MusicManager.play();
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (!MusicManager.isPlaying) return;
                  MusicManager.changeState(newStatus: MusicStatus.playing);
                }
              }
            },
            icon: Icon(Icons.play_arrow, color: AppColors.icons),
          ),
          IconButton(
            onPressed: () {
              MusicManager.next();
            },
            icon: Icon(Icons.skip_next, color: AppColors.icons),
          ),
        ],
      ),
    );
  }
}
