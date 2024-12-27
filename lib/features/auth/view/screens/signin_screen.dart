import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/auth/view/widgets/form_divider_widget.dart';
import 'package:mingalar_music_app/features/auth/view/widgets/form_header_widget.dart';
import 'package:mingalar_music_app/features/auth/view/widgets/signin_tabcontroller_widget.dart';
import 'package:mingalar_music_app/features/auth/view/widgets/social_footer_widget.dart';
import 'package:mingalar_music_app/features/auth/viewmodel/auth_view_model.dart';

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(
            context,
            tSignedIn,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            'HomeScreen',
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const FormHeaderWidget(
                      title: tSigninTitle,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textAlign: TextAlign.center,
                    ),
                    const SigninTabcontrollerWidget(),
                    const FormDividerWidget(),
                    SocialFooterWidget(
                      text1: tDontHaveAnAccount,
                      text2: tSignupBody,
                      onPressed: () {
                        Navigator.pushNamed(context, 'SignupScreen');
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const SignupScreen(),
                        //   ),
                        // );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
