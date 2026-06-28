import 'package:app_local_music/core/widgets/SongsWidget.dart';
import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:app_local_music/features/player/widgets/ButtonsNavigateSoundsWidget.dart';
import 'package:app_local_music/features/player/widgets/MusicListWidget.dart';
import 'package:app_local_music/features/player/widgets/ProgressSongWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final path = await FilePicker.pickFiles(type: FileType.audio);
          if (path == null) return;
          await FileRepository.addFile(path.paths.first!);
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget body() {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonsNavigateSoundsWidget(),
              ProgressSongWidget(),
              SizedBox(height: 180),
            ],
          ),
          MusicListWidget(),
        ],
      ),
    );
  }
}
