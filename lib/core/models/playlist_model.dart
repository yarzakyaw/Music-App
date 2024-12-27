import 'package:just_audio/just_audio.dart';

import 'package:mingalar_music_app/features/home/models/music_model.dart';

class PlaylistModel {
  final List<MusicModel> tracks;
  final AudioPlayer audioPlayer;
  bool isPlaying;
  bool isInitialized;
  int currentIndex;
  MusicModel? currentTrack;
  final String id;
  final String title;

  PlaylistModel({
    required this.tracks,
    required this.audioPlayer,
    this.isPlaying = false,
    this.isInitialized = false,
    this.currentIndex = 0,
    this.currentTrack,
    required this.id,
    required this.title,
  });
}
