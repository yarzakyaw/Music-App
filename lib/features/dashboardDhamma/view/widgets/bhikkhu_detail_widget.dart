import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/providers/favorite_bhikkhu_notifier.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/core/widgets/music_async_playlist_widget.dart';
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';

class BhikkhuDetailWidget extends ConsumerStatefulWidget {
  final String bhikkhuId;

  const BhikkhuDetailWidget({
    super.key,
    required this.bhikkhuId,
  });

  @override
  ConsumerState<BhikkhuDetailWidget> createState() =>
      _BhikkhuDetailWidgetState();
}

class _BhikkhuDetailWidgetState extends ConsumerState<BhikkhuDetailWidget> {
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
    final bhikkhuModel = ref.watch(getBhikkhuByIdProvider(widget.bhikkhuId));
    return bhikkhuModel.when(
      data: (bhikkhu) {
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
                    bhikkhu.nameMM,
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
                            bhikkhu.profileImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              bhikkhu.nameMM, // Artist name
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
                  _buildBhikkhuDetails(bhikkhu),
                  _buildPreferredCollections(bhikkhu),
                  _buildSimilarBhikkhus(bhikkhu),
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

  Widget _buildBhikkhuDetails(BhikkhuModel bhikkhu) {
    final favoriteBhikkhus = ref.watch(favoriteBhikkhuNotifierProvider);
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: BorderSide.strokeAlignCenter,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bhikkhu.totalFollowers > 1000
              ? Text(
                  '${bhikkhu.totalFollowers % 1000}k followers',
                  style: const TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.w600,
                    color: AppPallete.greyColor,
                  ),
                )
              : Text(
                  '${bhikkhu.totalFollowers} followers',
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
                      favoriteBhikkhus.containsKey(bhikkhu.id)
                          ? {
                              ref
                                  .read(
                                      favoriteBhikkhuNotifierProvider.notifier)
                                  .removeFromFavorites(bhikkhu.id),
                              ref
                                  .read(dhammaViewModelProvider.notifier)
                                  .updateFollowerStatusToFirebase(
                                    isFollowed: false,
                                    bhikkhu: bhikkhu,
                                  )
                            }
                          : {
                              ref
                                  .read(
                                      favoriteBhikkhuNotifierProvider.notifier)
                                  .addToFavorite(bhikkhu),
                              ref
                                  .read(dhammaViewModelProvider.notifier)
                                  .updateFollowerStatusToFirebase(
                                    isFollowed: true,
                                    bhikkhu: bhikkhu,
                                  )
                            };
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: favoriteBhikkhus.containsKey(bhikkhu.id)
                              ? AppPallete.greenColor
                              : AppPallete.greyColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          favoriteBhikkhus.containsKey(bhikkhu.id)
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

  Widget _buildPreferredCollections(BhikkhuModel bhikkhu) {
    final collectionModel =
        ref.watch(getPreferredCollectionsByBhikkhuProvider(bhikkhu.id));

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preferred Collections',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          collectionModel.when(
            data: (collections) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  final collection = collections[index];
                  final collectionTracks =
                      ref.watch(getCollectionTracksProvider(collection));
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return MusicAsyncPlaylistWidget(
                              title:
                                  '${collection.collectionName} by ${bhikkhu.nameENG}',
                              playlist: collectionTracks,
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
                              image:
                                  NetworkImage(collection.collectionImageUrl),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              collection.collectionName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              collection.releaseDate.year.toString(),
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

  Widget _buildSimilarBhikkhus(BhikkhuModel bhikkhu) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bhikkhus You Should Follow',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSimilarBhikkhuTile('ဦးညာဏိဿရ', bhikkhu.profileImageUrl),
              const SizedBox(width: 10),
              _buildSimilarBhikkhuTile('ဦးဃောသိတ', bhikkhu.profileImageUrl),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarBhikkhuTile(String name, String imageUrl) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 5),
        Text(name),
      ],
    );
  }
}
