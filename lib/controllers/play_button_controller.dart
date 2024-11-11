import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayButtonController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  RxBool isPlaying = false.obs;
  RxInt playIndex = 0.obs;

  RxString position = "".obs;
  RxString duration = "".obs;

  RxDouble maxValue = 0.0.obs;
  RxDouble value = 0.0.obs;

  void setPositionUpdate() {
    audioPlayer.durationStream.listen((duration) {
      this.duration.value = duration.toString().split(".")[0];
      maxValue.value = duration!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((position) {
      this.position.value = position.toString().split(".")[0];
      value.value = position.inSeconds.toDouble();
    });
  }

  Future<void> changeDurationToSeconds(int seconds) async {
    var duration = Duration(seconds: seconds);
    await audioPlayer.seek(duration);
  }

  Future<void> initialize(String url) async {
    try {
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<List<SongModel>> getSongs() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt <= 32) {
        await Permission.storage.request();
      } else {
        await Permission.photos.request();
      }

      bool hasPermission = await audioQuery.checkAndRequest(retryRequest: true);
      if (hasPermission) {
        return await audioQuery.querySongs();
      }
    } else if (Platform.isIOS) {
      PermissionStatus status = await Permission.mediaLibrary.request();

      if (status.isGranted) {
        return await audioQuery.querySongs();
      } else if (status.isDenied || status.isRestricted) {
        debugPrint(
            "Media library access denied. Please enable it in Settings.");
      }
    }

    return [];
  }
}
