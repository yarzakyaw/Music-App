import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/failure/app_failure.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_repository.g.dart';

@riverpod
DownloadRepository downloadRepository(Ref ref) {
  return DownloadRepository();
}

class DownloadRepository {
  final Dio _dio = Dio();
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<String> _getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return;
    } else if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        return;
      }
    } else {
      throw Exception('Storage permission not granted');
    }
  }

  /* Future<void> updateDownloadStatusMusic({
    required MusicModel audioTrack,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('music')
          .doc(audioTrack.id)
          .update({'downloadCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('artists')
          .doc(audioTrack.artistId)
          .update({'totalDownloads': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('albums')
          .doc(audioTrack.albumId)
          .update({'totalDownloads': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('artists')
          .doc(audioTrack.artistId)
          .collection('albums')
          .doc(audioTrack.albumId)
          .collection('music')
          .doc(audioTrack.id)
          .update({'downloadCount': FieldValue.increment(1)});

      final interactionId = const Uuid().v4();
      final interaction = MusicUserInteractionModel(
        id: interactionId,
        userId: currentUser!.uid,
        trackId: audioTrack.id,
        artistId: audioTrack.artistId,
        albumId: audioTrack.albumId,
        interactionType: 'Download',
        timestamp: DateTime.now().toLocal(),
      );

      await FirebaseFirestore.instance
          .collection('userInteractions')
          .doc(interactionId)
          .set(interaction.toMap());
    } catch (e) {
      throw Exception('Failed to update download status');
    }
  } */

  Future<Either<AppFailure, bool>> updateDownloadStatusMusic({
    required MusicModel audioTrack,
  }) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('updateDownloadStatus');
      final response = await callable.call({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'audioTrack': {
          'id': audioTrack.id,
          'artistId': audioTrack.artistId,
          'albumId': audioTrack.albumId,
        },
      });
      debugPrint('Download Status Response: ${response.data}');
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<void> updateDownloadStatusDhamma({
    required MusicModel audioTrack,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('dhamma')
          .doc(audioTrack.id)
          .update({'downloadCount': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(audioTrack.artistId)
          .update({'totalDownloads': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('dhammaCollections')
          .doc(audioTrack.albumId)
          .update({'totalDownloads': FieldValue.increment(1)});

      await FirebaseFirestore.instance
          .collection('bhikkhus')
          .doc(audioTrack.artistId)
          .collection('dhammaCollections')
          .doc(audioTrack.albumId)
          .collection('dhamma')
          .doc(audioTrack.id)
          .update({'downloadCount': FieldValue.increment(1)});

      final interactionId = const Uuid().v4();
      final interaction = DhammaUserInteractionModel(
        id: interactionId,
        userId: currentUser!.uid,
        trackId: audioTrack.id,
        bhikkhuId: audioTrack.artistId,
        collectionId: audioTrack.albumId,
        interactionType: 'Download',
        timestamp: DateTime.now().toLocal(),
      );

      await FirebaseFirestore.instance
          .collection('dhammaUserInteractions')
          .doc(interactionId)
          .set(interaction.toMap());
    } catch (e) {
      throw Exception('Failed to update download status');
    }
  } */

  Future<Either<AppFailure, bool>> updateDownloadStatusDhamma({
    required MusicModel audioTrack,
  }) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('updateDhammaDownloadStatus');
      final response = await callable.call({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'audioTrack': {
          'id': audioTrack.id,
          'artistId': audioTrack.artistId,
          'albumId': audioTrack.albumId,
        },
      });
      debugPrint('Download Status Response: ${response.data}');
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> downloadFile({
    required MusicModel musicModel,
    String? folderName,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      await _requestPermission();
      final dirPath = folderName != null
          ? '${await _getDownloadDirectory()}/$folderName'
          : '${await _getDownloadDirectory()}/${musicModel.audioType}';
      final trackFilePath = '$dirPath/${musicModel.musicName}.mp3';
      final imageFilePath = '$dirPath/${musicModel.musicName}.jpg';
      final metadataPath = '$dirPath/${musicModel.musicName}.json';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await _dio.download(
        musicModel.musicUrl,
        trackFilePath,
        onReceiveProgress: onReceiveProgress,
      );
      await _dio.download(
        musicModel.thumbnailUrl,
        imageFilePath,
      );

      // Save metadata as JSON
      final metadataFile = File(metadataPath);
      await metadataFile.writeAsString(jsonEncode(musicModel.toJson()));

      if (musicModel.audioType == 'Music') {
        updateDownloadStatusMusic(audioTrack: musicModel);
      } else {
        updateDownloadStatusDhamma(audioTrack: musicModel);
      }

      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, bool>> downloadPlaylist({
    required List<MusicModel> tracks,
    required String playlistName,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      await _requestPermission();
      final dirPath = '${await _getDownloadDirectory()}/$playlistName';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      for (var track in tracks) {
        final trackFilePath = '$dirPath/${track.musicName}.mp3';
        final imageFilePath = '$dirPath/${track.musicName}.jpg';
        final metadataPath = '$dirPath/${track.musicName}.json';
        await _dio.download(
          track.musicUrl,
          trackFilePath,
          onReceiveProgress: onReceiveProgress,
        );
        await _dio.download(
          track.thumbnailUrl,
          imageFilePath,
        );

        // Save metadata as JSON
        final metadataFile = File(metadataPath);
        await metadataFile.writeAsString(jsonEncode(track.toJson()));
      }
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */
}


/* import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/failure/app_failure.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_repository.g.dart';

@riverpod
DownloadRepository downloadRepository(Ref ref) {
  return DownloadRepository();
}

class DownloadRepository {
  final Dio _dio = Dio();

  Future<String> _getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return;
    } else if (status.isDenied) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        return;
      }
    } else {
      throw Exception('Storage permission not granted');
    }
  }

  Future<Either<AppFailure, bool>> downloadFile({
    required MusicModel musicModel,
    String? folderName,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      await _requestPermission();
      final dirPath = folderName != null
          ? '${await _getDownloadDirectory()}/$folderName'
          : '${await _getDownloadDirectory()}/${musicModel.audioType}';
      final trackFilePath = '$dirPath/${musicModel.musicName}.mp3';
      final imageFilePath = '$dirPath/${musicModel.musicName}.jpg';
      final metadataPath = '$dirPath/${musicModel.musicName}.json';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await _dio.download(
        musicModel.musicUrl,
        trackFilePath,
        onReceiveProgress: onReceiveProgress,
      );
      await _dio.download(
        musicModel.thumbnailUrl,
        imageFilePath,
      );

      // Save metadata as JSON
      final metadataFile = File(metadataPath);
      await metadataFile.writeAsString(jsonEncode(musicModel.toJson()));

      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, bool>> downloadFile(MusicModel musicModel,
      {String? folderName}) async {
    try {
      await _requestPermission();
      final dirPath = folderName != null
          ? '${await _getDownloadDirectory()}/$folderName'
          : '${await _getDownloadDirectory()}/${musicModel.audioType}';
      final trackFilePath = '$dirPath/${musicModel.musicName}.mp3';
      final imageFilePath = '$dirPath/${musicModel.musicName}.jpg';
      final metadataPath = '$dirPath/${musicModel.musicName}.json';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      await _dio.download(musicModel.musicUrl, trackFilePath);
      await _dio.download(musicModel.thumbnailUrl, imageFilePath);

      // Save metadata as JSON
      final metadataFile = File(metadataPath);
      await metadataFile.writeAsString(jsonEncode(musicModel.toJson()));

      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */

  Future<Either<AppFailure, bool>> downloadPlaylist({
    required List<MusicModel> tracks,
    required String playlistName,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      await _requestPermission();
      final dirPath = '${await _getDownloadDirectory()}/$playlistName';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      for (var track in tracks) {
        final trackFilePath = '$dirPath/${track.musicName}.mp3';
        final imageFilePath = '$dirPath/${track.musicName}.jpg';
        final metadataPath = '$dirPath/${track.musicName}.json';
        await _dio.download(
          track.musicUrl,
          trackFilePath,
          onReceiveProgress: onReceiveProgress,
        );
        await _dio.download(
          track.thumbnailUrl,
          imageFilePath,
        );

        // Save metadata as JSON
        final metadataFile = File(metadataPath);
        await metadataFile.writeAsString(jsonEncode(track.toJson()));
      }
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  /* Future<Either<AppFailure, bool>> downloadPlaylist(
      List<MusicModel> tracks, String playlistName) async {
    try {
      await _requestPermission();
      final dirPath =
          '${await _getDownloadDirectory()}/Downloads/$playlistName';
      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      for (var track in tracks) {
        final filePath = '$dirPath/${track.musicName}.mp3';
        final metadataPath = '$dirPath/${track.musicName}.json';
        await _dio.download(track.musicUrl, filePath);

        // Save metadata as JSON
        final metadataFile = File(metadataPath);
        await metadataFile.writeAsString(jsonEncode(track.toJson()));
      }
      return const Right(true);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  } */
}
 */