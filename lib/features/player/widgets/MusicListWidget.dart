import 'package:app_local_music/core/widgets/SongsWidget.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:flutter/material.dart';

class MusicListWidget extends StatefulWidget {
  const MusicListWidget({super.key});

  @override
  State<MusicListWidget> createState() => _MusicListWidgetState();
}

class _MusicListWidgetState extends State<MusicListWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder(
        future: FileRepository.getAllFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<FileModel> music = snapshot.data ?? [];
            return DraggableScrollableSheet(
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 0.5,
              builder: (context, scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: music.length,
                  itemBuilder: (context, index) {
                    return SongsWidget(song: music[index]);
                  },
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
