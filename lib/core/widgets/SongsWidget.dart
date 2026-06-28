import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:flutter/material.dart';

class SongsWidget extends StatefulWidget {
  final FileModel song;
  const SongsWidget({super.key, required this.song});

  @override
  State<SongsWidget> createState() => _SongsWidgetState();
}

class _SongsWidgetState extends State<SongsWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 200,
      child: InkWell(
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.song.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(),
              ),
            ),
          ],
        ),
        onTap: () => MusicManager.play(song: widget.song),
      ),
    );
  }
}
