import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/core/ui/ui_uitils.dart';
import 'package:moodly_j/features/home/presentation/home_screen.dart';
import 'package:moodly_j/features/moods/presentation/widgets/elvated_button.dart';
import 'package:moodly_j/features/on_boarding_screen/domain/enitities/user_entity.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_cubit.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_states.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/widgets/custom_input_field.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class RegistrationBottomSheetContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;

  const RegistrationBottomSheetContent({
    super.key,
    required this.formKey,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.blushPink,
          borderRadius: BorderRadius.circular(22.r),
        ),
        padding: EdgeInsets.all(16.r),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInputField(
                  validator: (input) {
                    if (input == null ||
                        input.trim().isEmpty ||
                        input.length < 3) {
                      return AppLocalizations.of(
                        context,
                      )!.nameCantBeLessThan3Characters;
                    }
                    return null;
                  },
                  nameController: nameController,
                ),
                SizedBox(height: 20.h),

                BlocConsumer<UserCubit, UserStates>(
                  builder: (context, state) {
                    if (state is LoadingCreateUserState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElvatedButton(
                      title: AppLocalizations.of(context)!.go,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await BlocProvider.of<UserCubit>(
                            context,
                          ).createUser(
                            userEntity: UserEntity(
                              imgPath: "assets/icons/person.png",
                              language: 'en',
                              name: nameController.text,
                            ),
                          );
                        }
                      },
                    );
                  },
                  listener: (context, state) {
                    if (state is SuccessCreateUserState) {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(HomeScreen.routeName);
                      BlocProvider.of<UserCubit>(context).getUser();
                    } else if (state is ErrorCreateUserState) {
                      Navigator.of(context).pop();
                      UiUtils.showMessage(context, state.message, false);
                    }
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
