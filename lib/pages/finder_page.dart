import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:music_app/constants/colors.dart';
import 'package:music_app/constants/consts.dart';
import 'package:music_app/controllers/play_button_controller.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/player_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class FinderPage extends StatefulWidget {
  const FinderPage({super.key});

  @override
  State<FinderPage> createState() => _FinderPageState();
}

class _FinderPageState extends State<FinderPage> {
  PlayButtonController? _controller;
  bool _isPicking = false;

  Future<File?> _pickFile() async {
    if (_isPicking) {
      return null;
    }

    _isPicking = true;
    try {
      if (Platform.isIOS) {
        PermissionStatus mediaLibraryStatus =
            await Permission.mediaLibrary.request();
        if (!mediaLibraryStatus.isGranted) {
          print("Media library access denied on iOS.");
          return null;
        }
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print("Error picking file: $e");
    } finally {
      _isPicking = false;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PlayButtonController>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: backgroundDarkColor,
        middle: Text(
          "Find Song",
          style: TextStyle(
            color: CupertinoColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          color: backgroundDarkColor,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenSize.height * 0.14,
                width: screenSize.width,
              ),
              const Icon(
                CupertinoIcons.music_note_2,
                size: 100,
                color: CupertinoColors.systemPurple,
              ),
              const SizedBox(height: 30),
              const Text(
                "Let's find your desired song.\nUpload an audio file.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                CupertinoIcons.arrow_down,
                size: 50,
                color: CupertinoColors.systemGrey2,
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: () async {
                  File? file = await _pickFile();
                  if (file != null) {
                    Song? foundSong = await apiService.getSongByFile(file);
                    if (foundSong != null) {
                      List<Song> songs = [];
                      songs.add(foundSong);
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
                      await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => PlayerPage(songs: songs),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Upload File"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
