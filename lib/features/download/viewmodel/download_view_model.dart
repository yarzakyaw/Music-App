import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/features/download/repositories/download_repository.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_view_model.g.dart';

@riverpod
class DownloadViewModel extends _$DownloadViewModel {
  late DownloadRepository _downloadRepository;
  ValueNotifier<double> progressNotifier = ValueNotifier(0);
  ValueNotifier<String> currentTrackStatusHeader = ValueNotifier('');
  ValueNotifier<String> currentTrackStatusBody = ValueNotifier('');

  @override
  AsyncValue? build() {
    _downloadRepository = ref.watch(downloadRepositoryProvider);
    return null;
  }

  Future<void> downloadFile(MusicModel track, {String? folderName}) async {
    state = const AsyncValue.loading();
    currentTrackStatusHeader.value = "Downloading ${track.musicName}";

    final res = await _downloadRepository.downloadFile(
      musicModel: track,
      folderName: folderName,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          progressNotifier.value = received / total;
          currentTrackStatusBody.value =
              '${(received / (1024 * 1024)).toStringAsFixed(2)} MB / ${(total / (1024 * 1024)).toStringAsFixed(2)} MB - ${(received / total * 100).toStringAsFixed(2)}%';
          // state = const AsyncValue.data(true);
        }
      },
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> downloadPlaylist(
      List<MusicModel> tracks, String playlistName) async {
    state = const AsyncValue.loading();
    currentTrackStatusHeader.value = "Downloading $playlistName";

    for (var i = 0; i < tracks.length; i++) {
      final track = tracks[i];
      await downloadFile(track, folderName: playlistName);
      currentTrackStatusBody.value = "Downloaded ${i + 1}/${tracks.length}";
    }

    state = const AsyncValue.data(true);
  }
}

/* import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/features/download/repositories/download_repository.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_view_model.g.dart';

@riverpod
class DownloadViewModel extends _$DownloadViewModel {
  late DownloadRepository _downloadRepository;
  double progress = 0.0;
  String ProgressMessageTitle = '';
  String ProgressMessageBody = '';

  @override
  AsyncValue? build() {
    _downloadRepository = ref.watch(downloadRepositoryProvider);
    return null;
  }

  Future<void> downloadFile(MusicModel track, {String? folderName}) async {
    state = const AsyncValue.loading();
    ProgressMessageTitle = 'Downloading ${track.title}';
    progress = 0.0;
    ProgressMessageBody = '';

    final res = await _downloadRepository.downloadFile(
      musicModel: track,
      folderName: folderName,
      onReceiveProgress: (received, total) {
        progress = received / total;
        ProgressMessageBody =
            '${(received / (1024 * 1024)).toStringAsFixed(2)} MB / ${(total / (1024 * 1024)).toStringAsFixed(2)} MB - ${(received / total * 100).toStringAsFixed(2)}%';
        // ProgressMessageBody =
        //     '${received.toStringAsFixed(2)} MB / ${total.toStringAsFixed(2)} MB - ${(received / total * 100).toStringAsFixed(2)}%';
        state = const AsyncValue.data(true);
      },
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> downloadPlaylist(
      List<MusicModel> tracks, String playlistName) async {
    state = const AsyncValue.loading();
    progress = 0.0;
    ProgressMessageTitle = 'Downloading $playlistName';
    ProgressMessageBody = '';

    int completed = 0;

    final res = await _downloadRepository.downloadPlaylist(
      tracks: tracks,
      playlistName: playlistName,
      onReceiveProgress: (received, total) {
        progress = received / total;
        ProgressMessageBody = '(${++completed}/${tracks.length}) completed';
        state = const AsyncValue.data(true);
      },
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }
} */

/* import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mingalar_music_app/features/download/repositories/download_repository.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_view_model.g.dart';

@riverpod
class DownloadViewModel extends _$DownloadViewModel {
  late DownloadRepository _downloadRepository;

  @override
  AsyncValue? build() {
    _downloadRepository = ref.watch(downloadRepositoryProvider);
    return null;
  }

  Future<void> downloadFile(MusicModel track, {String? folderName}) async {
    state = const AsyncValue.loading();
    final res =
        await _downloadRepository.downloadFile(track, folderName: folderName);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }

  Future<void> downloadPlaylist(
      List<MusicModel> tracks, String playlistName) async {
    state = const AsyncValue.loading();
    final res =
        await _downloadRepository.downloadPlaylist(tracks, playlistName);

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    debugPrint(val.toString());
  }
}
 */
