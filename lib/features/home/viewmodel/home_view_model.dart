import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_compilation_model.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/features/dhamma/repositories/dhamma_repository.dart';
import 'package:mingalar_music_app/features/home/models/album_model.dart';
import 'package:mingalar_music_app/features/home/models/artist_model.dart';
import 'package:mingalar_music_app/features/home/models/genre_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/repositories/home_local_repository.dart';
import 'package:mingalar_music_app/features/home/repositories/home_repository.dart';
import 'package:mingalar_music_app/features/libraryMusicPlaylist/repositories/user_generated_playlists_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
Future<List<MusicModel>> getAllMusic(Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getAllMusic();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> getAllMusicThisWeek(Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getAllMusicThisWeek();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> getSuggestedMusic(
    Ref ref, int offset, int limit) async {
  final res = await ref
      .watch(homeRepositoryProvider)
      .fetchSuggestedMusic(offset, limit);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> fetchTopTenLikedSongsByArtist(
    Ref ref, String artistId) async {
  final res = await ref
      .watch(homeRepositoryProvider)
      .getTopTenLikedSongsByArtist(artistId: artistId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> loadCustomPlaylistTracks(
  Ref ref,
  String collectionName,
  String playlistId,
) async {
  final res = await ref.watch(homeRepositoryProvider).getCustomPlaylistTracks(
      collectionName: collectionName, playlistId: playlistId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<ArtistModel>> getAllArtists(Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getAllArtists();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<ArtistModel>> getTenArtists(Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getTenArtists();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<ArtistModel> getAartistById(Ref ref, String artistId) async {
  final res = await ref.watch(homeRepositoryProvider).getArtistById(artistId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<CustomPlaylistCompilationModel>> getAllMingalarPlaylists(
    Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getAllMingalarPlaylists();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<CustomPlaylistCompilationModel>> getTenMingalarPlaylists(
    Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getTenMingalarPlaylists();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<CustomPlaylistCompilationModel>> getAllUserPlaylists(
    Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getAllUserGenPlaylists();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<CustomPlaylistCompilationModel>> getTenUserPlaylists(
    Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getTenUserGenPlaylists();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<GenreModel>> getAllGenres(Ref ref) async {
  final res = await ref.watch(homeRepositoryProvider).getAllGenres();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<String> getArtistProfile(Ref ref, String artistId) async {
  final res = await ref
      .watch(homeRepositoryProvider)
      .getPersonalProfileByArtist(artistId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<AlbumModel>> getAlbumsByArtist(Ref ref, String artistId) async {
  final res =
      await ref.watch(homeRepositoryProvider).getAlbumsByArtist(artistId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<AlbumModel>> getPopularAlbumsByArtist(
    Ref ref, String artistId) async {
  final res = await ref
      .watch(homeRepositoryProvider)
      .getPopularAlbumsByArtist(artistId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> getAlbumMusics(Ref ref, AlbumModel album) async {
  final res = await ref.watch(homeRepositoryProvider).getAlbumMusics(album);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late DhammaRepository _dhammaRepository;
  late HomeLocalRepository _homeLocalRepository;
  late UserGeneratedPlaylistsRepository _userGeneratedPlaylistsRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    _dhammaRepository = ref.watch(dhammaRepositoryProvider);
    _userGeneratedPlaylistsRepository =
        ref.watch(userGeneratedPlaylistsRepositoryProvider);
    return null;
  }

  Future<void> uploadMusic({
    required File selectedAudio,
    required File selectedThumbnail,
    required String musicName,
    required String audioType,
    required String genre,
    required String artistId,
    required String artist,
    required String artistMM,
    required String albumId,
    required String albumName,
    required String featuring,
    required DateTime releaseDate,
    required String downloadOption,
    required String creditTo,
    required Color selectedColor,
    required List<String> hashtags,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadMusictoStorage(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      musicName: musicName,
      audioType: audioType,
      genre: genre,
      artistId: artistId,
      artist: artist,
      artistMM: artistMM,
      albumId: albumId,
      albumName: albumName,
      featuring: featuring,
      releaseDate: releaseDate,
      downloadOption: downloadOption,
      creditTo: creditTo,
      hexCode: rgbToHex(selectedColor),
      hashtags: hashtags,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  List<MusicModel> getRecentlyPlayedMusic() {
    return _homeLocalRepository.loadMusic("Music");
  }

  List<UserDefinedPlaylistModel> getUserGeneratedPlaylists() {
    return _userGeneratedPlaylistsRepository.loadPlaylists();
  }

  Future<void> addArtist({
    required File selectedProfileImage,
    required String nameENG,
    required String nameMM,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.addArtistDetailToStorage(
      nameENG: nameENG,
      nameMM: nameMM,
      selectedProfileImage: selectedProfileImage,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> addAlbum({
    required File selectedAlbumImage,
    required String albumName,
    required String artistId,
    required DateTime releaseDate,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.addAlbumDetailsToStorage(
      artistId: artistId,
      albumName: albumName,
      selectedAlbumImage: selectedAlbumImage,
      releaseDate: releaseDate,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> addGenre({
    required String name,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.addGenreDetails(
      name: name,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> uploadUserGenPlaylistToFirebase({
    required UserDefinedPlaylistModel playlist,
    required String creatorName,
  }) async {
    state = const AsyncValue.loading();
    final res = playlist.tracks.first.audioType == "Music"
        ? await _homeRepository.uploadUserGenPlaylist(
            playlist: playlist,
            creatorName: creatorName,
          )
        : await _dhammaRepository.uploadUserGenDhammaPlaylist(
            playlist: playlist,
            creatorName: creatorName,
          );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> updateFavoriteStatusToFirebase({
    required bool isLiked,
    required MusicModel track,
  }) async {
    state = const AsyncValue.loading();
    final res = track.audioType == "Music"
        ? await _homeRepository.updateFavoriteStatus(
            isLiked: isLiked,
            audioTrack: track,
          )
        : await _dhammaRepository.updateFavoriteStatus(
            isLiked: isLiked,
            audioTrack: track,
          );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> updateFollowerStatusToFirebase({
    required bool isFollowed,
    required ArtistModel artist,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.updateFollowerStatus(
      isFollowed: isFollowed,
      artist: artist,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> updatePlayStatusToFirebase({
    required MusicModel track,
  }) async {
    state = const AsyncValue.loading();
    final res = track.audioType == "Music"
        ? await _homeRepository.updatePlayStatus(audioTrack: track)
        : await _dhammaRepository.updatePlayStatus(audioTrack: track);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }
}
