import 'package:app_local_music/features/Library/models/FileModel.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:app_local_music/features/player/screens/playerScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  void loadAll() async {
    await Hive.initFlutter();

    Hive.registerAdapter(FileModelAdapter());

    await Hive.openBox<FileModel>("files");

    //await FileRepository.clearAllFiles();

    await MusicManager.init();

    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loaded ? PlayerScreen() : Center(child: CircularProgressIndicator());
  }
}
