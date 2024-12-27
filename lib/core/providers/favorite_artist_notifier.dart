import 'dart:convert';

import 'package:mingalar_music_app/features/home/models/artist_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_artist_notifier.g.dart';

@riverpod
class FavoriteArtistNotifier extends _$FavoriteArtistNotifier {
  @override
  Map<String, ArtistModel> build() {
    _loadFavoriteArtists();
    return {};
  }

  Future<void> _loadFavoriteArtists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favoriteArtists');
    if (favoritesString != null) {
      final Map<String, dynamic> favoritesMap = json.decode(favoritesString);
      state = favoritesMap
          .map(
            (key, value) => MapEntry(key, ArtistModel.fromJson(value)),
          )
          .cast<String, ArtistModel>();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesMap =
        state.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('favoriteArtists', json.encode(favoritesMap));
  }

  void addToFavorite(ArtistModel artist) {
    // state = {...state as Map<String, BookmarkModel>, song.id: song}; // Option 1
    state = Map.from(state)..[artist.id] = artist; // Option 2

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
}
