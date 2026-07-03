import 'package:app_local_music/core/AppColors.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:app_local_music/features/player/widgets/ButtonsNavigateSoundsWidget.dart';
import 'package:app_local_music/features/player/widgets/MusicListWidget.dart';
import 'package:app_local_music/features/player/widgets/ProgressSongWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: body(),
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: Text(
          "Reproductor de musica",
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final path = await FilePicker.pickFiles(type: FileType.audio);
          if (path == null) return;
          await FileRepository.addFile(path.paths.first!);
        },
        backgroundColor: AppColors.accent,
        child: Icon(Icons.add, color: AppColors.icons),
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
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Reproduciendo",
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 75,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: MusicManager.actualSongEvent,
                  builder: (context, value, _) {
                    if (value == null) {
                      return Text(
                        "No se esta reproduciendo ninguna cancion",
                        style: TextStyle(
                          color: AppColors.textVariant,
                          fontSize: 20,
                        ),
                      );
                    }
                    return Marquee(
                      blankSpace: 150,
                      text: value.name,
                      style: TextStyle(
                        color: AppColors.accentVariant,
                        fontSize: 20,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
