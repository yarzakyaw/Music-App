import 'package:hive/hive.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/repositories/user_generated_playlists_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'librarymusicplaylist_view_model.g.dart';

@riverpod
class LibrarymusicplaylistViewModel extends _$LibrarymusicplaylistViewModel {
  late UserGeneratedPlaylistsRepository _userGeneratedPlaylistsRepository;
  String? _playlistId;

  @override
  UserDefinedPlaylistModel? build() {
    _userGeneratedPlaylistsRepository =
        ref.watch(userGeneratedPlaylistsRepositoryProvider);

    _playlistId = null;

    // Start tracking changes only if a playlist ID is set
    if (_playlistId != null) {
      _trackPlaylistChanges();
    }

    return null;
  }

  void _trackPlaylistChanges() {
    final box = Hive.box<UserDefinedPlaylistModel>('userGeneratedPlaylists');
    box.watch().listen((event) {
      if (_playlistId != null) {
        // Check if the playlist data has changed
        final updatedPlaylistIndex = box.values
            .toList()
            .indexWhere((playlist) => playlist.id == _playlistId);
        if (updatedPlaylistIndex != -1) {
          state = box.getAt(
            updatedPlaylistIndex,
          ); // Update the state with the latest playlist
        } else {
          state = null; // If the playlist is not found, set state to null
        }
      }
    });
  }

  void setPlaylistId(String playlistId) {
    _playlistId = playlistId;
    // Restart tracking if the playlist ID changes
    _trackPlaylistChanges();
  }
}
