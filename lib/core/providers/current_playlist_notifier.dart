import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_model.dart';
import 'package:mingalar_music_app/core/models/playlist_model.dart';
import 'package:mingalar_music_app/core/providers/all_dhamma_playlists_notifier.dart';
import 'package:mingalar_music_app/core/providers/all_music_playlists_notifier.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/repositories/home_local_repository.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_playlist_notifier.g.dart';

@riverpod
class CurrentPlaylistNotifier extends _$CurrentPlaylistNotifier {
  late HomeLocalRepository _homeLocalRepository;
  final Map<String, PlaylistModel> playlists = {};
  String? activePlaylistId;
  PlaylistModel? playlistModel;
  List<MusicModel> recentlyPlayedMusic = [];
  List<MusicModel> recentlyPlayedDhammaTrack = [];

  @override
  MusicModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    recentlyPlayedMusic =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedMusic();
    recentlyPlayedDhammaTrack = ref
        .watch(dhammaViewModelProvider.notifier)
        .getRecentlyPlayedDhammaTracks();
    return null;
  }

  void initializePlaylist(
    String playlistTitle,
    String playlistId,
    List<MusicModel> tracks,
  ) {
    final audioPlayer = AudioPlayer();
    final newPlaylistModel = PlaylistModel(
      tracks: tracks,
      audioPlayer: audioPlayer,
      id: playlistId,
      title: playlistTitle,
    );

    if (tracks.isNotEmpty) {
      newPlaylistModel.currentTrack = tracks.first;
      state = newPlaylistModel.currentTrack;
    }

    playlists[playlistId] = newPlaylistModel;
  }

  void setCurrentPlaylist(String playlistId) async {
    if (activePlaylistId != playlistId &&
        activePlaylistId != null &&
        playlists.containsKey(activePlaylistId)) {
      if (playlists[activePlaylistId] != null) {
        playlists[activePlaylistId]!.audioPlayer.pause();
        playlists[activePlaylistId]!.audioPlayer.stop();
        playlists[activePlaylistId]!.isPlaying = false;
        playlists[activePlaylistId]!.isInitialized = false;
        activePlaylistId = null;
        state = null;
      }
    }

    playlistModel = playlists[playlistId];
    if (playlistModel != null) {
      activePlaylistId = playlistId;
      if (!playlistModel!.isInitialized) {
        playlistModel!.audioPlayer.setAudioSource(
          /* ConcatenatingAudioSource(
            children: playlistModel!.tracks
                .map((track) => AudioSource.uri(
                      Uri.parse(track.musicUrl),
                      tag: MediaItem(
                        id: track.id,
                        title: track.musicName,
                        artist: track.artist,
                        artUri: Uri.parse(track.thumbnailUrl),
                      ),
                    ))
                .toList(),
          ), */
          ConcatenatingAudioSource(
            children: playlistModel!.tracks.map((track) {
              final artUri = track.thumbnailUrl.startsWith('https')
                  ? Uri.parse(track.thumbnailUrl)
                  : Uri.file(track.thumbnailUrl);
              return AudioSource.uri(
                Uri.parse(track.musicUrl),
                tag: MediaItem(
                  id: track.id,
                  title: track.musicName,
                  artist: track.artist,
                  artUri: artUri,
                ),
              );
            }).toList(),
          ),
        );
        playlistModel!.isInitialized = true;
      }
    }
  }

  void playCurrentPlaylist() {
    if (activePlaylistId != null && playlistModel != null) {
      // playlistModel = playlists[activePlaylistId];

      playlistModel!.audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          playlistModel!.audioPlayer.seek(Duration.zero);
          playlistModel!.audioPlayer.pause();
          playlistModel!.isPlaying = false;
          playlistModel!.isInitialized = false;
          playlistModel!.currentTrack = playlistModel!.tracks.first;
          playlistModel!.currentIndex = 0;
          this.state = null;
        }
      });

      playlistModel!.audioPlayer.currentIndexStream.listen((index) {
        if (index != null &&
            index >= 0 &&
            index < playlistModel!.tracks.length) {
          playlistModel!.currentTrack = playlistModel!.tracks[index];
          playlistModel!.currentIndex = index;
          state = playlistModel!.currentTrack;

          _homeLocalRepository.uploadLocalMusic(playlistModel!.currentTrack!);

          ref.read(homeViewModelProvider.notifier).updatePlayStatusToFirebase(
                track: playlistModel!.currentTrack!,
              );

          if (playlistModel!.currentTrack!.audioType == 'Music') {
            recentlyPlayedMusic = ref
                .read(homeViewModelProvider.notifier)
                .getRecentlyPlayedMusic();

            final recentPlaylistModel = CustomPlaylistModel(
              id: 'recentlyPlayedMusic',
              title: 'Recently Played',
              count: recentlyPlayedMusic.length,
              playlist: recentlyPlayedMusic,
              playListType: 'Music',
            );
            ref
                .read(allMusicPlaylistsNotifierProvider.notifier)
                .addToPlaylists(recentPlaylistModel);
          } else {
            recentlyPlayedDhammaTrack = ref
                .read(dhammaViewModelProvider.notifier)
                .getRecentlyPlayedDhammaTracks();

            final recentPlaylistModel = CustomPlaylistModel(
              id: 'recentlyPlayedDhamma',
              title: 'Recently Played',
              count: recentlyPlayedDhammaTrack.length,
              playlist: recentlyPlayedDhammaTrack,
              playListType: 'Dhamma',
            );
            ref
                .read(allDhammaPlaylistsNotifierProvider.notifier)
                .addToPlaylists(recentPlaylistModel);
          }
        }
      });

      if (!playlistModel!.isInitialized) {
        if (!playlistModel!.isPlaying) {
          playlistModel!.audioPlayer.play();
          state = playlistModel!.currentTrack;
          playlistModel!.isPlaying = true;
        }
      } else {
        togglePlayPause();
      }
    }
  }

  void togglePlayPause() {
    if (activePlaylistId != null) {
      // playlistModel = playlists[activePlaylistId];
      if (playlistModel != null) {
        if (playlistModel!.isPlaying) {
          playlistModel!.audioPlayer.pause();
        } else {
          playlistModel!.audioPlayer.play();
        }
        playlistModel!.isPlaying = !playlistModel!.isPlaying;
        state = state?.copyWith(hexCode: state?.hexCode);
      }
    }
  }

  void seek(double val) {
    if (activePlaylistId != null && playlistModel != null) {
      // playlistModel = playlists[activePlaylistId];
      if (playlistModel!.audioPlayer.duration != null) {
        playlistModel!.audioPlayer.seek(
          Duration(
            milliseconds:
                (val * playlistModel!.audioPlayer.duration!.inMilliseconds)
                    .toInt(),
          ),
        );
      }
    }
  }

  void skipToNext() {
    if (activePlaylistId != null && playlistModel != null) {
      // playlistModel = playlists[activePlaylistId];
      playlistModel!.audioPlayer.seekToNext();
    }
  }

  void skipToPrevious() {
    if (activePlaylistId != null && playlistModel != null) {
      // playlistModel = playlists[activePlaylistId];
      playlistModel!.audioPlayer.seekToPrevious();
    }
  }

  void toggleShuffle() async {
    if (activePlaylistId != null && playlistModel != null) {
      // playlistModel = playlists[activePlaylistId];
      final shuffleEnabled = !playlistModel!.audioPlayer.shuffleModeEnabled;
      await playlistModel!.audioPlayer.setShuffleModeEnabled(shuffleEnabled);
    }
  }

  MusicModel? getCurrentTrack() {
    if (activePlaylistId != null && playlistModel != null) {
      // return playlists[activePlaylistId]?.currentTrack;
      return playlistModel!.currentTrack;
    } else {
      return null;
    }
  }

  String? get currentPlaylistId => activePlaylistId;
}
