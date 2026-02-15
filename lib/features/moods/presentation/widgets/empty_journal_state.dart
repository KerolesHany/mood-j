import 'package:fluentui_system_icons/fluentui_system_icons.dart'
    show FluentIcons;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class EmptyJournalState extends StatelessWidget {
  const EmptyJournalState({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            color: AppTheme.blue,
            FluentIcons.document_one_page_24_regular,
            size: 40.r,
          ),
          SizedBox(height: 10.h),
          Text(
            localization.emptyJournal,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 25.sp,
              color: AppTheme.deepRose,
            ),
          ),
        ],
      ),
    );
  }
}
