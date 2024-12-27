import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';

class RecentMusicPlaylistsNotifier
    extends StateNotifier<Map<String, CustomPlaylistModel>> {
  RecentMusicPlaylistsNotifier() : super({});

  void setRecentPlaylists(Map<String, CustomPlaylistModel> playlists) {
    state = playlists;
  }
}

final recentMusicPlaylistsNotifierProvider = StateNotifierProvider<
    RecentMusicPlaylistsNotifier, Map<String, CustomPlaylistModel>>((ref) {
  return RecentMusicPlaylistsNotifier();
});
