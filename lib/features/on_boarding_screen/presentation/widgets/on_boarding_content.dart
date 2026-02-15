import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:moodly_j/l10n/app_localizations.dart';

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      children: [
        SizedBox(height: 30.h),
        Text(localization.welcomeToMoodJ, style: textStyle.titleLarge),
        SizedBox(height: 30.h),
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16.r),
          child: Image.asset("assets/images/first-img.jpg", width: 320.w),
        ),
        SizedBox(height: 30.h),
        Text(
          textAlign: TextAlign.center,
          style: textStyle.titleMedium,
          localization.trackYourMoodsReflectOnYourDayAndSeeYourJourneyOverTime,
        ),
      ],
    );
  }
}
