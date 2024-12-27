import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/repositories/home_local_repository.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_music_notifier.g.dart';

@riverpod
class CurrentMusicNotifier extends _$CurrentMusicNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  bool isInitialized = false;
  ConcatenatingAudioSource? playlist;
  List<MusicModel> musicModels = [];
  List<MusicModel> recentlyPlayedMusic = [];

  @override
  MusicModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    recentlyPlayedMusic =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedMusic();

    audioPlayer = AudioPlayer();

    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [],
    );

    return null;
  }

  void setPlaylist(List<MusicModel> playlistTracks) async {
    if (audioPlayer != null) {
      await audioPlayer!.stop();
    }

    isPlaying = false;
    playlist?.clear();
    musicModels.clear();

    // state = state?.copyWith(hexCode: state?.hexCode);

    for (var track in playlistTracks) {
      final audioSource = AudioSource.uri(
        Uri.parse(track.musicUrl),
        tag: MediaItem(
          id: track.id,
          title: track.musicName,
          artist: track.artist,
          artUri: Uri.parse(track.thumbnailUrl),
        ),
      );
      await playlist!.add(audioSource);
      musicModels.add(track);
    }

    if (musicModels.isNotEmpty) {
      state = musicModels.first; // Update state to the first track
    } else {
      debugPrint('No tracks available to play.');
    }
  }

  void playAll() async {
    if (!isInitialized) {
      if (playlist != null && playlist!.children.isNotEmpty) {
        isPlaying = true;

        await audioPlayer!.setAudioSource(playlist!);
        isInitialized = true;
        await audioPlayer!.play();
        // state = state?.copyWith(hexCode: state?.hexCode);

        audioPlayer!.currentIndexStream.listen((index) {
          if (index != null && index < playlist!.children.length) {
            _homeLocalRepository.uploadLocalMusic(musicModels[index]);
            state = musicModels[index];
            isPlaying = true;

            recentlyPlayedMusic = ref
                .watch(homeViewModelProvider.notifier)
                .getRecentlyPlayedMusic();

            // final recentPlaylistModel = PlaylistModel(
            //   id: 'recentlyPlayed',
            //   title: 'Recently Played',
            //   count: recentlyPlayedMusic.length,
            //   playlist: recentlyPlayedMusic,
            // );

            // ref
            //     .read(musicPlaylistNotifierProvider.notifier)
            //     .addToPlaylists(recentPlaylistModel);

            // audioPlayer!.playerStateStream.listen((state) {
            //   if (state.processingState == ProcessingState.completed) {
            //     skipToNext();
            //     isPlaying = true;
            //     this.state = this.state?.copyWith(hexCode: this.state?.hexCode);
            //   }
            // });
          } else {
            audioPlayer!.seek(Duration.zero);
            audioPlayer!.pause();
            isPlaying = false;
            state = state?.copyWith(hexCode: state?.hexCode);
          }
        });
        audioPlayer!.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            skipToNext();
            // isPlaying = true;
            // this.state = this.state?.copyWith(hexCode: this.state?.hexCode);
          }
        });
      }
    } else {
      playPause();
    }
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hexCode: state?.hexCode);
  }

  void seek(double val) {
    // audioPlayer!.seek(
    //   Duration(
    //     milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
    //   ),
    // );
    if (audioPlayer!.duration != null) {
      audioPlayer!.seek(
        Duration(
          milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
        ),
      );
    }
  }

  void toggleShuffle() async {
    // final shuffleEnabled = !audioPlayer!.shuffleModeEnabled;
    // await audioPlayer!.setShuffleModeEnabled(shuffleEnabled);
    if (audioPlayer != null) {
      final shuffleEnabled = !audioPlayer!.shuffleModeEnabled;
      await audioPlayer!.setShuffleModeEnabled(shuffleEnabled);
    }
  }

  void skipToNext() {
    audioPlayer?.seekToNext();
  }

  void skipToPrevious() {
    audioPlayer?.seekToPrevious();
  }
}

// audioPlayer!.playerStateStream.listen((state) {
//   if (state.processingState == ProcessingState.completed) {
//     if (playlist != null && playlist!.children.isNotEmpty) {
//       skipToNext();
//       isPlaying = true;
//       this.state = this.state?.copyWith(hexCode: this.state?.hexCode);
//     } else {
//       audioPlayer!.seek(Duration.zero);
//       audioPlayer!.pause();
//       isPlaying = false;
//       this.state = this.state?.copyWith(hexCode: this.state?.hexCode);
//     }
//   }
// });

// audioPlayer!.currentIndexStream.listen((index) {
//   if (index != null &&
//       playlist != null &&
//       index < playlist!.children.length) {
//     state = musicModels[index];
//   }
// });

// void updateMusic(MusicModel track) async {
//   isPlaylist = false;
//   await audioPlayer?.stop();

//   final audioSource = AudioSource.uri(
//     Uri.parse(track.musicUrl),
//     tag: MediaItem(
//       id: track.id,
//       title: track.musicName,
//       artist: track.artist,
//       artUri: Uri.parse(track.thumbnailUrl),
//     ),
//   );
//   await audioPlayer!.setAudioSource(audioSource);
//   audioPlayer!.playerStateStream.listen((state) {
//     if (state.processingState == ProcessingState.completed) {
//       audioPlayer!.seek(Duration.zero);
//       audioPlayer!.pause();
//       isPlaying = false;
//       this.state = this.state?.copyWith(hexCode: this.state?.hexCode);
//     }
//   });
//   _homeLocalRepository.uploadLocalMusic(track);
//   audioPlayer!.play();
//   isPlaying = true;
//   state = track;
// }
