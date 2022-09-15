
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class SpeedWidget extends StatelessWidget {
  final VideoPlayerController controller;
  static const allSpeeds = <double>[0.25, 0.5, 1, 1.5, 2, 3, 5, 10];
  const SpeedWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topRight,
        child: PopupMenuButton<double>(
          initialValue: controller.value.playbackSpeed,
          tooltip: 'Playback speed',
          onSelected: controller.setPlaybackSpeed,
          itemBuilder: (context) => allSpeeds
              .map<PopupMenuEntry<double>>((speed) => PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  ))
              .toList(),
          child: Container(
            color: Colors.white38,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text('${controller.value.playbackSpeed}x'),
          ),
        ),
      );
  }
}