import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/failure/app_failure.dart';
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/dhamma_category_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/dhamma_collection_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/dhamma_user_interaction.dart';
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

  Future<Either<AppFailure, bool>> updateFavoriteStatus({
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
  }

  Future<Either<AppFailure, bool>> updateFollowerStatus({
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
  }

  Future<Either<AppFailure, bool>> updatePlayStatus({
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
  }

  Future<Either<AppFailure, List<MusicModel>>> getAllDhammaTracks() async {
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
  }

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
    DateTime now = DateTime.now();
    DateTime monthAgo = now.subtract(const Duration(days: 30));
    int monthAgoInMilliseconds = monthAgo.millisecondsSinceEpoch;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('dhamma');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef
          .where('uploadDate', isGreaterThan: monthAgoInMilliseconds)
          .orderBy('uploadDate')
          .get();

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

  Future<Either<AppFailure, List<BhikkhuModel>>> getTenBhikkhus() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('bhikkhus');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot =
          await collectionRef.orderBy('totalFollowers').limit(10).get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<BhikkhuModel> bhikkhus = [];

      // Process the documents
      for (final doc in documents) {
        bhikkhus.add(BhikkhuModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(bhikkhus);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<BhikkhuModel>>> getAllBhikkhus() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('bhikkhus');
    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await collectionRef.get();

      // Extract the documents
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      List<BhikkhuModel> bhikkhus = [];

      // Process the documents
      for (final doc in documents) {
        bhikkhus.add(BhikkhuModel.fromMap(doc.data() as Map<String, dynamic>));
      }

      return Right(bhikkhus);
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
}
