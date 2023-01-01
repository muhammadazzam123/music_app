import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    // Listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // Listen to audio position
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget headerImage() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/music.jpg',
          width: double.infinity,
          height: 315,
          fit: BoxFit.cover,
        ),
      );
    }

    Widget bodyText() {
      return Column(
        children: [
          Text(
            'Bruno Mars',
            style: poppinsTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
              color: secondColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'The Lazy Song',
            style: poppinsTextStyle.copyWith(
              fontSize: 26,
              fontWeight: semiBold,
              color: firstColor,
            ),
          ),
        ],
      );
    }

    Widget bodySlider() {
      return Slider(
        activeColor: firstColor,
        inactiveColor: firstColor,
        min: 0,
        max: duration.inSeconds.toDouble(),
        value: position.inSeconds.toDouble(),
        onChanged: (value) async {
          final position = Duration(seconds: value.toInt());
          await audioPlayer.seek(position);

          // Optional: Play audio if was paused
          await audioPlayer.resume();
        },
      );
    }

    Widget bodyTime() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatTime(position),
              style: poppinsTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
                color: secondColor,
              ),
            ),
            Text(
              formatTime(duration - position),
              style: poppinsTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
                color: secondColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget buttonPlay() {
      return CircleAvatar(
        backgroundColor: secondColor,
        radius: 35,
        child: IconButton(
          color: firstColor,
          icon: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
          iconSize: 50,
          onPressed: () async {
            if (isPlaying) {
              await audioPlayer.pause();
            } else {
              String url =
                  "https://assets.mixkit.co/music/preview/mixkit-dreaming-big-31.mp3";
              await audioPlayer.play(url);
            }
          },
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              headerImage(),
              const SizedBox(height: 32),
              bodyText(),
              bodySlider(),
              bodyTime(),
              buttonPlay(),
            ],
          ),
        ),
      ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}
