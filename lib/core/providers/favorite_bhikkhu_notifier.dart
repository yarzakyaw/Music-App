import 'dart:convert';

import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_bhikkhu_notifier.g.dart';

@riverpod
class FavoriteBhikkhuNotifier extends _$FavoriteBhikkhuNotifier {
  @override
  Map<String, BhikkhuModel> build() {
    _loadFavoriteBhikkhus();
    return {};
  }

  Future<void> _loadFavoriteBhikkhus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favoriteBhikkhus');
    if (favoritesString != null) {
      final Map<String, dynamic> favoritesMap = json.decode(favoritesString);
      state = favoritesMap
          .map(
            (key, value) => MapEntry(key, BhikkhuModel.fromJson(value)),
          )
          .cast<String, BhikkhuModel>();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesMap =
        state.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('favoriteBhikkhus', json.encode(favoritesMap));
  }

  void addToFavorite(BhikkhuModel bhikkhu) {
    // state = {...state as Map<String, BookmarkModel>, song.id: song}; // Option 1
    state = Map.from(state)..[bhikkhu.id] = bhikkhu; // Option 2

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
