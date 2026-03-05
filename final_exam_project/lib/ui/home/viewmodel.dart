import 'dart:async';

import 'package:final_exam_project/data/repository/repository.dart';

import '../../data/model/song.dart';

class MusicAppViewModel {
  final StreamController<List<Song>> songStream =
      StreamController<List<Song>>();

  void loadSongs() {
    final repository = DefaultRepository();
    repository
        .loadData()
        .then((songs) {
          songStream.add(songs);
        })
        .catchError((_) {
          // Nếu có lỗi, vẫn phát ra list rỗng để UI dừng loading.
          songStream.add(const <Song>[]);
        });
  }
}
