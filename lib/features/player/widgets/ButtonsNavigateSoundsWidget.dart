import 'package:app_local_music/core/AppColors.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: constant_identifier_names
enum ReproductorIcons { play_arrow, pause }

class ButtonsNavigateSoundsWidget extends StatefulWidget {
  const ButtonsNavigateSoundsWidget({super.key});

  @override
  State<ButtonsNavigateSoundsWidget> createState() =>
      _ButtonsNavigateSoundsWidgetState();
}

class _ButtonsNavigateSoundsWidgetState
    extends State<ButtonsNavigateSoundsWidget> {
  ReproductorIcons actualIcon = ReproductorIcons.play_arrow;

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
                setState(() {
                  actualIcon = ReproductorIcons.play_arrow;
                });
              } else if (MusicManager.status == MusicStatus.paused) {
                await MusicManager.resume();
                MusicManager.changeState(newStatus: MusicStatus.playing);
                setState(() {
                  actualIcon = ReproductorIcons.pause;
                });
              } else {
                final statusPermission = await Permission.audio.request();
                if (statusPermission == PermissionStatus.granted) {
                  MusicManager.play();
                  await Future.delayed(const Duration(milliseconds: 500));
                  if (!MusicManager.isPlaying) return;
                  MusicManager.changeState(newStatus: MusicStatus.playing);
                  setState(() {
                    actualIcon = ReproductorIcons.pause;
                  });
                }
              }
            },
            icon: Icon(getIcon(actualIcon), color: AppColors.icons),
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

  IconData getIcon(ReproductorIcons icon) {
    switch (icon) {
      case ReproductorIcons.play_arrow:
        return Icons.play_arrow;
      case ReproductorIcons.pause:
        return Icons.pause;
    }
  }
}
