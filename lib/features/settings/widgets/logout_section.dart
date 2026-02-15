import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/features/settings/widgets/settings_card.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class LogoutSection extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutSection({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SettingsCard(
      child: GestureDetector(
        onTap: onLogout,
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
    );
  }
}
