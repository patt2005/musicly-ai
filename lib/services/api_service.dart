import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:music_app/constants/api_keys.dart";
import "package:music_app/models/song.dart";

class ApiService {
  Future<Song?> getSongByFile(File audioFile) async {
    final url = Uri.parse('https://api.audd.io/');
    var request = http.MultipartRequest('POST', url)
      ..fields['api_token'] = audDApiKey
      ..fields['return'] = 'apple_music,spotify'
      ..files.add(await http.MultipartFile.fromPath('file', audioFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody);
      Map<String, dynamic> data = jsonDecode(responseBody);
      try {
        Song song = Song(
          imageUrl: data["result"]["apple_music"]["artwork"]["url"],
          title: data["result"]["title"],
          artist: data["result"]["artist"],
          uri: data["result"]["apple_music"]["previews"][0]["url"],
        );
        return song;
      } catch (error) {
        debugPrint(error.toString());
        return null;
      }
    } else {
      debugPrint("Failed to retrieve data!");
      return null;
    }
  }
}
