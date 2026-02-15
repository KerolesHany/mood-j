import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/core/get_emoji.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_states.dart';
import 'package:moodly_j/l10n/app_localizations.dart';
import 'package:moodly_j/features/home/presentation/widgets/custom_item.dart';

class MostFrequentMoodItem extends StatelessWidget {
  const MostFrequentMoodItem({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocBuilder<MoodsCubit, MoodsStates>(
      buildWhen: (_, current) =>
          (current is MostFrequentMoodLoading ||
          current is MostFrequentMoodLoaded ||
          current is MostFrequentMoodError),
      builder: (context, state) {
        if (state is MostFrequentMoodLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MostFrequentMoodLoaded) {
          return CustomItem(
            fixedIcon: false,
            emoji: getEmoji(state.mood?.emoji, context).$1,
            bgColor: AppTheme.creamYellow,
            color: AppTheme.darkBrown,
            result: getEmoji(state.mood?.emoji, context).$2,
            title: localization.mostFrequent,
          );
        } else if (state is MostFrequentMoodError) {
          return Center(child: const Text("???"));
        }
        return const SizedBox();
      },
    );
  }
}
