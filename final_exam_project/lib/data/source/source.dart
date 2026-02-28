import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../model/song.dart';

abstract interface class DataSource {
  Future<List<Song>?> loadData();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    try {
      const url = 'https://thantrieu.com/resources/braniumapis/songs.json';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final bodyContent = utf8.decode(response.bodyBytes);
        final songWrapper = jsonDecode(bodyContent) as Map;
        final songList = songWrapper['songs'] as List;
        final songs = songList
            .map((song) => Song.fromJson(song))
            .toList(growable: false);
        return songs;
      } else {
        return null;
      }
    } catch (_) {
      // Trên web thường lỗi do CORS hoặc mạng, trả về null để repo fallback sang local.
      return null;
    }
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final jsonBody = jsonDecode(response) as Map;
    final songList = jsonBody['songs'] as List;
    final songs = songList
        .map((song) => Song.fromJson(song))
        .toList(growable: false);
    return songs;
  }
}
