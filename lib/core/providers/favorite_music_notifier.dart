import 'dart:convert';

import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_music_notifier.g.dart';

@riverpod
class FavoriteMusicNotifier extends _$FavoriteMusicNotifier {
  @override
  Map<String, MusicModel> build() {
    _loadFavorites();
    return {};
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      final Map<String, dynamic> favoritesMap = json.decode(favoritesString);
      state = favoritesMap
          .map(
            (key, value) => MapEntry(key, MusicModel.fromJson(value)),
          )
          .cast<String, MusicModel>();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesMap =
        state.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('favorites', json.encode(favoritesMap));
  }

  void addToFavorite(MusicModel music) {
    // state = {...state as Map<String, BookmarkModel>, song.id: song}; // Option 1
    state = Map.from(state)..[music.id] = music; // Option 2

    _saveFavorites(); // Persist the modified state
  }

  void removeFromFavorites(String id) {
    state = {
      ...state..remove(id),
    };

    _saveFavorites(); // Persist the modified state
  }

  void removeAllFavorites(String id) {
    state = {
      ...state..clear(),
    };

    _saveFavorites(); // Persist the modified state
  }

  //Map<String, MusicModel> get getFavoriteItems => state; // Getter for favorites
}
