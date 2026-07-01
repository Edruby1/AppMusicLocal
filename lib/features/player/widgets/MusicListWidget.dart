import 'package:app_local_music/core/AppColors.dart';
import 'package:app_local_music/core/widgets/SongsWidget.dart';
import 'package:app_local_music/features/Library/repository/FileRepository.dart';
import 'package:flutter/material.dart';

class MusicListWidget extends StatefulWidget {
  const MusicListWidget({super.key});

  @override
  State<MusicListWidget> createState() => _MusicListWidgetState();
}

class _MusicListWidgetState extends State<MusicListWidget> {
  final DraggableScrollableController controller =
      DraggableScrollableController();

  bool isStretch = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
        valueListenable: FileRepository.music,
        builder: (context, music, _) {
          if (music.isEmpty) {
            return Align(
              alignment: AlignmentGeometry.bottomEnd,
              child: SizedBox(
                height: 75,
                width: double.infinity,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "No tienes musica",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return DraggableScrollableSheet(
            controller: controller,
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.3,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: music.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Container(
                                height: 4,
                                width: 250,
                                decoration: BoxDecoration(
                                  color: AppColors.separator,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Tu musica",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SongsWidget(
                        song: music[index - 1],
                        controler: controller,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
