import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videos/speed.dart';

import 'on_click_fullscreen_or_portrait.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

int myindex = 0;

class _HomeState extends State<Home> {
  

  List list = [
    VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    VideoPlayerController.network('https://www.fluttercampus.com/video.mp4'),
    VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    VideoPlayerController.network('https://www.fluttercampus.com/video.mp4'),
  ];
  late VideoPlayerController controller;

  // double screenHeight = 0;
  // double screenWidth = 0;
  bool volumeOn = true;

  Widget playlist() {
    return Container(
      
      alignment: Alignment.bottomLeft,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return playlistItem(index);
          }),
    );
  }

  Widget playlistItem(int index) {
    return InkWell(
      onTap: () => setState(() {
        myindex = index;
        loadVideoPlayer(myindex);
      }),
      splashColor: Colors.transparent,
      highlightColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Text(
              '0${index + 1}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Barlow'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'video title $index',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Barlow'),
                  ),
                  SizedBox(height: 10),
                  Text('video about $index',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xff5d6169),
                      )),
                ],
              ),
            ),
            Icon(
              Icons.menu_rounded,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }

  loadVideoPlayer(myindex) {
    controller = list[myindex];
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value) {
      setState(() {
        controller.play();
      });
    });
  }

  Widget nextPrevious() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (myindex > 0) {
                setState(() {
                  myindex--;
                  loadVideoPlayer(myindex);
                });
                print('------------------------------');
                print(myindex);
              }
            },
            icon: const Icon(Icons.skip_previous)),
        IconButton(
            onPressed: () {
              if (myindex < (list.length - 1)) {
                setState(() {
                  myindex++;
                  loadVideoPlayer(myindex);
                });
                print('------------------------------');
                print(myindex);
              }
            },
            icon: const Icon(Icons.skip_next)),
        // start volume
        volume(),
      ],
    );
  }

  Widget volume() {
    return IconButton(
        onPressed: () {
          if (controller != null && controller.value.isInitialized) {
            setState(() {
              volumeOn = !volumeOn;
              volumeOn ? controller.setVolume(1.0) : controller.setVolume(0.0);
            });
          }
        },
        icon: volumeOn ? Icon(Icons.volume_mute) : Icon(Icons.volume_off));
  }
 
  String getPosition() {
    final duration = Duration(
        milliseconds: controller.value.position.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
  @override
  void initState() {
    loadVideoPlayer(myindex);
    super.initState();
    //controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
     
      body: 
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: [
            // AspectRatio(
            //   aspectRatio: controller.value.aspectRatio,
            //   child: VideoPlayer(controller),
            // ),
          SizedBox(
           
            width: double.infinity,
            child: VideoPlayerBothWidget(controller: controller),

          ),
            Text("video $myindex,${getPosition()}"),
            VideoProgressIndicator(controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  backgroundColor: Colors.redAccent,
                  playedColor: Colors.green,
                  bufferedColor: Colors.purple,
                )),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (controller.value.isPlaying) {
                        controller.pause();
                      } else {
                        controller.play();
                      }

                      setState(() {});
                    },
                    icon: Icon(controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow)),
                IconButton(
                    onPressed: () {
                      controller.seekTo(Duration(seconds: 0));

                      setState(() {});
                    },
                    icon: Icon(Icons.stop)),
              // start speed widget
              SpeedWidget(controller: controller,),
              ],
            ),
            // start next and previous
            nextPrevious(),
            // strat playlist
            playlist(),
          ]),
        ),
      ),
    
    );
  }
}
