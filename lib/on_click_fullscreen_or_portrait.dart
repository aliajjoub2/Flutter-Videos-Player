import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import 'advancedOverVideoPlayer.dart';

class VideoPlayerBothWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayerBothWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _VideoPlayerBothWidgetState createState() => _VideoPlayerBothWidgetState();
}

class _VideoPlayerBothWidgetState extends State<VideoPlayerBothWidget> {
  Orientation? target;

  @override
  void initState() {
    super.initState();

    NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      final isPortrait = event == NativeDeviceOrientation.portraitUp;
      final isLandscape = event == NativeDeviceOrientation.landscapeLeft ||
          event == NativeDeviceOrientation.landscapeRight;
      final isTargetPortrait = target == Orientation.portrait;
      final isTargetLandscape = target == Orientation.landscape;

      if (isPortrait && isTargetPortrait || isLandscape && isTargetLandscape) {
        //target = Orientation.portrait;
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    });
  }

  void setOrientation(bool isPortrait) {
    if (isPortrait) {
      Wakelock.disable();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    } else {
      Wakelock.enable();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  @override
  Widget build(BuildContext context) =>
      // Container(alignment: Alignment.topCenter, child: buildVideo());

      widget.controller.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : const Center(child: CircularProgressIndicator());

     Widget buildVideo() => OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          setOrientation(isPortrait);

          return Stack(
            fit: isPortrait ? StackFit.loose : StackFit.expand,
            children: <Widget>[
              buildVideoPlayer(isPortrait),
              Positioned.fill(
                child: AdvancedOverlayWidget(
                  controller: widget.controller,
                  onClickedFullScreen: () {
                    target = isPortrait
                        ? Orientation.landscape
                        : Orientation.portrait;

                    if (isPortrait) {
                      AutoOrientation.landscapeRightMode();
                    } else {
                      AutoOrientation.portraitUpMode();
                    }
                    if (target == Orientation.landscape) {
                      setState(() {
                        target = Orientation.portrait;
                      });
                    }
                     if (target == Orientation.portrait) {
                      setState(() {
                        target = Orientation.landscape;
                      });
                    }
                  },
                ),
              ),
            ],
          );
        },
      );

  Widget buildVideoPlayer(isPortrait) {
    final video = AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: VideoPlayer(widget.controller),
    );

    return buildFullScreen(child: video, isPortrait: isPortrait);
  }

  Widget buildFullScreen({required Widget child, isPortrait}) {
    final size = widget.controller.value.size;

    var width = size.width;
    var height = size.height;
    if (width == 0) {
      width = MediaQuery.of(context).size.width;
    }
    if (height == 0) {
      height = 100.0;
    }

    print('===== ${MediaQuery.of(context).size.height}');
    print('===== ${MediaQuery.of(context).size.width}');

    print(width);
    print(height);
    print(target);
    return SizedBox(
        width: width,
        height: isPortrait
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height,
        child: child);
  }
}
