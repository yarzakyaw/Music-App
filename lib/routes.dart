import 'package:flutter/material.dart';
import 'package:mingalar_music_app/features/auth/view/screens/signin_screen.dart';
import 'package:mingalar_music_app/features/auth/view/screens/signup_screen.dart';
import 'package:mingalar_music_app/features/dashboard/view/screens/dashboard_screen.dart';
import 'package:mingalar_music_app/features/dhamma/view/screens/dhamma_upload_screen.dart';
import 'package:mingalar_music_app/features/dhamma/view/widgets/add_bhikkhu.dart';
import 'package:mingalar_music_app/features/dhamma/view/widgets/add_category.dart';
import 'package:mingalar_music_app/features/home/view/screens/home_screen.dart';
import 'package:mingalar_music_app/features/home/view/screens/music_upload_screen.dart';
import 'package:mingalar_music_app/features/home/view/widgets/add_artist.dart';
import 'package:mingalar_music_app/features/home/view/widgets/add_genre.dart';
import 'package:mingalar_music_app/features/onboarding/view/screens/artist_selection_screen.dart';
import 'package:mingalar_music_app/features/onboarding/view/screens/bhikkhu_selection_screen.dart';
import 'package:mingalar_music_app/features/onboarding/view/screens/get_started_screen.dart';
import 'package:mingalar_music_app/features/splash/view/screens/splash_screen.dart';
import 'package:mingalar_music_app/features/theme/view/screens/theme_mode_select_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //     builder: (context) => const SplashScreen(),
      //   );
      case '/':
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case 'GetStarted':
        return MaterialPageRoute(
          builder: (context) => const GetStartedScreen(),
        );
      case 'ArtistSelection':
        return MaterialPageRoute(
          builder: (context) => const ArtistSelectionScreen(),
        );
      case 'BhikkhuSelection':
        return MaterialPageRoute(
          builder: (context) => const BhikkhuSelectionScreen(),
        );
      case 'ChooseTheme':
        return MaterialPageRoute(
          builder: (context) => const ThemeModeSelectScreen(),
        );
      case 'SignupScreen':
        return MaterialPageRoute(
          builder: (context) => const SignupScreen(),
        );
      case 'SigninScreen':
        return MaterialPageRoute(
          builder: (context) => const SigninScreen(),
        );
      case 'DashboardScreen':
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        );
      case 'HomeScreen':
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case 'MusicUploadScreen':
        return MaterialPageRoute(
          builder: (context) => const MusicUploadScreen(),
        );
      case 'AddArtistScreen':
        return MaterialPageRoute(
          builder: (context) => const AddArtist(),
        );
      case 'AddBhikkhuScreen':
        return MaterialPageRoute(
          builder: (context) => const AddBhikkhu(),
        );
      case 'AddGenreScreen':
        return MaterialPageRoute(
          builder: (context) => const AddGenre(),
        );
      case 'AddCategoryScreen':
        return MaterialPageRoute(
          builder: (context) => const AddCategory(),
        );
      case 'DhammaUploadScreen':
        return MaterialPageRoute(
          builder: (context) => const DhammaUploadScreen(),
        );
    }
    return null;
  }
}
