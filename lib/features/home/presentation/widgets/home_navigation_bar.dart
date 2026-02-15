import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class HomeNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const HomeNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        color: AppTheme.blue,
      ),
      child: BottomNavigationBar(
        elevation: 0,
        unselectedItemColor: AppTheme.white,
        selectedItemColor: AppTheme.darkBrown,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) async {
          final moodsCubit = getIt<MoodsCubit>();
          if (value == 0) {
            await moodsCubit.getMoodToday();
            await moodsCubit.getAllMoods();
            await moodsCubit.getMostFrequentMood();
            await moodsCubit.getWritingStreak();
          }
          onIndexChanged(value);
        },
        items: [
          BottomNavigationBarItem(
            label: localization.home,
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: localization.myJournal,
            icon: Icon(Icons.menu_book_rounded),
          ),
          BottomNavigationBarItem(
            label: localization.profile,
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
