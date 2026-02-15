import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/home/presentation/home_tab.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/widgets/journalist_tab.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_cubit.dart';
import 'package:moodly_j/features/settings/settings_tab.dart';

import 'package:moodly_j/features/home/presentation/widgets/home_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final List<StatefulWidget> tabs = [HomeTab(), JournalistTab(), SettingsTab()];
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final moodsCubit = getIt<MoodsCubit>();
    await getIt<UserCubit>().getUser();
    await moodsCubit.getAllMoods();
    await moodsCubit.getMoodToday();
    await moodsCubit.getMostFrequentMood();
    await moodsCubit.getWritingStreak();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: tabs[selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            color: AppTheme.blue,
          ),
          child: HomeNavigationBar(
            selectedIndex: selectedIndex,
            onIndexChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
