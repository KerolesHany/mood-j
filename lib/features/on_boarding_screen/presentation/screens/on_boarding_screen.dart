import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/widgets/on_boarding_content.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/widgets/get_started_button.dart';
import 'package:moodly_j/features/on_boarding_screen/presentation/widgets/start_bottom_sheet.dart';


class OnBoardingScreen extends StatefulWidget {
  static const String routeName = "OnBoardingScreen";
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool reminderSelected = false;
  String reminder = "Off";
  final notificationController = ValueNotifier<bool>(true);
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.white,
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              const OnBoardingContent(),
              const Spacer(),
              GetStartedButton(
                onPressed: () {
                  startBottomSheet(
                    context: context,

                    globalKey: _globalKey,
                    nameController: nameController,

                  );
                },
              ),
              SizedBox(height: 35.h),
            ],
          ),
        ),
      ),
    );
  }

  void dailyReminder(dynamic value) {
    setState(() {
      reminderSelected = !reminderSelected;
      if (reminderSelected) {
        reminder = "Off";
      } else {
        reminder = "On";
      }
    });
  }
}
