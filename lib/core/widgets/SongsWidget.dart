import 'package:app_local_music/core/AppColors.dart';
import 'package:app_local_music/core/logger/AppLogger.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:flutter/material.dart';

class SongsWidget extends StatefulWidget {
  final FileModel song;
  final DraggableScrollableController controler;
  final ScrollController scroll;
  const SongsWidget({
    super.key,
    required this.song,
    required this.controler,
    required this.scroll,
  });

  @override
  State<SongsWidget> createState() => _SongsWidgetState();
}

class _SongsWidgetState extends State<SongsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  child: IconButton(
                    onPressed: () async {
                      AppLogger.info("Borrando la cancion: ${widget.song.id}");
                      await FileRepository.deleteFile(widget.song.id);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete, color: AppColors.icons),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: MusicManager.actualSongEvent,
                    builder: (context, value, _) {
                      return Text(
                        widget.song.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: value?.id == widget.song.id
                              ? AppColors.accent
                              : AppColors.text,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          onTap: () async {
            Future.wait([
              widget.controler.animateTo(
                0.1,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              ),
              widget.scroll.animateTo(
                0,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
              ),
            ]);
            MusicManager.changeState(newStatus: MusicStatus.playing);
            MusicManager.play(song: widget.song);
          },
        ),
      ),
    );
  }
}
