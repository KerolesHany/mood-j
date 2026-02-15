import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/service/local_notifications.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/core/ui/ui_uitils.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_cubit.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_states.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/init_screen.dart';
import 'package:moodly_j/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moodly_j/features/settings/widgets/user_header_section.dart';
import 'package:moodly_j/features/settings/widgets/notification_section.dart';
import 'package:moodly_j/features/settings/widgets/language_section.dart';
import 'package:moodly_j/features/settings/widgets/logout_section.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool isNotificationEnabled = false;
  TimeOfDay notificationTime = const TimeOfDay(hour: 20, minute: 0);
  SharedPreferences? prefs;
  String language = 'en';

  @override
  void initState() {
    super.initState();
    final userCubit = getIt<UserCubit>();
    language = userCubit.user?.language ?? "en";
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs!.getBool('notification_enabled') ?? false;
      int? hour = prefs!.getInt('notification_hour');
      int? minute = prefs!.getInt('notification_minute');
      if (hour != null && minute != null) {
        notificationTime = TimeOfDay(hour: hour, minute: minute);
      }
    });
  }

  Future<void> _toggleNotification(bool value) async {
    if (value) {
      final granted = await LocalNotifications.requestPermission();
      if (!granted) {
        if (!mounted) return;
        UiUtils.showMessage(context, "Notification permission denied", false);
        return;
      }
    }
    setState(() {
      isNotificationEnabled = value;
    });
    await prefs?.setBool('notification_enabled', value);
    if (value) {
      await _scheduleNotification();
    } else {
      await LocalNotifications.cancel();
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: notificationTime,
    );
    if (picked != null && picked != notificationTime) {
      setState(() {
        notificationTime = picked;
      });
      await prefs?.setInt('notification_hour', picked.hour);
      await prefs?.setInt('notification_minute', picked.minute);

      if (isNotificationEnabled) {
        await _scheduleNotification();
      }
    }
  }

  Future<void> _scheduleNotification() async {
    if (!mounted) return;
    final localization = AppLocalizations.of(context)!;
    await LocalNotifications.scheduleDailyNotification(
      time: notificationTime,
      title: localization.dailyReminder,
      description: localization.dontForgetToWriteToday,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final userCubit = BlocProvider.of<UserCubit>(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: BlocListener<UserCubit, UserStates>(
          listener: (context, state) {
            if (state is SuccessLogOutState) {
              UiUtils.hideLoading(context);
              Navigator.of(context).pushReplacementNamed(InitScreen.routeName);
            } else if (state is ErrorLogOutState) {
              UiUtils.hideLoading(context);
              UiUtils.showMessage(context, state.message, false);
            } else if (state is LoadingLogOutState) {
              UiUtils.showLoadingIndicator(context);
            }
          },
          child: BlocListener<UserCubit, UserStates>(
            listener: (context, state) {
              if (state is SuccessChangeImageState ||
                  state is SuccessChangeLanguageState) {
                UiUtils.hideLoading(context);
                userCubit.getUser();
              } else if (state is ErrorChangeImageState ||
                  state is ErrorChangeLanguageState) {
                UiUtils.hideLoading(context);
                UiUtils.showMessage(
                  context,
                  localization.someThingWentWrong,
                  false,
                );
              } else if (state is LoadingChangeImageState ||
                  state is LoadingChangeLanguageState) {
                UiUtils.showLoadingIndicator(context);
              }
            },
            child: BlocBuilder<UserCubit, UserStates>(
              builder: (context, state) {
                if (state is LoadingGetUserState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ErrorGetUserState) {
                  return Center(child: Text(localization.someThingWentWrong));
                } else if (state is SuccessGetUserState) {
                  // Ensure state.user is not null or handle it
                  final user = state.user ?? userCubit.user;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UserHeaderSection(
                          user: user,
                          onImagePicked: (path) async {
                            await userCubit.changeImage(imgPath: path);
                          },
                        ),
                        SizedBox(height: 25.h),
                        NotificationSection(
                          isNotificationEnabled: isNotificationEnabled,
                          notificationTime: notificationTime,
                          onToggle: _toggleNotification,
                          onPickTime: _pickTime,
                        ),
                        SizedBox(height: 10.h),
                        LanguageSection(
                          currentLanguage: language,
                          onChanged: (value) async {
                            if (value != null) {
                              await userCubit.changeLanguage(language: value);
                              setState(() {
                                language = value;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10.h),
                        LogoutSection(
                          onLogout: () async {
                            await userCubit.logOut();
                          },
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
