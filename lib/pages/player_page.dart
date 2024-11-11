import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/controllers/play_button_controller.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/widgets/animated_wave.dart';

class PlayerPage extends StatefulWidget {
  final List<Song> songs;

  const PlayerPage({
    super.key,
    required this.songs,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  PlayButtonController? _controller;

  final List<int> _animationDurations = [400, 500, 600, 700, 800];
  final List<Color> _animationColors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent
  ];
  bool _isPaused = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _controller = Get.find<PlayButtonController>();
    await _controller!
        .initialize(widget.songs[_controller!.playIndex.value].uri);
    _controller!.setPositionUpdate();
  }

  Future<void> _changeSong(int offset) async {
    int newIndex = _controller!.playIndex.value + offset;

    if (newIndex >= 0 && newIndex < widget.songs.length) {
      _controller!.playIndex.value = newIndex;
      await _controller!.initialize(widget.songs[newIndex].uri);
      await _controller!.audioPlayer.play();
    } else {
      debugPrint("Index out of bounds: $newIndex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDarkColor,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: backgroundColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            await _controller!.audioPlayer.stop();
            _controller!.isPlaying.value = false;
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _controller == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Obx(
                  () => Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: backgroundColor,
                      ),
                      alignment: Alignment.center,
                      child:
                          widget.songs[_controller!.playIndex.value].imageUrl ==
                                  null
                              ? const Icon(
                                  Icons.music_note,
                                  size: 40,
                                  color: whiteColor,
                                )
                              : Image.network(
                                  widget.songs[_controller!.playIndex.value]
                                      .imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.music_note,
                                      size: 40,
                                      color: whiteColor,
                                    );
                                  },
                                ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                      color: backgroundColor,
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () => Text(
                            widget.songs[_controller!.playIndex.value].title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Text(
                            widget.songs[_controller!.playIndex.value].artist ??
                                "Unknown artist",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 20,
                              color: whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              10,
                              (index) => AnimatedWave(
                                isPaused: _isPaused,
                                duration: _animationDurations[index % 5],
                                color: _animationColors[index % 4],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                _controller!.position.value,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: whiteColor,
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  thumbColor: sliderColor,
                                  activeColor: sliderColor,
                                  inactiveColor: Colors.grey,
                                  max: _controller!.maxValue.toDouble(),
                                  min: const Duration(seconds: 0)
                                      .inSeconds
                                      .toDouble(),
                                  value: _controller!.value.value,
                                  onChanged: (value) async {
                                    await _controller!
                                        .changeDurationToSeconds(value.toInt());
                                    value = value;
                                  },
                                ),
                              ),
                              Text(
                                _controller!.duration.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: whiteColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await _changeSong(-1);
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 40,
                                color: whiteColor,
                              ),
                            ),
                            Obx(
                              () => CircleAvatar(
                                radius: 35,
                                backgroundColor: whiteColor,
                                child: Transform.scale(
                                  scale: 2.5,
                                  child: IconButton(
                                    onPressed: () async {
                                      _controller!.isPlaying.value =
                                          !_controller!.isPlaying.value;
                                      if (!_controller!.isPlaying.value) {
                                        setState(() {
                                          _isPaused = true;
                                        });
                                        await _controller!.audioPlayer.pause();
                                      } else {
                                        setState(() {
                                          _isPaused = false;
                                        });
                                        await _controller!.audioPlayer.play();
                                      }
                                    },
                                    icon: _controller!.isPlaying.value
                                        ? const Icon(
                                            Icons.pause_rounded,
                                            color: backgroundColor,
                                          )
                                        : const Icon(
                                            Icons.play_arrow_rounded,
                                            color: backgroundColor,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _changeSong(1);
                              },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 40,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
