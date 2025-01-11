import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_generated_dhamma_playlists_repository.g.dart';

@riverpod
UserGeneratedDhammaPlaylistsRepository userGeneratedDhammaPlaylistsRepository(
    Ref ref) {
  return UserGeneratedDhammaPlaylistsRepository();
}

class UserGeneratedDhammaPlaylistsRepository {
  final Box<UserDefinedPlaylistModel> userGeneratedDhammaPlaylistBox;

  UserGeneratedDhammaPlaylistsRepository()
      : userGeneratedDhammaPlaylistBox =
            Hive.box<UserDefinedPlaylistModel>('userGeneratedDhammaPlaylists');

  void createPlaylist(UserDefinedPlaylistModel playlist) {
    // Check for duplicates
    final existingPlaylists = userGeneratedDhammaPlaylistBox.values.toList();
    final isDuplicate = existingPlaylists.any((existingPlaylist) =>
        existingPlaylist.title.toLowerCase() == playlist.title.toLowerCase());

    if (isDuplicate) {
      // Handle duplicate case (e.g., throw an error or return a value)
      throw Exception('A playlist with this name already exists.');
    }
    userGeneratedDhammaPlaylistBox.add(playlist);
  }

  List<UserDefinedPlaylistModel> loadPlaylists() {
    return userGeneratedDhammaPlaylistBox.values
        .toList()
        .cast<UserDefinedPlaylistModel>();
  }

  void addTracksToPlaylist(String playlistId, MusicModel newTrack) {
    final playlistIndex = userGeneratedDhammaPlaylistBox.values
        .toList()
        .indexWhere((playlist) => playlist.id == playlistId);

    if (playlistIndex == -1) {
      throw Exception('Playlist not found.');
    }

    final playlist = userGeneratedDhammaPlaylistBox.getAt(playlistIndex);
    if (playlist != null) {
      playlist.tracks.add(newTrack);
      playlist.updatedAt = DateTime.now();
      userGeneratedDhammaPlaylistBox.putAt(playlistIndex, playlist);
    }
  }

  // Delete a track from the playlist
  void deleteTrackFromPlaylist(String playlistId, String trackId) {
    final playlistIndex = userGeneratedDhammaPlaylistBox.values
        .toList()
        .indexWhere((playlist) => playlist.id == playlistId);

    if (playlistIndex == -1) {
      throw Exception('Playlist not found.');
    }

    final playlist = userGeneratedDhammaPlaylistBox.getAt(playlistIndex);
    if (playlist != null) {
      playlist.tracks.removeWhere((track) => track.id == trackId);
      playlist.updatedAt = DateTime.now();
      userGeneratedDhammaPlaylistBox.putAt(playlistIndex, playlist);
    }
  }

  // Edit playlist details (title, description, hashtags, isShared)
  void editPlaylistDetails(
    String playlistId, {
    String? newTitle,
    String? newDescription,
    List<String>? newHashtags,
    bool? newIsShared,
  }) {
    final playlistIndex = userGeneratedDhammaPlaylistBox.values
        .toList()
        .indexWhere((playlist) => playlist.id == playlistId);

    if (playlistIndex == -1) {
      throw Exception('Playlist not found.');
    }

    final playlist = userGeneratedDhammaPlaylistBox.getAt(playlistIndex);
    if (playlist != null) {
      if (newTitle != null) {
        playlist.title = newTitle;
      }
      if (newDescription != null) {
        playlist.description = newDescription;
      }
      if (newHashtags != null) {
        playlist.hashtags = newHashtags;
        // Merge new hashtags with existing ones, avoiding duplicates
        /* final existingHashtags = Set<String>.from(playlist.hashtags);
        existingHashtags.addAll(newHashtags);
        playlist.hashtags = existingHashtags.toList(); */
      }
      if (newIsShared != null) {
        playlist.isShared = newIsShared;
      }
      // Update the updatedAt field
      playlist.updatedAt = DateTime.now();
      userGeneratedDhammaPlaylistBox.putAt(playlistIndex, playlist);
    }
  }

  // Delete the whole playlist
  void deletePlaylist(String playlistId) {
    final playlistIndex = userGeneratedDhammaPlaylistBox.values
        .toList()
        .indexWhere((playlist) => playlist.id == playlistId);

    if (playlistIndex == -1) {
      throw Exception('Playlist not found.');
    }

    userGeneratedDhammaPlaylistBox.deleteAt(playlistIndex);
  }
}
