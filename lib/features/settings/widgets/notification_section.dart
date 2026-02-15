import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/settings/widgets/settings_card.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class NotificationSection extends StatelessWidget {
  final bool isNotificationEnabled;
  final TimeOfDay notificationTime;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickTime;

  const NotificationSection({
    super.key,
    required this.isNotificationEnabled,
    required this.notificationTime,
    required this.onToggle,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return SettingsCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onChanged: onToggle,
                activeThumbColor: AppTheme.blue,
              ),
            ],
          ),
          if (isNotificationEnabled) ...[
            const Divider(),
            InkWell(
              onTap: onPickTime,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localization.reminder,
                      style: textTheme.bodyMedium!.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          notificationTime.format(context),
                          style: textTheme.bodyMedium!.copyWith(
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
    );
  }
}
