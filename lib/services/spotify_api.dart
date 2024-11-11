import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:music_app/constants/api_keys.dart';

class SpotifyApi {
  String? accessToken;

  Future<void> _authenticate() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$spotifyClientId:$spotifyClientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      accessToken = jsonResponse['access_token'];
    } else {
      throw Exception('Failed to authenticate with Spotify');
    }
  }

  Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    if (accessToken == null) {
      await _authenticate();
    }

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final tracks = jsonResponse['tracks']['items'] as List;
      return tracks.map((track) => track as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to search tracks');
    }
  }
}
