import 'package:app_local_music/core/AppColors.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:flutter/material.dart';

class SongsWidget extends StatefulWidget {
  final FileModel song;
  final DraggableScrollableController controler;
  const SongsWidget({super.key, required this.song, required this.controler});

  @override
  State<SongsWidget> createState() => _SongsWidgetState();
}

class _SongsWidgetState extends State<SongsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.song.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: AppColors.text),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            widget.controler.animateTo(
              0.1,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
            MusicManager.changeState(newStatus: MusicStatus.playing);
            MusicManager.play(song: widget.song);
          },
        ),
      ),
    );
  }
}
