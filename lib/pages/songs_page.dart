import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/controllers/play_button_controller.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/player_page.dart';
import 'package:music_app/pages/results_page.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  PlayButtonController? _controller;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PlayButtonController>();
  }

  Widget _buildAlbumCard(int index) {
    return GestureDetector(
      onTap: () async {
        _controller!.playIndex.value = index;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerPage(songs: recommendedSongs),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              width: 155,
              height: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    recommendedSongs[index].imageUrl!,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              recommendedSongs[index].title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongCard(int index) {
    return GestureDetector(
      onTap: () async {
        _controller!.playIndex.value = index;
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerPage(songs: popularSongs),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(popularSongs[index].imageUrl!),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  popularSongs[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  popularSongs[index].artist!,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(
      {required TextEditingController controller, required String label}) {
    return TextField(
      onSubmitted: (value) async {
        String text = value;
        _textController.clear();
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ResultsPage(query: text),
          ),
        );
      },
      controller: controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          FontAwesomeIcons.magnifyingGlass,
          color: Colors.white,
        ),
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.white60,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.white60,
            width: 1,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: backgroundDarkColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: backgroundDarkColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "MusiclyAI",
          style: TextStyle(
            fontSize: 21,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundDarkColor,
      body: _controller == null
          ? const Center(
              child: CircularProgressIndicator(color: sliderColor),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7),
                    const Text(
                      "Listen to the Latest Songs",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 17),
                    _buildSearchBox(
                        controller: _textController, label: "Search song..."),
                    const SizedBox(height: 25),
                    const Text(
                      "Popular",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        itemCount: recommendedSongs.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => _buildAlbumCard(index),
                      ),
                    ),
                    const Text(
                      "Recommended for you",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 25),
                    for (int i = 0; i < popularSongs.length; i++)
                      _buildSongCard(i),
                  ],
                ),
              ),
            ),
    );
  }
}
