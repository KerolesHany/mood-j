import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/core/get_emoji.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_states.dart';
import 'package:moodly_j/l10n/app_localizations.dart';
import 'package:moodly_j/features/home/presentation/widgets/custom_item.dart';

class TodayMoodItem extends StatelessWidget {
  const TodayMoodItem({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocBuilder<MoodsCubit, MoodsStates>(
      buildWhen: (_, current) =>
          current is MoodTodayLoading ||
          current is MoodTodayLoaded ||
          current is MoodTodayError,
      builder: (contexts, statee) {
        if (statee is MoodTodayLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (statee is MoodTodayLoaded) {
          return CustomItem(
            fixedIcon: false,
            emoji: getEmoji(statee.mood?.emoji, context).$1,
            bgColor: AppTheme.mintGreen,
            color: AppTheme.forestGreen,
            result: getEmoji(statee.mood?.emoji, context).$2,
            title: localization.todayMood,
          );
        } else if (statee is MoodTodayError) {
          return const Text("Error");
        }
        return const SizedBox();
      },
    );
  }
}
