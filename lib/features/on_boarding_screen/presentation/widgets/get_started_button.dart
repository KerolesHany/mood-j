import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class GetStartedButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GetStartedButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textStyle = Theme.of(context).textTheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(320.w, 45.h),
        padding: EdgeInsets.symmetric(
          horizontal: 22.r,
          vertical: 10.r,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(18.r),
        ),
        backgroundColor: AppTheme.blue,
        foregroundColor: AppTheme.black,
      ),
      onPressed: onPressed,
      child: Text(
        localization.getStarted,
        style: textStyle.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.white,
        ),
      ),
    );
  }
}
