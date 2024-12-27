import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:mingalar_music_app/features/dashboard/view/screens/dashboard_screen.dart';
import 'package:mingalar_music_app/features/library/view/screens/library_screen.dart';
import 'package:mingalar_music_app/features/home/view/widgets/music_slab.dart';
import 'package:mingalar_music_app/features/onboarding/view/screens/get_started_screen.dart';
import 'package:mingalar_music_app/features/profile/view/screens/profile_screen.dart';
import 'package:mingalar_music_app/features/search/view/screens/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  // Keys to access navigators for each tab
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final pages = const [
    DashboardScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final menuItemSelectedColor =
        isDark ? AppPallete.whiteColor : AppPallete.green;
    final menuItemUnSelectedColor = isDark
        ? AppPallete.inactiveBottomBarItemColor
        : AppPallete.inactiveBottomBarItemColor;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const GetStartedScreen(),
            ),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return isLoading
        ? const Loader()
        : Scaffold(
            body: Stack(
              children: [
                IndexedStack(
                  index: selectedIndex,
                  children: List.generate(pages.length, (index) {
                    return Navigator(
                      key: navigatorKeys[index],
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute(
                          builder: (context) => pages[index],
                        );
                      },
                    );
                  }),
                ),

                // Positioned(
                //   bottom: 70,
                //   child: IconButton(
                //     onPressed: () async {
                //       await ref
                //           .read(authViewModelProvider.notifier)
                //           .signoutUser();
                //       Navigator.pushNamed(context, 'GetStarted');
                //     },
                //     icon: const Icon(Icons.logout),
                //   ),
                // ),
                const Positioned(
                  bottom: 0,
                  child: MusicSlab(),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                if (selectedIndex != index) {
                  navigatorKeys[selectedIndex]
                      .currentState
                      ?.popUntil((route) => route.isFirst);
                  setState(() {
                    selectedIndex = index;
                  });
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    selectedIndex == 0 ? iHomeFilled : iHomeUnFilled,
                    color: selectedIndex == 0
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tHome,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    selectedIndex == 1 ? iSearchFilled : iSearchUnFilled,
                    color: selectedIndex == 1
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tSearchHome,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    height: 20,
                    width: 20,
                    selectedIndex == 2 ? iLibraryFilled : iLibraryUnFilled,
                    color: selectedIndex == 2
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tLibrary,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    height: 20,
                    width: 20,
                    selectedIndex == 3 ? iProfileFilled : iProfileUnFilled,
                    color: selectedIndex == 3
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tProfile,
                ),
              ],
            ),
          );
  }
}

/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mingalar_music_app/core/constants/image_strings.dart';
import 'package:mingalar_music_app/core/constants/text_strings.dart';
import 'package:mingalar_music_app/core/theme/app_pallete.dart';
import 'package:mingalar_music_app/core/utils.dart';
import 'package:mingalar_music_app/core/widgets/loader.dart';
import 'package:mingalar_music_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:mingalar_music_app/features/dashboard/view/screens/dashboard_screen.dart';
import 'package:mingalar_music_app/features/library/view/screens/library_screen.dart';
import 'package:mingalar_music_app/features/home/view/widgets/music_slab.dart';
import 'package:mingalar_music_app/features/onboarding/view/screens/get_started_screen.dart';
import 'package:mingalar_music_app/features/profile/view/screens/profile_screen.dart';
import 'package:mingalar_music_app/features/search/view/screens/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  final pages = const [
    DashboardScreen(),
    SearchScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final menuItemSelectedColor =
        isDark ? AppPallete.whiteColor : AppPallete.green;
    final menuItemUnSelectedColor = isDark
        ? AppPallete.inactiveBottomBarItemColor
        : AppPallete.inactiveBottomBarItemColor;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const GetStartedScreen(),
            ),
            (_) => false,
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return isLoading
        ? const Loader()
        : Scaffold(
            body: Stack(
              children: [
                /* IndexedStack(
                  index: selectedIndex,
                  children: pages,
                ), */
                Navigator(
                  onGenerateRoute: (RouteSettings settings) {
                    return MaterialPageRoute(
                      builder: (context) => pages[selectedIndex],
                    );
                  },
                ),
                // pages[selectedIndex],

                // Positioned(
                //   bottom: 70,
                //   child: IconButton(
                //     onPressed: () async {
                //       await ref
                //           .read(authViewModelProvider.notifier)
                //           .signoutUser();
                //       Navigator.pushNamed(context, 'GetStarted');
                //     },
                //     icon: const Icon(Icons.logout),
                //   ),
                // ),
                const Positioned(
                  bottom: 0,
                  child: MusicSlab(),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (value) {
                setState(() {
                  if (selectedIndex != value) {
                    // Pop until the root of the current tab
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                  selectedIndex = value;
                  debugPrint('-------------${selectedIndex.toString()}');
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    selectedIndex == 0 ? iHomeFilled : iHomeUnFilled,
                    color: selectedIndex == 0
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tHome,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    selectedIndex == 1 ? iSearchFilled : iSearchUnFilled,
                    color: selectedIndex == 1
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tSearchHome,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    height: 20,
                    width: 20,
                    selectedIndex == 2 ? iLibraryFilled : iLibraryUnFilled,
                    color: selectedIndex == 2
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tLibrary,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    height: 20,
                    width: 20,
                    selectedIndex == 3 ? iProfileFilled : iProfileUnFilled,
                    color: selectedIndex == 3
                        ? menuItemSelectedColor
                        : menuItemUnSelectedColor,
                  ),
                  label: tProfile,
                ),
              ],
            ),
          );
  }
} */
