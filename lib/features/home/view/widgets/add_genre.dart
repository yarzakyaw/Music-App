import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/customfield_widget.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/home/viewmodel/home_view_model.dart';

class AddGenre extends ConsumerStatefulWidget {
  const AddGenre({
    super.key,
  });

  @override
  ConsumerState<AddGenre> createState() => _AddGenreState();
}

class _AddGenreState extends ConsumerState<AddGenre> {
  final genreNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    genreNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));

    return Scaffold(
      appBar: AppBar(
        title: const Text(tAddGenre),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                ref.read(homeViewModelProvider.notifier).addGenre(
                      name: genreNameController.text,
                    );
              } else {
                showSnackBar(context, tMissingFields);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: CustomfieldWidget(
                  hintText: tGenreName,
                  controller: genreNameController,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return tMissingFields;
                    }
                    return null;
                  },
                ),
              ),
            ),
    );
  }
}
