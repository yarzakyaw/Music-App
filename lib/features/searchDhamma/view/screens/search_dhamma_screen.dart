import 'package:flutter/material.dart';
import 'package:mingalar_music_app/features/searchDhamma/view/widgets/dhamma_card_widget.dart';

class SearchDhammaScreen extends StatelessWidget {
  const SearchDhammaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "What teachings do you seek?",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
            ),
          ),
        ),
        // Categories Section
        // const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // For example; you can customize this
            itemBuilder: (context, index) {
              return DhammaCardWidget(
                title: 'Teaching ${index + 1}',
                description:
                    'This is a brief description of teaching ${index + 1}.',
              );
            },
          ),
        )
      ],
    );
  }
}
