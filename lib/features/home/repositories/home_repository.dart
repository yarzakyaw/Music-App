import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:mingalar_music_app/core/failure/app_failure.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_compilation_model.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/features/home/models/album_model.dart';
import 'package:mingalar_music_app/features/home/models/artist_model.dart';
import 'package:mingalar_music_app/features/home/models/genre_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  final Box<MusicModel> _allMusicBox = Hive.box<MusicModel>('allMusic');
  final Box<MusicModel> _thisWeekMusicBox =
      Hive.box<MusicModel>('thisWeekMusic');
  final Box<ArtistModel> _allArtistsBox = Hive.box<ArtistModel>('allArtists');
  final Box<ArtistModel> _tenArtistsBox = Hive.box<ArtistModel>('tenArtists');
  final Box<CustomPlaylistCompilationModel> _allMingalarPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('allMingalarPlaylists');
  final Box<CustomPlaylistCompilationModel> _tenMingalarPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('tenMingalarPlaylists');
  final Box<CustomPlaylistCompilationModel> _allUserPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('allUserPlaylists');
  final Box<CustomPlaylistCompilationModel> _tenUserPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('tenUserPlaylists');

  Future<Either<AppFailure, MusicModel>> uploadMusictoStorage({
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
    required String hexCode,
    required List<String> hashtags,
  }) async {
    String musicUrl;
    String thumbnailUrl;
    final taskId = const Uuid().v4();
    try {
      Reference musicRef = FirebaseStorage.instance
          .ref()
          .child('music')
          .child(currentUser!.uid)
          .child(taskId);
      //create upload task
      UploadTask audioTask = musicRef.putFile(selectedAudio);
      //upload image
      TaskSnapshot audioSnapshot = await audioTask;
      //get image url
      musicUrl = await audioSnapshot.ref.getDownloadURL();

      Reference thumbnailRef = FirebaseStorage.instance
          .ref()
          .child('thumbnails')
          .child(currentUser!.uid)
          .child(taskId);

      //create upload task
      UploadTask thumbnailTask = thumbnailRef.putFile(selectedThumbnail);
      //upload image
      TaskSnapshot thumbnailSnapshot = await thumbnailTask;
      //get image url
      thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

      final music = MusicModel(
        id: taskId,
        userId: currentUser!.uid,
        musicName: musicName,
        audioType: audioType,
        genre: genre,
        artistId: artistId,
        artist: artist,
        artistMM: artistMM,
        alias: '',
        title: '',
        albumId: albumId,
        albumName: albumName,
        featuring: featuring,
        releaseDate: releaseDate,
        uploadDate: DateTime.now(),
        likeCount: 0,
        playCount: 0,
        shareCount: 0,
        downloadCount: 0,
        downloadOption: downloadOption,
        creditTo: creditTo,
        hexCode: hexCode,
        musicUrl: musicUrl,
        thumbnailUrl: thumbnailUrl,
        hashtags: hashtags,
      );

      await FirebaseFirestore.instance.collection('music').doc(taskId).set(
            music.toMap(),
          );
      await FirebaseFirestore.instance
          .collection('artists')
          .doc(artistId)
          .collection('albums')
          .doc(albumId)
          .collection('music')
          .doc(taskId)
          .set(music.toMap());

      return Right(music);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, ArtistModel>> addArtistDetailToStorage({
    required String nameENG,
    required String nameMM,
    required File selectedProfileImage,
  }) async {
    String profilelUrl;
    final artistId = const Uuid().v4();
    try {
      Reference profileRef = FirebaseStorage.instance
          .ref()
          .child('artistProfileImages')
          .child(artistId);

      //create upload task
      UploadTask profileTask = profileRef.putFile(selectedProfileImage);
      //upload image
      TaskSnapshot profileSnapshot = await profileTask;
      //get image url
      profilelUrl = await profileSnapshot.ref.getDownloadURL();

      final artist = ArtistModel(
        id: artistId,
        nameENG: nameENG,
        nameMM: nameMM,
        profileImageUrl: profilelUrl,
        ownerId: "",
        totalPlayCount: 0,
        totalDownloads: 0,
        totalLikes: 0,
        totalShare: 0,
        totalFollowers: 0,
        totalFollowing: 0,
        vault: 0,
      );

      await FirebaseFirestore.instance.collection('artists').doc(artistId).set(
            artist.toMap(),
          );

      return Right(artist);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, AlbumModel>> addAlbumDetailsToStorage({
    required String artistId,
    required String albumName,
    required File selectedAlbumImage,
    required DateTime releaseDate,
  }) async {
    String albumUrl;
    final albumId = const Uuid().v4();
    try {
      Reference albumRef = FirebaseStorage.instance
          .ref()
          .child('albumProfileImages')
          .child(albumId);

      //create upload task
      UploadTask albumTask = albumRef.putFile(selectedAlbumImage);
      //upload image
      TaskSnapshot albumSnapshot = await albumTask;
      //get image url
      albumUrl = await albumSnapshot.ref.getDownloadURL();

      final album = AlbumModel(
        id: albumId,
        artistId: artistId,
        albumName: albumName,
        releaseDate: releaseDate,
        albumImageUrl: albumUrl,
        totalDownloads: 0,
        totalLikes: 0,
        totalPlayCount: 0,
        totalShare: 0,
      );

      await FirebaseFirestore.instance.collection('albums').doc(albumId).set(
            album.toMap(),
          );
      await FirebaseFirestore.instance
          .collection('artists')
          .doc(artistId)
          .collection('albums')
          .doc(albumId)
          .set(
            album.toMap(),
          );

      return Right(album);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, GenreModel>> addGenreDetails({
    required String name,
  }) async {
    final genreId = const Uuid().v4();
    try {
      final genre = GenreModel(id: genreId, name: name);
      await FirebaseFirestore.instance.collection('genres').doc(genreId).set(
            genre.toMap(),
          );
      return Right(genre);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> uploadUserGenPlaylist({
    required UserDefinedPlaylistModel playlist,
    required String creatorName,
  }) async {
    try {
      if (creatorName == 'Mingalar') {
        await FirebaseFirestore.instance
            .collection('mingalarPlaylists')
            .doc(playlist.id)
            .set(
          {
            'id': playlist.id,
            'title': playlist.title,
            'description': playlist.description,
            'createdAt': playlist.createdAt,
            'updatedAt': DateTime.now(),
            'createrId': playlist.createrId,
            'creatorName': creatorName,
            'hashtags': playlist.hashtags,
            'likeCount': 0,
            'isShared': true,
          },
        );
        for (MusicModel track in playlist.tracks) {
          await FirebaseFirestore.instance
              .collection('mingalarPlaylists')
              .doc(playlist.id)
              .collection('tracks')
              .doc(track.id)
              .set(track.toMap());
        }
      } else {
        await FirebaseFirestore.instance
            .collection('fanPlaylists')
            .doc(playlist.id)
            .set(
          {
            'id': playlist.id,
            'title': playlist.title,
            'description': playlist.description,
            'createdAt': playlist.createdAt,
            'updatedAt': DateTime.now(),
            'createrId': playlist.createrId,
            'creatorName': creatorName,
            'hashtags': playlist.hashtags,
            'likeCount': 0,
            'isShared': true,
          },
        );
        for (MusicModel track in playlist.tracks) {
          await FirebaseFirestore.instance
              .collection('fanPlaylists')
              .doc(playlist.id)
              .collection('tracks')
              .doc(track.id)
              .set(track.toMap());
        }
      }
      return Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<void> createOrUpdatePlaylist(String playlistId, List<String> songIds,
      String title, String description) async {
    await FirebaseFirestore.instance
        .collection('Playlists')
        .doc(playlistId)
        .set({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'songIds': songIds,
      'criteria': title, // You can customize this further
    }, SetOptions(merge: true)); // Use merge to update existing
  } */

  /* Playlists Collection
playlistId
title: Title of the playlist.
description: Description of the playlist.
createdAt: Timestamp for when the playlist was created.
updatedAt: Timestamp for the last update.
songIds: Array of song IDs in this playlist.
hashtags: Array of strings representing hashtags (e.g., ["#Chill", "#Workout", "#SummerVibes"]). */

  /* Future<Either<AppFailure, bool>> updateFavoriteStatus({
    required bool isLiked,
    required MusicModel audioTrack,
  }) async {
    try {
      if (isLiked) {
        await FirebaseFirestore.instance
            .collection('music')
            .doc(audioTrack.id)
            .update({'likeCount': FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('artists')
            .doc(audioTrack.artistId)
            .update({'totalLikes': FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('albums')
            .doc(audioTrack.albumId)
            .update({'totalLikes': FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('artists')
            .doc(audioTrack.artistId)
            .collection('albums')
            .doc(audioTrack.albumId)
            .collection('music')
            .doc(audioTrack.id)
            .update({'likeCount': FieldValue.increment(1)});

        final interactionId = const Uuid().v4();
        final interaction = MusicUserInteractionModel(
          id: interactionId,
          userId: currentUser!.uid,
          trackId: audioTrack.id,
          artistId: audioTrack.artistId,
          albumId: audioTrack.albumId,
          interactionType: 'Like',
          timestamp: DateTime.now().toLocal(),
        );

        await FirebaseFirestore.instance
            .collection('userInteractions')
            .doc(interactionId)
            .set(interaction.toMap());
      } else {
        await FirebaseFirestore.instance
            .collection('music')
            .doc(audioTrack.id)
            .update({'likeCount': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('artists')
            .doc(audioTrack.artistId)
            .update({'totalLikes': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('albums')
            .doc(audioTrack.albumId)
            .update({'totalLikes': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('artists')
            .doc(audioTrack.artistId)
            .collection('albums')
            .doc(audioTrack.albumId)
            .collection('music')
            .doc(audioTrack.id)
            .update({'likeCount': FieldValue.increment(-1)});
      }
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */

  Future<Either<AppFailure, bool>> updateFavoriteStatus({
    required bool isLiked,
    required MusicModel audioTrack,
  }) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable("updateLikeStatus");

      final response = await callable.call({
        "isLiked": isLiked,
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "id": audioTrack.id,
        "artistId": audioTrack.artistId,
        "albumId": audioTrack.albumId,
      });
      debugPrint('Like Status Response: ${response.data}');

      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, bool>> updateFollowerStatus({
    required bool isFollowed,
    required ArtistModel artist,
  }) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final String ownedAccountId =
        (userDoc.data() as Map<String, dynamic>)['ownedAccountId'];
    final String ownedAccountIsIn =
        (userDoc.data() as Map<String, dynamic>)['ownedAccountIsIn'];
    // ownedAccountType - artists / bhikkhus

    try {
      if (isFollowed) {
        await FirebaseFirestore.instance
            .collection('artists')
            .doc(artist.id)
            .update({'totalFollowers': FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'totalFollowing': FieldValue.increment(1)});

        if (ownedAccountId != "") {
          await FirebaseFirestore.instance
              .collection(ownedAccountIsIn)
              .doc(ownedAccountId)
              .update({'totalFollowing': FieldValue.increment(1)});
        }
      } else {
        await FirebaseFirestore.instance
            .collection('artists')
            .doc(artist.id)
            .update({'totalFollowers': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'totalFollowing': FieldValue.increment(-1)});

        if (ownedAccountId != "") {
          await FirebaseFirestore.instance
              .collection(ownedAccountIsIn)
              .doc(ownedAccountId)
              .update({'totalFollowing': FieldValue.increment(-1)});
        }
      }
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */

  Future<Either<AppFailure, bool>> updateFollowerStatus({
    required bool isFollowed,
    required ArtistModel artist,
  }) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateFollowerStatus');
      final response = await callable.call({
        'isFollowed': isFollowed,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'artist': {
          'id': artist.id,
        },
      });
      debugPrint('Follower Status Response: ${response.data}');
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, bool>> updatePlayStatus({
    required MusicModel audioTrack,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('music')
          .doc(audioTrack.id)
          .update({'playCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('artists')
          .doc(audioTrack.artistId)
          .update({'totalPlayCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('albums')
          .doc(audioTrack.albumId)
          .update({'totalPlayCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('artists')
          .doc(audioTrack.artistId)
          .collection('albums')
          .doc(audioTrack.albumId)
          .collection('music')
          .doc(audioTrack.id)
          .update({'playCount': FieldValue.increment(1)});

      final interactionId = const Uuid().v4();

      final interaction = MusicUserInteractionModel(
        id: interactionId,
        userId: currentUser!.uid,
        trackId: audioTrack.id,
        artistId: audioTrack.artistId,
        albumId: audioTrack.albumId,
        interactionType: 'Play',
        timestamp: DateTime.now().toLocal(),
      );

      await FirebaseFirestore.instance
          .collection('userInteractions')
          .doc(interactionId)
          .set(interaction.toMap());
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */

  Future<Either<AppFailure, bool>> updatePlayStatus({
    required MusicModel audioTrack,
  }) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updatePlayStatus');
      final response = await callable.call({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'audioTrack': {
          'id': audioTrack.id,
          'artistId': audioTrack.artistId,
          'albumId': audioTrack.albumId,
        },
      });
      debugPrint('Play Status Response: ${response.data}');
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getAllMusic() async {
    try {
      // Check for cached music in Hive
      if (_allMusicBox.isNotEmpty) {
        List<MusicModel> music = _allMusicBox.values.toList();
        return Right(music);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('music');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedMusic = [];

      // Process the documents
      for (final doc in documents) {
        final music = MusicModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedMusic.add(music);
        await _allMusicBox.put(music.id, music);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates('music', 'allMusic');

      return Right(fetchedMusic);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getAlbumMusics(
    AlbumModel album,
  ) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('artists')
        .doc(album.artistId)
        .collection('albums')
        .doc(album.id)
        .collection('music');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> music = [];

      // Process the documents
      for (final doc in documents) {
        music.add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(music);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getAllMusicThisWeek() async {
    try {
      // Check for cached music in Hive
      if (_thisWeekMusicBox.isNotEmpty) {
        List<MusicModel> music = _thisWeekMusicBox.values.toList();
        return Right(music);
      }
      // Fetch all documents
      DateTime now = DateTime.now();
      DateTime weekAgo = now.subtract(const Duration(days: 7));
      int weekAgoInMilliseconds = weekAgo.millisecondsSinceEpoch;
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('music');
      QuerySnapshot querySnapshot = await collectionRef
          .where('uploadDate', isGreaterThan: weekAgoInMilliseconds)
          .orderBy('uploadDate')
          .get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedMusic = [];

      // Process the documents
      for (final doc in documents) {
        final music = MusicModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedMusic.add(music);
        await _thisWeekMusicBox.put(music.id, music);
      }

      // Maintain cache based on uploadDate within the last week
      _maintainCacheWithinWeek(_thisWeekMusicBox);

      // Listen for real-time updates
      listenToFirestoreUpdates('music', 'thisWeekMusic');

      return Right(fetchedMusic);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> fetchSuggestedMusic(
    int offset,
    int limit,
  ) async {
    try {
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('music');
      QuerySnapshot querySnapshot = await collectionRef
          .orderBy('likeCount')
          .startAt([offset])
          .limit(limit)
          .get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedMusic = [];

      // Process the documents
      for (final doc in documents) {
        fetchedMusic
            .add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(fetchedMusic);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getTopTenLikedSongsByArtist({
    required String artistId,
  }) async {
    try {
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('music');
      QuerySnapshot querySnapshot = await collectionRef
          .where('artistId', isEqualTo: artistId)
          .orderBy('likeCount')
          .limit(10)
          .get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedMusic = [];

      // Process the documents
      for (final doc in documents) {
        fetchedMusic
            .add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(fetchedMusic);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getCustomPlaylistTracks({
    required String collectionName,
    required String playlistId,
  }) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(playlistId)
        .collection('tracks');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> music = [];

      // Process the documents
      for (final doc in documents) {
        music.add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(music);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<ArtistModel>>> getAllArtists() async {
    try {
      // Check for cached music in Hive
      if (_allArtistsBox.isNotEmpty) {
        List<ArtistModel> artists = _allArtistsBox.values.toList();
        return Right(artists);
      }

      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('artists');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<ArtistModel> fetchedArtists = [];

      // Process the documents
      for (final doc in documents) {
        final artist = ArtistModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedArtists.add(artist);
        await _allArtistsBox.put(artist.id, artist);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates('artists', 'allArtists');

      return Right(fetchedArtists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<ArtistModel>>> getTenArtists() async {
    try {
      // Check for cached music in Hive
      if (_tenArtistsBox.isNotEmpty) {
        List<ArtistModel> artists = _tenArtistsBox.values.toList();
        return Right(artists);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('artists');
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('totalFollowers').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<ArtistModel> fetchedArtists = [];

      // Process the documents
      for (final doc in documents) {
        final artist = ArtistModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedArtists.add(artist);
        await _tenArtistsBox.put(artist.id, artist);
      }

      _maintainCacheLimit(_tenArtistsBox, 10);

      // Listen for real-time updates
      listenToFirestoreUpdates('artists', 'tenArtists');

      return Right(fetchedArtists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, List<ArtistModel>>> getTenArtists() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('artists');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('totalFollowers').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<ArtistModel> artists = [];

      // Process the documents
      for (final doc in documents) {
        artists.add(ArtistModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(artists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getAllMingalarPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_allMingalarPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _allMingalarPlaylistsBox.values.toList();
        return Right(playlists);
      }

      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('mingalarPlaylists');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _allMingalarPlaylistsBox.put(playlist.id, playlist);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates('mingalarPlaylists', 'allMingalarPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getTenMingalarPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_tenMingalarPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _tenMingalarPlaylistsBox.values.toList();
        return Right(playlists);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('mingalarPlaylists');
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('likeCount').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _tenMingalarPlaylistsBox.put(playlist.id, playlist);
      }

      _maintainCacheLimitUserGenPlaylists(_tenMingalarPlaylistsBox, 10);

      // Listen for real-time updates
      listenToFirestoreUpdates('mingalarPlaylists', 'tenMingalarPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getAllUserGenPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_allUserPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _allUserPlaylistsBox.values.toList();
        return Right(playlists);
      }

      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('fanPlaylists');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _allUserPlaylistsBox.put(playlist.id, playlist);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates('fanPlaylists', 'allUserPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getTenUserGenPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_tenUserPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _tenUserPlaylistsBox.values.toList();
        return Right(playlists);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('fanPlaylists');
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('likeCount').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _tenUserPlaylistsBox.put(playlist.id, playlist);
      }

      _maintainCacheLimitUserGenPlaylists(_tenUserPlaylistsBox, 10);

      // Listen for real-time updates
      listenToFirestoreUpdates('fanPlaylists', 'tenUserPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<GenreModel>>> getAllGenres() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('genres');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<GenreModel> genres = [];

      // Process the documents
      for (final doc in documents) {
        genres.add(GenreModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(genres);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<AlbumModel>>> getAlbumsByArtist(
    String artistId,
  ) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('artists')
        .doc(artistId)
        .collection('albums');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<AlbumModel> albums = [];

      // Process the documents
      for (final doc in documents) {
        albums.add(AlbumModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(albums);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<AlbumModel>>> getPopularAlbumsByArtist(
    String artistId,
  ) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('popularAlbums')
        .doc(artistId)
        .collection('topAlbums');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<AlbumModel> albums = [];

      // Process the documents
      for (final doc in documents) {
        albums.add(AlbumModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(albums);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, String>> getPersonalProfileByArtist(
    String artistId,
  ) async {
    try {
      // Fetch all documents
      DocumentSnapshot artistDoc = await FirebaseFirestore.instance
          .collection('artists')
          .doc(artistId)
          .get();

      final String profileImageUrl =
          (artistDoc.data() as Map<String, dynamic>)['profileImageUrl'];

      return Right(profileImageUrl);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, ArtistModel>> getArtistById(
    String artistId,
  ) async {
    try {
      // Fetch all documents
      DocumentSnapshot artistDoc = await FirebaseFirestore.instance
          .collection('artists')
          .doc(artistId)
          .get();

      final ArtistModel artist =
          ArtistModel.fromMap(artistDoc.data() as Map<String, dynamic>);

      return Right(artist);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  void listenToFirestoreUpdates(String collectionName, String boxName) {
    FirebaseFirestore.instance.collection(collectionName).snapshots().listen(
      (snapshot) {
        // Use the appropriate Hive box based on the collection
        Box<dynamic>? box = getBoxForCollection(boxName);
        if (box == null) return; // Handle unknown collection gracefully

        for (var change in snapshot.docChanges) {
          final doc = change.doc;
          switch (change.type) {
            case DocumentChangeType.added:
            case DocumentChangeType.modified:
              // Update or add the document
              if (collectionName == 'music') {
                final music =
                    MusicModel.fromMap(doc.data() as Map<String, dynamic>);
                box.put(music.id, music);
              } else if (collectionName == 'artists') {
                final artist =
                    ArtistModel.fromMap(doc.data() as Map<String, dynamic>);
                box.put(artist.id, artist);
              } else if (collectionName == 'fanPlaylists') {
                final userPlaylist = CustomPlaylistCompilationModel.fromMap(
                    doc.data() as Map<String, dynamic>);
                box.put(userPlaylist.id, userPlaylist);
              } else if (collectionName == 'mingalarPlaylists') {
                final mingalarPlaylist = CustomPlaylistCompilationModel.fromMap(
                    doc.data() as Map<String, dynamic>);
                box.put(mingalarPlaylist.id, mingalarPlaylist);
              }
              break;

            case DocumentChangeType.removed:
              // Remove the document from Hive
              box.delete(doc.id);
              break;
          }
        }
      },
      onError: (error) {
        // Handle any errors
        debugPrint("Error listening to Firestore: $error");
      },
    );
  }

  // Helper method to get the appropriate Hive box
  Box<dynamic>? getBoxForCollection(String boxName) {
    switch (boxName) {
      case 'allMusic':
        return _allMusicBox;
      case 'allArtists':
        return _allArtistsBox;
      case 'thisWeekMusic':
        return _thisWeekMusicBox;
      case 'tenArtists':
        return _tenArtistsBox;
      case 'allMingalarPlaylists':
        return _allMingalarPlaylistsBox;
      case 'tenMingalarPlaylists':
        return _tenMingalarPlaylistsBox;
      case 'allUserPlaylists':
        return _allUserPlaylistsBox;
      case 'tenUserPlaylists':
        return _tenUserPlaylistsBox;
      default:
        return null;
    }
  }

  void _maintainCacheWithinWeek(Box<MusicModel> box) {
    DateTime now = DateTime.now();
    DateTime weekAgo = now.subtract(const Duration(days: 7));
    // int weekAgoInMilliseconds = weekAgo.millisecondsSinceEpoch;

    List<String> keysToRemove = [];
    for (var key in box.keys) {
      final music = box.get(key);
      if (music != null && music.uploadDate.isBefore(weekAgo)) {
        keysToRemove.add(key);
      }
    }

    for (var key in keysToRemove) {
      box.delete(key);
    }
  }

  // Helper method to maintain the cache limit
  void _maintainCacheLimit(Box<ArtistModel> box, int limit) {
    List<ArtistModel> artistList = box.values.toList();
    // Sort the list based on follower counts in descending order
    artistList.sort((a, b) => b.totalFollowers.compareTo(a.totalFollowers));
    if (artistList.length > limit) {
      // Get the keys for the music that are not in the top N
      final keysToRemove =
          artistList.skip(limit).map((artist) => artist.id).toList();

      // Remove those entries from the Hive box
      for (var key in keysToRemove) {
        box.delete(key);
      }
    }
  }

  // Helper method to maintain the cache limit
  void _maintainCacheLimitUserGenPlaylists(
      Box<CustomPlaylistCompilationModel> box, int limit) {
    List<CustomPlaylistCompilationModel> playlistList = box.values.toList();
    // Sort the list based on follower counts in descending order
    playlistList.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    if (playlistList.length > limit) {
      // Get the keys for the music that are not in the top N
      final keysToRemove =
          playlistList.skip(limit).map((playlist) => playlist.id).toList();

      // Remove those entries from the Hive box
      for (var key in keysToRemove) {
        box.delete(key);
      }
    }
  }

  /* void listenToFirestoreUpdates(String collectionName) {
    switch (collectionName) {
      case 'music':
        FirebaseFirestore.instance
            .collection('music')
            .snapshots()
            .listen((snapshot) {
          // Clear the existing Hive box to avoid duplicates
          _allMusicBox.clear();

          // Iterate through the documents in the Firestore snapshot
          for (var doc in snapshot.docs) {
            final music = MusicModel.fromMap(doc.data());
            _allMusicBox.put(music.id, music); // Using id as the key
          }
        });
        break;
      case 'artists':
        FirebaseFirestore.instance
            .collection('artists')
            .snapshots()
            .listen((snapshot) {
          // Clear the existing Hive box to avoid duplicates
          _allArtistsBox.clear();

          // Iterate through the documents in the Firestore snapshot
          for (var doc in snapshot.docs) {
            final artist = ArtistModel.fromMap(doc.data());
            _allArtistsBox.put(artist.id, artist); // Using id as the key
          }
        });
        break;
      default:
    }
  } */
}
