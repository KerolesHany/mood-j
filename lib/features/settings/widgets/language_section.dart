import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moodly_j/core/theme/app_theme.dart';
import 'package:moodly_j/features/settings/widgets/settings_card.dart';
import 'package:moodly_j/l10n/app_localizations.dart';

class LanguageSection extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String?> onChanged;

  const LanguageSection({
    super.key,
    required this.currentLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return SettingsCard(
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
                value: currentLanguage,
                icon: const Icon(
                  Icons.language,
                  color: AppTheme.blue,
                ),
                borderRadius: BorderRadius.circular(14),
                style: const TextStyle(
                  color: AppTheme.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: Colors.white,
                onChanged: onChanged,
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
    );
  }
}
