import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/dhamma_category_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/dhamma_collection_model.dart';
import 'package:mingalar_music_app/features/dhamma/repositories/dhamma_repository.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/repositories/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dhamma_view_model.g.dart';

@riverpod
Future<List<MusicModel>> getAllDhammaTracks(Ref ref) async {
  final res = await ref.watch(dhammaRepositoryProvider).getAllDhammaTracks();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> getAllTracksThisMonth(Ref ref) async {
  final res = await ref.watch(dhammaRepositoryProvider).getAllTracksThisMonth();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<BhikkhuModel>> getAllBhikkhus(Ref ref) async {
  final res = await ref.watch(dhammaRepositoryProvider).getAllBhikkhus();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<DhammaCategoryModel>> getAllDhammaCategories(Ref ref) async {
  final res = await ref.watch(dhammaRepositoryProvider).getAllCategories();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<DhammaCollectionModel>> getCollectionsByBhikkhu(
    Ref ref, String bhikkhuId) async {
  final res = await ref
      .watch(dhammaRepositoryProvider)
      .getCollectionsByBhikkhu(bhikkhuId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<BhikkhuModel>> getTenBhikkhus(Ref ref) async {
  final res = await ref.watch(dhammaRepositoryProvider).getTenBhikkhus();

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<BhikkhuModel> getBhikkhuById(Ref ref, String bhikkhuId) async {
  final res =
      await ref.watch(dhammaRepositoryProvider).getBhikkhuById(bhikkhuId);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<MusicModel>> getCollectionTracks(
    Ref ref, DhammaCollectionModel collectionModel) async {
  final res = await ref
      .watch(dhammaRepositoryProvider)
      .getCollectionTracks(collectionModel);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class DhammaViewModel extends _$DhammaViewModel {
  late DhammaRepository _dhammaRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _dhammaRepository = ref.watch(dhammaRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadDhammaTrack({
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
    required Color selectedColor,
    required String downloadOption,
    required String creditTo,
    required List<String> hashtags,
  }) async {
    state = const AsyncValue.loading();
    final res = await _dhammaRepository.uploadDhammatoStorage(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      dhammaName: dhammaName,
      audioType: audioType,
      category: category,
      bhikkhuId: bhikkhuId,
      bhikkhu: bhikkhu,
      bhikkhuMM: bhikkhuMM,
      bhikkhuAlias: bhikkhuAlias,
      bhikkhuTitle: bhikkhuTitle,
      collectionId: collectionId,
      collectionName: collectionName,
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

  List<MusicModel> getRecentlyPlayedDhammaTracks() {
    return _homeLocalRepository.loadMusic("Dhamma");
  }

  Future<void> addBhikkhu({
    required File selectedProfileImage,
    required String nameENG,
    required String nameMM,
    required String alias,
    required String title,
  }) async {
    state = const AsyncValue.loading();
    final res = await _dhammaRepository.addBhikkhuDetailToStorage(
      nameENG: nameENG,
      nameMM: nameMM,
      alias: alias,
      title: title,
      selectedProfileImage: selectedProfileImage,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> addCollection({
    required File selectedCollectionImage,
    required String collectionName,
    required String bhikkhuId,
    required DateTime releaseDate,
  }) async {
    state = const AsyncValue.loading();
    final res = await _dhammaRepository.addCollectionDetailsToStorage(
      bhikkhuId: bhikkhuId,
      collectionName: collectionName,
      selectedCollectionImage: selectedCollectionImage,
      releaseDate: releaseDate,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> addCategory({
    required String name,
  }) async {
    state = const AsyncValue.loading();
    final res = await _dhammaRepository.addDhammaCategoryDetails(name: name);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> updateFollowerStatusToFirebase({
    required bool isFollowed,
    required BhikkhuModel bhikkhu,
  }) async {
    state = const AsyncValue.loading();
    final res = await _dhammaRepository.updateFollowerStatus(
      isFollowed: isFollowed,
      bhikkhu: bhikkhu,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }
}
