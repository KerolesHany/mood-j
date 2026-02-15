import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodly_j/core/service/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moodly_j/core/service_locator/get_it.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/core/ui/ui_uitils.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_cubit.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/cubit/user_states.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/init_screen.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final themeController = ValueNotifier<bool>(true);
  final notificationController = ValueNotifier<bool>(true);
  final lanaugeController = ValueNotifier<bool>(true);
  final nameController = TextEditingController();

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
    final textTheme = Theme.of(context).textTheme;
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
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //! User Image
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final imgUrl = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (imgUrl == null) return;
                              await userCubit.changeImage(imgPath: imgUrl.path);
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 70.r,
                                  backgroundImage:
                                      (userCubit.user?.imgPath == null ||
                                          userCubit.user!.imgPath.isEmpty ||
                                          userCubit.user!.imgPath ==
                                              "assets/icons/person.png")
                                      ? AssetImage("assets/icons/person.png")
                                      : FileImage(File(userCubit.user!.imgPath))
                                            as ImageProvider,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(8.r),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        //! User Name
                        Text(
                          state.user!.name,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black,
                          ),
                        ),
                        SizedBox(height: 25.h),

                        //! Notification
                        _buildCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localization.dailyReminder,
                                    style: textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      color: AppTheme.black,
                                    ),
                                  ),
                                  Switch(
                                    value: isNotificationEnabled,
                                    onChanged: _toggleNotification,
                                    activeThumbColor: AppTheme.blue,
                                  ),
                                ],
                              ),
                              if (isNotificationEnabled) ...[
                                Divider(),
                                InkWell(
                                  onTap: _pickTime,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          localization
                                              .reminder, // "Reminder" or "Time"
                                          style: textTheme.bodyMedium!.copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              notificationTime.format(context),
                                              style: textTheme.bodyMedium!
                                                  .copyWith(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.blue,
                                                  ),
                                            ),
                                            SizedBox(width: 5.w),
                                            Icon(
                                              Icons.access_time,
                                              color: AppTheme.blue,
                                              size: 20.sp,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),

                        //! Language
                        _buildCard(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                localization.language,
                                style: textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: AppTheme.black,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.blue),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: language,
                                    icon: Icon(
                                      Icons.language,
                                      color: AppTheme.blue,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    style: TextStyle(
                                      color: AppTheme.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    dropdownColor: Colors.white,
                                    onChanged: (value) async {
                                      await BlocProvider.of<UserCubit>(
                                        context,
                                      ).changeLanguage(language: value!);
                                      setState(() {
                                        language = value;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: 'en',
                                        child: Text(localization.english),
                                      ),
                                      DropdownMenuItem(
                                        value: 'ar',
                                        child: Text(localization.arabic),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //! Log Out
                        SizedBox(height: 10.h),
                        _buildCard(
                          child: GestureDetector(
                            onTap: () async {
                              await BlocProvider.of<UserCubit>(
                                context,
                              ).logOut();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.redAccent,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  localization.logOut,
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
