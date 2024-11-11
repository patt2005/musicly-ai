import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/constants/consts.dart';
import 'package:music_app/controllers/play_button_controller.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/player_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlayButtonController? _controller;
  late TextEditingController _searchController;
  bool _isSearchMode = false;
  List<Song>? _songs;
  late List<Song> _filteredSongs;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PlayButtonController>();
    _searchController = TextEditingController();
    _filteredSongs = [];
    _loadSongs();
  }

  void _loadSongs() async {
    List<Song> songs = [];
    for (SongModel song in await _controller!.getSongs()) {
      songs.add(
        Song(
          imageUrl: null,
          title: song.title,
          artist: song.artist,
          uri: song.uri!,
        ),
      );
    }
    setState(() {
      _songs = songs;
      _filteredSongs = songs;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (!_isSearchMode) {
        _searchController.clear();
        _filteredSongs = _songs ?? [];
      }
    });
  }

  void _filterSongs(String query) {
    setState(() {
      _filteredSongs = _songs!
          .where(
              (song) => song.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDarkColor,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: backgroundDarkColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: backgroundDarkColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleSearchMode,
            icon: Icon(
              _isSearchMode ? Icons.close : Icons.search,
              size: 26,
              color: whiteColor,
            ),
          ),
          const SizedBox(width: 7),
        ],
        title: _isSearchMode
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: whiteColor),
                decoration: const InputDecoration(
                  hintText: 'Search songs...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                onChanged: _filterSongs,
              )
            : const Text(
                "Local Songs",
                style: TextStyle(
                  fontSize: 21,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      body: _songs == null
          ? const Center(
              child: CircularProgressIndicator(
                color: sliderColor,
              ),
            )
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_songs!.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.25),
            Image.asset(
              "images/sad-face.png",
              width: 150,
              height: 150,
            ),
            const Text(
              "No songs found on your device.",
              style: TextStyle(
                color: whiteColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _filteredSongs.length,
          itemBuilder: (context, index) {
            var song = _filteredSongs[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: backgroundColor,
                title: Text(
                  song.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
                leading: const Icon(
                  Icons.music_note,
                  color: whiteColor,
                  size: 32,
                ),
                onTap: () async {
                  _controller!.playIndex.value = index;
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlayerPage(songs: _filteredSongs),
                    ),
                  );
                },
                subtitle: Text(
                  song.artist ?? 'Unknown Artist',
                  style: const TextStyle(
                    fontSize: 12,
                    color: whiteColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.play_arrow,
                  color: whiteColor,
                  size: 26,
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
