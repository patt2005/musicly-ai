import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/constants/consts.dart';
import 'package:music_app/controllers/play_button_controller.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/player_page.dart';

class ResultsPage extends StatefulWidget {
  final String query;

  const ResultsPage({
    super.key,
    required this.query,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final List<Song> _songs = [];
  PlayButtonController? _controller;

  void _getSongs() async {
    final data = await spotifyApi.searchTracks(widget.query);
    for (int i = 0; i < data.length; i++) {
      if (data[i]["preview_url"] != null) {
        _songs.add(
          Song(
            imageUrl: data[i]["album"]["images"][0]["url"],
            title: data[i]["name"],
            artist: data[i]["artists"][0]["name"],
            uri: data[i]["preview_url"],
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PlayButtonController>();
    _getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: backgroundDarkColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: backgroundDarkColor,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Songs",
          style: TextStyle(
            fontSize: 21,
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundDarkColor,
      body: _songs.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
                color: sliderColor,
              ),
            )
          : ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    _controller!.playIndex.value = index;
                    await Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => PlayerPage(songs: _songs),
                      ),
                    );
                  },
                  title: Text(
                    _songs[index].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.play_arrow,
                    color: whiteColor,
                    size: 26,
                  ),
                  subtitle: Text(
                    _songs[index].artist ?? "Unknown artist",
                    style: const TextStyle(
                      color: whiteColor,
                      fontSize: 12,
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _songs[index].imageUrl!,
                      width: 50,
                      height: 50,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
