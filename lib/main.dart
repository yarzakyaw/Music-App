import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mingalar_music_app/core/models/custom_playlist_compilation_model.dart';
import 'package:mingalar_music_app/core/models/user_defined_playlist_model.dart';
import 'package:mingalar_music_app/core/theme/app_theme.dart';
import 'package:mingalar_music_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:mingalar_music_app/features/dhamma/models/bhikkhu_model.dart';
import 'package:mingalar_music_app/features/home/models/artist_model.dart';
import 'package:mingalar_music_app/features/home/models/music_model.dart';
import 'package:mingalar_music_app/firebase_options.dart';
import 'package:mingalar_music_app/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  // final dir = await getApplicationDocumentsDirectory();
  // Hive.defaultDirectory = dir.path;
  await Hive.initFlutter();
  Hive.registerAdapter(MusicModelAdapter());
  Hive.registerAdapter(ArtistModelAdapter());
  Hive.registerAdapter(BhikkhuModelAdapter());
  Hive.registerAdapter(UserDefinedPlaylistModelAdapter());
  Hive.registerAdapter(CustomPlaylistCompilationModelAdapter());

  await Hive.openBox<MusicModel>('recently_played');
  await Hive.openBox<MusicModel>('allMusic');
  await Hive.openBox<MusicModel>('allDhamma');
  await Hive.openBox<ArtistModel>('allArtists');
  await Hive.openBox<BhikkhuModel>('allBhikkhus');
  await Hive.openBox<MusicModel>('thisWeekMusic');
  await Hive.openBox<MusicModel>('thisMonthDhamma');
  await Hive.openBox<ArtistModel>('tenArtists');
  await Hive.openBox<BhikkhuModel>('tenBhikkhus');
  await Hive.openBox<UserDefinedPlaylistModel>('userGeneratedPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>('allMingalarPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>('tenMingalarPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>('allUserPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>('tenUserPlaylists');
  await Hive.openBox<UserDefinedPlaylistModel>('userGeneratedDhammaPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>(
      'allMingalarDhammaPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>(
      'tenMingalarDhammaPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>('allUserDhammaPlaylists');
  await Hive.openBox<CustomPlaylistCompilationModel>('tenUserDhammaPlaylists');

  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).setInitialScreen();

  // Activate App Check with Debug Provider
  await FirebaseAppCheck.instance.activate(
    // webProvider:
    //     ReCaptchaV3Provider('6LfU4WYqAAAAAL82p3ov1xayPPeFO8PCsSALGXnQ'),
    // androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.debug,
    androidProvider:
        kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mingalar Music',
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: ThemeMode.system,
      // home: currentUser == null ? const SignupScreen() : const HomeScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
    );
  }
}
