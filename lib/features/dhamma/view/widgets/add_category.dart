import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/customfield_widget.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/dhamma/viewmodel/dhamma_view_model.dart';

class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({super.key});

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final categoryNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    categoryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(dhammaViewModelProvider.select((val) => val?.isLoading == true));

    return Scaffold(
      appBar: AppBar(
        title: const Text(tAddCategory),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                ref.read(dhammaViewModelProvider.notifier).addCategory(
                      name: categoryNameController.text,
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
                  hintText: tCategoryName,
                  controller: categoryNameController,
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
