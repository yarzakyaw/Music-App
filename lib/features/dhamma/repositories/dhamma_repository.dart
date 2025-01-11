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
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/dhamma_category_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/dhamma_collection_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'dhamma_repository.g.dart';

@riverpod
DhammaRepository dhammaRepository(Ref ref) {
  return DhammaRepository();
}

class DhammaRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  final Box<MusicModel> _allDhammaBox = Hive.box<MusicModel>('allDhamma');
  final Box<MusicModel> _thisMonthDhammaBox =
      Hive.box<MusicModel>('thisMonthDhamma');
  final Box<BhikkhuModel> _allBhikkhusBox =
      Hive.box<BhikkhuModel>('allBhikkhus');
  final Box<BhikkhuModel> _tenBhikkhusBox =
      Hive.box<BhikkhuModel>('tenBhikkhus');
  final Box<CustomPlaylistCompilationModel> _allMingalarDhammaPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('allMingalarDhammaPlaylists');
  final Box<CustomPlaylistCompilationModel> _tenMingalarDhammaPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('tenMingalarDhammaPlaylists');
  final Box<CustomPlaylistCompilationModel> _allUserDhammaPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('allUserDhammaPlaylists');
  final Box<CustomPlaylistCompilationModel> _tenUserDhammaPlaylistsBox =
      Hive.box<CustomPlaylistCompilationModel>('tenUserDhammaPlaylists');

  Future<Either<AppFailure, MusicModel>> uploadDhammatoStorage({
    required File selectedAudio,
    required File selectedThumbnail,
    required String dhammaName,
    required String audioType,
    required String category,
    required String bhikkhuId,
    required String bhikkhu,
    required String bhikkhuMM,
    required String bhikkhuAlias,
    required String bhikkhuTitle,
    required String collectionId,
    required String collectionName,
    required DateTime releaseDate,
    required String downloadOption,
    required String creditTo,
    required String hexCode,
    required List<String> hashtags,
  }) async {
    String trackUrl;
    String thumbnailUrl;
    final taskId = const Uuid().v4();
    try {
      Reference dhammaRef = FirebaseStorage.instance
          .ref()
          .child('dhamma')
          .child(currentUser!.uid)
          .child(taskId);
      //create upload task
      UploadTask audioTask = dhammaRef.putFile(selectedAudio);
      //upload image
      TaskSnapshot audioSnapshot = await audioTask;
      //get image url
      trackUrl = await audioSnapshot.ref.getDownloadURL();

      Reference thumbnailRef = FirebaseStorage.instance
          .ref()
          .child('dhammaImages')
          .child(currentUser!.uid)
          .child(taskId);

      //create upload task
      UploadTask thumbnailTask = thumbnailRef.putFile(selectedThumbnail);
      //upload image
      TaskSnapshot thumbnailSnapshot = await thumbnailTask;
      //get image url
      thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

      final dhamma = MusicModel(
        id: taskId,
        userId: currentUser!.uid,
        musicName: dhammaName,
        audioType: audioType,
        genre: category,
        artistId: bhikkhuId,
        artist: bhikkhu,
        artistMM: bhikkhuMM,
        alias: bhikkhuAlias,
        title: bhikkhuTitle,
        albumId: collectionId,
        albumName: collectionName,
        releaseDate: releaseDate,
        uploadDate: DateTime.now(),
        likeCount: 0,
        playCount: 0,
        shareCount: 0,
        downloadCount: 0,
        downloadOption: downloadOption,
        creditTo: creditTo,
        hexCode: hexCode,
        musicUrl: trackUrl,
        thumbnailUrl: thumbnailUrl,
        featuring: '',
        hashtags: hashtags,
      );

      await FirebaseFirestore.instance.collection('dhamma').doc(taskId).set(
            dhamma.toMap(),
          );
      await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(bhikkhuId)
          .collection('dhammaCollections')
          .doc(collectionId)
          .collection('dhamma')
          .doc(taskId)
          .set(dhamma.toMap());

      return Right(dhamma);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, BhikkhuModel>> addBhikkhuDetailToStorage({
    required String nameENG,
    required String nameMM,
    required String alias,
    required String title,
    required File selectedProfileImage,
  }) async {
    String profilelUrl;
    final bhikkhuId = const Uuid().v4();
    try {
      Reference profileRef = FirebaseStorage.instance
          .ref()
          .child('bhikkhuProfileImages')
          .child(bhikkhuId);

      //create upload task
      UploadTask profileTask = profileRef.putFile(selectedProfileImage);
      //upload image
      TaskSnapshot profileSnapshot = await profileTask;
      //get image url
      profilelUrl = await profileSnapshot.ref.getDownloadURL();

      final bhikkhu = BhikkhuModel(
        id: bhikkhuId,
        nameENG: nameENG,
        nameMM: nameMM,
        alias: alias,
        title: title,
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

      await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(bhikkhuId)
          .set(
            bhikkhu.toMap(),
          );

      return Right(bhikkhu);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, DhammaCollectionModel>>
      addCollectionDetailsToStorage({
    required String bhikkhuId,
    required String collectionName,
    required File selectedCollectionImage,
    required DateTime releaseDate,
  }) async {
    String collectionUrl;
    final collectionId = const Uuid().v4();
    try {
      Reference collectionRef = FirebaseStorage.instance
          .ref()
          .child('collectionProfileImages')
          .child(collectionId);

      //create upload task
      UploadTask collectionTask =
          collectionRef.putFile(selectedCollectionImage);
      //upload image
      TaskSnapshot collectionSnapshot = await collectionTask;
      //get image url
      collectionUrl = await collectionSnapshot.ref.getDownloadURL();

      final dhammaCollection = DhammaCollectionModel(
        id: collectionId,
        bhikkhuId: bhikkhuId,
        collectionName: collectionName,
        releaseDate: releaseDate,
        collectionImageUrl: collectionUrl,
        totalDownloads: 0,
        totalLikes: 0,
        totalPlayCount: 0,
        totalShare: 0,
      );

      await FirebaseFirestore.instance
          .collection('dhammaCollections')
          .doc(collectionId)
          .set(
            dhammaCollection.toMap(),
          );
      await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(bhikkhuId)
          .collection('dhammaCollections')
          .doc(collectionId)
          .set(
            dhammaCollection.toMap(),
          );

      return Right(dhammaCollection);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, DhammaCategoryModel>> addDhammaCategoryDetails({
    required String name,
  }) async {
    final categoryId = const Uuid().v4();
    try {
      final category = DhammaCategoryModel(id: categoryId, name: name);
      await FirebaseFirestore.instance
          .collection('dhammaCategories')
          .doc(categoryId)
          .set(
            category.toMap(),
          );
      return Right(category);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> uploadUserGenDhammaPlaylist({
    required UserDefinedPlaylistModel playlist,
    required String creatorName,
  }) async {
    try {
      if (creatorName == 'Mingalar') {
        await FirebaseFirestore.instance
            .collection('mingalarDhammaPlaylists')
            .doc(playlist.id)
            .set(
          {
            'id': playlist.id,
            'title': playlist.title,
            'description': playlist.description,
            'createdAt': playlist.createdAt,
            'updatedAt': DateTime.now(),
            'createrId': playlist.createrId,
            'createrName': creatorName,
            'hashtags': playlist.hashtags,
          },
        );
        for (MusicModel track in playlist.tracks) {
          await FirebaseFirestore.instance
              .collection('mingalarDhammaPlaylists')
              .doc(playlist.id)
              .collection('tracks')
              .doc(track.id)
              .set(track.toMap());
        }
      } else {
        await FirebaseFirestore.instance
            .collection('fanDhammaPlaylists')
            .doc(playlist.id)
            .set(
          {
            'id': playlist.id,
            'title': playlist.title,
            'description': playlist.description,
            'createdAt': playlist.createdAt,
            'updatedAt': DateTime.now(),
            'createrId': playlist.createrId,
            'createrName': creatorName,
            'hashtags': playlist.hashtags,
          },
        );
        for (MusicModel track in playlist.tracks) {
          await FirebaseFirestore.instance
              .collection('fanDhammaPlaylists')
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

  /* Future<Either<AppFailure, bool>> updateFavoriteStatus({
    required bool isLiked,
    required MusicModel audioTrack,
  }) async {
    try {
      if (isLiked) {
        await FirebaseFirestore.instance
            .collection('dhamma')
            .doc(audioTrack.id)
            .update({'likeCount': FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('bhikkhus')
            .doc(audioTrack.artistId)
            .update({'totalLikes': FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('dhammaCollections')
            .doc(audioTrack.albumId)
            .update({'totalLikes': FieldValue.increment(1)});

        await FirebaseFirestore.instance
            .collection('bhikkhus')
            .doc(audioTrack.artistId)
            .collection('dhammaCollections')
            .doc(audioTrack.albumId)
            .collection('dhamma')
            .doc(audioTrack.id)
            .update({'likeCount': FieldValue.increment(1)});

        final interactionId = const Uuid().v4();
        final interaction = DhammaUserInteractionModel(
          id: interactionId,
          userId: currentUser!.uid,
          trackId: audioTrack.id,
          bhikkhuId: audioTrack.artistId,
          collectionId: audioTrack.albumId,
          interactionType: 'Like',
          timestamp: DateTime.now().toLocal(),
        );

        await FirebaseFirestore.instance
            .collection('dhammaUserInteractions')
            .doc(interactionId)
            .set(interaction.toMap());
      } else {
        await FirebaseFirestore.instance
            .collection('dhamma')
            .doc(audioTrack.id)
            .update({'likeCount': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('bhikkhus')
            .doc(audioTrack.artistId)
            .update({'totalLikes': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('dhammaCollections')
            .doc(audioTrack.albumId)
            .update({'totalLikes': FieldValue.increment(-1)});

        await FirebaseFirestore.instance
            .collection('bhikkhus')
            .doc(audioTrack.artistId)
            .collection('dhammaCollections')
            .doc(audioTrack.albumId)
            .collection('dhamma')
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
          FirebaseFunctions.instance.httpsCallable("updateDhammaLikeStatus");

      final response = await callable.call({
        'isLiked': isLiked,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'audioTrack': {
          'id': audioTrack.id,
          'artistId': audioTrack.artistId,
          'albumId': audioTrack.albumId,
        },
      });
      debugPrint('Like Status Response: ${response.data}');

      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, bool>> updateFollowerStatus({
    required bool isFollowed,
    required BhikkhuModel bhikkhu,
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
            .collection('bhikkhus')
            .doc(bhikkhu.id)
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
            .collection('bhikkhus')
            .doc(bhikkhu.id)
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
    required BhikkhuModel bhikkhu,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('updateBhikkhuFollowerStatus');
      final response = await callable.call({
        'isFollowed': isFollowed,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'bhikkhu': {
          'id': bhikkhu.id,
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
          .collection('dhamma')
          .doc(audioTrack.id)
          .update({'playCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(audioTrack.artistId)
          .update({'totalPlayCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('dhammaCollections')
          .doc(audioTrack.albumId)
          .update({'totalPlayCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(audioTrack.artistId)
          .collection('dhammaCollections')
          .doc(audioTrack.albumId)
          .collection('dhamma')
          .doc(audioTrack.id)
          .update({'playCount': FieldValue.increment(1)});

      final interactionId = const Uuid().v4();

      final interaction = DhammaUserInteractionModel(
        id: interactionId,
        userId: currentUser!.uid,
        trackId: audioTrack.id,
        bhikkhuId: audioTrack.artistId,
        collectionId: audioTrack.albumId,
        interactionType: 'Play',
        timestamp: DateTime.now().toLocal(),
      );

      await FirebaseFirestore.instance
          .collection('dhammaUserInteractions')
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
          FirebaseFunctions.instance.httpsCallable('updateDhammaPlayStatus');
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

  Future<Either<AppFailure, List<MusicModel>>> getAllDhammaTracks() async {
    try {
      // Check for cached music in Hive
      if (_allDhammaBox.isNotEmpty) {
        List<MusicModel> dhamma = _allDhammaBox.values.toList();
        return Right(dhamma);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('dhamma');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedDhamma = [];

      // Process the documents
      for (final doc in documents) {
        final dhamma = MusicModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedDhamma.add(dhamma);
        await _allDhammaBox.put(dhamma.id, dhamma);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates('dhamma', 'allDhamma');

      return Right(fetchedDhamma);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, List<MusicModel>>> getAllDhammaTracks() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('dhamma');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> dhamma = [];

      // Process the documents
      for (final doc in documents) {
        dhamma.add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(dhamma);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */

  Future<Either<AppFailure, List<MusicModel>>> getCollectionTracks(
      DhammaCollectionModel collectionModel) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('bhikkhus')
        .doc(collectionModel.bhikkhuId)
        .collection('dhammaCollections')
        .doc(collectionModel.id)
        .collection('dhamma');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> dhamma = [];

      // Process the documents
      for (final doc in documents) {
        dhamma.add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(dhamma);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getAllTracksThisMonth() async {
    try {
      // Check for cached music in Hive
      if (_thisMonthDhammaBox.isNotEmpty) {
        List<MusicModel> dhamma = _thisMonthDhammaBox.values.toList();
        return Right(dhamma);
      }

      // Fetch all documents
      DateTime now = DateTime.now();
      DateTime monthAgo = now.subtract(const Duration(days: 30));
      int monthAgoInMilliseconds = monthAgo.millisecondsSinceEpoch;
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('dhamma');
      QuerySnapshot querySnapshot = await collectionRef
          .where('uploadDate', isGreaterThan: monthAgoInMilliseconds)
          .orderBy('uploadDate')
          .get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedDhamma = [];

      // Process the documents
      for (final doc in documents) {
        final dhamma = MusicModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedDhamma.add(dhamma);
        await _thisMonthDhammaBox.put(dhamma.id, dhamma);
      }

      // Maintain cache based on uploadDate within the last week
      _maintainCacheWithinMonth(_thisMonthDhammaBox);

      // Listen for real-time updates
      listenToFirestoreUpdates('music', 'thisMonthDhamma');

      return Right(fetchedDhamma);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> fetchSuggestedDhammaTracks(
    int offset,
    int limit,
  ) async {
    try {
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('dhamma');
      QuerySnapshot querySnapshot = await collectionRef
          .orderBy('likeCount')
          .startAt([offset])
          .limit(limit)
          .get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedDhammaTracks = [];

      // Process the documents
      for (final doc in documents) {
        fetchedDhammaTracks
            .add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(fetchedDhammaTracks);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<MusicModel>>> getTopTenPlayedTracksByBhikkhu({
    required String bhikkhuId,
  }) async {
    try {
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('dhamma');
      QuerySnapshot querySnapshot = await collectionRef
          .where('artistId', isEqualTo: bhikkhuId)
          .orderBy('playCount')
          .limit(10)
          .get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<MusicModel> fetchedTracks = [];

      // Process the documents
      for (final doc in documents) {
        fetchedTracks
            .add(MusicModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(fetchedTracks);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<BhikkhuModel>>> getAllBhikkhus() async {
    try {
      // Check for cached music in Hive
      if (_allBhikkhusBox.isNotEmpty) {
        List<BhikkhuModel> bhikkhus = _allBhikkhusBox.values.toList();
        return Right(bhikkhus);
      }

      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('bhikkhus');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<BhikkhuModel> fetchedBhikkhus = [];

      // Process the documents
      for (final doc in documents) {
        final bhikkhu =
            BhikkhuModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedBhikkhus.add(bhikkhu);
        await _allBhikkhusBox.put(bhikkhu.id, bhikkhu);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates('bhikkhus', 'allBhikkhus');

      return Right(fetchedBhikkhus);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<BhikkhuModel>>> getTenBhikkhus() async {
    try {
      // Check for cached music in Hive
      if (_tenBhikkhusBox.isNotEmpty) {
        List<BhikkhuModel> bhikkhus = _tenBhikkhusBox.values.toList();
        return Right(bhikkhus);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('bhikkhus');
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('totalFollowers').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<BhikkhuModel> fetchedBhikkhus = [];

      // Process the documents
      for (final doc in documents) {
        final bhikkhus =
            BhikkhuModel.fromMap(doc.data() as Map<String, dynamic>);
        fetchedBhikkhus.add(bhikkhus);
        await _tenBhikkhusBox.put(bhikkhus.id, bhikkhus);
      }

      _maintainCacheLimit(_tenBhikkhusBox, 10);

      // Listen for real-time updates
      listenToFirestoreUpdates('bhikkhus', 'tenBhikkhus');

      return Right(fetchedBhikkhus);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getAllMingalarDhammaPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_allMingalarDhammaPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _allMingalarDhammaPlaylistsBox.values.toList();
        return Right(playlists);
      }

      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('mingalarDhammaPlaylists');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _allMingalarDhammaPlaylistsBox.put(playlist.id, playlist);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates(
          'mingalarDhammaPlaylists', 'allMingalarDhammaPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getTenMingalarDhammaPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_tenMingalarDhammaPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _tenMingalarDhammaPlaylistsBox.values.toList();
        return Right(playlists);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('mingalarDhammaPlaylists');
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('playCount').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _tenMingalarDhammaPlaylistsBox.put(playlist.id, playlist);
      }

      _maintainCacheLimitUserGenPlaylists(_tenMingalarDhammaPlaylistsBox, 10);

      // Listen for real-time updates
      listenToFirestoreUpdates(
          'mingalarDhammaPlaylists', 'tenMingalarDhammaPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getAllUserGenDhammaPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_allUserDhammaPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _allUserDhammaPlaylistsBox.values.toList();
        return Right(playlists);
      }

      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('fanDhammaPlaylists');
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _allUserDhammaPlaylistsBox.put(playlist.id, playlist);
      }

      // Listen for real-time updates
      listenToFirestoreUpdates('fanDhammaPlaylists', 'allUserDhammaPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<CustomPlaylistCompilationModel>>>
      getTenUserGenDhammaPlaylists() async {
    try {
      // Check for cached music in Hive
      if (_tenUserDhammaPlaylistsBox.isNotEmpty) {
        List<CustomPlaylistCompilationModel> playlists =
            _tenUserDhammaPlaylistsBox.values.toList();
        return Right(playlists);
      }
      // Fetch all documents
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('fanDhammaPlaylists');
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('playCount').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<CustomPlaylistCompilationModel> fetchedPlaylists = [];

      // Process the documents
      for (final doc in documents) {
        final playlist = CustomPlaylistCompilationModel.fromMap(
            doc.data() as Map<String, dynamic>);
        fetchedPlaylists.add(playlist);
        await _tenUserDhammaPlaylistsBox.put(playlist.id, playlist);
      }

      _maintainCacheLimitUserGenPlaylists(_tenUserDhammaPlaylistsBox, 10);

      // Listen for real-time updates
      listenToFirestoreUpdates('fanDhammaPlaylists', 'tenUserDhammaPlaylists');

      return Right(fetchedPlaylists);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<DhammaCategoryModel>>>
      getAllCategories() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('dhammaCategories');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<DhammaCategoryModel> categories = [];

      // Process the documents
      for (final doc in documents) {
        categories.add(
            DhammaCategoryModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(categories);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<DhammaCollectionModel>>>
      getCollectionsByBhikkhu(
    String bhikkhuId,
  ) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('bhikkhus')
        .doc(bhikkhuId)
        .collection('dhammaCollections');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<DhammaCollectionModel> collections = [];

      // Process the documents
      for (final doc in documents) {
        collections.add(
            DhammaCollectionModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(collections);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<DhammaCollectionModel>>>
      getPreferredCollectionsByBhikkhu(
    String bhikkhuId,
  ) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('preferredCollections')
        .doc(bhikkhuId)
        .collection('topCollections');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<DhammaCollectionModel> dhammaCollections = [];

      // Process the documents
      for (final doc in documents) {
        dhammaCollections.add(
            DhammaCollectionModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(dhammaCollections);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, BhikkhuModel>> getBhikkhuById(
    String bhikkhuId,
  ) async {
    try {
      // Fetch all documents
      DocumentSnapshot bhikkhuDoc = await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(bhikkhuId)
          .get();

      final bhikkhuModel =
          BhikkhuModel.fromMap(bhikkhuDoc.data() as Map<String, dynamic>);

      return Right(bhikkhuModel);
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
              if (collectionName == 'dhamma') {
                final dhamma =
                    MusicModel.fromMap(doc.data() as Map<String, dynamic>);
                box.put(dhamma.id, dhamma);
              } else if (collectionName == 'bhikkhus') {
                final bhikkhu =
                    BhikkhuModel.fromMap(doc.data() as Map<String, dynamic>);
                box.put(bhikkhu.id, bhikkhu);
              } else if (collectionName == 'fanDhammaPlaylists') {
                final userPlaylist = CustomPlaylistCompilationModel.fromMap(
                    doc.data() as Map<String, dynamic>);
                box.put(userPlaylist.id, userPlaylist);
              } else if (collectionName == 'mingalarDhammaPlaylists') {
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
  Box<dynamic>? getBoxForCollection(String collectionName) {
    switch (collectionName) {
      case 'allDhamma':
        return _allDhammaBox;
      case 'allBhikkhus':
        return _allBhikkhusBox;
      case 'thisMonthDhamma':
        return _thisMonthDhammaBox;
      case 'tenBhikkhus':
        return _tenBhikkhusBox;
      case 'allMingalarDhammaPlaylists':
        return _allMingalarDhammaPlaylistsBox;
      case 'tenMingalarDhammaPlaylists':
        return _tenMingalarDhammaPlaylistsBox;
      case 'allUserDhammaPlaylists':
        return _allUserDhammaPlaylistsBox;
      case 'tenUserDhammaPlaylists':
        return _tenUserDhammaPlaylistsBox;
      default:
        return null; // Return null for unknown collections
    }
  }

  void _maintainCacheWithinMonth(Box<MusicModel> box) {
    DateTime now = DateTime.now();
    DateTime monthAgo = now.subtract(const Duration(days: 30));
    // int weekAgoInMilliseconds = weekAgo.millisecondsSinceEpoch;

    List<String> keysToRemove = [];
    for (var key in box.keys) {
      final music = box.get(key);
      if (music != null && music.uploadDate.isBefore(monthAgo)) {
        keysToRemove.add(key);
      }
    }

    for (var key in keysToRemove) {
      box.delete(key);
    }
  }

  // Helper method to maintain the cache limit
  void _maintainCacheLimit(Box<BhikkhuModel> box, int limit) {
    List<BhikkhuModel> bhikkhuList = box.values.toList();
    // Sort the list based on follower counts in descending order
    bhikkhuList.sort((a, b) => b.totalFollowers.compareTo(a.totalFollowers));
    if (bhikkhuList.length > limit) {
      // Get the keys for the music that are not in the top N
      final keysToRemove =
          bhikkhuList.skip(limit).map((bhikkhu) => bhikkhu.id).toList();

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
}
