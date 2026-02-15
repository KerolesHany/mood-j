import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_cubti.dart';
import 'package:moodly_j/features/moods/presentation/cubit/moods_states.dart';
import 'package:moodly_j/l10n/app_localizations.dart';
import 'package:moodly_j/features/home/presentation/widgets/custom_item.dart';

class TotalEntriesItem extends StatelessWidget {
  const TotalEntriesItem({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocBuilder<MoodsCubit, MoodsStates>(
      buildWhen: (_, current) =>
          (current is LoadingGetAllMoodsState ||
          current is SuccessGetAllMoodsState ||
          current is ErrorGetAllMoodsState),
      builder: (context, state) {
        if (state is LoadingGetAllMoodsState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SuccessGetAllMoodsState) {
          return CustomItem(
            icon: "assets/icons/book.png",
            bgColor: AppTheme.lavender,
            color: AppTheme.deepPurple,
            result: "${state.allMoods.length}",
            title: localization.totalEntries,
          );
        } else if (state is ErrorGetAllMoodsState) {
          return const Center(child: Text("Error"));
        }
        return const SizedBox();
      },
    );
  }
}
