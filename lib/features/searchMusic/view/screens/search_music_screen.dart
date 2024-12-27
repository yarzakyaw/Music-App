import 'package:flutter/material.dart';
import 'package:mingalar_music_app/features/searchMusic/view/widgets/card_widget.dart';

class SearchMusicScreen extends StatelessWidget {
  const SearchMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "What do you want to listen to?",
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                children: List.generate(8, (index) {
                  return CardWidget(
                    title: _getCardTitle(index),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCardTitle(int index) {
    const titles = [
      'Music',
      'Podcasts',
      'Live Events',
      '2024 in Music',
      '2024 in Podcasts',
      'Made For You',
      'New Releases',
      'K-pop',
      'Pop'
    ];
    return titles[index % titles.length];
  }
}
