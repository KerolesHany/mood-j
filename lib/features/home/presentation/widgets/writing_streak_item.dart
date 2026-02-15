import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_states.dart';
import 'package:moodly_j/l10n/app_localizations.dart';
import 'package:moodly_j/features/home/presentation/widgets/custom_item.dart';

class WritingStreakItem extends StatelessWidget {
  const WritingStreakItem({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocBuilder<MoodsCubit, MoodsStates>(
      buildWhen: (_, current) =>
          (current is WritingStreakLoading ||
          current is WritingStreakLoaded ||
          current is WritingStreakError),
      builder: (context, state) {
        if (state is WritingStreakLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WritingStreakLoaded) {
          return CustomItem(
            icon: "assets/icons/fire.png",
            bgColor: AppTheme.lightPink,
            color: AppTheme.deepRose,
            result: "${state.streak} ${localization.days}",
            title: localization.writingStreak,
          );
        } else if (state is WritingStreakError) {
          return const Text("Error");
        }
        return const SizedBox();
      },
    );
  }
}
