import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/screens/add_mood_screen.dart';
import 'package:moodly_j/features/home/presentation/widgets/custom_button.dart';
import 'package:moodly_j/features/home/presentation/widgets/total_entries_item.dart';
import 'package:moodly_j/features/home/presentation/widgets/most_frequent_mood_item.dart';
import 'package:moodly_j/features/home/presentation/widgets/writing_streak_item.dart';
import 'package:moodly_j/features/home/presentation/widgets/today_mood_item.dart';
import 'package:moodly_j/features/home/presentation/widgets/user_greeting.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

// ignore: must_be_immutable
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final moodsCubit = getIt<MoodsCubit>();
    await moodsCubit.getAllMoods();
    await moodsCubit.getMoodToday();
    await moodsCubit.getMostFrequentMood();
    await moodsCubit.getWritingStreak();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    // get a emoji by its name
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(22.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),
            Text(
              localization.yourJournalMoods,
              style: textTheme.titleLarge!.copyWith(fontSize: 22.sp),
            ),
            SizedBox(height: 12.h),
            const UserGreeting(),
            SizedBox(height: 12.h),
            ListTile(
              selected: true,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              selectedTileColor: AppTheme.creamYellow,
              title: Text(
                localization.dontForgetToWriteToday,
                style: textTheme.titleMedium!.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBrown,
                ),
              ),
              leading: Icon(FluentIcons.pen_16_filled),
            ),

            SizedBox(height: 20.h),
            SizedBox(
              height: 290.h,
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: 1,
                ),
                children: const [
                  TotalEntriesItem(),
                  MostFrequentMoodItem(),
                  WritingStreakItem(),
                  TodayMoodItem(),
                ],
              ),
            ),
            // SizedBox(height: 15.h),
            CustomButton(
              bgColor: AppTheme.lightBlue,
              color: AppTheme.leafGreen,
              icon: Icons.add_box_outlined,
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed(AddMoodScreen.routeName);
              },
              title: localization.addMood,
            ),
          ],
        ),
      ),
    );
  }
}
