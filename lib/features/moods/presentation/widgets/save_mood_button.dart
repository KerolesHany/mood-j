import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/core/ui/ui_uitils.dart';
import 'package:moodly_j/features/home/presentation/home_screen.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_states.dart';
import 'package:moodly_j/features/moods/presentation/widgets/elvated_button.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class SaveMoodButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveMoodButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    
    return BlocListener<MoodsCubit, MoodsStates>(
      listener: (context, state) {
        if (state is LoadingAddMoodState) {
          UiUtils.showLoadingIndicator(context);
        } else if (state is ErrorAddMoodState) {
          UiUtils.hideLoading(context);
          UiUtils.showMessage(context, state.message, false);
        } else if (state is SuccessAddMoodState) {
          UiUtils.hideLoading(context);
          UiUtils.showMessage(
            context,
            localization.yourMoodAdded,
            true,
          );
          Navigator.of(
            context,
          ).pushReplacementNamed(HomeScreen.routeName);
          getIt<MoodsCubit>().getMoodToday();
          getIt<MoodsCubit>().getAllMoods();
          getIt<MoodsCubit>().getMostFrequentMood();
          getIt<MoodsCubit>().getWritingStreak();
        }
      },
      child: ElvatedButton(
        onPressed: onPressed,
        title: localization.save,
      ),
    );
  }
}
