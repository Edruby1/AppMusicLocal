import 'package:app_local_music/core/AppColors.dart';
import 'package:app_local_music/features/Library/services/MusicManager.dart';
import 'package:flutter/material.dart';

class ProgressSongWidget extends StatefulWidget {
  const ProgressSongWidget({super.key});

  @override
  State<ProgressSongWidget> createState() => _ProgressSongWidgetState();
}

class _ProgressSongWidgetState extends State<ProgressSongWidget> {
  bool isDragging = false;
  double? sliderValue;
  Duration? duration;
  Duration? position;

  @override
  void initState() {
    super.initState();
    MusicManager.duration.listen((dur) {
      setState(() {
        duration = dur;
      });
    });
    MusicManager.position.listen((pos) {
      if (!isDragging) {
        setState(() {
          position = pos;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            timeReformat(position ?? Duration()),
            style: TextStyle(color: AppColors.text),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              thumbShape: const RoundSliderOverlayShape(overlayRadius: 6),

              activeTrackColor: AppColors.progress,
              inactiveTrackColor: AppColors.rest,
              overlayColor: Colors.transparent,
              thumbColor: AppColors.progress,
              showValueIndicator: ShowValueIndicator.alwaysVisible,
            ),
            child: Slider(
              value: sliderValue ?? position?.inMilliseconds.toDouble() ?? 0,
              max: duration?.inMilliseconds.toDouble() ?? 1,

              onChanged: (v) {
                if (MusicManager.status == MusicStatus.stopped) return;
                setState(() {
                  isDragging = true;
                  sliderValue = v;
                });
              },

              onChangeEnd: (v) async {
                setState(() {
                  isDragging = false;
                  sliderValue = null;
                });
                await MusicManager.seek(Duration(milliseconds: v.toInt()));
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            timeReformat(duration ?? Duration()),
            style: TextStyle(color: AppColors.text),
          ),
        ),
      ],
    );
  }

  String timeReformat(Duration time) {
    final minutes = time.inMinutes;
    final seconds = time.inSeconds % 60;

    return "$minutes:${seconds.toString().padLeft(2, "0")}";
  }
}
