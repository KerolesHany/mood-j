import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_cubit.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_states.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class UserGreeting extends StatelessWidget {
  const UserGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<UserCubit, UserStates>(
      buildWhen: (_, current) =>
          current is SuccessGetUserState ||
          current is ErrorGetUserState ||
          current is LoadingGetUserState,
      builder: (context, state) {
        if (state is SuccessGetUserState) {
          return Text(
            "${localization.hello}${state.user!.name}",
            style: textTheme.titleMedium,
          );
        }
        return SizedBox();
      },
    );
  }
}
