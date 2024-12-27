import 'dart:convert';

import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'all_dhamma_playlists_notifier.g.dart';

@riverpod
class AllDhammaPlaylistsNotifier extends _$AllDhammaPlaylistsNotifier {
  @override
  Map<String, CustomPlaylistModel> build() {
    _loadPlaylists();
    return {};
  }

  Future<void> _loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customDhammaPlaylistsString =
        prefs.getString('customDhammaPlaylists');
    if (customDhammaPlaylistsString != null) {
      final Map<String, dynamic> customDhammaPlaylistsMap =
          json.decode(customDhammaPlaylistsString);
      state = customDhammaPlaylistsMap
          .map(
            (key, value) => MapEntry(key, CustomPlaylistModel.fromJson(value)),
          )
          .cast<String, CustomPlaylistModel>();
    }
  }

  Future<void> _savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final customDhammaPlaylistsMap =
        state.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(
        'customDhammaPlaylists', json.encode(customDhammaPlaylistsMap));
  }

  void addToPlaylists(CustomPlaylistModel playlist) {
    // state = {...state as Map<String, BookmarkModel>, song.id: song}; // Option 1
    state = Map.from(state)..[playlist.id] = playlist; // Option 2

    _savePlaylists();
  }

  void removeFromPlaylists(String id) {
    state = {
      ...state..remove(id),
    };

    _savePlaylists();
  }

  void removeAllPlaylists(String id) {
    state = {
      ...state..clear(),
    };

    _savePlaylists();
  }
}
