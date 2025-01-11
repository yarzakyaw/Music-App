import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box<MusicModel> recentBox;

  HomeLocalRepository() : recentBox = Hive.box<MusicModel>('recently_played');

  void uploadLocalMusic(MusicModel music) {
    recentBox.put(music.id, music);
  }

  List<MusicModel> loadMusic(String audioType) {
    List<MusicModel> music = [];
    for (final key in recentBox.keys) {
      final track = recentBox.get(key);
      if (track?.audioType == audioType) {
        music.add(track!);
      }
    }
    return music;
  }
}

/* import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomeLocalRepository homeLocalRepository(Ref ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  final Box box = Hive.box();

  void uploadLocalMusic(MusicModel music) {
    box.put(music.id, music.toJson());
  }

  List<MusicModel> loadMusic(String audioType) {
    List<MusicModel> music = [];
    for (final key in box.keys) {
      final track = MusicModel.fromJson(box.get(key));
      if (track.audioType == audioType) {
        music.add(track);
      }
    }
    return music;
  }
}
 */
