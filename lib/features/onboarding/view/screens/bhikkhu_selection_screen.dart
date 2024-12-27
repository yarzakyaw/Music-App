import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/providers/favorite_bhikkhu_notifier.dart';
import 'package:mingalar_music_app/core/widgets/custom_app_bar.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';
import 'package:mingalar_music_app/features/onboarding/view/widgets/basic_app_button.dart';

class BhikkhuSelectionScreen extends ConsumerStatefulWidget {
  const BhikkhuSelectionScreen({super.key});

  @override
  ConsumerState<BhikkhuSelectionScreen> createState() =>
      _BhikkhuSelectionScreenState();
}

class _BhikkhuSelectionScreenState
    extends ConsumerState<BhikkhuSelectionScreen> {
  List<String> selectedBhikkhus = [];
  List<BhikkhuModel> allBhikkhus = [];
  List<BhikkhuModel> filteredBhikkhus = [];
  List<BhikkhuModel> selectedBhikkhuList = [];
  String searchQuery = '';

  void toggleBhikkhuSelection(BhikkhuModel bhikkhu) {
    setState(() {
      if (selectedBhikkhus.contains(bhikkhu.id)) {
        selectedBhikkhus.remove(bhikkhu.id);
        selectedBhikkhuList.remove(bhikkhu);
      } else {
        selectedBhikkhus.add(bhikkhu.id);
        selectedBhikkhuList.add(bhikkhu);
      }
    });
  }

  void filterBhikkhus(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text(tSelectBhikkhus)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TextField(
                onChanged: filterBhikkhus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: tSearch,
                ),
              ),
            ),
            const Text(
              tSelectOne,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            ref.watch(getAllBhikkhusProvider).when(
                  data: (bhikkhus) {
                    filteredBhikkhus = searchQuery.isEmpty
                        ? bhikkhus
                        : bhikkhus.where((bhikkhu) {
                            return bhikkhu.nameMM
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
                        itemCount: filteredBhikkhus.length,
                        itemBuilder: (context, index) {
                          var bhikkhu = filteredBhikkhus[index];
                          bool isSelected =
                              selectedBhikkhus.contains(bhikkhu.id);
                          return GestureDetector(
                            onTap: () => toggleBhikkhuSelection(bhikkhu),
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: isSelected
                                    ? Colors.blue.withOpacity(0.7)
                                    : Colors.black54,
                                title: Text(
                                  bhikkhu.nameMM,
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
                                      NetworkImage(bhikkhu.profileImageUrl),
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
              onPressed: selectedBhikkhus.isNotEmpty
                  ? () {
                      for (final bhikkhu in selectedBhikkhuList) {
                        ref
                            .read(favoriteBhikkhuNotifierProvider.notifier)
                            .addToFavorite(bhikkhu);
                        ref
                            .read(dhammaViewModelProvider.notifier)
                            .updateFollowerStatusToFirebase(
                              isFollowed: true,
                              bhikkhu: bhikkhu,
                            );
                      }
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'HomeScreen',
                        (_) => false,
                      );
                    }
                  : () {},
              title: tContinue,
            ),
          ],
        ),
      ),
    );
  }
}
