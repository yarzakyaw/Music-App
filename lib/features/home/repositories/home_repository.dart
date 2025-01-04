import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/failure/app_failure.dart';
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
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('music');
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

  Future<Either<AppFailure, List<MusicModel>>> getAlbumMusics(
      AlbumModel album) async {
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
    DateTime now = DateTime.now();
    DateTime weekAgo = now.subtract(const Duration(days: 7));
    int weekAgoInMilliseconds = weekAgo.millisecondsSinceEpoch;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('music');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef
          .where('uploadDate', isGreaterThan: weekAgoInMilliseconds)
          .orderBy('uploadDate')
          .get();

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
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('artists');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

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
  }

  Future<Either<AppFailure, List<ArtistModel>>> getTenArtists() async {
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
}
