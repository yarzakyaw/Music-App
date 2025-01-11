import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/add_to_playlist_track_widget.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';

class DhammaSelectionScreenWidget extends ConsumerStatefulWidget {
  final UserDefinedPlaylistModel playlist;

  const DhammaSelectionScreenWidget({
    super.key,
    required this.playlist,
  });

  @override
  ConsumerState<DhammaSelectionScreenWidget> createState() =>
      _DhammaSelectionScreenWidgetState();
}

class _DhammaSelectionScreenWidgetState
    extends ConsumerState<DhammaSelectionScreenWidget> {
  int offset = 0;
  final int limit = 10;
  bool isLoadingMore = false;
  bool hasMoreTracks = false;
  Set<String> addedTracksIds = {};
  List<MusicModel> suggestedTracksList = [];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dhamma Tracks'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Dhamma Tracks',
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
                buildSuggestedDhammaTracks(),
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

  Widget buildSuggestedDhammaTracks() {
    final suggestedAsyncDhammaTracks =
        ref.watch(getSuggestedDhammaTracksProvider(offset, limit));

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
          suggestedAsyncDhammaTracks.when(
            data: (fetchedDhammaTracks) {
              final newTracks = fetchedDhammaTracks
                  .where((track) => !addedTracksIds.contains(track.id))
                  .toList();
              for (var track in newTracks) {
                addedTracksIds.add(track.id);
              }
              suggestedTracksList.addAll(newTracks);

              hasMoreTracks = newTracks.isNotEmpty;

              return Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (!isLoadingMore &&
                        scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent &&
                        hasMoreTracks) {
                      loadMoreTracks();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: suggestedTracksList.length +
                        (isLoadingMore && hasMoreTracks ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == suggestedTracksList.length &&
                          isLoadingMore) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final track = suggestedTracksList[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 8.0,
                        ),
                        child: AddToPlaylistTrackWidget(
                          track: track,
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
  void loadMoreTracks() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });

    offset += limit;

    // Fetch more songs
    final result =
        await ref.read(getSuggestedDhammaTracksProvider(offset, limit).future);

    final newTracks =
        result.where((track) => !addedTracksIds.contains(track.id)).toList();

    if (newTracks.isNotEmpty) {
      setState(() {
        hasMoreTracks = true;
        suggestedTracksList.addAll(newTracks);
        for (var track in newTracks) {
          addedTracksIds.add(track.id);
        }
        isLoadingMore = false;
      });
    } else {
      setState(() {
        isLoadingMore = false;
        hasMoreTracks = false;
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
