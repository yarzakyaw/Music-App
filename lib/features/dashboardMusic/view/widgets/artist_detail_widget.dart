import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/providers/favorite_artist_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/core/widgets/music_async_playlist_widget.dart';
import 'package:mingalar_music_app/features/home/models/artist_model.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class ArtistDetailWidget extends ConsumerStatefulWidget {
  final String artistId;

  const ArtistDetailWidget({
    super.key,
    required this.artistId,
  });

  @override
  ConsumerState<ArtistDetailWidget> createState() => _ArtistDetailWidgetState();
}

class _ArtistDetailWidgetState extends ConsumerState<ArtistDetailWidget> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showTitle) {
        setState(() {
          _showTitle = true;
        });
      } else if (_scrollController.offset <= 200 && _showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final artistModel = ref.watch(getAartistByIdProvider(widget.artistId));
    return artistModel.when(
      data: (artist) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showTitle ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    artist.nameENG,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              centerTitle: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // final top = constraints.biggest.height;
                  return FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: _showTitle ? 0.0 : 1.0,
                          child: Image.network(
                            artist.profileImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              artist.nameENG, // Artist name
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              backgroundColor: isDark
                  ? AppPallete.backgroundColor
                  : AppPallete.lightBackgroundColor,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildArtistDetails(artist),
                  _buildPopularReleases(artist),
                  _buildSimilarArtists(artist),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        );
      },
      error: (error, st) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () => const Loader(),
    );
  }

  Widget _buildArtistDetails(ArtistModel artist) {
    final favoriteArtists = ref.watch(favoriteArtistNotifierProvider);

    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: BorderSide.strokeAlignCenter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          artist.totalFollowers > 1000
              ? Text(
                  '${artist.totalFollowers % 1000}k followers',
                  style: const TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.w600,
                    color: AppPallete.greyColor,
                  ),
                )
              : Text(
                  '${artist.totalFollowers} followers',
                  style: const TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.w600,
                    color: AppPallete.greyColor,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      favoriteArtists.containsKey(artist.id)
                          ? {
                              ref
                                  .read(favoriteArtistNotifierProvider.notifier)
                                  .removeFromFavorites(artist.id),
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .updateFollowerStatusToFirebase(
                                    isFollowed: false,
                                    artist: artist,
                                  )
                            }
                          : {
                              ref
                                  .read(favoriteArtistNotifierProvider.notifier)
                                  .addToFavorite(artist),
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .updateFollowerStatusToFirebase(
                                    isFollowed: true,
                                    artist: artist,
                                  )
                            };
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: favoriteArtists.containsKey(artist.id)
                              ? AppPallete.greenColor
                              : AppPallete.greyColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          favoriteArtists.containsKey(artist.id)
                              ? 'following'
                              : 'follow',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: SvgPicture.asset(
                        iShuffleSVG,
                        colorFilter: const ColorFilter.mode(
                          AppPallete.greyColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.play_circle_fill,
                    ),
                    iconSize: 60,
                    color: AppPallete.greyColor,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPopularReleases(ArtistModel artist) {
    final albumModel = ref.watch(getAlbumsByArtistProvider(artist.id));
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Releases',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          albumModel.when(
            data: (albums) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  final albumMusic = ref.watch(getAlbumMusicsProvider(album));
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return MusicAsyncPlaylistWidget(
                              title: '${album.albumName} by ${artist.nameENG}',
                              playlist: albumMusic,
                            );
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final tween = Tween(
                                    begin: const Offset(1, 0), end: Offset.zero)
                                .chain(
                              CurveTween(
                                curve: Curves.easeIn,
                              ),
                            );

                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(album.albumImageUrl),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              album.albumName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              album.releaseDate.year.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
            error: (error, st) {
              return Text(error.toString());
            },
            loading: () => const Loader(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarArtists(ArtistModel artist) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Artists You May Like',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSimilarArtistTile('Shawn Mendes', artist.profileImageUrl),
              const SizedBox(width: 10),
              _buildSimilarArtistTile('The Vamps', artist.profileImageUrl),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarArtistTile(String name, String imageUrl) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 5),
        Text(name),
      ],
    );
  }
}
