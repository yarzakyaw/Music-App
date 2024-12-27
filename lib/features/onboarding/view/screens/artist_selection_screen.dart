import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/providers/favorite_artist_notifier.dart';
import 'package:mingalar_music_app/core/widgets/custom_app_bar.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/home/models/artist_model.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';
import 'package:mingalar_music_app/features/onboarding/view/widgets/basic_app_button.dart';

class ArtistSelectionScreen extends ConsumerStatefulWidget {
  const ArtistSelectionScreen({super.key});

  @override
  ConsumerState<ArtistSelectionScreen> createState() =>
      _ArtistSelectionScreenState();
}

class _ArtistSelectionScreenState extends ConsumerState<ArtistSelectionScreen> {
  List<String> selectedArtists = [];
  List<ArtistModel> allArtists = [];
  List<ArtistModel> filteredArtists = [];
  List<ArtistModel> selectedArtistList = [];
  String searchQuery = '';

  void toggleArtistSelection(ArtistModel artist) {
    setState(() {
      if (selectedArtists.contains(artist.id)) {
        selectedArtists.remove(artist.id);
        selectedArtistList.remove(artist);
      } else {
        selectedArtists.add(artist.id);
        selectedArtistList.add(artist);
      }
    });
  }

  void filterArtists(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text(tSelectArtists)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                onChanged: filterArtists,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: tSearch,
                ),
              ),
            ),
            const Text(
              tSelectThree,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            ref.watch(getAllArtistsProvider).when(
                  data: (artists) {
                    filteredArtists = searchQuery.isEmpty
                        ? artists
                        : artists.where((artist) {
                            return artist.nameENG
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                          }).toList();
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: filteredArtists.length,
                        itemBuilder: (context, index) {
                          var artist = filteredArtists[index];
                          bool isSelected = selectedArtists.contains(artist.id);
                          return GestureDetector(
                            onTap: () => toggleArtistSelection(artist),
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: isSelected
                                    ? Colors.blue.withOpacity(0.7)
                                    : Colors.black54,
                                title: Text(
                                  artist.nameENG,
                                  textAlign: TextAlign.center,
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check,
                                        color: Colors.white)
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(artist.profileImageUrl),
                                  radius: 50,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, st) {
                    return Center(
                      child: Text(error.toString()),
                    );
                  },
                  loading: () => const Loader(),
                ),
            BasicAppButton(
              onPressed: selectedArtists.length >= 3
                  ? () {
                      for (final artist in selectedArtistList) {
                        ref
                            .read(favoriteArtistNotifierProvider.notifier)
                            .addToFavorite(artist);
                        ref
                            .read(homeViewModelProvider.notifier)
                            .updateFollowerStatusToFirebase(
                              isFollowed: true,
                              artist: artist,
                            );
                      }
                      Navigator.pushNamed(
                        context,
                        'BhikkhuSelection',
                      );
                    }
                  : () {},
              title: tContinue,
            )
          ],
        ),
      ),
    );
  }
}
