import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/add_to_playlist_track_widget.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class MusicSelectionScreenWidget extends ConsumerStatefulWidget {
  final UserDefinedPlaylistModel playlist;

  const MusicSelectionScreenWidget({
    super.key,
    required this.playlist,
  });

  @override
  ConsumerState<MusicSelectionScreenWidget> createState() =>
      _MusicSelectionScreenWidgetState();
}

class _MusicSelectionScreenWidgetState
    extends ConsumerState<MusicSelectionScreenWidget> {
  int offset = 0;
  final int limit = 10;
  bool isLoadingMore = false;
  bool hasMoreSongs = false;
  Set<String> addedSongIds = {};
  List<MusicModel> suggestedMusicList = [];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Music'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Songs',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: CarouselSlider(
              items: [
                buildSuggestedMusic(),
                buildRecentlyPlayedPage(),
              ],
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height - 56,
                enlargeCenterPage: true,
                autoPlay: false,
                viewportFraction: 0.9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuggestedMusic() {
    final suggestedAsyncMusic =
        ref.watch(getSuggestedMusicProvider(offset, limit));

    return Container(
      decoration: BoxDecoration(
        color: AppPallete.cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Suggested Songs', style: TextStyle(fontSize: 20)),
          ),
          suggestedAsyncMusic.when(
            data: (fetchedMusic) {
              final newSongs = fetchedMusic
                  .where((song) => !addedSongIds.contains(song.id))
                  .toList();
              for (var song in newSongs) {
                addedSongIds.add(song.id);
              }
              suggestedMusicList.addAll(newSongs);

              hasMoreSongs = newSongs.isNotEmpty;

              return Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (!isLoadingMore &&
                        scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent &&
                        hasMoreSongs) {
                      loadMoreSongs();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: suggestedMusicList.length +
                        (isLoadingMore && hasMoreSongs ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == suggestedMusicList.length && isLoadingMore) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final song = suggestedMusicList[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        child: AddToPlaylistTrackWidget(
                          track: song,
                          playlist: widget.playlist,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  // Method to load more songs
  void loadMoreSongs() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });

    offset += limit;

    // Fetch more songs
    final result =
        await ref.read(getSuggestedMusicProvider(offset, limit).future);

    final newSongs =
        result.where((song) => !addedSongIds.contains(song.id)).toList();

    if (newSongs.isNotEmpty) {
      setState(() {
        hasMoreSongs = true;
        suggestedMusicList.addAll(newSongs);
        for (var song in newSongs) {
          addedSongIds.add(song.id);
        }
        isLoadingMore = false;
      });
    } else {
      setState(() {
        isLoadingMore = false;
        hasMoreSongs = false;
      });
    }
  }

  Widget buildRecentlyPlayedPage() {
    return Container(
      decoration: BoxDecoration(
        color: AppPallete.borderColor, // Use a light grey background
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Recently played', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
